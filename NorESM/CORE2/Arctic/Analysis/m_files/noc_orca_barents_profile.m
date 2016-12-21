clear all

grid_file='/bcmhsm/milicak/RUNS/noresm/CORE2/Arctic/DATA/noc/19a_model_domain/ORCA1-N403_area.nc';
area=ncgetvar(grid_file,'area');

filename_s='/bcmhsm/milicak/RUNS/noresm/CORE2/Arctic/DATA/noc/18_temp_sal_velocity_tracer_means_first_and_last_cycles/ORCA1-N403_1948to2007y60_ptemp_salin_pass5.nc'
filename_t='/bcmhsm/milicak/RUNS/noresm/CORE2/Arctic/DATA/noc/18_temp_sal_velocity_tracer_means_first_and_last_cycles/ORCA1-N403_1948to2007y60_ptemp_salin_pass5.nc'
salt=ncgetvar(filename_s,'vosaline');
temp=ncgetvar(filename_t,'votemper');
lon=ncgetvar(filename_t,'nav_lon');
lat=ncgetvar(filename_t,'nav_lat');
zt=ncgetvar(filename_t,'deptht');

% Barents Sea basin
x=[19.7071
   19.0959
   18.6814
   18.3724
   17.9220
   18.1664
   17.8706
   17.5346
   17.9180
   20.1578
   22.7161
   32.2109
   43.1429
   50.9130
   58.6355
   63.5817
   66.8387
   68.6011
   66.4919
   60.3575
   55.7395
   54.7073
   49.3743
   20.7319
   19.7071];
y=[   69.8284
   71.2928
   72.3131
   73.6369
   74.9009
   75.7959
   76.1340
   76.8250
   78.4396
   79.5847
   79.8880
   79.8457
   79.8200
   79.3279
   78.7119
   77.9732
   77.4845
   76.6687
   75.9617
   75.1764
   72.8633
   71.3728
   66.2373
   68.7426
   69.8284];


in=insphpoly(lon,lat,x,y,0,90);
in=double(in);
in(in==0)=NaN;
in=repmat(in,[1 1 75]);
% temperature
tmp=temp;

area(isnan(tmp))=NaN;
total_area=in.*area;
total_area=squeeze(nansum(total_area,2)); 
total_area=squeeze(nansum(total_area,1));

tmp2=tmp.*in.*area;
tmp2=squeeze(nansum(tmp2,2));
tmp2=squeeze(nansum(tmp2,1));
temp_barents=tmp2./total_area;

% salinity
tmp=salt;
tmp2=tmp.*in.*area;
tmp2=squeeze(nansum(tmp2,2));
tmp2=squeeze(nansum(tmp2,1));
salt_barents=tmp2./total_area;

save('matfiles/noc_orca_barents_basin_profiles.mat','temp_barents','salt_barents','zt')



