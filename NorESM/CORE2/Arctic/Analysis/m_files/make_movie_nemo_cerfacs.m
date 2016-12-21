clear all
sec_depth=450; %section depth

filename_s='/work/milicak/RUNS/noresm/CORE2/Arctic/DATA/nemo-cerfacs/CERFACS_TSUV_decade.nc';
filename_t='/work/milicak/RUNS/noresm/CORE2/Arctic/DATA/nemo-cerfacs/CERFACS_TSUV_decade.nc';
lon=ncgetvar(filename_t,'lon');
lat=ncgetvar(filename_t,'lat');
zt=ncgetvar(filename_t,'gdept');

salt=ncgetvar(filename_s,'S_decade_Cy1');
temp=ncgetvar(filename_t,'T_decade_Cy1'); 
salt(:,:,:,7:12)=ncgetvar(filename_s,'S_decade_Cy2');
temp(:,:,:,7:12)=ncgetvar(filename_t,'T_decade_Cy2'); 
salt(:,:,:,13:18)=ncgetvar(filename_s,'S_decade_Cy3');
temp(:,:,:,13:18)=ncgetvar(filename_t,'T_decade_Cy3'); 
salt(:,:,:,19:24)=ncgetvar(filename_s,'S_decade_Cy4');
temp(:,:,:,19:24)=ncgetvar(filename_t,'T_decade_Cy4'); 
salt(:,:,:,25:30)=ncgetvar(filename_s,'S_decade_Cy5');
temp(:,:,:,25:30)=ncgetvar(filename_t,'T_decade_Cy5'); 


timeind=1
kind=max(find(zt<=sec_depth));
for Time=1:30
hhh=figure('Visible','off');
m_proj('stereographic','lat',90,'long',0,'radius',25);
m_pcolor(lon,lat,squeeze(temp(:,:,kind,Time)));shading interp;needJet2;caxis([-2 5])
m_coast('patch',[.7 .7 .7],'edgecolor','k');
%xlabel('Lon'); ylabel('Lat');
m_grid
title(['NEMO-CERFACS Time = ' num2str(Time*10-5) ' years; depth = ' num2str(sec_depth)]);
no=num2str(timeind,'%.4d');
printname=['gifs/horizontal_section' no];
print(hhh,'-dpng','-r150',printname)
close all
timeind=timeind+1
end

