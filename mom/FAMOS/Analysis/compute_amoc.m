clear all

%root_folder = '/hexagon/work/milicak/RUNS/mom/' ;
root_folder = '/export/grunchfs/unibjerknes/milicak/bckup/mom/FAMOS/';

%project_name = 'om3_core3_ctrl'
%project_name = 'om3_core3_2'
%project_name = 'om3_core3_2_BG_pos'
%project_name = 'om3_core3_2_BG_neg'
%project_name = 'om3_core3_2_GS_pos'
project_name = 'om3_core3_2_GS_neg'

%fname = [root_folder project_name '/om3_core3/history/00010101.ice_month.nc'];
fname = [root_folder project_name '/om3_core3/history/ty_trans_19480101.ocean_month.nc'];
aname = '/export/grunchfs/unibjerknes/milicak/bckup/noresm/CORE2/Arctic/DATA/gfdl-mom/grids_bathymetry/ocean.static.nc';
mname = ['/fimm/home/bjerknes/milicak/Analysis/mom/APE/Analysis/grid_spec_v6_regMask.nc'];

area = ncread(aname,'area_t');
mask = ncread(mname,'tmask');
tytrans = ncread(fname,'ty_trans');
lat_cr = 26.5; %North 26.5 for amoc

% mask == 2 is for the Atlantic
% make whole new mask
mask(mask~=2) = 0;
mask(mask==2) = 1;
lon=ncread(mname,'geolon_t');
lat=ncread(mname,'geolat_t');
jindex = max(find(lat(1,:)<=lat_cr))+1;

mask = repmat(mask,[1 1 size(tytrans,3) size(tytrans,4)]);
amoc = tytrans.*mask;
amoc = squeeze(nansum(amoc,1));
amoc = cumsum(amoc,2);
amoc = squeeze(amoc(jindex,:,:));
amoc_max = max(amoc,[],1);

savename = ['matfiles/' project_name '_amoc_max_time.mat']
save(savename,'amoc_max')
