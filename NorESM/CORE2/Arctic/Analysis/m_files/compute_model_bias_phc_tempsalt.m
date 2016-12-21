%clear all
sec_depth=400; %section depth
%sec_depth=5;

map_file='/bcmhsm/milicak/RUNS/noresm/CORE2/Arctic/DATA/maps/map_noresm_tnx1v1_to_woa09_1deg_aave_.nc';
% Get dimensions, longitude and latitude of WOA09 grid
dst_grid_dims=ncgetvar(map_file,'dst_grid_dims');
nx_b=dst_grid_dims(1);
ny_b=dst_grid_dims(2);
lon_b=reshape(ncgetvar(map_file,'xc_b'),nx_b,ny_b);
lat_b=reshape(ncgetvar(map_file,'yc_b'),nx_b,ny_b);
lon_b=lon_b(:,1);
lat_b=lat_b(1,:)';

temp_model_woa=zeros(size(lon_b,1),size(lat_b,1));
salt_model_woa=zeros(size(lon_b,1),size(lat_b,1));
filename_t='../../../../climatology/Analysis/t00an1.nc';
lon=ncgetvar(filename_t,'lon');
lat=ncgetvar(filename_t,'lat');
zt=ncgetvar(filename_t,'depth'); %convert cm to meter
kind=max(find(zt<=sec_depth));
phc=load('matfiles/PHC_annual.mat');
phc.temp=squeeze(phc.temp(:,:,kind)); 
phc.salt=squeeze(phc.salt(:,:,kind));

files = [{'ORCA1'} {'gold'} {'mri'} {'ORCA1'} ...
         {'ORCA1'} {'hycom'} {'mom'} {'mom_0_25'} {'noresm_tnx1v1'} ...
         {'ORCA1'} {'geomar'} {'pop'} {'fesomv2'} {'hycom2'} {'mri'}];

titles = [{'CERFACS'} {'gold'} {'MRI-F'} {'NOC'} ...
         {'CMCC'} {'FSU-HYCOM'} {'mom'} {'MOM0_25'} {'noresm'} ...
         {'CNRM'} {'Kiel-ORCA05'} {'NCAR'} {'AWI-FESOM'} {'FSU-HYCOMv2'} {'MRI-A'}];

figtitles = [{'CERFACS'} {'GFDL-GOLD'} {'MRI-F'} {'NOC'} ...
         {'CMCC'} {'FSU-HYCOM'} {'GFDL-MOM'} {'MOM0.25'} {'BERGEN'} ...
         {'CNRM'} {'Kiel-ORCA05'} {'NCAR'} {'AWI-FESOM'} {'FSU-HYCOMv2'} {'MRI-A'}];

%for i=1:15 %length(files)
for i=9 %length(files)
map_file=['/bcmhsm/milicak/RUNS/noresm/CORE2/Arctic/DATA/maps/map_' char(files(i)) '_to_woa09_1deg_aave_.nc'];
if(sec_depth==400)
filename=['/bcmhsm/milicak/RUNS/noresm/CORE2/Arctic/DATA/matfiles/' char(titles(i)) '_temp_salt'];
elseif(sec_depth==5)
filename=['/bcmhsm/milicak/RUNS/noresm/CORE2/Arctic/DATA/matfiles/' char(titles(i)) '_temp_salt_5m'];
end
% Read regrid indexes and weights
n_a=ncgetdim(map_file,'n_a');
n_b=ncgetdim(map_file,'n_b');
S=sparse(ncgetvar(map_file,'row'),ncgetvar(map_file,'col'), ...
         ncgetvar(map_file,'S'),n_b,n_a);
load(filename)
if(i==1 | i==4 | i==5 | i==10 | i==11)
  temp=temp(2:end-1,1:end-1);
  salt=salt(2:end-1,1:end-1);
elseif(i==3 | i==15)
  temp=temp(3:end-2,1:end-2);
  salt=salt(3:end-2,1:end-2);
elseif(i==14)
  temp=temp(:,1:end-1);
  salt=salt(:,1:end-1);
end
% Get dimensions, longitude and latitude of WOA09 grid
dst_grid_dims=ncgetvar(map_file,'dst_grid_dims');
nx_b=dst_grid_dims(1);
ny_b=dst_grid_dims(2);
% Interpolate model data to WOA09 grid
s_a=reshape(salt,[],1);
t_a=reshape(temp,[],1);
if(i==13)
  dd=reshape(S*s_a,nx_b,ny_b);
  dd1=dd(181:end,:);
  dd2=dd(1:180,:);
  dd=[dd1;dd2]; 
  %dd(isnan(dd)==1)=0;
  salt_model_woa=dd;
  dd=reshape(S*t_a,nx_b,ny_b);
  dd1=dd(181:end,:);
  dd2=dd(1:180,:);
  dd=[dd1;dd2]; 
  %dd(isnan(dd)==1)=0;
  temp_model_woa=dd;
else
  salt_model_woa=reshape(S*s_a,nx_b,ny_b);
  temp_model_woa=reshape(S*t_a,nx_b,ny_b);
end
i

keyboard
%salt_model_woa(salt_model_woa>=37.0)=NaN;
figure(1)
m_proj('stereographic','lat',90,'long',0,'radius',25);
m_pcolor(lon,lat,salt_model_woa'-phc.salt');shading interp;needJet2;
if(sec_depth==5)
caxis([-2 2])
elseif(sec_depth==400)
caxis([-.35 .1])
end
m_coast('patch',[.7 .7 .7],'edgecolor','k');
%xlabel('Lon'); ylabel('Lat');
colorbar off
title(char(figtitles(i)))
m_grid('xtick',[-120 -60 0 60 120])
     fontsize=18;
     set(findall(gcf,'type','text'),'FontSize',fontsize)
     set(gca,'fontsize',fontsize)
     set(gcf,'color','w');
printname=['paperfigs2/' char(titles(i)) '_salt_bias_horizontal_section_' num2str(sec_depth)];
print(1,'-depsc2','-r150',printname)
export_fig(1,printname,'-eps','-r150');
close all

figure(1)
m_proj('stereographic','lat',90,'long',0,'radius',25);
m_pcolor(lon,lat,temp_model_woa'-phc.temp');shading interp;needJet2;
if(sec_depth==5)
if 0
caxis([-1 8])
x = [-2:0.05:0 1:0.6:8 8]; %with jet4
x = [-2:0.05:0 -1.63 -1.53 -1.43 -1.33 -1.23 -1.73  1:0.6:8 8];
x = []
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
end
colormap(bluewhitered(64))
caxis([-2 2])
elseif(sec_depth==400)
colormap(bluewhitered(64))
caxis([-2 2])
end
m_coast('patch',[.7 .7 .7],'edgecolor','k');
%xlabel('Lon'); ylabel('Lat');
colorbar off
title(char(figtitles(i)))
m_grid('xtick',[-120 -60 0 60 120])
     fontsize=18;
     set(findall(gcf,'type','text'),'FontSize',fontsize)
     set(gca,'fontsize',fontsize)
     set(gcf,'color','w');
printname=['paperfigs2/' char(titles(i)) '_temp_bias_horizontal_section_' num2str(sec_depth)];
print(1,'-depsc2','-r150',printname)
export_fig(1,printname,'-eps','-r150');
close all
end


