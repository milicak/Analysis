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

S.def_zeta = 0;       S.zeta_time = 366;
S.def_v2d  = 0;       S.v2d_time  = 366;
S.def_v3d  = 0;       S.v3d_time  = 366;
S.def_temp = 0;       S.temp_time = 366;
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


S.ncname = 'BlackSea_clm_zeta.nc';
S.def_zeta = 1;       S.zeta_time = 366;
S.def_v2d  = 0;       S.v2d_time  = 366;
S.def_v3d  = 0;       S.v3d_time  = 366;
S.def_temp = 0;       S.temp_time = 366;
S.def_salt = 0;       S.salt_time = 366;
[~]=c_climatology(S);

S.ncname = 'BlackSea_clm_ubarvbar.nc';
S.def_zeta = 0;       S.zeta_time = 366;
S.def_v2d  = 1;       S.v2d_time  = 366;
S.def_v3d  = 0;       S.v3d_time  = 366;
S.def_temp = 0;       S.temp_time = 366;
S.def_salt = 0;       S.salt_time = 366;
[~]=c_climatology(S);

display('use ncecat to combine netcdf files at hexagon, fimm or grunch')
display('ncks -4 BlackSea_clm_salt.nc BlackSea_clm.nc')
display('ncks -A -v zeta,zeta_time -o BlackSea_clm.nc BlackSea_clm_zeta.nc')
display('ncks -A -v v,v3d_time -o BlackSea_clm.nc BlackSea_clm_v.nc')
display('ncks -A -v ubar,vbar,v2d_time -o BlackSea_clm.nc BlackSea_clm_ubarvbar.nc')
display('ncks -A -v temp,temp_time -o BlackSea_clm.nc BlackSea_clm_temp.nc')











