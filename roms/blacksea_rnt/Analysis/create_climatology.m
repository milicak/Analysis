clear all

nameit='blacksea';
grd=rnt_gridload(nameit);

%  Vertical transfomation equation (Vtransform).
%    (Check  https://www.myroms.org/wiki/index.php/Vertical_S-coordinate)
%
%            [1] Original tranformation equation
%            [2] New transformation equation

grd.vtra = 1;

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

grd.vstr = 4;

%  Vertical stretching parameters:
%
%            tetha_s:  S-coordinate surface control parameter.
%            tetha_b:  S-coordinate bottom control parameter.
%            Tcline:   S-coordinate surface/bottom stretching width (m)

grd.theta_s = 5.0;
grd.theta_b = 0.4;

datadir='.';
outdir='./';

% the following file will be made if it does not exist.
levfile=         [outdir,'Levitus.mat'];

% first create climatology file with all variables for 24 times (15days frequency)
clmfile=[outdir,nameit,'-clim_all.nc'];
create_climatology_netcdf4_all(grd,clmfile)

break
break

% first create climatology file with 3d uvel values
clmfile=[outdir,nameit,'-clim_uvel.nc'];
create_climatology_netcdf4_uvel(grd,clmfile)

% first create climatology file with 3d vvel values
clmfile=[outdir,nameit,'-clim_vvel.nc'];
create_climatology_netcdf4_vvel(grd,clmfile)

% first create climatology file with 3d temp values
clmfile=[outdir,nameit,'-clim_temp.nc'];
create_climatology_netcdf4_temp(grd,clmfile)

% first create climatology file with 3d salt values
clmfile=[outdir,nameit,'-clim_salt.nc'];
create_climatology_netcdf4_salt(grd,clmfile)


display('use ncecat to combine netcdf files at grunch')
display('cp blacksea-clim_salt.nc blacksea-clim.nc')
display('ncks -4 blacksea-clim.nc blacksea-clim.nc')
display('ncks -A -v temp,temp_time -o blacksea-clim.nc blacksea-clim_temp.nc')
display('ncks -A -v v,v3d_time -o blacksea-clim.nc blacksea-clim_vvel.nc')
display('ncks -A -v u,v3d_time -o blacksea-clim.nc blacksea-clim_uvel.nc')
