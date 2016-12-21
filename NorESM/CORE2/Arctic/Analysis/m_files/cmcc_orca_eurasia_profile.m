clear all

%grid_file='/bcmhsm/milicak/RUNS/noresm/CORE2/Arctic/DATA/cmcc/CMCC_bathy_meter_121126.nc';
grid_file='/bcmhsm/milicak/RUNS/noresm/CORE2/Arctic/DATA/noc/19a_model_domain/ORCA1-N403_area.nc';
area=ncgetvar(grid_file,'area');
area=area(:,:,1:46);

filename_s='/bcmhsm/milicak/RUNS/noresm/CORE2/Arctic/DATA/cmcc/CMCC_5YM_S_0001_0300.nc'
filename_t='/bcmhsm/milicak/RUNS/noresm/CORE2/Arctic/DATA/cmcc/CMCC_5YM_PT_0001_0300.nc'
salt=ncgetvar(filename_s,'vosaline');
temp=ncgetvar(filename_t,'votemper');
lon=ncgetvar(filename_t,'nav_lon');
lat=ncgetvar(filename_t,'nav_lat');
zt=ncgetvar(filename_t,'deptht');

% Euroasian basin
x=[27.2474628708497
          36.5447032085722
          48.5214896162041
          60.7001380803934
          77.9434238049383
          94.8206611280039
          107.876624193844
           114.76253701556
          121.721644200227
          134.412781688966
          140.650432725167
          141.964704250335
          145.155248340791
          149.246374638137
          132.143273251575
           149.76109018589
         -79.6880622455017
           -55.18591213471
         -43.4591200137502
         -22.0049915144465
         -20.6758818057775
         -17.5930251981611
         -9.73692516655174
          5.28638472739742
          27.2474628708497];

y=[      81.2047365447009
          81.5007859895957
          82.2436675361916
           82.721919243158
          82.4532187163616
          81.6658524321853
          80.1201616988957
           78.868040305759
          77.3745806589471
           78.343810419039
          79.2198008825623
          81.0361747596064
          82.8850251870597
          84.6970166179212
           88.170272215848
          88.5112003265041
          89.0201530656119
            86.82607324433
          85.3307236364029
          85.7137862915936
          84.4424860812103
          83.6275436815664
          82.8313390219846
          82.2610471668164
          81.2047365447009];

in=insphpoly(lon,lat,x,y,0,90);
in=double(in);
in(in==0)=NaN;
in=repmat(in,[1 1 46]);
% temperature
tmp=squeeze(temp(:,:,:,49:end)); %last cycle 
tmp=squeeze(nanmean(tmp,4));

area(isnan(tmp))=NaN;
total_area=in.*area;
total_area=squeeze(nansum(total_area,2)); 
total_area=squeeze(nansum(total_area,1));

tmp2=tmp.*in.*area;
tmp2=squeeze(nansum(tmp2,2));
tmp2=squeeze(nansum(tmp2,1));
temp_eurasia=tmp2./total_area;

% salinity
tmp=squeeze(salt(:,:,:,49:end)); %last cycle 
tmp=squeeze(nanmean(tmp,4));
tmp2=tmp.*in.*area;
tmp2=squeeze(nansum(tmp2,2));
tmp2=squeeze(nansum(tmp2,1));
salt_eurasia=tmp2./total_area;

save('matfiles/cmcc_orca_eurasia_basin_profiles.mat','temp_eurasia','salt_eurasia','zt')



