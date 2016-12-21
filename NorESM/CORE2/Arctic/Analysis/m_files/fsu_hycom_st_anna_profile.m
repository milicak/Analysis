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

x=[64.4897
   68.2101
   70.5941
   73.3574
   76.4362
   77.3953
   77.3654
   75.7384
   73.3536
   66.1355
   62.8216
   61.7141
   61.8900
   63.1248
   64.4897];
y=[   80.3753
   80.4973
   80.4742
   80.4529
   80.2670
   79.4066
   78.7283
   77.7325
   76.9500
   76.7388
   77.6636
   78.4921
   79.0841
   79.8339
   80.3753];

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
temp_st_anna=tmp2./total_area;

% salinity
tmp=salt;
tmp=squeeze(nanmean(tmp,4));
tmp2=tmp.*in.*area;
tmp2=squeeze(nansum(tmp2,2));
tmp2=squeeze(nansum(tmp2,1));
salt_st_anna=tmp2./total_area;

save('matfiles/fsu_hycom_st_anna_profiles.mat','temp_st_anna','salt_st_anna','ztref')



