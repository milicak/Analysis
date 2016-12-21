clear all
sec_depth=400; %section depth
sec_depth=5

%filename_s='../../../../climatology/Analysis/WOA09_salt.nc';
%filename_t='../../../../climatology/Analysis/WOA09_temp.nc';
filename_s='/bcmhsm/milicak/RUNS/noresm/CORE2/Arctic/DATA/nodc/s00_04.nc';
filename_t='/bcmhsm/milicak/RUNS/noresm/CORE2/Arctic/DATA/nodc/t00_04.nc';
salt=ncgetvar(filename_s,'s_an');
temp=ncgetvar(filename_t,'t_an'); 
lon=ncgetvar(filename_t,'lon');
lat=ncgetvar(filename_t,'lat');
zt=ncgetvar(filename_t,'depth'); %convert cm to meter

timeind=1
kind=max(find(zt<=sec_depth));
temp=squeeze(temp(:,:,kind));
salt=squeeze(salt(:,:,kind));

lon_s3=[-18.5:2:14];
lat_s3=[79.5]*ones(1,length(lon_s3));
%lon_s4=[  13.0   12.0    8.0    4.0    4.0   10.0   20.0   30.0   40.0   50.0   60.0   70.0   80.0   90.0  100.0  110.0  120.0  130.0  140.0];
%lat_s4=[  75.0   76.0   78.0   79.0   80.0   81.0   81.8   81.8   82.6   83.0   83.2   83.1   82.8   82.5   81.8   79.7   78.2   78.2   79.7];
lon_s4=[17.6 16.5 16.05 15.6 15.1 14.1 13.0   12.0  10.0  8.0    4.0    4.0   10.0   20.0   30.0   40.0   50.0   60.0   70.0   80.0   90.0  100.0  110.0  120.0  130.0  140.0];
lat_s4=[69   70.6 71.3  72.02 72.8 73.8 75.0   76.0 77.0  78.0   79.0   80.0   81.0   81.8   81.8   82.6   83.0   83.2   83.1   82.8   82.5   81.8   79.7   78.2   78.2   79.7];
lon_s5=[17.4 17.2 17.7 17.6 17.5 18.0 18.15 18.3 18.5 18.7 18.9 19.0 19.2 19.4 19.5 19.6 19.65];
lat_s5=[76.8 76.3 75.8 75.4 75.0 74.5 74.0 73.75 73.25 72.8 72.35 71.9 71.4 71.0 70.6 70.3 70.0];
lon_s5=fliplr(lon_s5);
lat_s5=fliplr(lat_s5);

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
title('WOA2013')
m_grid('xtick',[-120 -60 0 60 120])
hold on
     fontsize=18;
     set(findall(gcf,'type','text'),'FontSize',fontsize)
     set(gca,'fontsize',fontsize)
     set(gcf,'color','w');
%m_plot(lon_s3,lat_s3,'k','linewidth',2)
%m_plot([-110 70],[70 70],'k','linewidth',2)
%m_plot(lon_s4,lat_s4,'k','linewidth',2)
%printname=['paperfigs/phc_temp_horizontal_section_' num2str(sec_depth)];
printname=['paperfigs2/nodc_temp_horizontal_section_' num2str(sec_depth)];
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
title('WOA2013')
m_grid('xtick',[-120 -60 0 60 120])
hold on
     fontsize=18;
     set(findall(gcf,'type','text'),'FontSize',fontsize)
     set(gca,'fontsize',fontsize)
     set(gcf,'color','w');
printname=['paperfigs2/nodc_salt_horizontal_section_' num2str(sec_depth)];
print(1,'-depsc2','-r150',printname)
export_fig(1,printname,'-eps','-r150');
close all

