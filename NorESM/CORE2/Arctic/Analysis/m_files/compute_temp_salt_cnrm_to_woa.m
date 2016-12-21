clear all
% this subroutine creates mat files of nemo_cnrm data interpolated to WOA09

map_file='/bcmhsm/milicak/RUNS/noresm/CORE2/Arctic/DATA/maps/map_ORCA1_to_woa09_aave_20130510.nc';
% Read regrid indexes and weights
n_a=ncgetdim(map_file,'n_a');
n_b=ncgetdim(map_file,'n_b');
S=sparse(ncgetvar(map_file,'row'),ncgetvar(map_file,'col'), ...
         ncgetvar(map_file,'S'),n_b,n_a);

% Get dimensions, longitude and latitude of WOA09 grid
dst_grid_dims=ncgetvar(map_file,'dst_grid_dims');
nx_b=dst_grid_dims(1);
ny_b=dst_grid_dims(2);
lon_b=reshape(ncgetvar(map_file,'xc_b'),nx_b,ny_b);
lat_b=reshape(ncgetvar(map_file,'yc_b'),nx_b,ny_b);
lon_b=lon_b(:,1);
lat_b=lat_b(1,:)';

filename_s='/work/milicak/RUNS/noresm/CORE2/Arctic/DATA/nemo-cnrm/CNRM_TSUV_decade.nc';
filename_t='/work/milicak/RUNS/noresm/CORE2/Arctic/DATA/nemo-cnrm/CNRM_TSUV_decade.nc';
lon=ncgetvar(filename_t,'lon');
lat=ncgetvar(filename_t,'lat');
zt=ncgetvar(filename_t,'gdept');
lon=lon(2:end-1,1:end-1);
lat=lat(2:end-1,1:end-1);

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

tmp=squeeze(temp(2:end-1,1:end-1,:,25:end)); %last cycle 
temp=squeeze(nanmean(tmp,4));
tmp=squeeze(salt(2:end-1,1:end-1,:,25:end)); %last cycle 
salt=squeeze(nanmean(tmp,4));
clear tmp

% Interpolate model data to WOA09 grid
for k=1:size(salt,3)
  s_a=reshape(salt(:,:,k),[],1);
  s_b(:,:,k)=reshape(S*s_a,nx_b,ny_b);
  t_a=reshape(temp(:,:,k),[],1);
  t_b(:,:,k)=reshape(S*t_a,nx_b,ny_b);
end

savename='matfiles/nemo_cnrm_woa_tempsalt.mat'
save(savename,'lon_b','lat_b','s_b','t_b','zt')

