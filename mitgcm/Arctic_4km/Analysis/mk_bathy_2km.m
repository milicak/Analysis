clear all 
close all
load grid
nx = 3360;
ny = 3072;
fact = 6370/6.378137;  % factor used to convert km output from m_lldist on
                     % a sphere with 6378.137 km to m on a sphere with
                     % radius 6370 km
%read 4 km lon lat values                    
lonc = LON(4:2:(end-3),4:2:(end-3));
latc = LAT(4:2:(end-3),4:2:(end-3));

lon = LON(3:1:(end-3),3:1:(end-3));
lat = LAT(3:1:(end-3),3:1:(end-3));

%read 4km bathy file
Depth = rdmds('Depth_4km');

%interpolate to the 2km grid
bathy = griddata(lonc, latc, Depth, lon, lat);

bathy(isnan(bathy)) = 0;
bathy(bathy<=10) = 0;

tmp1 = bathy;  
tmp1(bathy==0) = 1;
tmp1(bathy > 0) = 0;
tmp2 = imfill(tmp1,'holes');
fill = tmp2-tmp1;
bathy(logical(fill)) = 0;

writebin('BATHY_3360x3072_arctic_2km',bathy);
