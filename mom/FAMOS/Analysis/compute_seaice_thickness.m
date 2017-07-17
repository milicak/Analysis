clear all

fice_cr = 0.15;
%project_name = 'om3_core3_2'
%project_name = 'om3_core3_2_BG_neg'
%project_name = 'om3_core3_2_GS_neg'
project_name = 'om3_core3_ctrl'
%root_folder = '/hexagon/work/milicak/RUNS/mom/' ;
root_folder = '/export/grunchfs/unibjerknes/milicak/bckup/mom/';

%fname = [root_folder project_name '/om3_core3/history/00010101.ice_month.nc'];
fname = [root_folder project_name '/history_1-62years/00010101.ice_month.nc'];
aname = '/export/grunchfs/unibjerknes/milicak/bckup/noresm/CORE2/Arctic/DATA/gfdl-mom/grids_bathymetry/ocean.static.nc';

fice = ncread(fname,'CN');
hice = ncread(fname,'HI');
area = ncread(aname,'area_t');

fice = squeeze(nansum(fice,3));
hice(hice<fice_cr) = 0.0;
hice = reshape(hice,[size(hice,1) size(hice,2) 12 size(hice,3)/12]);

break
savename = ['matfiles/' project_name '_ice_thickness.mat']
save(savename,'hice')
