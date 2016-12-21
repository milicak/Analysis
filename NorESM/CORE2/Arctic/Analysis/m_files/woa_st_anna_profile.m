clear all

grid_file='/home/fimm/bjerknes/milicak/Analysis/NorESM/climatology/Analysis/WOA09_salt.nc';
lon=ncgetvar(grid_file,'lon');
lat=ncgetvar(grid_file,'lat');
[lon lat]=meshgrid(lon,lat);
lon=lon';lat=lat';

filename_s='/home/fimm/bjerknes/milicak/Analysis/NorESM/climatology/Analysis/WOA09_salt.nc';
filename_t='/home/fimm/bjerknes/milicak/Analysis/NorESM/climatology/Analysis/WOA09_temp.nc';
salt=ncgetvar(filename_s,'s');
temp=ncgetvar(filename_t,'t');
zt=nc_varget(filename_t,'depth');

resolution=1; %1; %0.5;
nx=360;
ny=180;
deg2rad=pi/180;
%grid_center_lat=ones(nx,1)*(-89.5:resolution:89.5);
%grid_center_lon=(0.5:resolution:359.5)'*ones(1,ny);
grid_center_lat=ones(nx,1)*(-90+resolution*0.5:resolution:90-resolution*0.5);
grid_center_lon=(0+resolution*0.5:resolution:360-resolution*0.5)'*ones(1,ny);
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
grid_area=ones(nx,1)*reshape(grid_area,1,[]);
area=grid_area;

x=[64.4897
   68.2101
   70.5941
   73.3574
   76.4362
   77.3953
   77.3654
   75.7384
   73.3536
   66.1355
   62.8216
   61.7141
   61.8900
   63.1248
   64.4897];
y=[   80.3753
   80.4973
   80.4742
   80.4529
   80.2670
   79.4066
   78.7283
   77.7325
   76.9500
   76.7388
   77.6636
   78.4921
   79.0841
   79.8339
   80.3753];

in=insphpoly(lon,lat,x,y,0,90);
in=double(in);
in(in==0)=NaN;
in=repmat(in,[1 1 33]);
% temperature
tmp=temp;

area=repmat(area,[1 1 33]);
area(isnan(tmp))=NaN;
total_area=in.*area;
total_area=squeeze(nansum(total_area,2)); 
total_area=squeeze(nansum(total_area,1));

tmp2=tmp.*in.*area;
tmp2=squeeze(nansum(tmp2,2));
tmp2=squeeze(nansum(tmp2,1));
temp_st_anna=tmp2./total_area;

% salinity
tmp=salt;
tmp2=tmp.*in.*area;
tmp2=squeeze(nansum(tmp2,2));
tmp2=squeeze(nansum(tmp2,1));
salt_st_anna=tmp2./total_area;

save('matfiles/woa_st_anna_profiles.mat','temp_st_anna','salt_st_anna','zt')



