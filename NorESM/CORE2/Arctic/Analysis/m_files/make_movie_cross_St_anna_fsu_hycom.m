clear all
warning off

filename_s='/work/milicak/RUNS/noresm/CORE2/Arctic/DATA/fsu-hycom/TSuv_pentadals_glb1x3.nc';
filename_t='/work/milicak/RUNS/noresm/CORE2/Arctic/DATA/fsu-hycom/TSuv_pentadals_glb1x3.nc';
%salt=ncgetvar(filename_s,'salinity');
temp=ncgetvar(filename_t,'temperature'); 
lon=ncgetvar(filename_t,'Longitude');
lat=ncgetvar(filename_t,'Latitude');
zt=ncgetvar(filename_t,'Depth');
nz=size(zt,3);

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

timeind=1
for Time=1:60
temp3d=squeeze(temp(:,:,:,Time));
temp3d(temp3d<-100)=NaN;
for k=1:nz
dnm(:,k)=griddata(lon,lat,squeeze(temp3d(:,:,k)),x,y,'nearest');
zrho(:,k)=griddata(lon,lat,squeeze(zt(:,:,k,Time)),x,y,'nearest');
k
end
zw(1:length(x),1:nz+1)=0;
zw(:,2:end)=zrho;
hhh=figure('Visible','off');
gcolor(dnm',-zw');colorbar
caxis([-1.8 1])
needJet2
title(['HYCOM Time = ' num2str(Time*5-2.5) ' years']);
no=num2str(timeind,'%.4d');
printname=['gifs/vertical_section' no];
print(hhh,'-dpng','-r150',printname)
close all
timeind=timeind+1
end

