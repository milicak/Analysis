clear all
sec_depth=450; %section depth

filename_s='/work/milicak/RUNS/noresm/CORE2/Arctic/DATA/fsu-hycom/TSuv_pentadals_glb1x3.nc';
filename_t='/work/milicak/RUNS/noresm/CORE2/Arctic/DATA/fsu-hycom/TSuv_pentadals_glb1x3.nc';
salt=ncgetvar(filename_s,'salinity');
temp=ncgetvar(filename_t,'temperature'); 
lon=ncgetvar(filename_t,'Longitude');
lat=ncgetvar(filename_t,'Latitude');
zt=ncgetvar(filename_t,'Depth');

timeind=1
for Time=1:60
for i=1:size(temp,1)
for j=1:size(temp,2)
temp1=squeeze(temp(i,j,:,Time));
zt1=squeeze(zt(i,j,:,Time));
zt1(temp1<-100)=[];                                
temp1(temp1<-100)=[];
if(isempty(zt1)~=1)
[B I]=unique(zt1);
zt1=zt1(I);
temp1=temp1(I);
T1(i,j)=interp1(zt1,temp1,sec_depth);
else
T1(i,j)=NaN;
end
end
end

hhh=figure('Visible','off');
m_proj('stereographic','lat',90,'long',0,'radius',25);
m_pcolor(lon,lat,T1);shading interp;needJet2;caxis([-2 5])
m_coast('patch',[.7 .7 .7],'edgecolor','k');
%xlabel('Lon'); ylabel('Lat');
m_grid
title(['HYCOM Time = ' num2str(Time*5-2.5) ' years; depth = ' num2str(sec_depth)]);
no=num2str(timeind,'%.4d');
printname=['gifs/horizontal_section' no];
print(hhh,'-dpng','-r150',printname)
close all
timeind=timeind+1
end

