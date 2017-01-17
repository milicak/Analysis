clear all

ssh=ncread('/export/grunchfs/unibjerknes/milicak/bckup/obs/zos_AVISO_L4_199210-201012.nc','zos');
lonclim = ncread('/export/grunchfs/unibjerknes/milicak/bckup/obs/zos_AVISO_L4_199210-201012.nc','lon');
latclim = ncread('/export/grunchfs/unibjerknes/milicak/bckup/obs/zos_AVISO_L4_199210-201012.nc','lat');

