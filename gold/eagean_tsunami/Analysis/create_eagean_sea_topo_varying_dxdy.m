clear all


%now let's do the hybrid grid

res1=1e3; %m in high resoultion
res2=4e3; %m in low  resoultion
hmin=15;  %m minimum depth
rtarget=0.2; %aim for smoothing

% Title of the project
title='Eagean_Sea_mosaic'

global_topo_file='/work/milicak/ETOPO2v2g_f4.nc';

lon=ncread(global_topo_file,'x');
lat=ncread(global_topo_file,'y');
topo=ncread(global_topo_file,'z');

%lat_start=48;%southern boundary
%lat_end=65;  %northern boundary
%lon_start=-65;%southern boundary
%lon_end=-35;  %northern boundary

lat_start=-90;%southern boundary
lat_end=90;  %northern boundary
lon_start=-180;%southern boundary
lon_end=180;  %northern boundary

lat_high_res_start=52;
lat_high_res_end=64;
lon_high_res_start=-64;
lon_high_res_end=-40;

istr=max(find(lon<=lon_start));
iend=max(find(lon<=lon_end));
jstr=max(find(lat<=lat_start));
jend=max(find(lat<=lat_end));

lon_new=lon(istr:iend);
lat_new=lat(jstr:jend);
topo_new=topo(jstr:jend,istr:iend);
break

% in this version we will use constant dx and dy
% However it is possible to do a varying change dx dy

if 0
    % alittle bit bigger domain to remove Nan
    lat_start1=lat_start-1;%southern boundary
    lat_end1=lat_end+1;  %northern boundary
    lon_start1=lon_start-1;%southern boundary
    lon_end1=lon_end+1;  %northern boundary

    istr=max(find(lon<=lon_start1));
    iend=max(find(lon<=lon_end1));
    jstr=max(find(lat<=lat_start1));
    jend=max(find(lat<=lat_end1));

    lon_new1=lon(istr:iend);
    lat_new1=lat(jstr:jend);
    topo_new1=topo(jstr:jend,istr:iend);
end

%figure(1)
%m_proj('lambert','lon',[lon_start lon_end],'lat',[lat_start lat_end]);
%m_contour(lon_new,lat_new,topo_new,30);
%m_grid

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%Variable resolution dx
%lon_new=lon_new1(1):(lon_new1(end)-lon_new1(1))/Nx:lon_new1(end);
lon_hybrid(1) = lon_new(1);
%dx(1,1)=res2;
xchange=false;
i=2;
while logical(xchange)==0
    if(lon_hybrid(i-1) >= lon_high_res_start & lon_hybrid(i-1) <= lon_high_res_end )
       dx(i-1,1) = res1;
    elseif (lon_hybrid(i-1) < lon_high_res_start)
       dx(i-1,1) = res2-(res2-res1)*(lon_hybrid(i-1)-lon_new(1))/(lon_high_res_start-lon_new(1));
    elseif (lon_hybrid(i-1) > lon_high_res_end)
       dx(i-1,1) = res2-(res2-res1)*(lon_hybrid(i-1)-lon_new(end))/(lon_high_res_end-lon_new(end));
    end
    lon_hybrid(i) = km2deg(4*dx(i-1)/1e3)+lon_hybrid(i-1);
    if (lon_hybrid(i) >= lon_new(end))
       xchange=true;
    end
    i=i+1;
end

%Variable resolution dy
lat_hybrid(1) = lat_new(1);
ychange=false;
i=2;
while logical(ychange)==0
    if(lat_hybrid(i-1) >= lat_high_res_start & lat_hybrid(i-1) <= lat_high_res_end )
       dy(i-1,1) = res1;
    elseif (lat_hybrid(i-1) < lat_high_res_start)
       dy(i-1,1) = res2-(res2-res1)*(lat_hybrid(i-1)-lat_new(1))/(lat_high_res_start-lat_new(1));
    elseif (lat_hybrid(i-1) > lat_high_res_end)
       dy(i-1,1) = res2-(res2-res1)*(lat_hybrid(i-1)-lat_new(end))/(lat_high_res_end-lat_new(end));
    end
    lat_hybrid(i) = km2deg(dy(i-1)/1e3)+lat_hybrid(i-1);
    if (lat_hybrid(i) >= lat_new(end))
       ychange=true;
    end
    i=i+1;
end

%break
%check if they are even or not
nx=length(lon_hybrid);
ny=length(lat_hybrid);

if(isodd(nx)==0)
   nx=nx+1;
   dnm=lon_hybrid(end-1)-lon_hybrid(end);
   lon_hybrid(end+1)=lon_hybrid(end)+dnm;
   dx(end+1)=dx(end);
end

if(isodd(ny)==0)
   ny=ny+1;
   dnm=lat_hybrid(end-1)-lat_hybrid(end);
   lat_hybrid(end+1)=lat_hybrid(end)+dnm;
   dy(end+1)=dy(end);
end


%dx(1:nx)=pos2dist(lat_start,lon_start,lat_start,lon_end,1)*1e3/nx; %in meters for the hybrid grid 2*dx is the model resolution in x-direction
%dy(1:ny)=pos2dist(lat_start,lon_start,lat_end,lon_start,1)*1e3/ny; %in meters for the hybrid grid 2*dy is the model resolution in y-direction
%LON=lon_start:(lon_end-lon_start)/(nx):lon_end;
%LAT=lat_start:(lat_end-lat_start)/(ny):lat_end;

[x y]=meshgrid(lon_hybrid,lat_hybrid);

for i=1:nx-1
for j=1:ny-1
x_rho(j,i)=0.25*(x(j,i)+x(j,i+1)+x(j+1,i)+x(j+1,i+1));
y_rho(j,i)=0.25*(y(j,i)+y(j,i+1)+y(j+1,i)+y(j+1,i+1));
end
end

depth_t=griddata(lon_new1,lat_new1,topo_new1,x_rho,y_rho);

h=-depth_t;
h=smoothgrid(h,hmin,rtarget);
land_mask=ones(size(h,1),size(h,2));
land_mask(h<=hmin+2)=0;
%land_mask(depth_t>-hmin)=0;
mask_rho=land_mask(1:2:end,1:2:end);

clear depth_t
depth_t=h(1:2:end,1:2:end);
depth_t(mask_rho==0)=0;
break

%contour(x_rho,y_rho,depth_t,30);

nyp=ny+1;
nxp=nx+1;
dx_real=repmat(dx',ny,1);
dy_real=repmat(dy,1,nx);
area=dx_real(1:ny-1,:).*dy_real(:,1:nx-1);

[nyhalf nxhalf]=size(depth_t);

filename=[title 'N' num2str(nxhalf) 'M' num2str(nyhalf) '.nc']

disp([' Create the grid file...' filename])
disp([' nx = ',num2str(nx)])
disp([' ny = ',num2str(ny)])
disp(['nx and ny have to be even, otherwise do it again'])

%break

create_hgrid(nx,ny,nxhalf,nyhalf,filename,title)

disp(' ')
disp([' Fill the filename...' filename])
nc=netcdf(filename,'write');

nc{'x'}(:)=x;
nc{'y'}(:)=y;
nc{'area'}(:)=area;
nc{'dx'}(:)=dx_real;
nc{'dy'}(:)=dy_real;
nc{'depth'}(:)=depth_t;
nc{'angle'}(:)=zeros(ny,nx);

result=close(nc);

