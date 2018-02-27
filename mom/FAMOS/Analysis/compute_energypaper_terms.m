clear all

root_folder = '/work/users/mil021/RUNS/mom/FAMOS/';

project_name = 'om3_core3_2'

gridname = '/work/users/mil021/RUNS/mom/FAMOS/om3_core3_2/om3_core3/history/ocean.static.nc';

lon=ncread(gridname,'geolon_t');                                                
lat=ncread(gridname,'geolat_t');                                                
[nx ny] = size(lon); 
nz = 50;
                                                                                
% Beaufort Gyre mask                                                            
lon1 = [-130 -130 -170 -170];                                                   
lat1 = [70.5 80.5 80.5 70.5];                                                   
lon1(end+1) = lon1(1);                                                          
lat1(end+1) = lat1(1);                                                          
in = insphpoly(lon,lat,lon1,lat1,0.,90.);                                       
in = double(in);                                                                
in3d = repmat(in,[1 1 12]);
in4d = repmat(in,[1 1 nz 12]);


ftime = 685;
ltime = 744;
fname = [root_folder project_name '/om3_core3/history/salt_19480101.ocean_month.nc'];
dnm = ncread(fname,'salt',[1 1 1 ftime],[Inf Inf Inf Inf]);                    
dnm = reshape(dnm,[nx ny nz 12 (ltime-ftime+1)/12]);
salt = squeeze(nanmean(dnm,5)).*in4d;

fname = [root_folder project_name '/om3_core3/history/u_19480101.ocean_month.nc'];
dnm = ncread(fname,'u',[1 1 5 ftime],[Inf Inf 2 Inf]);                    
dnm = squeeze(nanmean(dnm,3));
dnm = reshape(dnm,[nx ny 12 (ltime-ftime+1)/12]);
uvel = squeeze(nanmean(dnm,4)).*in3d;

fname = [root_folder project_name '/om3_core3/history/v_19480101.ocean_month.nc'];
dnm = ncread(fname,'v',[1 1 5 ftime],[Inf Inf 2 Inf]);                    
dnm = squeeze(nanmean(dnm,3));
dnm = reshape(dnm,[nx ny 12 (ltime-ftime+1)/12]);
vvel = squeeze(nanmean(dnm,4)).*in3d;
                                                                                
fname = [root_folder project_name '/om3_core3/history/eta_t_19480101.ocean_month.nc'];
dnm = ncread(fname,'eta_t',[1 1 ftime],[Inf Inf Inf]);                    
dnm = reshape(dnm,[nx ny 12 (ltime-ftime+1)/12]);
eta = squeeze(nanmean(dnm,4)).*in3d;

fname = [root_folder project_name '/om3_core3/history/tau_x_19480101.ocean_month.nc'];
dnm = ncread(fname,'tau_x',[1 1 ftime],[Inf Inf Inf]);                    
dnm = reshape(dnm,[nx ny 12 (ltime-ftime+1)/12]);
taux = squeeze(nanmean(dnm,4)).*in3d;

fname = [root_folder project_name '/om3_core3/history/tau_y_19480101.ocean_month.nc'];
dnm = ncread(fname,'tau_y',[1 1 ftime],[Inf Inf Inf]);                    
dnm = reshape(dnm,[nx ny 12 (ltime-ftime+1)/12]);
tauy = squeeze(nanmean(dnm,4)).*in3d;

fname = [root_folder project_name '/om3_core3/history/19480101.ice_month.nc'];
dnm = ncread(fname,'UI',[1 1 ftime],[Inf Inf Inf]);                    
dnm = reshape(dnm,[nx ny 12 (ltime-ftime+1)/12]);
uvelice = squeeze(nanmean(dnm,4)).*in3d;

fname = [root_folder project_name '/om3_core3/history/19480101.ice_month.nc'];
dnm = ncread(fname,'VI',[1 1 ftime],[Inf Inf Inf]);                    
dnm = reshape(dnm,[nx ny 12 (ltime-ftime+1)/12]);
vvelice = squeeze(nanmean(dnm,4)).*in3d;

fname = [root_folder project_name '/om3_core3/history/19480101.ice_month.nc'];
dnm = ncread(fname,'CN',[1 1 1 ftime],[Inf Inf Inf Inf]);                    
dnm = squeeze(nansum(dnm,3));
dnm = reshape(dnm,[nx ny 12 (ltime-ftime+1)/12]);
fice = squeeze(nanmean(dnm,4)).*in3d;

outname = 'ITU-MOM_cntrol_simulation.nc'

nccreate(outname, ...
         'salt','Dimensions',{'lon',nx,'lat',ny,'depth',nz,'Time',12},...
          'Format','classic') 
ncwriteatt(outname,'salt','long name','Salinity');
ncwriteatt(outname,'salt','units','psu');

nccreate(outname, ...
         'uvel','Dimensions',{'lon',nx,'lat',ny,'Time',12},...
          'Format','classic') 
ncwriteatt(outname,'uvel','long name','horizontal ocean velocity at 50m');
ncwriteatt(outname,'uvel','units','m/s');

nccreate(outname, ...
         'vvel','Dimensions',{'lon',nx,'lat',ny,'Time',12},...
          'Format','classic') 
ncwriteatt(outname,'vvel','long name','meridional ocean velocity at 50m');
ncwriteatt(outname,'vvel','units','m/s');

nccreate(outname, ...
         'eta','Dimensions',{'lon',nx,'lat',ny,'Time',12},...
          'Format','classic') 
ncwriteatt(outname,'eta','long name','Sea surface height');
ncwriteatt(outname,'eta','units','m');

nccreate(outname, ...
         'taux','Dimensions',{'lon',nx,'lat',ny,'Time',12},...
          'Format','classic') 
ncwriteatt(outname,'taux','long name','horizontal ocean stress');
ncwriteatt(outname,'taux','units','N/m^2');

nccreate(outname, ...
         'tauy','Dimensions',{'lon',nx,'lat',ny,'Time',12},...
          'Format','classic') 
ncwriteatt(outname,'tauy','long name','meridional ocean stress');
ncwriteatt(outname,'tauy','units','m');

nccreate(outname, ...
         'uvelice','Dimensions',{'lon',nx,'lat',ny,'Time',12},...
          'Format','classic') 
ncwriteatt(outname,'uvelice','long name','horizontal ice velocity');
ncwriteatt(outname,'uvelice','units','m/s');

nccreate(outname, ...
         'vvelice','Dimensions',{'lon',nx,'lat',ny,'Time',12},...
          'Format','classic') 
ncwriteatt(outname,'vvelice','long name','meridional ice velocity');
ncwriteatt(outname,'vvelice','units','m/s');

nccreate(outname, ...
         'fice','Dimensions',{'lon',nx,'lat',ny,'Time',12},...
          'Format','classic') 
ncwriteatt(outname,'fice','long name','ice concentration');
ncwriteatt(outname,'fice','units','0-1');

%%% write variables
ncwrite(outname,'salt',salt);
ncwrite(outname,'uvel',uvel);
ncwrite(outname,'vvel',vvel);
ncwrite(outname,'eta',eta);
ncwrite(outname,'taux',taux);
ncwrite(outname,'tauy',tauy);
ncwrite(outname,'uvelice',uvelice);
ncwrite(outname,'vvelice',vvelice);
ncwrite(outname,'fice',fice);
