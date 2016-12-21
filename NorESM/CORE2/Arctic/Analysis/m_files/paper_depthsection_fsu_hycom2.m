clear all
sec_depth=400; %section depth
sec_depth=5;
qscale=1500;

filename_s='/bcmhsm/milicak/RUNS/noresm/CORE2/Arctic/DATA/fsu-hycom2/TSuv_pentadals_cyc5_fsu-hycom2.nc';
filename_t='/bcmhsm/milicak/RUNS/noresm/CORE2/Arctic/DATA/fsu-hycom2/TSuv_pentadals_cyc5_fsu-hycom2.nc';
filename_u='/bcmhsm/milicak/RUNS/noresm/CORE2/Arctic/DATA/fsu-hycom2/TSuv_pentadals_cyc5_fsu-hycom2.nc';
filename_v='/bcmhsm/milicak/RUNS/noresm/CORE2/Arctic/DATA/fsu-hycom2/TSuv_pentadals_cyc5_fsu-hycom2.nc';
salt=ncgetvar(filename_s,'salinity');
temp=ncgetvar(filename_t,'temperature'); 
uvel=ncgetvar(filename_u,'u');
vvel=ncgetvar(filename_v,'v'); 
lon=ncgetvar(filename_t,'Longitude');
lat=ncgetvar(filename_t,'Latitude');
zt=ncgetvar(filename_t,'Depth');

timeind=1
for Time=7:12
%for Time=1:12
for i=1:size(temp,1)
for j=1:size(temp,2)
temp1=squeeze(temp(i,j,:,Time));
salt1=squeeze(salt(i,j,:,Time));
uvel1=squeeze(uvel(i,j,:,Time));
vvel1=squeeze(vvel(i,j,:,Time));
zt1=squeeze(zt(i,j,:,Time));
zt1(temp1<-100)=[];                                
temp1(temp1<-100)=[];
salt1(salt1<-100)=[];
uvel1(uvel1<-100)=[];
vvel1(vvel1<-100)=[];
if(isempty(zt1)~=1)
[B I]=unique(zt1);
zt1=zt1(I);
temp1=temp1(I);
salt1=salt1(I);
uvel1=uvel1(I);
vvel1=vvel1(I);
T1(i,j,timeind)=interp1(zt1,temp1,sec_depth);
S1(i,j,timeind)=interp1(zt1,salt1,sec_depth);
U1(i,j,timeind)=interp1(zt1,uvel1,sec_depth);
V1(i,j,timeind)=interp1(zt1,vvel1,sec_depth);
else
T1(i,j,timeind)=NaN;
S1(i,j,timeind)=NaN;
U1(i,j,timeind)=NaN;
V1(i,j,timeind)=NaN;
end
end
end
timeind=timeind+1
end

temp=squeeze(nanmean(T1,3));
salt=squeeze(nanmean(S1,3));
uvel=squeeze(nanmean(U1,3));
vvel=squeeze(nanmean(V1,3));

%rotate the velocities
[ur,vr]=vecrotc(lon,lat,uvel,vvel);
ind=find(isnan(uvel)~=1 & isnan(vvel)~=1);
ind1=find(isnan(ur)~=1 & isnan(vr)~=1);


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
title('FSU-HYCOMv2')
m_grid('xtick',[-120 -60 0 60 120])
     fontsize=18;
     set(findall(gcf,'type','text'),'FontSize',fontsize)
     set(gca,'fontsize',fontsize)
     set(gcf,'color','w');
%printname=['paperfigs/fsu_hycom_salt_horizontal_section_' num2str(sec_depth)];
printname=['paperfigs2/fsu_hycom2_salt_horizontal_section_' num2str(sec_depth)];
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
title('FSU-HYCOMv2')
m_grid('xtick',[-120 -60 0 60 120])
     fontsize=18;
     set(findall(gcf,'type','text'),'FontSize',fontsize)
     set(gca,'fontsize',fontsize)
     set(gcf,'color','w');
printname=['paperfigs2/fsu_hycom2_temp_horizontal_section_' num2str(sec_depth)];
%printname=['paperfigs/fsu_hycom_temp_horizontal_section_' num2str(sec_depth)];
print(1,'-depsc2','-r150',printname)
export_fig(1,printname,'-eps','-r150');
break
close all

figure(1)
m_proj('stereographic','lat',90,'long',0,'radius',25);
h=m_quiver(lon(ind),lat(ind),uvel(ind),vvel(ind),0,'k');
hU = get(h,'UData') ;
hV = get(h,'VData') ;
set(h,'UData',qscale*hU,'VData',qscale*hV,'linewidth',.5)
adjust_quiver_arrowhead_size(h,2); 
m_coast('patch',[.7 .7 .7],'edgecolor','k');
m_grid

printname=['paperfigs/fsu_hycom2_uv_horizontal_section_' num2str(sec_depth)];
print(1,'-depsc2','-r150',printname)
close all






