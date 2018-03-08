clear all


%now let's do the hybrid grid
nx = 600*2; %2800;
ny = 200*2; %3000; %820;
nxp = nx+1;
nyp = ny+1;

hmin = 20;  %m minimum depth
rtarget = 0.2; %aim for smoothing

% Title of the project
title = 'Marmara_Sea_mosaic'

%global_topo_file = '/export/grunchfs/unibjerknes/milicak/bckup/world_grid/ETOPO2v2g_f4.nc';
%global_topo_file = '/export/grunchfs/unibjerknes/milicak/bckup/world_grid/GEBCO_2014_1D.nc';
global_topo_file = '/okyanus/users/milicak/world_grid/GEBCO_2014_1D.nc';

%lon = ncread(global_topo_file,'x');
%lat = ncread(global_topo_file,'y');
topo = ncread(global_topo_file,'z');
dims = ncread(global_topo_file,'dimension');
topo = reshape(topo,[dims(1) dims(2)]);
topo = fliplr(topo);
lon = -180: (360/(double(dims(1))-1)) :180;
lat = -90: (180/(double(dims(2))-1)) :90;

lat_start = 40.2; %35; %southern boundary
lat_end = 41.08;   %northern boundary
lon_start = 26.58; %25; %eastern boundary
lon_end = 30.51; %29;   %western boundary

lat_startwoa = lat_start-1; %southern boundary
lat_endwoa = lat_end+1;   %northern boundary
lon_startwoa = lon_start-1; %eastern boundary
lon_endwoa = lon_end+1;   %western boundary

istr = max(find(lon<=lon_startwoa));
iend = max(find(lon<=lon_endwoa));
jstr = max(find(lat<=lat_startwoa));
jend = max(find(lat<=lat_endwoa));

lon_new = lon(istr:iend);
lat_new = lat(jstr:jend);
topo_new = topo(istr:iend,jstr:jend);
clear topo

% in this version we will use constant dx and dy
% However it is possible to do a varying change dx dy
LON = lon_start:(lon_end-lon_start)/(nx):lon_end;
LON = LON';
LON = repmat(LON,[1 nyp]);
LAT = lat_start:(lat_end-lat_start)/(ny):lat_end;
LAT = repmat(LAT,[nxp 1]);
earthRadiusInMeters = 6371000;
dx = distance(LAT(1:end-1,:),LON(1:end-1,:),LAT(2:end,:),LON(2:end,:),earthRadiusInMeters);
dy = distance(LAT(:,1:end-1),LON(:,1:end-1),LAT(:,2:end),LON(:,2:end),earthRadiusInMeters);

x = LON;
y = LAT;

disp(['xrho ; yrho'])
x_rho = 0.25*(x(1:nx-1,1:ny-1) + x(1:nx-1,2:ny) + x(2:nx,1:ny-1) + x(2:nx,2:ny));
y_rho = 0.25*(y(1:nx-1,1:ny-1) + y(1:nx-1,2:ny) + y(2:nx,1:ny-1) + y(2:nx,2:ny));

disp([' meshgrid'])
[lon_new lat_new]=meshgrid(lon_new,lat_new);
lon_new = double(lon_new');
lat_new = double(lat_new');
disp(['griddata'])
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

shallowest_depth = 0;
shallowest_ocean_depth = 0.01;
land = -0.03;
depth_t(depth_t<shallowest_depth & depth_t>land) = land;
if 0
[NX NY] = size(depth_t);
dnm = depth_t;
fprintf(1,'2. Removing isolated ocean points.\n') ;
for nn = 1:8   % 3 or 4 sweeps should be enough?
%for nn = 1:1   % 3 or 4 sweeps should be enough?
   for ii = 2:NX-1
      for jj = 2:NY-1
         sides = (depth_t(ii-1,jj  ) <= - shallowest_depth) + ...
                 (depth_t(ii  ,jj-1) <= - shallowest_depth) + ...
                 (depth_t(ii  ,jj+1) <= - shallowest_depth) + ...
                 (depth_t(ii+1,jj  ) <= - shallowest_depth) ;
         if(sides < 2 && depth_t(ii,jj) <= - shallowest_depth)    % Less than 2 sides of this ocean point areocean points.
            depth_t(ii,jj) = land ;
%           fprintf(1,' Splat (%d, %d)!\n',ii,jj) ;
         end % if
      end %jj
   end %ii
end % nn
%break
end

%clip land values
%depth_t(depth_t<-5) = -5;
% minimum ocean depth
disp(['minimum depth'])
depth_t(depth_t<shallowest_ocean_depth & depth_t>0) = shallowest_ocean_depth;
depth_t(depth_t>4000)=4000;

lon1 = x(2:2:end,2:2:end);
lat1 = y(2:2:end,2:2:end);
x1 = [26.5833   26.7117   26.9242   26.9084   26.5833   26.5833];
y1 = [40.4800   40.4946   40.5851   40.7137   40.7000   40.4800];
in = insphpoly(lon1,lat1,x1,y1,0,90);
in = double(in);
depth_t(in==1) = land;
x1 = [28.7164   28.7875   28.7846   28.7042   28.7164];
y1 = [41.0125   41.0122   41.0567   41.0537   41.0125];
in = insphpoly(lon1,lat1,x1,y1,0,90);
in = double(in);
depth_t(in==1) = land;

%bogaz artifical
x1 = [29.0133 29.0330 29.0330 29.0133 29.0133];
y1 = [41.0426 41.0426 41.08 41.08 41.0426];
in = insphpoly(lon1,lat1,x1,y1,0,90);
in = double(in);
depth_t(in==1) = 20;

area = dx(:,1:nyp-1).*dy(1:nxp-1,:);

[nxhalf nyhalf] = size(depth_t);

filename=[title 'N' num2str(nxhalf) 'M' num2str(nyhalf) '.nc']

disp([' Create the grid file...' filename])
disp([' nx = ',num2str(nx)])
disp([' ny = ',num2str(ny)])
disp(['nx and ny have to be even, otherwise do it again'])

%break

create_hgrid(nx,ny,nxhalf,nyhalf,filename,title)
%break

disp(' ')
disp([' Fill the filename...' filename])
ncwrite(filename,'x',x)
ncwrite(filename,'y',y)
ncwrite(filename,'dx',dx)
ncwrite(filename,'dy',dy)
ncwrite(filename,'depth',depth_t)
ncwrite(filename,'area',area)
ncwrite(filename,'angle',zeros(nx,ny))
