clear all


%now let's do the hybrid grid
nx = 720;
ny = 820;
nxp = nx+1;
nyp = ny+1;

hmin = 20;  %m minimum depth
rtarget = 0.2; %aim for smoothing

% Title of the project
title = 'Eagean_Sea_mosaic'

global_topo_file = '/work/milicak/ETOPO2v2g_f4.nc';

lon = ncread(global_topo_file,'x');
lat = ncread(global_topo_file,'y');
topo = ncread(global_topo_file,'z');

lat_start = 30.5; %southern boundary
lat_end = 42;   %northern boundary
lon_start = 20.2; %eastern boundary
lon_end = 30;   %western boundary

%lat_start = -90;%southern boundary
%lat_end = 90;  %northern boundary
%lon_start = -180;%southern boundary
%lon_end = 180;  %northern boundary

istr = max(find(lon<=lon_start));
iend = max(find(lon<=lon_end));
jstr = max(find(lat<=lat_start));
jend = max(find(lat<=lat_end));

lon_new = lon(istr:iend);
lat_new = lat(jstr:jend);
topo_new = topo(istr:iend,jstr:jend);

% in this version we will use constant dx and dy
% However it is possible to do a varying change dx dy
LON = lon_start:(lon_end-lon_start)/(nx):lon_end;
LON = LON';
LON = repmat(LON,[1 nyp]);
LAT = lat_start:(lat_end-lat_start)/(ny):lat_end;
LAT = repmat(LAT,[nxp 1]);
if 0
    % just for global tripolar grid case
    LAT = ncread('/work/milicak/RUNS/gold/ocean_hgrid.nc','y');
    LON = ncread('/work/milicak/RUNS/gold/ocean_hgrid.nc','x');
end
earthRadiusInMeters = 6371000;
dx = distance(LAT(1:end-1,:),LON(1:end-1,:),LAT(2:end,:),LON(2:end,:),earthRadiusInMeters);
dy = distance(LAT(:,1:end-1),LON(:,1:end-1),LAT(:,2:end),LON(:,2:end),earthRadiusInMeters);

x = LON;
y = LAT;

for i=1:nx-1
for j=1:ny-1
x_rho(i,j)=0.25*(x(i,j)+x(i,j+1)+x(i+1,j)+x(i+1,j+1));
y_rho(i,j)=0.25*(y(i,j)+y(i,j+1)+y(i+1,j)+y(i+1,j+1));
end
end

[lon_new lat_new]=meshgrid(lon_new,lat_new);
lon_new = double(lon_new');
lat_new = double(lat_new');
depth_t = griddata(lon_new,lat_new,topo_new,x_rho,y_rho);

h = -depth_t;
%%h = smoothgrid(h,hmin,rtarget);
%land_mask = ones(size(h,1),size(h,2));
%land_mask(h<=hmin+2) = 0;
%land_mask(depth_t>-hmin)=0;
%mask_rho = land_mask(1:2:end,1:2:end);

clear depth_t
depth_t = h(1:2:end,1:2:end);
%depth_t(mask_rho==0)=0;

area = dx(:,1:nyp-1).*dy(1:nxp-1,:);

[nxhalf nyhalf] = size(depth_t);

filename=[title 'N' num2str(nxhalf) 'M' num2str(nyhalf) '.nc']

disp([' Create the grid file...' filename])
disp([' nx = ',num2str(nx)])
disp([' ny = ',num2str(ny)])
disp(['nx and ny have to be even, otherwise do it again'])

%break

create_hgrid(nx,ny,nxhalf,nyhalf,filename,title)

disp(' ')
disp([' Fill the filename...' filename])
ncwrite(filename,'x',x)
ncwrite(filename,'y',y)
ncwrite(filename,'dx',dx)
ncwrite(filename,'dy',dy)
ncwrite(filename,'depth',depth_t)
ncwrite(filename,'area',area)
ncwrite(filename,'angle',zeros(nx,ny))
