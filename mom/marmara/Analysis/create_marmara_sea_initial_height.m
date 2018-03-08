clear all

% Title of the project
title = 'Marmara_Sea_mosaic'
grdname = 'Marmara_Sea_mosaicN600M200.nc';
%grdname = 'Eagean_Sea_mosaicN1400M1500.nc';
%command = ['cp ' grdname ' ' outname];
%status = system(command);

ll1 = ncread(grdname,'x');
ll2 = ncread(grdname,'y');
depth = double(ncread(grdname,'depth'));
depth(depth<=0) = 0;
mask = double(ncread(grdname,'depth'));
mask(mask>0) = 1;
mask(mask<=0) = 0;
lon = ll1(2:2:end,2:2:end);
lat = ll2(2:2:end,2:2:end);


lon_c = 29.0;
lat_c = 40.84;

%initial wave is zero
%hini = zeros(size(lon,1),size(lon,2));
%hini(isnan(hini)) = 0.0;

% read all variables from the text file
aa=load('co_seismic_displacement_noheader.txt');

% lon and lat values for the earthquake
loneq = aa(:,3);
lateq = aa(:,4);

% earthquake initial ssh
ssheq = aa(:,6);

% idealized polygon points
% polygon has to be closed so be careful
% These numbers will change according to Sinan's input
xq=[28.5 28.5 29 29 28.5];
yq=[40.6 40.8 40.8 40.6 40.6];

% create a mask of points inside the polygon
[in,on] = inpolygon(loneq,lateq,xq,yq);

% now interpolate this on the MOM6 grid
% assuming lon, lat are the MOM6 grid variables

hini = griddata(loneq(in),lateq(in),ssheq(in),double(lon),double(lat));
hini(isnan(hini)) = 0.0;

return
if 0
for i=1:size(lon,1)
    for j=1:size(lon,2)
       tmp =( (lon(i,j)-lon_c)^2 + (lat(i,j)-lat_c)^2) / (2.0*0.125/128.0);
       hini(i,j) = 5.0*exp(-tmp);
    end
end
end

hini = hini.*mask;
hini(hini == 0)=1e-10;
hini = depth+hini;
[nxhalf nyhalf] = size(hini);
nx = 2*nxhalf;
ny = 2*nyhalf;

filename=[title 'N' num2str(nxhalf) 'M' num2str(nyhalf) '_hini.nc']
create_hini_file(nx,ny,nxhalf,nyhalf,filename,title)
ncwrite(filename,'h',hini);
