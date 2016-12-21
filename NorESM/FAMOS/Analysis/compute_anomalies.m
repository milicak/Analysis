clear all

fill_value=-1e33;
% Read lon lat from CORE data and FAMOS setup for both slp and u/v components
lon=ncgetvar('/hexagon/work/shared/noresm/inputdata/ocn/iaf/ncep.slp_.T62.1967.nc','lon');
lat=ncgetvar('/hexagon/work/shared/noresm/inputdata/ocn/iaf/ncep.slp_.T62.1967.nc','lat');
%slp1=ncgetvar('/hexagon/work/shared/noresm/inputdata/ocn/iaf/ncep.slp_.T62.1997.nc','slp_');
lon1=ncgetvar('FAMOS_wind/uvanom_BG+.nc','lon_p');
lat1=ncgetvar('FAMOS_wind/uvanom_BG+.nc','lat_p');
lon2=ncgetvar('FAMOS_wind/uvanom_BG+.nc','lon');
lat2=ncgetvar('FAMOS_wind/uvanom_BG+.nc','lat');
[xx1 yy1]=meshgrid(lon1,lat1);
[xx2 yy2]=meshgrid(lon2,lat2);
[xx yy]=meshgrid(lon,lat);

slp_an=ncgetvar('FAMOS_wind/uvanom_BG+.nc','slp');
slp_an_cesm=interp2(xx1,yy1,slp_an',xx,yy)*1e2; % conversion is 1e2 important

u_an=ncgetvar('FAMOS_wind/uvanom_BG+.nc','uanom');
u_an_cesm=interp2(xx2,yy2,u_an',xx,yy);

v_an=ncgetvar('FAMOS_wind/uvanom_BG+.nc','vanom');
v_an_cesm=interp2(xx2,yy2,v_an',xx,yy);

nx=len(lon);
ny=len(lat);

% need to write a netcdf using lon lat and slp_an_cesm, u_an_cesm, v_an_cesm (be careful about dimensions)
% THAT'S IT!!!!!
% Create netcdf file.
ncid=netcdf.create([expid '_ssh_monthly_' num2str(fyear) '-' num2str(lyear) '.nc'],'NC_CLOBBER');

% Define dimensions.
ni_dimid=netcdf.defDim(ncid,'ni',nx);
nj_dimid=netcdf.defDim(ncid,'nj',ny);
time_dimid=netcdf.defDim(ncid,'time',netcdf.getConstant('NC_UNLIMITED'));

% Define variables and assign attributes
time_varid=netcdf.defVar(ncid,'time','float',time_dimid);
netcdf.putAtt(ncid,time_varid,'long_name',time_long_name);
netcdf.putAtt(ncid,time_varid,'units',time_units);
netcdf.putAtt(ncid,time_varid,'calendar',time_calendar);

tlon_varid=netcdf.defVar(ncid,'lon','float',[ni_dimid]);
netcdf.putAtt(ncid,tlon_varid,'long_name','longitude');
netcdf.putAtt(ncid,tlon_varid,'units','degrees_east');

tlat_varid=netcdf.defVar(ncid,'lat','float',[nj_dimid]);
netcdf.putAtt(ncid,tlat_varid,'long_name','latitude');
netcdf.putAtt(ncid,tlat_varid,'units','degrees_north');

tarea_varid=netcdf.defVar(ncid,'slp_anom','float',[ni_dimid nj_dimid]);
netcdf.putAtt(ncid,tarea_varid,'long_name','SLP anomaly');
netcdf.putAtt(ncid,tarea_varid,'units','Pa');
netcdf.putAtt(ncid,tarea_varid,'coordinates','lon lat');

ssh_varid=netcdf.defVar(ncid,'slp_anom','float',[ni_dimid nj_dimid time_dimid]);
netcdf.putAtt(ncid,ssh_varid,'long_name','SLP anomaly');
netcdf.putAtt(ncid,ssh_varid,'units','Pa');
netcdf.putAtt(ncid,ssh_varid,'_FillValue',single(fill_value));
netcdf.putAtt(ncid,ssh_varid,'coordinates','lon lat');

% Global attributes

% End definitions and leave define mode.
netcdf.endDef(ncid)

% Provide values for time invariant variables.
netcdf.putVar(ncid,tlon_varid,single(lon));
netcdf.putVar(ncid,tlat_varid,single(lat));
netcdf.putVar(ncid,tarea_varid,single(slp_an_cesm));
