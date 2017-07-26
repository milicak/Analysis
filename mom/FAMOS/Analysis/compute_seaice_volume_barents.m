clear all

fice_cr = 0.15;
%project_name = 'om3_core3_2'
%project_name = 'om3_core3_2_BG_neg'
project_name = 'om3_core3_2_BG_pos'
%project_name = 'om3_core3_2_GS_neg'
%project_name = 'om3_core3_2_GS_pos'
%project_name = 'om3_core3_ctrl'
root_folder = '/hexagon/work/milicak/RUNS/mom/' ;
%root_folder = '/export/grunchfs/unibjerknes/milicak/bckup/mom/';

fname = [root_folder project_name '/om3_core3/history/19480101.ice_month.nc'];
%fname = [root_folder project_name '/history_1-62years/00010101.ice_month.nc'];
aname = '/export/grunchfs/unibjerknes/milicak/bckup/noresm/CORE2/Arctic/DATA/gfdl-mom/grids_bathymetry/ocean.static.nc';

out = load('/fimm/home/bjerknes/milicak/Analysis/NorESM/Arctic_seaice/Analysis/region_masks.mat');
gridname = '/export/grunchfs/unibjerknes/milicak/bckup/noresm/CORE2/Arctic/DATA/gfdl-mom/grids_bathymetry/ocean.static.nc';
lon = ncread(gridname,'geolon_t');
lat = ncread(gridname,'geolat_t');
regionnames = [{'KaraBarents'}];
in = insphpoly(lon,lat,out.lon1,out.lat1,0,90);
in = double(in);

fice = ncread(fname,'CN');
hice = ncread(fname,'HI');
area = ncread(aname,'area_t');

fice = squeeze(nansum(fice,3));
fice(fice<fice_cr) = 0.0;
area = repmat(area,[1 1 size(fice,3)]);
mask = repmat(in,[1 1 size(fice,3)]);
vice = fice.*hice.*area.*mask;
vice = reshape(vice,[size(vice,1) size(vice,2) 12 size(vice,3)/12]);
vice = squeeze(nansum(vice,1));
vice = squeeze(nansum(vice,1));

%break
savename = ['matfiles/' project_name '_ice_volume_barents.mat']
save(savename,'vice')
