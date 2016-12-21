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
disp('getting roms grid dimensions ...');
gn=roms_get_grid_mw(gridname,[S.theta_s S.theta_b S.Tcline S.N S.Vstretching]);

fn=clim_name;
% Call to create the initial (ini) file
disp('going to create init file')
make_initial_blacksea(fn,gn,ini_name,wdr,T1)



