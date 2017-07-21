clear all

salt_cr = 34.8;
%root_folder = '/hexagon/work/milicak/RUNS/mom/' ;
root_folder = '/export/grunchfs/unibjerknes/milicak/bckup/mom/';

%project_name = 'om3_core3_2'
%project_name = 'om3_core3_2_BG_neg'
%project_name = 'om3_core3_2_BG_pos'
%project_name = 'om3_core3_2_GS_neg'
project_name = 'om3_core3_ctrl'

%fname = [root_folder project_name '/om3_core3/history/00010101.ice_month.nc'];
fname = [root_folder project_name '/history_1-62years/salt_00010101.ocean_month.nc'];
fname2 = [root_folder project_name '/history_1-62years/dht_00010101.ocean_month.nc'];
aname = '/export/grunchfs/unibjerknes/milicak/bckup/noresm/CORE2/Arctic/DATA/gfdl-mom/grids_bathymetry/ocean.static.nc';
mname = ['/fimm/home/bjerknes/milicak/Analysis/mom/APE/Analysis/grid_spec_v6_regMask.nc'];

dz = ncread(fname2,'dht');
area = ncread(aname,'area_t');
mask = ncread(mname,'tmask');
salt = ncread(fname,'salt');
break

fice = squeeze(nansum(fice,3));
fice(fice<fice_cr) = 0.0;
area = repmat(area,[1 1 size(fice,3)]);
vice = fice.*hice.*area;
vice = reshape(vice,[size(vice,1) size(vice,2) 12 size(vice,3)/12]);
vice = squeeze(nansum(vice,1));
vice = squeeze(nansum(vice,1));

%break
savename = ['matfiles/' project_name '_ice_volume.mat']
save(savename,'vice')
