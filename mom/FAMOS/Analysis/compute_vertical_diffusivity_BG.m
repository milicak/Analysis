clear all

%project_name = 'om3_core3_2'
%project_name = 'om3_core3_2_BG_neg'
project_name = 'om3_core3_2_BG_pos'
%project_name = 'om3_core3_2_GS_neg'
%project_name = 'om3_core3_2_GS_pos'
%project_name = 'om3_core3_ctrl'
%root_folder = '/hexagon/work/milicak/RUNS/mom/' ;
%root_folder = '/export/grunchfs/unibjerknes/milicak/bckup/mom/FAMOS/';
%root_folder = '/work/users/mil021/RUNS/mom/FAMOS/' ;
root_folder = '/shared/projects/uniklima/globclim/milicak/mom/FAMOS/';

fname = [root_folder project_name '/om3_core3/history/diff_cbt_t_19480101.ocean_month.nc'];
%aname = '/export/grunchfs/unibjerknes/milicak/bckup/noresm/CORE2/Arctic/DATA/gfdl-mom/grids_bathymetry/ocean.static.nc';
aname = '/work/users/mil021/RUNS/mom/FAMOS/om3_core3_2/om3_core3/history/ocean.static.nc';

kappad = squeeze(ncread(fname,'diff_cbt_t',[1 1 10 1],[Inf Inf 1 Inf]));

lon = ncread(aname,'geolon_t');
lat = ncread(aname,'geolat_t');
% Beaufort Gyre mask                                                            
lon1 = [-130 -130 -170 -170];                                                   
lat1 = [70.5 80.5 80.5 70.5];                                                   
lon1(end+1) = lon1(1);                                                          
lat1(end+1) = lat1(1);                                                          
in = insphpoly(lon,lat,lon1,lat1,0.,90.);                                       
in = double(in);

% Ekman pumping velocity ==> W_ek = curl(tau)/(rho*f)
mask = repmat(in,[1 1 size(kappad,3)]);
dnm = kappad.*mask;
dnm(dnm==0) = NaN;
dnm = squeeze(nanmean(dnm,1));
dnm = squeeze(nanmean(dnm,1));

kappa_diff = dnm;

%savename = ['matfiles/' project_name '_kappa_diffusivity_BG.mat']
%save(savename,'kappa_diff')
