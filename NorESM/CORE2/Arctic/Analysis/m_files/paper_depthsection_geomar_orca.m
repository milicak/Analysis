clear all
sec_depth=400; %section depth
sec_depth=5;

filename_s='/bcmhsm/milicak/RUNS/noresm/CORE2/Arctic/DATA/geomar/ORCA05_5yr_19480101_20071231_vosaline.nc';
filename_t='/bcmhsm/milicak/RUNS/noresm/CORE2/Arctic/DATA/geomar/ORCA05_5yr_19480101_20071231_votemper.nc';
filename_u='/bcmhsm/milicak/RUNS/noresm/CORE2/Arctic/DATA/geomar/ORCA05-K3186_5yr_19480101_20071231_vozocrtx.nc';
filename_v='/bcmhsm/milicak/RUNS/noresm/CORE2/Arctic/DATA/geomar/ORCA05-K3186_5yr_19480101_20071231_vomecrty.nc';
salt=ncgetvar(filename_s,'vosaline');
temp=ncgetvar(filename_t,'votemper'); 
uvel=ncgetvar(filename_u,'vozocrtx');
vvel=ncgetvar(filename_v,'vomecrty'); 
lon=ncgetvar(filename_t,'nav_lon');
lat=ncgetvar(filename_t,'nav_lat');
zt=ncgetvar(filename_t,'deptht');


if 0

temp=squeeze(nanmean(squeeze(temp(:,:,:,55:end)),4)); %
uvel=squeeze(nanmean(squeeze(uvel(:,:,:,1:end)),4)); %
vvel=squeeze(nanmean(squeeze(vvel(:,:,:,1:end)),4)); %

temp(temp==0)=NaN;

for k=1:size(temp,3)
[ur(:,:,k),vr(:,:,k)]=vecrotc(lon,lat,uvel(:,:,k),vvel(:,:,k),'C');
end


for i=1:size(temp,1)
for j=1:size(temp,2)
indk=min(find(temp(i,j,:)==max(temp(i,j,:))));
if(isempty(indk)~=1)
maxtemp(i,j)=zt(indk);
u1(i,j)=ur(i,j,indk);
v1(i,j)=vr(i,j,indk);
else
maxtemp(i,j)=NaN;
u1(i,j)=NaN;
v1(i,j)=NaN;
end
end
end


ind1=find(isnan(u1)~=1 & isnan(v1)~=1);

figure
m_proj('stereographic','lat',90,'long',0,'radius',25,'rect','on');
m_pcolor(lon,lat,maxtemp);shfn
hold on
%h=m_quiver(lon(ind1),lat(ind1),u1(ind1),v1(ind1),0,'k');
%hU = get(h,'UData') ;
%hV = get(h,'VData') ;
%qscale=25/2;
%set(h,'UData',qscale*hU,'VData',qscale*hV,'linewidth',.5)
m_ncquiverref(lon,lat,u1,v1,'cm','median','false','col',[1e-4:1e-4:3e-3]);
%adjust_quiver_arrowhead_size(h,2);
m_coast('patch',[.7 .7 .7],'edgecolor','k');
m_grid

end





timeind=1
kind=max(find(zt<=sec_depth));
if(zt(kind)<sec_depth)
dx1=sec_depth-zt(kind);
dx2=zt(kind+1)-sec_depth;
end

%tmp=squeeze(temp(:,:,kind:kind+1,49:end)); %last cycle 
tmp=squeeze(temp(:,:,kind:kind+1,55:end)); %
tmp2=squeeze(nanmean(tmp,4));
temp=(squeeze(tmp2(:,:,2)).*dx1+squeeze(tmp2(:,:,1)).*dx2)./(dx1+dx2);

%tmp=squeeze(salt(:,:,kind:kind+1,49:end)); %last cycle 
tmp=squeeze(salt(:,:,kind:kind+1,55:end));
tmp2=squeeze(nanmean(tmp,4));
salt=(squeeze(tmp2(:,:,2)).*dx1+squeeze(tmp2(:,:,1)).*dx2)./(dx1+dx2);

if 0
%tmp=squeeze(uvel(:,:,kind:kind+1,1:end)); %last cycle 
tmp=squeeze(uvel(:,:,kind:kind+1,7:end));
tmp2=squeeze(nanmean(tmp,4));
uvel=(squeeze(tmp2(:,:,2)).*dx1+squeeze(tmp2(:,:,1)).*dx2)./(dx1+dx2);

%tmp=squeeze(vvel(:,:,kind:kind+1,1:end)); %last cycle 
tmp=squeeze(vvel(:,:,kind:kind+1,7:end));
tmp2=squeeze(nanmean(tmp,4));
vvel=(squeeze(tmp2(:,:,2)).*dx1+squeeze(tmp2(:,:,1)).*dx2)./(dx1+dx2);


%rotate the velocities
[ur,vr]=vecrotc(lon,lat,uvel,vvel,'C');
%ind=find(isnan(uvel)~=1 & isnan(vvel)~=1);
%ind1=find(isnan(ur)~=1 & isnan(vr)~=1);
%ind1=find((ur)~=0 & (vr)~=0);
%ind1=find(isnan(ur)~=1 & isnan(vr)~=1 & ur~=0 & vr~=0);
ur(ur==0)=NaN;
vr(vr==0)=NaN;

figure(1)
m_proj('stereographic','lat',90,'long',0,'radius',25,'rect','on');
m_ncquiverref(lon,lat,ur,vr,'m/s',0.0006,'b');
title('Kiel-ORCA05')
m_coast('patch',[.7 .7 .7],'edgecolor','k');
m_grid
m_grid('xtick',[-120 -60 0 60 120])
fontsize=18;
%set(findall(gcf,'type','text'),'FontSize',fontsize)
set(gca,'fontsize',fontsize)
set(gcf,'color','w');
printname=['paperfigs2/geomar_orca_uv_horizontal_section1_' num2str(sec_depth)];
print(1,'-depsc2','-r150',printname)
close all
end


figure(1)
m_proj('stereographic','lat',90,'long',0,'radius',25);
m_pcolor(lon,lat,sq(salt));shading interp;needJet2;caxis([34.2 35.2])
if(sec_depth==5)
caxis([25 35])
elseif(sec_depth==400)
caxis([34.2 35.2])
end
m_coast('patch',[.7 .7 .7],'edgecolor','k');
%xlabel('Lon'); ylabel('Lat');
colorbar off
title('Kiel-ORCA05')
m_grid('xtick',[-120 -60 0 60 120])
     fontsize=18;
     set(findall(gcf,'type','text'),'FontSize',fontsize)
     set(gca,'fontsize',fontsize)
     set(gcf,'color','w');
%printname=['paperfigs/geomar_orca_salt_horizontal_section_' num2str(sec_depth)];
printname=['paperfigs2/geomar_orca_salt_horizontal_section_' num2str(sec_depth)];
print(1,'-depsc2','-r150',printname)
export_fig(1,printname,'-eps','-r150');
close all
%break

figure(1)
m_proj('stereographic','lat',90,'long',0,'radius',25);
m_pcolor(lon,lat,sq(temp));shading interp;needJet2;caxis([-2 5])
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
title('Kiel-ORCA05')
m_grid('xtick',[-120 -60 0 60 120])
     fontsize=18;
     set(findall(gcf,'type','text'),'FontSize',fontsize)
     set(gca,'fontsize',fontsize)
     set(gcf,'color','w');
printname=['paperfigs2/geomar_orca_temp_horizontal_section_' num2str(sec_depth)];
%printname=['paperfigs/geomar_orca_temp_horizontal_section_' num2str(sec_depth)];
print(1,'-depsc2','-r150',printname)
export_fig(1,printname,'-eps','-r150');
break
close all

figure(1)
m_proj('stereographic','lat',90,'long',0,'radius',25);
h=m_quiver(lon(ind),lat(ind),uvel(ind),vvel(ind),0,'k');
hU = get(h,'UData') ;
hV = get(h,'VData') ;
qscale=25;
set(h,'UData',qscale*hU,'VData',qscale*hV,'linewidth',.5)
adjust_quiver_arrowhead_size(h,2);
m_coast('patch',[.7 .7 .7],'edgecolor','k');
m_grid
close

figure(1)
m_proj('stereographic','lat',90,'long',0,'radius',25);
h=m_quiver(lon(ind1),lat(ind1),ur(ind1),vr(ind1),0,'k');
hU = get(h,'UData') ;
hV = get(h,'VData') ;
qscale=25/2;
set(h,'UData',qscale*hU,'VData',qscale*hV,'linewidth',.5)
%adjust_quiver_arrowhead_size(h,2);
m_coast('patch',[.7 .7 .7],'edgecolor','k');
m_grid


printname=['paperfigs/geomar_orca_uv_horizontal_section_' num2str(sec_depth)];
print(1,'-depsc2','-r150',printname)
close all




