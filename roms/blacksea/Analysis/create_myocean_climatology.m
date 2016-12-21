clear all

filename1='/home/mil021/Downloads/myocean_blacksea_tempsaltvel_01_01_2012_to_05_01_2012.nc';
filename2='/home/mil021/Downloads/myocean_blacksea_tempsaltvel_05_02_2012_to_09_01_2012.nc';
filename3='/home/mil021/Downloads/myocean_blacksea_tempsaltvel_09_02_2012_to_12_31_2012.nc';
outname='myocean_blacksea_tempsaltvel_01_01_2012_to_12_31_2012.nc';

time_long_name=ncgetatt(filename1,'long_name','time');
time_units=ncgetatt(filename1,'units','time');
time_calendar=ncgetatt(filename1,'calendar','time');

depth=ncgetvar(filename1,'dep');
lon=ncgetvar(filename1,'lon');
lat=ncgetvar(filename1,'lat');

salt1=ncgetvar(filename1,'sea_water_salinity');
temp1=ncgetvar(filename1,'sea_water_temperature');
u1=ncgetvar(filename1,'eastward_sea_water_velocity');
v1=ncgetvar(filename1,'northward_sea_water_velocity');
time1=ncgetvar(filename1,'time');
ssh1=ncgetvar(filename1,'sea_surface_height_above_sea_level');

salt2=ncgetvar(filename2,'sea_water_salinity');
temp2=ncgetvar(filename2,'sea_water_temperature');
u2=ncgetvar(filename2,'eastward_sea_water_velocity');
v2=ncgetvar(filename2,'northward_sea_water_velocity');
time2=ncgetvar(filename2,'time');
ssh2=ncgetvar(filename2,'sea_surface_height_above_sea_level');

salt3=ncgetvar(filename3,'sea_water_salinity');
temp3=ncgetvar(filename3,'sea_water_temperature');
u3=ncgetvar(filename3,'eastward_sea_water_velocity');
v3=ncgetvar(filename3,'northward_sea_water_velocity');
time3=ncgetvar(filename3,'time');
ssh3=ncgetvar(filename3,'sea_surface_height_above_sea_level');


time=[time1;time2;time3];
temp(:,:,:,1:size(temp1,4))=temp1;
temp(:,:,:,size(temp1,4)+1:size(temp1,4)+1+size(temp2,4)-1)=temp2;
temp(:,:,:,size(temp1,4)+size(temp2,4)+1:size(temp1,4)+size(temp2,4)+1+size(temp3,4)-1)=temp3;

salt(:,:,:,1:size(temp1,4))=salt1;
salt(:,:,:,size(temp1,4)+1:size(temp1,4)+1+size(temp2,4)-1)=salt2;
salt(:,:,:,size(temp1,4)+size(temp2,4)+1:size(temp1,4)+size(temp2,4)+1+size(temp3,4)-1)=salt3;

u(:,:,:,1:size(temp1,4))=u1;
u(:,:,:,size(temp1,4)+1:size(temp1,4)+1+size(temp2,4)-1)=u2;
u(:,:,:,size(temp1,4)+size(temp2,4)+1:size(temp1,4)+size(temp2,4)+1+size(temp3,4)-1)=u3;

v(:,:,:,1:size(temp1,4))=v1;
v(:,:,:,size(temp1,4)+1:size(temp1,4)+1+size(temp2,4)-1)=v2;
v(:,:,:,size(temp1,4)+size(temp2,4)+1:size(temp1,4)+size(temp2,4)+1+size(temp3,4)-1)=v3;

ssh(:,:,1:size(temp1,4))=ssh1;
ssh(:,:,size(temp1,4)+1:size(temp1,4)+1+size(temp2,4)-1)=ssh2;
ssh(:,:,size(temp1,4)+size(temp2,4)+1:size(temp1,4)+size(temp2,4)+1+size(temp3,4)-1)=ssh3;

% convert Kelvin to Celcisius
temp=temp-272.15;

% Create netcdf file.
ncid=netcdf.create(outname,'NC_CLOBBER');
nx=size(temp,1);
ny=size(temp,2);
nz=size(temp,3);

% Define dimensions.
ni_dimid=netcdf.defDim(ncid,'ni',nx);
nj_dimid=netcdf.defDim(ncid,'nj',ny);
nk_dimid=netcdf.defDim(ncid,'nk',nz);
time_dimid=netcdf.defDim(ncid,'time',netcdf.getConstant('NC_UNLIMITED'));
[lon lat]=meshgrid(lon,lat);lon=lon';lat=lat';

% Define variables and assign attributes
time_varid=netcdf.defVar(ncid,'time','double',time_dimid);
netcdf.putAtt(ncid,time_varid,'long_name',time_long_name);
netcdf.putAtt(ncid,time_varid,'units',time_units);
netcdf.putAtt(ncid,time_varid,'calendar',time_calendar);

tlon_varid=netcdf.defVar(ncid,'LON','double',[ni_dimid nj_dimid]);
netcdf.putAtt(ncid,tlon_varid,'long_name','T grid center longitude');
netcdf.putAtt(ncid,tlon_varid,'units','degrees_east');

tlat_varid=netcdf.defVar(ncid,'LAT','double',[ni_dimid nj_dimid]);
netcdf.putAtt(ncid,tlat_varid,'long_name','T grid center latitude');
netcdf.putAtt(ncid,tlat_varid,'units','degrees_north');

depth_varid=netcdf.defVar(ncid,'Depth','double',[nk_dimid]);
netcdf.putAtt(ncid,depth_varid,'long_name','Depth');
netcdf.putAtt(ncid,depth_varid,'units','meter');

ssh_varid=netcdf.defVar(ncid,'ssh','double',[ni_dimid nj_dimid time_dimid]);
netcdf.putAtt(ncid,ssh_varid,'long_name','ssh');
netcdf.putAtt(ncid,ssh_varid,'units','m');
netcdf.putAtt(ncid,ssh_varid,'coordinates','TLON TLAT');

temp_varid=netcdf.defVar(ncid,'temp','double',[ni_dimid nj_dimid nk_dimid time_dimid]);
netcdf.putAtt(ncid,temp_varid,'long_name','temp');
netcdf.putAtt(ncid,temp_varid,'units','C');
netcdf.putAtt(ncid,temp_varid,'coordinates','TLON TLAT');

salt_varid=netcdf.defVar(ncid,'salt','double',[ni_dimid nj_dimid nk_dimid time_dimid]);
netcdf.putAtt(ncid,salt_varid,'long_name','salt');
netcdf.putAtt(ncid,salt_varid,'units','psu');
netcdf.putAtt(ncid,salt_varid,'coordinates','TLON TLAT');

uvel_varid=netcdf.defVar(ncid,'uvel','double',[ni_dimid nj_dimid nk_dimid time_dimid]);
netcdf.putAtt(ncid,uvel_varid,'long_name','uvel');
netcdf.putAtt(ncid,uvel_varid,'units','m/s');
netcdf.putAtt(ncid,uvel_varid,'coordinates','TLON TLAT');

vvel_varid=netcdf.defVar(ncid,'vvel','double',[ni_dimid nj_dimid nk_dimid time_dimid]);
netcdf.putAtt(ncid,vvel_varid,'long_name','vvel');
netcdf.putAtt(ncid,vvel_varid,'units','m/s');
netcdf.putAtt(ncid,vvel_varid,'coordinates','TLON TLAT');

% End definitions and leave define mode.
netcdf.endDef(ncid)

% Provide values for time invariant variables.
netcdf.putVar(ncid,tlon_varid,lon);
netcdf.putVar(ncid,tlat_varid,lat);
netcdf.putVar(ncid,depth_varid,depth);

for n=1:size(time,1)
netcdf.putVar(ncid,time_varid,n-1,1,time(n));
netcdf.putVar(ncid,ssh_varid,[0 0 n-1],[nx ny 1],squeeze(ssh(:,:,n)));
netcdf.putVar(ncid,temp_varid,[0 0 0 n-1],[nx ny nz 1],squeeze(temp(:,:,:,n)));
netcdf.putVar(ncid,salt_varid,[0 0 0 n-1],[nx ny nz 1],squeeze(salt(:,:,:,n)));
netcdf.putVar(ncid,uvel_varid,[0 0 0 n-1],[nx ny nz 1],squeeze(u(:,:,:,n)));
netcdf.putVar(ncid,vvel_varid,[0 0 0 n-1],[nx ny nz 1],squeeze(v(:,:,:,n)));
n
end

% Close netcdf file
netcdf.close(ncid)











