clear all

%project_name = 'om3_core3_2'
%project_name = 'om3_core3_2_BG_neg'
%project_name = 'om3_core3_2_BG_pos'
%project_name = 'om3_core3_2_GS_neg'
project_name = 'om3_core3_2_GS_pos'
%project_name = 'om3_core3_ctrl'
root_folder = '/hexagon/work/milicak/RUNS/mom/' ;
%root_folder = '/export/grunchfs/unibjerknes/milicak/bckup/mom/';

fname = [root_folder project_name '/om3_core3/history/tau_x_19480101.ocean_month.nc'];
aname = '/export/grunchfs/unibjerknes/milicak/bckup/noresm/CORE2/Arctic/DATA/gfdl-mom/grids_bathymetry/ocean.static.nc';

taux = ncread(fname,'tau_x');
area = ncread(aname,'area_t');

out = load('/fimm/home/bjerknes/milicak/Analysis/NorESM/Arctic_seaice/Analysis/region_masks.mat');
gridname = '/export/grunchfs/unibjerknes/milicak/bckup/noresm/CORE2/Arctic/DATA/gfdl-mom/grids_bathymetry/ocean.static.nc';
lon = ncread(gridname,'geolon_t');
lat = ncread(gridname,'geolat_t');
regionnames = [{'KaraBarents'}];
in = insphpoly(lon,lat,out.lon1,out.lat1,0,90);
in = double(in);

area = repmat(area,[1 1 size(taux,3)]);
mask = repmat(in,[1 1 size(taux,3)]);
taux = taux.*area.*mask;
taux = squeeze(nansum(taux,1));
taux = squeeze(nansum(taux,1));

taux = taux';
taux = reshape(taux,[12 length(taux)/12]);

savename = ['matfiles/' project_name '_taux_barents.mat']
save(savename,'taux')
