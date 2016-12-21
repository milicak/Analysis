clear all
sec_depth=400; %section depth
sec_depth=5

filename_s='/bcmhsm/milicak/RUNS/noresm/CORE2/Arctic/DATA/woa013/woa13_decav_s_annual_01.nc';
filename_t='/bcmhsm/milicak/RUNS/noresm/CORE2/Arctic/DATA/woa013/woa13_decav_t_annual_01.nc';

salt=ncgetvar(filename_s,'s_an');
temp=ncgetvar(filename_t,'t_an'); 
lon=ncgetvar(filename_t,'lon');
lat=ncgetvar(filename_t,'lat');
zt=ncgetvar(filename_t,'depth'); %convert cm to meter

timeind=1
kind=max(find(zt<=sec_depth));

temp=squeeze(temp(:,:,kind)); 
salt=squeeze(salt(:,:,kind));

figure(1)
m_proj('stereographic','lat',90,'long',0,'radius',25);
m_pcolor(lon,lat,temp');shading interp;needJet2;caxis([-2 5])
if(sec_depth==5)
caxis([-1 8])
%x = [-2:0.15:2.75 3:0.5:8];
x = [-2:0.05:0 5 -1.43 -1.53 -1.33 4.4 5.4 1:0.6:8 8];
x = [-2:0.05:0 1:0.6:8 8]; %with jet4
x = [-2:0.05:0 -1.63 -1.53 -1.43 -1.33 -1.23 -1.73  1:0.6:8 8];
x=sort(x);
Nx = length(x);
clim = [min(x) max(x)];
dx = min(diff(x));
y = clim(1):dx:clim(2);
for k=1:Nx-1, y(y>x(k) & y<=x(k+1)) = x(k+1); end % NEW
cmap = colormap(jet(Nx));
f1=load('/fimm/home/bjerknes/milicak/matlab/tools/jet5');
cmap=f1;
cmap2 = [...
interp1(x(:),cmap(:,1),y(:)) ...
interp1(x(:),cmap(:,2),y(:)) ...
interp1(x(:),cmap(:,3),y(:)) ...
];
caxis([-1 8])
colormap(cmap2)
caxis(clim)
elseif(sec_depth==400)
caxis([-2 5])
end
m_coast('patch',[.7 .7 .7],'edgecolor','k');
%xlabel('Lon'); ylabel('Lat');
colorbar off
title('WOA13')
m_grid('xtick',[-120 -60 0 60 120])
hold on
     fontsize=18;
     set(findall(gcf,'type','text'),'FontSize',fontsize)
     set(gca,'fontsize',fontsize)
     set(gcf,'color','w');
%m_plot(lon_s3,lat_s3,'k','linewidth',2)
%m_plot([-110 70],[70 70],'k','linewidth',2)
%m_plot(lon_s4,lat_s4,'k','linewidth',2)
%printname=['paperfigs/woa_temp_horizontal_section_' num2str(sec_depth)];
printname=['paperfigs2/woa13_alistair_temp_horizontal_section_' num2str(sec_depth)];
%print(1,'-depsc2','-r150',printname)
export_fig(1,printname,'-eps','-r150');
%break
close all

figure(1)
m_proj('stereographic','lat',90,'long',0,'radius',25);
m_pcolor(lon,lat,salt');shading interp;needJet2;caxis([34.2 35.2])
if(sec_depth==5)
caxis([25 35])
elseif(sec_depth==400)
caxis([34.2 35.2])
end
m_coast('patch',[.7 .7 .7],'edgecolor','k');
%xlabel('Lon'); ylabel('Lat');
colorbar off
title('WOA13')
m_grid('xtick',[-120 -60 0 60 120])
hold on
     fontsize=18;
     set(findall(gcf,'type','text'),'FontSize',fontsize)
     set(gca,'fontsize',fontsize)
     set(gcf,'color','w');
%printname=['paperfigs/woa_salt_horizontal_section_' num2str(sec_depth)];
printname=['paperfigs2/woa13_alistair_salt_horizontal_section_' num2str(sec_depth)];
print(1,'-depsc2','-r150',printname)
close all

