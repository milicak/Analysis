clear all
sec_depth=450; %section depth

filename_s='/bcmhsm/milicak/RUNS/noresm/CORE2/Arctic/DATA/fesom/FESOM_task18.nc';
filename_t='/bcmhsm/milicak/RUNS/noresm/CORE2/Arctic/DATA/fesom/FESOM_task18.nc';
salt=ncgetvar(filename_s,'Salt');
temp=ncgetvar(filename_t,'Temp'); 
lon=ncgetvar(filename_t,'lons');
lat=ncgetvar(filename_t,'lats');
zt=-ncgetvar(filename_t,'deps');

timeind=1
kind=max(find(zt<=sec_depth));
for Time=1:60
hhh=figure('Visible','off');
m_proj('stereographic','lat',90,'long',0,'radius',25);
%m_pcolor(lon,lat,squeeze(temp(:,:,kind,Time))');shading interp;needJet2;caxis([-2 5])
m_pcolor(lon,lat,squeeze(salt(:,:,kind,Time))');shading interp;needJet2;caxis([34.2 35.2])
m_coast('patch',[.7 .7 .7],'edgecolor','k');
%xlabel('Lon'); ylabel('Lat');
m_grid
title(['FESOM Time = ' num2str(Time*5-2.5) ' years; depth = ' num2str(sec_depth)]);
no=num2str(timeind,'%.4d');
printname=['gifs/horizontal_section' no];
print(hhh,'-dpng','-r150',printname)
close all
timeind=timeind+1
end

