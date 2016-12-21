clear all
sec_depth=400; %section depth
sec_depth=5

filename_s='/bcmhsm/milicak/RUNS/noresm/CORE2/Arctic/DATA/nemo-cnrm/CNRM_TSUV_decade.nc';
filename_t='/bcmhsm/milicak/RUNS/noresm/CORE2/Arctic/DATA/nemo-cnrm/CNRM_TSUV_decade.nc';
lon=ncgetvar(filename_t,'lon');
lat=ncgetvar(filename_t,'lat');
zt=ncgetvar(filename_t,'gdept');

uvel=ncgetvar(filename_s,'U_decade_Cy1');
vvel=ncgetvar(filename_t,'V_decade_Cy1');
uvel(:,:,:,7:12)=ncgetvar(filename_s,'U_decade_Cy2');
vvel(:,:,:,7:12)=ncgetvar(filename_t,'V_decade_Cy2');
uvel(:,:,:,13:18)=ncgetvar(filename_s,'U_decade_Cy3');
vvel(:,:,:,13:18)=ncgetvar(filename_t,'V_decade_Cy3');
uvel(:,:,:,19:24)=ncgetvar(filename_s,'U_decade_Cy4');
vvel(:,:,:,19:24)=ncgetvar(filename_t,'V_decade_Cy4');
uvel(:,:,:,25:30)=ncgetvar(filename_s,'U_decade_Cy5');
vvel(:,:,:,25:30)=ncgetvar(filename_t,'V_decade_Cy5');

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
if(zt(kind)<=sec_depth)
dx1=sec_depth-zt(kind);
dx2=zt(kind+1)-sec_depth;
end

if 0
tmp=squeeze(uvel(:,:,kind:kind+1,28:end));
tmp2=squeeze(nanmean(tmp,4));
uvel=(squeeze(tmp2(:,:,2)).*dx1+squeeze(tmp2(:,:,1)).*dx2)./(dx1+dx2);

tmp=squeeze(vvel(:,:,kind:kind+1,28:end));
tmp2=squeeze(nanmean(tmp,4));
vvel=(squeeze(tmp2(:,:,2)).*dx1+squeeze(tmp2(:,:,1)).*dx2)./(dx1+dx2);
end

if(sec_depth==400)
%tmp=squeeze(temp(:,:,kind:kind+1,25:end)); %last cycle 
tmp=squeeze(temp(:,:,kind:kind+1,28:end));
tmp2=squeeze(nanmean(tmp,4));
temp=(squeeze(tmp2(:,:,2)).*dx1+squeeze(tmp2(:,:,1)).*dx2)./(dx1+dx2);

%tmp=squeeze(salt(:,:,kind:kind+1,25:end)); %last cycle 
tmp=squeeze(salt(:,:,kind:kind+1,28:end));
tmp2=squeeze(nanmean(tmp,4));
salt=(squeeze(tmp2(:,:,2)).*dx1+squeeze(tmp2(:,:,1)).*dx2)./(dx1+dx2);
elseif(sec_depth==5)
tmp=squeeze(salt(:,:,1,28:end));
salt=squeeze(nanmean(tmp,3));
tmp=squeeze(temp(:,:,1,28:end));
temp=squeeze(nanmean(tmp,3));
end


if 0
%rotate the velocities
[ur,vr]=vecrotc(lon,lat,uvel,vvel,'C');
%ind=find(isnan(uvel)~=1 & isnan(vvel)~=1);
%ind1=find(isnan(ur)~=1 & isnan(vr)~=1 & ur~=0 & vr~=0);

figure(1)
m_proj('stereographic','lat',90,'long',0,'radius',25,'rect','on');
m_ncquiverref(lon,lat,ur,vr,'m/s',0.0002,'b');
title('CNRM')
m_coast('patch',[.7 .7 .7],'edgecolor','k');
m_grid
m_grid('xtick',[-120 -60 0 60 120])
fontsize=18;
%set(findall(gcf,'type','text'),'FontSize',fontsize)
set(gca,'fontsize',fontsize)
set(gcf,'color','w');
printname=['paperfigs2/nemo_cnrm_uv_horizontal_section1_' num2str(sec_depth)];
print(1,'-depsc2','-r150',printname)
close all
end

figure(1)
m_proj('stereographic','lat',90,'long',0,'radius',25);
m_pcolor(lon,lat,salt);shading interp;needJet2;caxis([34.2 35.2])
if(sec_depth==5)
caxis([25 35])
elseif(sec_depth==400)
caxis([34.2 35.2])
end
m_coast('patch',[.7 .7 .7],'edgecolor','k');
%xlabel('Lon'); ylabel('Lat');
colorbar off
title('CNRM')
m_grid('xtick',[-120 -60 0 60 120])
     fontsize=18;
     set(findall(gcf,'type','text'),'FontSize',fontsize)
     set(gca,'fontsize',fontsize)
     set(gcf,'color','w');
%printname=['paperfigs/nemo_cnrm_salt_horizontal_section_' num2str(sec_depth)];
printname=['paperfigs2/nemo_cnrm_salt_horizontal_section_' num2str(sec_depth)];
print(1,'-depsc2','-r150',printname)
export_fig(1,printname,'-eps','-r150');
close all
%break

figure(1)
m_proj('stereographic','lat',90,'long',0,'radius',25);
m_pcolor(lon,lat,temp);shading interp;needJet2;caxis([-2 5])
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
title('CNRM')
m_grid('xtick',[-120 -60 0 60 120])
     fontsize=18;
     set(findall(gcf,'type','text'),'FontSize',fontsize)
     set(gca,'fontsize',fontsize)
     set(gcf,'color','w');
printname=['paperfigs2/nemo_cnrm_temp_horizontal_section_' num2str(sec_depth)];
%printname=['paperfigs/nemo_cnrm_temp_horizontal_section_' num2str(sec_depth)];
print(1,'-depsc2','-r150',printname)
export_fig(1,printname,'-eps','-r150');
break
close all


