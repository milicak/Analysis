clear all

ssh=ncread('/export/grunchfs/unibjerknes/milicak/bckup/obs/zos_AVISO_L4_199210-201012.nc','zos');
lonclim = ncread('/export/grunchfs/unibjerknes/milicak/bckup/obs/zos_AVISO_L4_199210-201012.nc','lon');
latclim = ncread('/export/grunchfs/unibjerknes/milicak/bckup/obs/zos_AVISO_L4_199210-201012.nc','lat');

ssh = ssh(:,:,4:end-12);
ssh(ssh>10) = NaN;
ssh = squeeze(nanmean(ssh,3));
map_file='/bcmhsm/milicak/RUNS/noresm/CORE2/Arctic/DATA/maps/map_woa09_1deg_to_mom_patch_.nc';

% Read interpolation indexes and weights
n_a=ncgetdim(map_file,'n_a');
n_b=ncgetdim(map_file,'n_b');
Sspr=sparse(ncgetvar(map_file,'row'),ncgetvar(map_file,'col'), ...
         ncgetvar(map_file,'S'),n_b,n_a);

% mom 1degree grid points         
nx_b = 360;
ny_b = 200;
sshsrc = reshape(ssh(:,:),[],1);
sshmom = reshape(Sspr*sshsrc,nx_b,ny_b);
