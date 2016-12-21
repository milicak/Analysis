clear all

filename_s='/work/milicak/RUNS/noresm/CORE2/Arctic/DATA/NorESM/NOIIA_T62_tn11_sr10m60d_01_salinity_pendatal_1-300.nc';
filename_t='/work/milicak/RUNS/noresm/CORE2/Arctic/DATA/NorESM/NOIIA_T62_tn11_sr10m60d_01_temperature_pendatal_1-300.nc';
%salt=ncgetvar(filename_s,'saln');
temp=ncgetvar(filename_t,'temp'); 
lon=ncgetvar(filename_t,'TLON');
lat=ncgetvar(filename_t,'TLAT');
zt=ncgetvar(filename_t,'depth');

nz=length(zt);
%lon3d=repmat(lon,[1 1 nz]);
%lat3d=repmat(lat,[1 1 nz]);
%zt3d=repmat(zt,[1 size(lon,1) size(lon,2)]);
%zt3d=permute(zt3d,[2 3 1]);

timeind=1
x=[29.1631
   31.4116
   33.0345
   34.4897
   37.9779
   42.1681
   45.0182
   47.2141
   49.5077
   53.6763
   57.3879
   59.9744
   62.6068
   66.0226
   72.9631
   76.4011
   80.3511
   83.5055
   85.0220
   89.5164
   92.3443
   94.6118
   97.2483
  100.0738
  102.1481
  105.2653
  116.3305
  122.6895
  125.9848
  128.5276
  132.0704];

y=[82.2450
   82.4067
   82.4786
   82.6328
   82.8145
   82.9880
   83.1431
   83.2937
   83.4342
   83.4924
   83.6060
   83.6967
   83.6526
   83.6759
   83.6208
   83.5415
   83.3795
   83.2877
   83.2697
   83.0813
   82.8622
   82.7380
   82.5958
   82.3235
   82.2325
   81.7976
   81.0545
   80.6028
   80.2717
   80.0752
   80.1638];

%x2=repmat(x,[1 nz]);
%y2=repmat(y,[1 nz]);
%zt2=repmat(zt,[1 length(x)]);

for Time=1:60
hhh=figure('Visible','off');
temp3d=squeeze(temp(:,:,:,Time));
%dnm3=griddata3(lon3d,lat3d,zt3d,squeeze(temp3d(:,:,:)),x2,y2,zt2');
for k=1:nz
dnm(:,k)=griddata(lon,lat,squeeze(temp3d(:,:,k)),x,y,'nearest');
k
end
pcolor(x,-zt,dnm');shading flat;colorbar
caxis([-1.8 1])
needJet2
ylim([-4000 0])
title(['NorESM Time = ' num2str(Time*5-2.5) ' years']);
no=num2str(timeind,'%.4d');
printname=['gifs/vertical_section' no];
print(hhh,'-dpng','-r150',printname)
close all
timeind=timeind+1
end

