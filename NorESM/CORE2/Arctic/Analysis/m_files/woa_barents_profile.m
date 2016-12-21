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

% barents basin
x=[19.7071
   19.0959
   18.6814
   18.3724
   17.9220
   18.1664
   17.8706
   17.5346
   17.9180
   20.1578
   22.7161
   32.2109
   43.1429
   50.9130
   58.6355
   63.5817
   66.8387
   68.6011
   66.4919
   60.3575
   55.7395
   54.7073
   49.3743
   20.7319
   19.7071];
y=[   69.8284
   71.2928
   72.3131
   73.6369
   74.9009
   75.7959
   76.1340
   76.8250
   78.4396
   79.5847
   79.8880
   79.8457
   79.8200
   79.3279
   78.7119
   77.9732
   77.4845
   76.6687
   75.9617
   75.1764
   72.8633
   71.3728
   66.2373
   68.7426
   69.8284];

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
temp_barents=tmp2./total_area;

% salinity
tmp=salt;
tmp2=tmp.*in.*area;
tmp2=squeeze(nansum(tmp2,2));
tmp2=squeeze(nansum(tmp2,1));
salt_barents=tmp2./total_area;

save('matfiles/woa_barents_sea_profile.mat','temp_barents','salt_barents','zt')



