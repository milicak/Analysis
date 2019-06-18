clear all
% variable names
fname = '/media/milicak/DATA1/datasets/WRF/BSA03/T2_full.nc'
varname = 'T2'

freqdata = 6; % six hours data 
dataperday = 24/freqdata; 

ocngrdname = '/media/milicak/DATA1/datasets/WRF/BSA03/BlackSea_grid_NX_896_NY_440.nc';
lonmit = ncread(ocngrdname,'nav_lon');
latmit = ncread(ocngrdname,'nav_lat');

grdname = '/media/milicak/DATA1/datasets/WRF/BSA03/wrf_model_mask.nc';
lon = ncread(grdname,'XLONG');
lat = ncread(grdname,'XLAT');
mask = ncread(grdname,'LANDMASK');
lon = double(lon);
lat = double(lat);
mask = double(mask);


index = 0
year = 2011;
for itr= 1:365*dataperday %2011
    index = index+1
    var = double(ncread(fname,varname,[1 1 itr],[Inf Inf 1]));
    dnm = griddata(lon(mask==0),lat(mask==0),var(mask==0), ...
            lon(mask==1),lat(mask==1),'nearest');
    var(mask==1) = dnm;
    varmit(:,:,index) = griddata(lon,lat,var,lonmit,latmit);
end
oname = [varname '_' num2str(year) '.data'];
fid=fopen(oname,'w','b');                             
fwrite(fid,varmit,'real*4');                             
fclose(fid)                                           
clear varmit

index = 0
year = 2012;
for itr = 365*dataperday+1 : (365+366)*dataperday %2012
    index = index+1;
    var = double(ncread(fname,varname,[1 1 itr],[Inf Inf 1]));
    dnm = griddata(lon(mask==0),lat(mask==0),var(mask==0), ...
            lon(mask==1),lat(mask==1),'nearest');
    var(mask==1) = dnm;
    varmit(:,:,index) = griddata(lon,lat,var,lonmit,latmit);
end
oname = [varname '_' num2str(year) '.data'];
fid=fopen(oname,'w','b');                             
fwrite(fid,varmit,'real*4');                             
fclose(fid)                                           
clear varmit

index = 0
year = 2013;
for itr = (365+366)*dataperday+1 : (365+366+365)*dataperday %2013
    index = index+1;
    var = double(ncread(fname,varname,[1 1 itr],[Inf Inf 1]));
    dnm = griddata(lon(mask==0),lat(mask==0),var(mask==0), ...
            lon(mask==1),lat(mask==1),'nearest');
    var(mask==1) = dnm;
    varmit(:,:,index) = griddata(lon,lat,var,lonmit,latmit);
end
oname = [varname '_' num2str(year) '.data'];
fid=fopen(oname,'w','b');                             
fwrite(fid,varmit,'real*4');                             
fclose(fid)                                           
clear varmit

index = 0
year = 2014;
for itr = (365+366+365)*dataperday+1 : (365+366+365+365)*dataperday %2014
    index = index+1;
    var = double(ncread(fname,varname,[1 1 itr],[Inf Inf 1]));
    dnm = griddata(lon(mask==0),lat(mask==0),var(mask==0), ...
            lon(mask==1),lat(mask==1),'nearest');
    var(mask==1) = dnm;
    varmit(:,:,index) = griddata(lon,lat,var,lonmit,latmit);
end
oname = [varname '_' num2str(year) '.data'];
fid=fopen(oname,'w','b');                             
fwrite(fid,varmit,'real*4');                             
fclose(fid)                                           
clear varmit

index = 0
year = 2015;
for itr = (365+366+365+365)*dataperday+1 : (365+366+365+365+365)*dataperday %2015
    index = index+1;
    var = double(ncread(fname,varname,[1 1 itr],[Inf Inf 1]));
    dnm = griddata(lon(mask==0),lat(mask==0),var(mask==0), ...
            lon(mask==1),lat(mask==1),'nearest');
    var(mask==1) = dnm;
    varmit(:,:,index) = griddata(lon,lat,var,lonmit,latmit);
end
oname = [varname '_' num2str(year) '.data'];
fid=fopen(oname,'w','b');                             
fwrite(fid,varmit,'real*4');                             
fclose(fid)                                           
clear varmit

index = 0
year = 2016;
for itr = (365+366+365+365+365)*dataperday+1 : (365+366+365+365+365+366)*dataperday %2016
    index = index+1;
    var = double(ncread(fname,varname,[1 1 itr],[Inf Inf 1]));
    dnm = griddata(lon(mask==0),lat(mask==0),var(mask==0), ...
            lon(mask==1),lat(mask==1),'nearest');
    var(mask==1) = dnm;
    varmit(:,:,index) = griddata(lon,lat,var,lonmit,latmit);
end
oname = [varname '_' num2str(year) '.data'];
fid=fopen(oname,'w','b');                             
fwrite(fid,varmit,'real*4');                             
fclose(fid)                                           
clear varmit

return

index = 0
year = 2017;
for itr = (365+366+365+365+365+366)*dataperday+1 : (365+366+365+365+365+366+365)*dataperday %2017
    index = index+1;
    var = double(ncread(fname,varname,[1 1 itr],[Inf Inf 1]));
    dnm = griddata(lon(mask==0),lat(mask==0),var(mask==0), ...
            lon(mask==1),lat(mask==1),'nearest');
    var(mask==1) = dnm;
    varmit(:,:,index) = griddata(lon,lat,var,lonmit,latmit);
end
oname = [varname '_' num2str(year) '.data'];
fid=fopen(oname,'w','b');                             
fwrite(fid,varmit,'real*4');                             
fclose(fid)                                           
clear varmit





