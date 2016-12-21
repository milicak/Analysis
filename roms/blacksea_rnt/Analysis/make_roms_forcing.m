clear all
method='spline';                  % spline interpolation

roms_frc_name='blacksea-forcing_all.nc';
roms_grd_name='blacksea-grid.nc';

era_data_name='netcdf-web237-20140505185354-6466-13626.nc';
era_data_name2='netcdf-web240-20140506102708-29188-15838.nc';
time=nc_varget(era_data_name,'time');
lat_era=nc_varget(era_data_name,'latitude');
lon_era=nc_varget(era_data_name,'longitude');
[lon_era lat_era]=meshgrid(lon_era,lat_era);


nameit='blacksea';

grd=rnt_gridload(nameit);
grd.vtra = 1;
grd.vstr = 4;
grd.theta_s = 5.0;
grd.theta_b = 0.4;

vars = {'Uwind',                                                 ...
        'Vwind',                                                 ...
        'swrad',                                                 ...
        'lwrad',                                                 ...
        'rain',                                                  ...
        'Tair',                                                  ...
        'Qair',                                                  ...
        'Pair'};


daysoffset=datenum('01-01-1900'); %ECMWF data is HOURS and start from this date
time=(time./24+daysoffset);  %need to divide by 24 since the data is HOURLY

%create the forcing netcdf file
% need to do it once
%rnc_CreateForcBulkFile_old(grd,roms_frc_name)

nn=0;
for ind=1:720
   nn=nn+1;
   u10era=nc_varget(era_data_name,'u10',[ind-1 0 0],[1 -1 -1]);
   uwind=griddata(lon_era,lat_era,u10era,grd.lonu,grd.latu,'cubic');
   v10era=nc_varget(era_data_name,'v10',[ind-1 0 0],[1 -1 -1]);
   vwind=griddata(lon_era,lat_era,v10era,grd.lonv,grd.latv,'cubic');
   tairera=nc_varget(era_data_name,'t2m',[ind-1 0 0],[1 -1 -1])-273.15;
   tair=griddata(lon_era,lat_era,tairera,grd.lonr,grd.latr,'cubic');
   tdewera=nc_varget(era_data_name,'d2m',[ind-1 0 0],[1 -1 -1])-273.15;
   E     = 6.11 .* 10.0 .^ (7.5 .* tdewera ./ (237.7 + tdewera));
   Es    = 6.11 .* 10.0 .^ (7.5 .* tairera ./ (237.7 + tairera));
   qairera = 100.0 .* (E ./ Es);
   qair=griddata(lon_era,lat_era,qairera,grd.lonr,grd.latr,'cubic');
   pairera=nc_varget(era_data_name,'msl',[ind-1 0 0],[1 -1 -1]).*0.01; %convert pascal to milibar
   pair=griddata(lon_era,lat_era,pairera,grd.lonr,grd.latr,'cubic');
   precip=nc_varget(era_data_name,'tp',[ind-1 0 0],[1 -1 -1]);
   evap=nc_varget(era_data_name2,'e',[ind-1 0 0],[1 -1 -1]);
   scale=-100.0/(3*3600.0)*(24*3600.0); %convert evap-precip to cm/day and !3 hour step!
   swfluxera= (-evap - precip) .* scale;
   swflux=griddata(lon_era,lat_era,swfluxera,grd.lonr,grd.latr,'cubic');
   nswrad=nc_varget(era_data_name,'ssr',[ind-1 0 0],[1 -1 -1]);  %net shortwave
   sensbl=nc_varget(era_data_name2,'sshf',[ind-1 0 0],[1 -1 -1]); %sensible
   latent=nc_varget(era_data_name2,'slhf',[ind-1 0 0],[1 -1 -1]); %latent
   nlwrad=nc_varget(era_data_name2,'str',[ind-1 0 0],[1 -1 -1]); %net longwave
   scale  = -1.0/(3*3600.0); %convert Jm-2 to Wattsm-2 since it is 3 hour step!
   shfluxera=(sensbl+latent+nlwrad+nswrad) .* scale;
   shflux=griddata(lon_era,lat_era,shfluxera,grd.lonr,grd.latr,'cubic');
   cloudera=nc_varget(era_data_name,'tcc',[ind-1 0 0],[1 -1 -1]);  %net shortwave
   cloud=griddata(lon_era,lat_era,cloudera,grd.lonr,grd.latr,'cubic');
   rain=griddata(lon_era,lat_era,precip,grd.lonr,grd.latr,'cubic');

   %%%%%% Write the netcdf file %%%%%%
   ncid = netcdf.open(roms_frc_name,'WRITE');
   varid = netcdf.inqVarID(ncid,'Uwind');
   netcdf.putVar(ncid,varid,[0 0 nn-1],[grd.L grd.Mp 1],uwind);
   varid = netcdf.inqVarID(ncid,'Vwind');
   netcdf.putVar(ncid,varid,[0 0 nn-1],[grd.Lp grd.M 1],vwind);
   varid = netcdf.inqVarID(ncid,'Tair');
   netcdf.putVar(ncid,varid,[0 0 nn-1],[grd.Lp grd.Mp 1],tair);
   varid = netcdf.inqVarID(ncid,'Qair');
   netcdf.putVar(ncid,varid,[0 0 nn-1],[grd.Lp grd.Mp 1],qair);
   varid = netcdf.inqVarID(ncid,'Pair');
   netcdf.putVar(ncid,varid,[0 0 nn-1],[grd.Lp grd.Mp 1],pair);
   varid = netcdf.inqVarID(ncid,'swflux');
   netcdf.putVar(ncid,varid,[0 0 nn-1],[grd.Lp grd.Mp 1],swflux);
   varid = netcdf.inqVarID(ncid,'shflux');
   netcdf.putVar(ncid,varid,[0 0 nn-1],[grd.Lp grd.Mp 1],shflux);
   varid = netcdf.inqVarID(ncid,'cloud');
   netcdf.putVar(ncid,varid,[0 0 nn-1],[grd.Lp grd.Mp 1],cloud);
   varid = netcdf.inqVarID(ncid,'rain');
   netcdf.putVar(ncid,varid,[0 0 nn-1],[grd.Lp grd.Mp 1],rain);

   varid = netcdf.inqVarID(ncid,'wind_time');
   netcdf.putVar(ncid,varid,[nn-1],[1],time(ind));
   varid = netcdf.inqVarID(ncid,'tair_time');
   netcdf.putVar(ncid,varid,[nn-1],[1],time(ind));
   varid = netcdf.inqVarID(ncid,'qair_time');
   netcdf.putVar(ncid,varid,[nn-1],[1],time(ind));
   varid = netcdf.inqVarID(ncid,'pair_time');
   netcdf.putVar(ncid,varid,[nn-1],[1],time(ind));
   varid = netcdf.inqVarID(ncid,'swf_time');
   netcdf.putVar(ncid,varid,[nn-1],[1],time(ind));
   varid = netcdf.inqVarID(ncid,'srf_time');
   netcdf.putVar(ncid,varid,[nn-1],[1],time(ind));
   varid = netcdf.inqVarID(ncid,'shf_time');
   netcdf.putVar(ncid,varid,[nn-1],[1],time(ind));
   varid = netcdf.inqVarID(ncid,'rain_time');
   netcdf.putVar(ncid,varid,[nn-1],[1],time(ind));
   varid = netcdf.inqVarID(ncid,'cloud_time');
   netcdf.putVar(ncid,varid,[nn-1],[1],time(ind));
   netcdf.close(ncid);
   ind
end
