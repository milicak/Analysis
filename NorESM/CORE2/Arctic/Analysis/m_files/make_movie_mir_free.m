clear all
sec_depth=450; %section depth

filename_s='/work/milicak/RUNS/noresm/CORE2/Arctic/DATA/mir-free/salinity_pentadal.nc';
filename_t='/work/milicak/RUNS/noresm/CORE2/Arctic/DATA/mir-free/temperature_pentadal.nc';
gridfile='/work/milicak/RUNS/noresm/CORE2/Arctic/DATA/mir-free/lonlat_t.nc';
salt=ncgetvar(filename_s,'s');
temp=ncgetvar(filename_t,'temp'); 
lon=ncgetvar(gridfile,'glon_t');
lat=ncgetvar(gridfile,'glat_t');
zt=ncgetvar(filename_t,'level');

temp(temp<-100)=NaN;
salt(salt<-100)=NaN;

timeind=1
kind=max(find(zt<=sec_depth));
for Time=1:60
hhh=figure('Visible','off');
m_proj('stereographic','lat',90,'long',0,'radius',25);
m_pcolor(lon,lat,squeeze(temp(:,:,kind,Time)));shading interp;needJet2;caxis([-2 5])
m_coast('patch',[.7 .7 .7],'edgecolor','k');
%xlabel('Lon'); ylabel('Lat');
m_grid
title(['MIR-FREE Time = ' num2str(Time*5-2.5) ' years; depth = ' num2str(sec_depth)]);
no=num2str(timeind,'%.4d');
printname=['gifs/horizontal_section' no];
print(hhh,'-dpng','-r150',printname)
close all
timeind=timeind+1
end

