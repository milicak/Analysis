clear all

filename=['ECMWF_cloudcover_sealevelpress_2012_3hours_notsort.nc'];
filename2=['ECMWF_cloudcover_sealevelpress_2012_3hours.nc'];

time=ncread(filename,'time');
[tsort I]=sort(time);
v1=ncread(filename,'msl');
v2=ncread(filename,'tcc');
v1=v1(:,:,I);
v2=v2(:,:,I);

%ncwrite(filename2,'msl',v1);
nc=netcdf(filename2,'w');
nc{'msl'}(:)=v1;
ncwrite(filename2,'tcc',v2);
ncwrite(filename2,'time',tsort);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear all

filename=['ECMWF_T2_Tdew2_2012_3hours_notsort.nc'];
filename2=['ECMWF_T2_Tdew2_2012_3hours.nc'];

time=ncread(filename,'time');
[tsort I]=sort(time);
v1=ncread(filename,'d2m');
v2=ncread(filename,'t2m');
v1=v1(:,:,I);
v2=v2(:,:,I);

ncwrite(filename2,'d2m',v1);
ncwrite(filename2,'t2m',v2);
ncwrite(filename2,'time',tsort);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear all

filename=['ECMWF_u10_v10_2012_3hours_notsort.nc'];
filename2=['ECMWF_u10_v10_2012_3hours.nc'];

time=ncread(filename,'time');
[tsort I]=sort(time);
v1=ncread(filename,'u10');
v2=ncread(filename,'v10');
v1=v1(:,:,I);
v2=v2(:,:,I);

ncwrite(filename2,'u10',v1);
ncwrite(filename2,'v10',v2);
ncwrite(filename2,'time',tsort);
