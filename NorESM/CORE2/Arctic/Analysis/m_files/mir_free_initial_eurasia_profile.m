clear all

grid_file='/work/milicak/RUNS/noresm/CORE2/Arctic/DATA/mir-free/bathymetry_t.nc';
area=ncgetvar(grid_file,'area_t');

filename_s='/work/milicak/RUNS/noresm/CORE2/Arctic/DATA/mir-free/salinity_initial.nc';
filename_t='/work/milicak/RUNS/noresm/CORE2/Arctic/DATA/mir-free/temperature_initial.nc';
salt=ncgetvar(filename_s,'s');
temp=ncgetvar(filename_t,'temp');
gridfile='/work/milicak/RUNS/noresm/CORE2/Arctic/DATA/mir-free/lonlat_t.nc';
lon=ncgetvar(gridfile,'glon_t');
lat=ncgetvar(gridfile,'glat_t');
zt=ncgetvar(filename_t,'level');

temp(temp<-100)=NaN;
salt(salt<-100)=NaN;

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
in=repmat(in,[1 1 51]);
% temperature
tmp=temp;

area=repmat(area,[1 1 51]);
area(isnan(tmp))=NaN;
total_area=in.*area;
total_area=squeeze(nansum(total_area,2)); 
total_area=squeeze(nansum(total_area,1));

tmp2=tmp.*in.*area;
tmp2=squeeze(nansum(tmp2,2));
tmp2=squeeze(nansum(tmp2,1));
temp_eurasia=tmp2./total_area;

% salinity
tmp=salt;
tmp2=tmp.*in.*area;
tmp2=squeeze(nansum(tmp2,2));
tmp2=squeeze(nansum(tmp2,1));
salt_eurasia=tmp2./total_area;

save('matfiles/mir_free_initial_eurasia_basin_profiles.mat','temp_eurasia','salt_eurasia','zt')



