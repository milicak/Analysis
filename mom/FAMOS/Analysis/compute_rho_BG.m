clear all

project_name = 'om3_core3_2'
%project_name = 'om3_core3_2_BG_neg'
%project_name = 'om3_core3_2_BG_pos'
%project_name = 'om3_core3_2_GS_neg'
%project_name = 'om3_core3_2_GS_pos'
%project_name = 'om3_core3_ctrl'
%root_folder = '/work/users/mil021/RUNS/mom/FAMOS/' ;
%root_folder = '/export/grunchfs/unibjerknes/milicak/bckup/mom/FAMOS/';
root_folder = '/shared/projects/uniklima/globclim/milicak/mom/FAMOS/';

fname = [root_folder project_name '/om3_core3/history/pot_rho_0_19480101.ocean_month.nc'];
aname = '/work/users/mil021/RUNS/mom/FAMOS/om3_core3_2/om3_core3/history/ocean.static.nc';
depth = ncread(aname,'ht');
mask2 = ones(size(depth,1),size(depth,2));
mask2(depth<300) = 0;

area = ncread(aname,'area_t');
rho0 = squeeze(ncread(fname,'pot_rho_0',[1 1 1 1],[Inf Inf 1 Inf]));

lon = ncread(aname,'geolon_t');
lat = ncread(aname,'geolat_t');
% Beaufort Gyre mask                                                            
lon1 = [-130 -130 -170 -170];                                                   
lat1 = [70.5 80.5 80.5 70.5];                                                   
lon1(end+1) = lon1(1);                                                          
lat1(end+1) = lat1(1);                                                          
in = insphpoly(lon,lat,lon1,lat1,0.,90.);                                       
in = double(in);

area = repmat(area,[1 1 size(rho0,3)]);
mask = repmat(in,[1 1 size(rho0,3)]);
mask2 = repmat(mask2,[1 1 size(rho0,3)]);
rho0 = rho0.*area.*mask.*mask2;
areasum = area.*mask.*mask2;
rho0 = squeeze(nansum(rho0,1));
rho0 = squeeze(nansum(rho0,1));
areasum = squeeze(nansum(areasum,1));
areasum = squeeze(nansum(areasum,1));
rho0 = rho0./areasum;
rhosurf = rho0;

savename = ['matfiles/' project_name '_rhosurf_BG.mat']
save(savename,'rhosurf')
