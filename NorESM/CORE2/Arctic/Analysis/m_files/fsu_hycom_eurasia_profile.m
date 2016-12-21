clear all

grid_file='/work/milicak/RUNS/noresm/CORE2/Arctic/DATA/fsu-hycom/bathy_2darea_glb1x3.nc';
area=ncgetvar(grid_file,'area');

filename_s='/work/milicak/RUNS/noresm/CORE2/Arctic/DATA/fsu-hycom/TSuv_pentadals_glb1x3.nc';
filename_t='/work/milicak/RUNS/noresm/CORE2/Arctic/DATA/fsu-hycom/TSuv_pentadals_glb1x3.nc';
salt=ncgetvar(filename_s,'salinity');
temp=ncgetvar(filename_t,'temperature');
lon=ncgetvar(filename_t,'Longitude');
lat=ncgetvar(filename_t,'Latitude');
zt=ncgetvar(filename_t,'Depth');
filename_t='/work/milicak/RUNS/noresm/CORE2/Arctic/DATA/NorESM/NOIIA_T62_tn11_sr10m60d_01_temperature_pendatal_1-300.nc';
ztref=ncgetvar(filename_t,'depth');
ztref=ztref(2:end);Nz=size(ztref,1);

timeind=1
for Time=49:60 %last cycle
for i=1:size(temp,1)
for j=1:size(temp,2)
temp1=squeeze(temp(i,j,:,Time));
salt1=squeeze(salt(i,j,:,Time));
zt1=squeeze(zt(i,j,:,Time));
zt1(temp1<-100)=[];
temp1(temp1<-100)=[];
salt1(salt1<-100)=[];
if(isempty(zt1)~=1)
[B I]=unique(zt1);
zt1=zt1(I);
temp1=temp1(I);
salt1=salt1(I);
T1(i,j,1:Nz,timeind)=interp1(zt1,temp1,ztref);
S1(i,j,1:Nz,timeind)=interp1(zt1,salt1,ztref);
else
T1(i,j,1:Nz,timeind)=NaN;
S1(i,j,1:Nz,timeind)=NaN;
end
end
end
timeind=timeind+1
end

temp=T1;
salt=S1;

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
in=repmat(in,[1 1 69]);
% temperature
tmp=temp;
tmp=squeeze(nanmean(tmp,4));

area=repmat(area,[1 1 69]);
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
tmp=squeeze(nanmean(tmp,4));
tmp2=tmp.*in.*area;
tmp2=squeeze(nansum(tmp2,2));
tmp2=squeeze(nansum(tmp2,1));
salt_eurasia=tmp2./total_area;

save('matfiles/fsu_hycom_eurasia_basin_profiles.mat','temp_eurasia','salt_eurasia','ztref')



