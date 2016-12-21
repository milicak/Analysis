clear all

grid_file='/work/milicak/RUNS/noresm/CORE2/Arctic/DATA/fsu-hycom/bathy_2darea_glb1x3.nc';
area=ncgetvar(grid_file,'area');

filename_s='/work/milicak/RUNS/noresm/CORE2/Arctic/DATA/fsu-hycom/TSuv_1stmonth_glb1x3.nc';
filename_t='/work/milicak/RUNS/noresm/CORE2/Arctic/DATA/fsu-hycom/TSuv_1stmonth_glb1x3.nc';
salt=ncgetvar(filename_s,'salinity');
temp=ncgetvar(filename_t,'temperature');
lon=ncgetvar(filename_t,'Longitude');
lat=ncgetvar(filename_t,'Latitude');
zt=ncgetvar(filename_t,'Depth');
filename_t='/work/milicak/RUNS/noresm/CORE2/Arctic/DATA/NorESM/NOIIA_T62_tn11_sr10m60d_01_temperature_pendatal_1-300.nc';
ztref=ncgetvar(filename_t,'depth');
ztref=ztref(2:end);Nz=size(ztref,1);

for i=1:size(temp,1)
for j=1:size(temp,2)
temp1=squeeze(temp(i,j,:));
salt1=squeeze(salt(i,j,:));
zt1=squeeze(zt(i,j,:));
zt1(temp1<-100)=[];
temp1(temp1<-100)=[];
salt1(salt1<-100)=[];
if(isempty(zt1)~=1)
[B I]=unique(zt1);
zt1=zt1(I);
temp1=temp1(I);
salt1=salt1(I);
T1(i,j,1:Nz)=interp1(zt1,temp1,ztref);
S1(i,j,1:Nz)=interp1(zt1,salt1,ztref);
else
T1(i,j,1:Nz)=NaN;
S1(i,j,1:Nz)=NaN;
end
end
end

temp=T1;
salt=S1;

% canada basin
x=[ -103.84775688995
         -132.426110480092
          -146.32851987161
         -157.129445685198
         -165.289764266082
         -174.948859566318
         -169.908721619095
          -153.99152252417
         -153.654033773183
         -155.991549118887
         -157.264115189183
          -158.99374858648
         -156.200224800736
         -149.147691533142
         -146.758355108426
         -144.575059890815
         -142.121921555256
         -140.683340702781
         -138.653559249327
         -137.204255767801
          -134.56804180152
         -129.946421652944
         -127.799470427715
         -127.884540272314
         -127.978284839156
         -127.025389763871
          -120.96578199099
         -110.556210660899
         -109.124896536309
         -108.367743820184
          -105.94954447772
          -103.84775688995];

y=[      83.1681125452104
          83.7662334620532
          83.8235854688569
          83.8506192123663
          83.5387740470199
          81.0961814080998
            79.63568188243
          77.4297453757112
          76.9425777887249
          76.1151804105261
          74.9362263809805
          73.5789329669126
          72.8750577746576
          71.4351508667292
          71.0889175071879
          71.0180792528114
          70.7030506843364
          70.6869725167624
          70.4111375153443
          70.4316926024079
          70.6888027417022
          71.8499446192718
          72.9555979284964
          73.7334233896998
          74.5127217931511
          75.3222606599783
          77.8864195154148
          80.0342652352252
          80.3858803567825
            81.84979009224
           82.139759675712
          83.1681125452104];

in=insphpoly(lon,lat,x,y,0,90);
in=double(in);
in(in==0)=NaN;
in=repmat(in,[1 1 69]);
% temperature
tmp=temp;

area=repmat(area,[1 1 69]);
area(isnan(tmp))=NaN;
total_area=in.*area;
total_area=squeeze(nansum(total_area,2)); 
total_area=squeeze(nansum(total_area,1));

tmp2=tmp.*in.*area;
tmp2=squeeze(nansum(tmp2,2));
tmp2=squeeze(nansum(tmp2,1));
temp_canada=tmp2./total_area;

% salinity
tmp=salt;
tmp2=tmp.*in.*area;
tmp2=squeeze(nansum(tmp2,2));
tmp2=squeeze(nansum(tmp2,1));
salt_canada=tmp2./total_area;

save('matfiles/fsu_hycom_initial_canada_basin_profiles.mat','temp_canada','salt_canada','ztref')



