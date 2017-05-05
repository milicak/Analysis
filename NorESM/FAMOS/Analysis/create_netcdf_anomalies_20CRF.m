clear all

fill_value=-1e33;
% Read lon lat from CORE data and FAMOS setup for both slp and u/v components
lon=ncgetvar('/work/shared/noresm/inputdata/atm/datm7/20CRv2adj/uwnd.10m.1947.nc','lon');
lat=ncgetvar('/work/shared/noresm/inputdata/atm/datm7/20CRv2adj/uwnd.10m.1947.nc','lat');

root_folder='FAMOS_wind/';
%project_name='uvanom_BG+.nc'
%ncfile='FAMOS_20CR_BG_pos.nc'

%project_name='uvanom_BG-.nc'
%ncfile='FAMOS_20CR_BG_neg.nc'

%project_name='uvanom_GS+.nc'
%ncfile='FAMOS_20CR_GS_pos.nc'

project_name='uvanom_GS-.nc'
ncfile='FAMOS_20CR_GS_neg.nc'

filename=[root_folder project_name];

lon1=ncgetvar(filename,'lon_p');
lat1=ncgetvar(filename,'lat_p');
lon2=ncgetvar(filename,'lon');
lat2=ncgetvar(filename,'lat');
[xx1 yy1]=meshgrid(lon1,lat1);
[xx2 yy2]=meshgrid(lon2,lat2);
[xx yy]=meshgrid(lon,lat);

u_an=ncgetvar(filename,'uanom');
u_an_cesm=interp2(xx2,yy2,u_an',xx,yy);

v_an=ncgetvar(filename,'vanom');
v_an_cesm=interp2(xx2,yy2,v_an',xx,yy);

w_an_cesm = sqrt(u_an_cesm.^2+v_an_cesm.^2);

nx=length(lon);
ny=length(lat);

% need to write a netcdf using lon lat and slp_an_cesm, u_an_cesm, v_an_cesm (be careful about dimensions)
% THAT'S IT!!!!!
% Create netcdf file.
ncid=netcdf.create(ncfile,'NC_CLOBBER');

% Define dimensions.
nj_dimid=netcdf.defDim(ncid,'lat',ny);
ni_dimid=netcdf.defDim(ncid,'lon',nx);
time_dimid=netcdf.defDim(ncid,'time',netcdf.getConstant('NC_UNLIMITED'));

% Define variables and assign attributes
time_varid=netcdf.defVar(ncid,'time','float',time_dimid);
netcdf.putAtt(ncid,time_varid,'long_name','observation time');
%netcdf.putAtt(ncid,time_varid,'units',time_units);
%netcdf.putAtt(ncid,time_varid,'calendar',time_calendar);

tlon_varid=netcdf.defVar(ncid,'lon','float',[ni_dimid]);
netcdf.putAtt(ncid,tlon_varid,'long_name','longitude');
netcdf.putAtt(ncid,tlon_varid,'units','degrees_east');

tlat_varid=netcdf.defVar(ncid,'lat','float',[nj_dimid]);
netcdf.putAtt(ncid,tlat_varid,'long_name','latitude');
netcdf.putAtt(ncid,tlat_varid,'units','degrees_north');

slp_varid=netcdf.defVar(ncid,'w_10_anom','float',[ni_dimid nj_dimid]);
netcdf.putAtt(ncid,slp_varid,'long_name','w 10 anomaly');
netcdf.putAtt(ncid,slp_varid,'units','m/s');
netcdf.putAtt(ncid,slp_varid,'coordinates','lon lat');

uvel_varid=netcdf.defVar(ncid,'u_10_anom','float',[ni_dimid nj_dimid]);
netcdf.putAtt(ncid,uvel_varid,'long_name','U Wind anomaly');
netcdf.putAtt(ncid,uvel_varid,'units','m/s');
netcdf.putAtt(ncid,uvel_varid,'coordinates','lon lat');

vvel_varid=netcdf.defVar(ncid,'v_10_anom','float',[ni_dimid nj_dimid]);
netcdf.putAtt(ncid,uvel_varid,'long_name','V Wind anomaly');
netcdf.putAtt(ncid,uvel_varid,'units','m/s');
netcdf.putAtt(ncid,uvel_varid,'coordinates','lon lat');

%ssh_varid=netcdf.defVar(ncid,'slp_anom','float',[ni_dimid nj_dimid time_dimid]);
%netcdf.putAtt(ncid,ssh_varid,'long_name','SLP anomaly');
%netcdf.putAtt(ncid,ssh_varid,'units','Pa');
%netcdf.putAtt(ncid,ssh_varid,'_FillValue',single(fill_value));
%netcdf.putAtt(ncid,ssh_varid,'coordinates','lon lat');

% Global attributes

% End definitions and leave define mode.
netcdf.endDef(ncid)

% Provide values for time invariant variables.
netcdf.putVar(ncid,tlon_varid,single(lon));
netcdf.putVar(ncid,tlat_varid,single(lat));
netcdf.putVar(ncid,slp_varid,w_an_cesm');
netcdf.putVar(ncid,uvel_varid,u_an_cesm');
netcdf.putVar(ncid,vvel_varid,v_an_cesm');

% Close netcdf file
netcdf.close(ncid)

