clear all

lons=ncread('NBF1850_f19_tn11_test_mis3b_mixing3_SO.cam2.h0.3600-12.nc','slon');
lats=ncread('NBF1850_f19_tn11_test_mis3b_mixing3_SO.cam2.h0.3600-12.nc','slat'); 
lat=ncread('NBF1850_f19_tn11_test_mis3b_mixing3_SO.cam2.h0.3600-12.nc','lat');  
lon=ncread('NBF1850_f19_tn11_test_mis3b_mixing3_SO.cam2.h0.3600-12.nc','lon');



resolution = 1.8947;
resolution2 = 2.5;
nx = 144;
ny = 96;


nccreate('area_cam.nc','area',...
          'Dimensions',{'lon',nx,'lat',ny},...
          'Format','classic')

          
deg2rad=pi/180;
%grid_center_lat=ones(nx,1)*(-89.5:resolution:89.5);
%grid_center_lon=(0.5:resolution:359.5)'*ones(1,ny);
dnm = -90:180/(ny-1):90;
grid_center_lat=ones(nx,1)*dnm;
dnm = 0:357.5/(nx-1):357.5;
grid_center_lon=dnm'*ones(1,ny);
grid_corner_lat=zeros(4,nx,ny);
grid_corner_lon=zeros(4,nx,ny);
grid_corner_lat(1,:,:)=grid_center_lat-0.5*resolution;
grid_corner_lat(2,:,:)=grid_center_lat-0.5*resolution;
grid_corner_lat(3,:,:)=grid_center_lat+0.5*resolution;
grid_corner_lat(4,:,:)=grid_center_lat+0.5*resolution;
grid_corner_lon(1,:,:)=grid_center_lon-0.5*resolution;
grid_corner_lon(2,:,:)=grid_center_lon+0.5*resolution;
grid_corner_lon(3,:,:)=grid_center_lon+0.5*resolution;
grid_corner_lon(4,:,:)=grid_center_lon-0.5*resolution;
grid_area=2*(sin(grid_corner_lat(4,1,:)*deg2rad) ...
            -sin(grid_corner_lat(1,1,:)*deg2rad))*pi/nx;
grid_area=ones(nx,1)*reshape(grid_area,1,[])*rad2km(1)*1e3*(rad2km(1)*1e3);

ncwrite('area_cam.nc','area',grid_area);
