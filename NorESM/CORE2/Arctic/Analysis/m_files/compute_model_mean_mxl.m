clear all

map_file='/bcmhsm/milicak/RUNS/noresm/CORE2/Arctic/DATA/maps/map_noresm_tnx1v1_to_woa09_1deg_aave_.nc';
% Get dimensions, longitude and latitude of WOA09 grid
dst_grid_dims=ncgetvar(map_file,'dst_grid_dims');
nx_b=dst_grid_dims(1);
ny_b=dst_grid_dims(2);
lon_b=reshape(ncgetvar(map_file,'xc_b'),nx_b,ny_b);
lat_b=reshape(ncgetvar(map_file,'yc_b'),nx_b,ny_b);
lon_b=lon_b(:,1);
lat_b=lat_b(1,:)';

mxl_model_woa=zeros(size(lon_b,1),size(lat_b,1));

files = [{'ORCA1'} {'gold'} {'mri'} {'ORCA1'} ...
         {'ORCA1'} {'hycom'} {'mom'} {'mom_0_25'} {'noresm_tnx1v1'} ...
         {'ORCA1'} {'geomar'} {'pop'} {'fesomv2'} {'hycom2'}];


files2 = [{'cerfacs_nemo'} {'gfdl_gold'} {'mir_free'} {'noc_orca'} ...
         {'cmcc_orca'} {'fsu_hycom'} {'gfdl_mom'} {'mom_0_25'} {'noresm'} ...
         {'cnrm_nemo'} {'geomar_orca'} {'ncar_pop'} {'fesom'} {'fsu_hycom2'}];

for i=1:14 %length(files)
map_file=['/bcmhsm/milicak/RUNS/noresm/CORE2/Arctic/DATA/maps/map_' char(files(i)) '_to_woa09_1deg_aave_.nc'];
filename = ['matfiles/' char(files2(i)) '_mxl_depth.mat'];
% Read regrid indexes and weights
n_a=ncgetdim(map_file,'n_a');
n_b=ncgetdim(map_file,'n_b');
S=sparse(ncgetvar(map_file,'row'),ncgetvar(map_file,'col'), ...
         ncgetvar(map_file,'S'),n_b,n_a);
load(filename)
if(i==1 | i==4 | i==5 | i==10 | i==11)
  mxl=mxl(2:end-1,1:end-1);
elseif(i==3)
  mxl=mxl(3:end-2,1:end-2);
elseif(i==14)
  mxl=mxl(:,1:end-1);
end
% Get dimensions, longitude and latitude of WOA09 grid
dst_grid_dims=ncgetvar(map_file,'dst_grid_dims');
nx_b=dst_grid_dims(1);
ny_b=dst_grid_dims(2);
% Interpolate model data to WOA09 grid
t_a=reshape(mxl,[],1);
if(i==13)
  dd=reshape(S*t_a,nx_b,ny_b);
  dd1=dd(181:end,:);
  dd2=dd(1:180,:);
  dd=[dd1;dd2]; 
  %dd(isnan(dd)==1)=0;
  mxl_model_woa=mxl_model_woa+dd;
else
  mxl_model_woa=mxl_model_woa+reshape(S*t_a,nx_b,ny_b);
end
i
end

%mxl_model_woa=mxl_model_woa./length(files);

mxl_model_woa=mxl_model_woa./i;

filename_t='../../../../climatology/Analysis/t00an1.nc';
lon=ncgetvar(filename_t,'lon');
lat=ncgetvar(filename_t,'lat');

m_proj('stereographic','lat',90,'long',0,'radius',25);
m_pcolor(lon,lat,mxl_model_woa');shfn
caxis([0 100])
colorbar off
m_coast('patch',[.7 .7 .7]);
m_grid('xtick',[-120 -60 0 60 120])
    fontsize=18;
    set(findall(gcf,'type','text'),'FontSize',fontsize)
    set(gca,'fontsize',fontsize)
    set(gcf,'color','w');
title('MMM')
printname=['paperfigs2/mmm_mxl_depth'];
print(1,'-depsc2','-r150',printname)
%close
