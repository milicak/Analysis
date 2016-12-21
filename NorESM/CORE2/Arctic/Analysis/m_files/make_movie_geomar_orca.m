clear all
sec_depth=455; %section depth since the zt(19) is 452 meter

%filename_s='/work/milicak/RUNS/noresm/CORE2/Arctic/DATA/geomar/ORCA05_5yr_19480101_20071231_vosaline.nc';
filename_t='/work/milicak/RUNS/noresm/CORE2/Arctic/DATA/geomar/ORCA05_5yr_19480101_20071231_votemper.nc';
%salt=ncgetvar(filename_s,'vosaline');
temp=ncgetvar(filename_t,'votemper'); 
lon=ncgetvar(filename_t,'nav_lon');
lat=ncgetvar(filename_t,'nav_lat');
zt=ncgetvar(filename_t,'deptht');

timeind=1
kind=max(find(zt<=sec_depth));
for Time=1:60
hhh=figure('Visible','off');
m_proj('stereographic','lat',90,'long',0,'radius',25);
m_pcolor(lon,lat,sq(temp(:,:,kind,Time)));shading interp;needJet2;caxis([-2 5])
m_coast('patch',[.7 .7 .7],'edgecolor','k');
%xlabel('Lon'); ylabel('Lat');
m_grid
title(['ORCA Time = ' num2str(Time*5-2.5) ' years; depth = ' num2str(sec_depth)]);
no=num2str(timeind,'%.4d');
printname=['gifs/horizontal_section' no];
print(hhh,'-dpng','-r150',printname)
close all
timeind=timeind+1
end

