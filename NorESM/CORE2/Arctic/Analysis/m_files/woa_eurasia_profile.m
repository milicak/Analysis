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

% Euroasian basin
x=[27.2474628708497
          36.5447032085722
          48.5214896162041
          60.7001380803934
          77.9434238049383
          94.8206611280039
          107.876624193844
           114.76253701556
          121.721644200227
          134.412781688966
          140.650432725167
          141.964704250335
          145.155248340791
          149.246374638137
          132.143273251575
           149.76109018589
         -79.6880622455017
           -55.18591213471
         -43.4591200137502
         -22.0049915144465
         -20.6758818057775
         -17.5930251981611
         -9.73692516655174
          5.28638472739742
          27.2474628708497];

y=[      81.2047365447009
          81.5007859895957
          82.2436675361916
           82.721919243158
          82.4532187163616
          81.6658524321853
          80.1201616988957
           78.868040305759
          77.3745806589471
           78.343810419039
          79.2198008825623
          81.0361747596064
          82.8850251870597
          84.6970166179212
           88.170272215848
          88.5112003265041
          89.0201530656119
            86.82607324433
          85.3307236364029
          85.7137862915936
          84.4424860812103
          83.6275436815664
          82.8313390219846
          82.2610471668164
          81.2047365447009];


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
temp_eurasia=tmp2./total_area;

% salinity
tmp=salt;
tmp2=tmp.*in.*area;
tmp2=squeeze(nansum(tmp2,2));
tmp2=squeeze(nansum(tmp2,1));
salt_eurasia=tmp2./total_area;

save('matfiles/woa_eurasia_basin_profiles.mat','temp_eurasia','salt_eurasia','zt')



