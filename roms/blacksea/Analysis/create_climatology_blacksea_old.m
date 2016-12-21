clear all
%%%%%%%%%%%%%%%%%%%%%   START OF USER INPUT  %%%%%%%%%%%%%%%%%%%%%%%%%%
cd ~/matlab/nctoolbox/
setup_nctoolbox
addpath('/home/mil021/models/COAWST/Tools/mfiles/roms_clm')

clim_name='BlackSea_clm.nc';
ini_name='BlackSea_ini.nc';
bndry_name='BlackSea_bndry.nc';


% (1) Enter start date (T1) to get climatology data 
T1=datenum(2012,1,1,0,0,0); %start date

% (3) Enter working directory (wdr)
wdr='/home/mil021/Analysis/roms/blacksea/Analysis';
eval(['cd ',wdr])

% (4) Enter path and name of the ROMS grid (modelgrid)
modelgrid='/home/mil021/Analysis/roms/blacksea/Analysis/BlackSea_grd.nc'
eval(['gridname=''',modelgrid,''';']);

% (5) Enter grid vertical coordinate parameters --These need to be consistent with the ROMS setup. 
%--------------------------------------------------------------------------
%  Set application parameters in structure array, S.
%--------------------------------------------------------------------------

%  Climatology output file name.

S.ncname = clim_name;

%  Spherical grid switch.
%
%            [0] Cartesian grid
%            [1] Spherical grid

S.spherical = 1;

%  Number of vertical levels (N) at RHO-points (center grid cell).

S.N = 30;

%  Number of total active and passive tracers. Usually, NT=2 for potential
%  temperature and salinity.

S.NT = 2;

%  Set vertical stretching parameters. These values are specified in ROMS
%  input script.

%  Vertical transfomation equation (Vtransform).
%    (Check  https://www.myroms.org/wiki/index.php/Vertical_S-coordinate)
%
%            [1] Original tranformation equation
%            [2] New transformation equation

S.Vtransform = 1;

%  Vertical stretching function (Vstretching).
%    (Check  https://www.myroms.org/wiki/index.php/Vertical_S-coordinate)
%
%            [1] Original function (Song and Haidvogel, 1994)
%            [2] A. Shchepetkin function
%            [3] R. Geyer function
%    Vstretching   Vertical stretching function:
%                    Vstretching = 1,  original (Song and Haidvogel, 1994)
%                    Vstretching = 2,  A. Shchepetkin (UCLA-ROMS, 2005)
%                    Vstretching = 3,  R. Geyer BBL refinement
%                    Vstretching = 4,  A. Shchepetkin (UCLA-ROMS, 2010)

S.Vstretching = 4;

%  Vertical stretching parameters:
%
%            tetha_s:  S-coordinate surface control parameter.
%            tetha_b:  S-coordinate bottom control parameter.
%            Tcline:   S-coordinate surface/bottom stretching width (m)

S.theta_s = 5.0;
S.theta_b = 0.4;
S.Tcline  = 10.0;

S.hc = S.Tcline;

%  Set climatology fields to process and the number of time records.
%    (S.def_* = 0,  do not process
%     S.def_* = 1,  process)

S.def_zeta = 1;       S.zeta_time = 366;
S.def_v2d  = 1;       S.v2d_time  = 366;
S.def_v3d  = 1;       S.v3d_time  = 366;
S.def_temp = 1;       S.temp_time = 366;
S.def_salt = 1;       S.salt_time = 366;


%%%%%%%%%%%%%%%%%%%%%   END OF USER INPUT  %%%%%%%%%%%%%%%%%%%%%%%%%%

disp('getting roms grid dimensions ...');
gn=roms_get_grid_mw(gridname,[S.theta_s S.theta_b S.Tcline S.N S.Vstretching]);

%  Number of interior RHO-points (Lm, Mm) in the X- and Y-directions. These
%  are the values specified in ROMS input script.

S.Lm = size(gn.lon_rho,1)-2;
S.Mm = size(gn.lon_rho,2)-2;


% Call to create the climatology (clm) file
disp('going to create clm file')
%--------------------------------------------------------------------------
%  Create climatology Netcdf file.
%--------------------------------------------------------------------------

%ncid=netcdf.create(S.ncname,'NC_64BIT_OFFSET');
ncid=netcdf.create(S.ncname,'NC_NETCDF4');
%ncid=netcdf.create(S.ncname,'NC_CLOBBER');
% Define dimensions.
nx2=S.Lm+2;nx1=S.Lm+1;
ny2=S.Mm+2;ny1=S.Mm+1;

ni_rho_dimid=netcdf.defDim(ncid,'xi_rho',nx2);
ni_u_dimid=netcdf.defDim(ncid,'xi_u',nx1);
ni_v_dimid=netcdf.defDim(ncid,'xi_v',nx2);

nj_rho_dimid=netcdf.defDim(ncid,'eta_rho',ny2);
nj_u_dimid=netcdf.defDim(ncid,'eta_u',ny2);
nj_v_dimid=netcdf.defDim(ncid,'eta_v',ny1);

nz_dimid=netcdf.defDim(ncid,'s_rho',S.N);
nz_w_dimid=netcdf.defDim(ncid,'s_w',S.N+1);

temp_time_dimid=netcdf.defDim(ncid,'temp_time',S.temp_time);
salt_time_dimid=netcdf.defDim(ncid,'salt_time',S.salt_time);
zeta_time_dimid=netcdf.defDim(ncid,'zeta_time',S.zeta_time);
v2d_time_dimid=netcdf.defDim(ncid,'v2d_time',S.v2d_time);
v3d_time_dimid=netcdf.defDim(ncid,'v3d_time',S.v3d_time);

zeta_varid=netcdf.defVar(ncid,'zeta','double',[ni_rho_dimid nj_rho_dimid zeta_time_dimid]);
netcdf.putAtt(ncid,zeta_varid,'long_name','sea surface height climatology');
netcdf.putAtt(ncid,zeta_varid,'units','meter');

ubar_varid=netcdf.defVar(ncid,'ubar','double',[ni_u_dimid nj_u_dimid v2d_time_dimid]);
netcdf.putAtt(ncid,ubar_varid,'long_name','vertically integrated u-momentum component climatology');
netcdf.putAtt(ncid,ubar_varid,'units','meter second-1');

vbar_varid=netcdf.defVar(ncid,'vbar','double',[ni_v_dimid nj_v_dimid v2d_time_dimid]);
netcdf.putAtt(ncid,vbar_varid,'long_name','vertically integrated v-momentum component climatology');
netcdf.putAtt(ncid,vbar_varid,'units','meter second-1');

saln_varid=netcdf.defVar(ncid,'salt','double',[ni_rho_dimid nj_rho_dimid nz_dimid salt_time_dimid]);
netcdf.putAtt(ncid,saln_varid,'long_name','salinity climatology');
netcdf.putAtt(ncid,saln_varid,'units','psu');

temp_varid=netcdf.defVar(ncid,'temp','double',[ni_rho_dimid nj_rho_dimid nz_dimid temp_time_dimid]);
netcdf.putAtt(ncid,temp_varid,'long_name','potential temperature climatology');
netcdf.putAtt(ncid,temp_varid,'units','Celsius');

u_varid=netcdf.defVar(ncid,'u','double',[ni_u_dimid nj_u_dimid nz_dimid v3d_time_dimid]);
netcdf.putAtt(ncid,u_varid,'long_name','u-momentum component climatology');
netcdf.putAtt(ncid,u_varid,'units','meter second-1');

v_varid=netcdf.defVar(ncid,'v','double',[ni_v_dimid nj_v_dimid nz_dimid v3d_time_dimid]);
netcdf.putAtt(ncid,v_varid,'long_name','v-momentum component climatology');
netcdf.putAtt(ncid,v_varid,'units','meter second-1');

% Global attributes

% End definitions and leave define mode.
netcdf.endDef(ncid)





[~]=c_climatology(S);

S.ncname = 'BlackSea_clm_temp.nc';
S.def_zeta = 0;       S.zeta_time = 366;
S.def_v2d  = 0;       S.v2d_time  = 366;
S.def_v3d  = 0;       S.v3d_time  = 366;
S.def_temp = 1;       S.temp_time = 366;
S.def_salt = 0;       S.salt_time = 366;
[~]=c_climatology(S);

S.ncname = 'BlackSea_clm_u.nc';
S.def_zeta = 0;       S.zeta_time = 366;
S.def_v2d  = 0;       S.v2d_time  = 366;
S.def_v3d  = 1;       S.v3d_time  = 366;
S.def_temp = 0;       S.temp_time = 366;
S.def_salt = 0;       S.salt_time = 366;
S.uv=0;
[~]=c_climatology(S);
S.uv=1;
S.ncname = 'BlackSea_clm_v.nc';
[~]=c_climatology(S);


S.ncname = 'BlackSea_clm_ubarvbarzeta.nc';
S.def_zeta = 1;       S.zeta_time = 366;
S.def_v2d  = 1;       S.v2d_time  = 366;
S.def_v3d  = 0;       S.v3d_time  = 366;
S.def_temp = 0;       S.temp_time = 366;
S.def_salt = 0;       S.salt_time = 366;
[~]=c_climatology(S);






















