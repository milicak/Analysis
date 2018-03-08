clear all

deg2rad = pi/180;
grav = 9.81;
gridfile = '/home/milicak/Analysis/NorESM/climatology/Analysis/grid.nc';

lon = ncread(gridfile,'plon');
lat = ncread(gridfile,'plat');
dx = ncread(gridfile,'pdx');
dy = ncread(gridfile,'pdy');
angle = ncread(gridfile,'angle');
fcor = coriolis(lat);

x = lon;                                                                       
x = x(260:end,:);                                                              
x(x<0) = x(x<0)+360;                                                           
lon(260:end,:) = x;  

pclon=reshape(ncread(gridfile,'pclon'),[],4)';
pclat=reshape(ncread(gridfile,'pclat'),[],4)';

%lat = ncread('NBF1850_f19_tn11_test_mis3b_mixing3_SO.cam2.h0.3600-12.nc','lat');  
%lon = ncread('NBF1850_f19_tn11_test_mis3b_mixing3_SO.cam2.h0.3600-12.nc','lon');
%[lon lat] = meshgrid(lon,lat);
%lon = lon';
%lat = lat';


nx = 1000;
ny = 500;
lat1 = -89:89*2/(ny-1):89;
lon1 = -180:360/(nx-1):180;

for i=1:nx-1;for j=1:ny
dx2(i,j)=lldistkm([lat1(j) lon1(i)],[lat1(j) lon1(i+1)]);
end;end
for i=1:nx;for j=1:ny-1
dy2(i,j)=lldistkm([lat1(j) lon1(i)],[lat1(j+1) lon1(i)]);
end;end
dy2(:,end+1) = dy2(:,end);
dx2(end+1,:) = dx2(end,:);

[lon1 lat1] = meshgrid(lon1,lat1);
lon1 = lon1';
lat1 = lat1';
fcor2 = coriolis(lat1);


loncenter1 = -40;
latcenter1 = 38;
loncenter2 = -10;
latcenter2 = 70;
loncenter4 = -20;
latcenter4 = 55;

sigma = 16; % approximately 1500 km
sigma2 = 8; % approximately 1000 km
sigma4 = 18; % approximately 1000 km

dnm = 1.0*exp(-((lon1-loncenter1).^2+(lat1-latcenter1).^2)./(2*sigma^2));
dnm2 = -1.0.*exp(-((lon1-loncenter2).^2+(lat1-latcenter2).^2)./(2*sigma2^2));
dnm4 = 1.7.*exp(-((lon1-loncenter4).^2+(lat1-latcenter4).^2)./(2*sigma4^2));
dnm3 = (1.0*dnm+0.5*dnm2);

tmpx = (dnm3(2:end,:)-dnm3(1:end-1,:))./dx2(1:end-1,:);
tmpy = (dnm3(:,2:end)-dnm3(:,1:end-1))./dy2(:,1:end-1);
tmpx(end+1,:) = tmpx(end,:);
tmpy(:,end+1) = tmpy(:,end);
uvel = -grav*tmpy./fcor2;
vvel = grav*tmpx./fcor2;

% remove equator and SH
uvel(lat1<10) = 0.0; 
vvel(lat1<10) = 0.0; 
% remove north pole
uvel(lat1>=87.0) = 0.0; 
vvel(lat1>=87.0) = 0.0; 

%interpolate to micom grid
umicom = griddata(lon1,lat1,uvel,lon,lat);
vmicom = griddata(lon1,lat1,vvel,lon,lat);

cutoff = 1e-2;
umicom(abs(umicom)<cutoff) = 0.0;
vmicom(abs(vmicom)<cutoff) = 0.0;
return

%%%%%%% Need to rotate velocities using angle                                   
unew = uvel.*cos(angle)+vvel.*sin(angle);                                               
vnew = -uvel.*sin(angle)+vvel.*cos(angle);

figure
micom_flat(dnm3,pclon,pclat)
m_coast('patch',[.7 1 .7],'edgecolor','none');
figure
micom_flat(sq(uvel),pclon,pclat)
m_coast('patch',[.7 1 .7],'edgecolor','none');
figure
micom_flat(sq(vvel),pclon,pclat)
m_coast('patch',[.7 1 .7],'edgecolor','none');


figure
m_proj('Equidistant Cylindrical','lon',[0 360],'lat',[-90 90]);
m_pcolor(lon,lat,sq(dnm3));shf
m_coast('patch',[.7 1 .7],'edgecolor','none');
m_grid

%nccreate('area_cam.nc','area',...
%          'Dimensions',{'lon',nx,'lat',ny},...
%          'Format','classic')
%ncwrite('area_cam.nc','area',grid_area);

          

