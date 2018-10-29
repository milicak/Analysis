clear all

project_name = 'om3_core3_2'
%project_name = 'om3_core3_2_BG_neg'
%project_name = 'om3_core3_2_BG_pos'
%project_name = 'om3_core3_2_GS_neg'
%project_name = 'om3_core3_2_GS_pos'
%project_name = 'om3_core3_ctrl'
%root_folder = '/hexagon/work/milicak/RUNS/mom/' ;
%root_folder = '/export/grunchfs/unibjerknes/milicak/bckup/mom/FAMOS/';
root_folder = '/shared/projects/uniklima/globclim/milicak/mom/FAMOS/';

fname = [root_folder project_name '/om3_core3/history/tau_curl_19480101.ocean_month.nc'];
%aname = '/export/grunchfs/unibjerknes/milicak/bckup/noresm/CORE2/Arctic/DATA/gfdl-mom/grids_bathymetry/ocean.static.nc';
aname = '/work/users/mil021/RUNS/mom/FAMOS/om3_core3_2/om3_core3/history/ocean.static.nc';
depth = ncread(aname,'ht');
mask2 = ones(size(depth,1),size(depth,2));
mask2(depth<300) = 0;

taucurl = ncread(fname,'tau_curl');
area = ncread(aname,'area_t');

lon = ncread(aname,'geolon_t');
lat = ncread(aname,'geolat_t');
% Beaufort Gyre mask                                                            
lon1 = [-130 -130 -170 -170];                                                   
lat1 = [70.5 80.5 80.5 70.5];                                                   
lon1(end+1) = lon1(1);                                                          
lat1(end+1) = lat1(1);                                                          
in = insphpoly(lon,lat,lon1,lat1,0.,90.);                                       
in = double(in);

area = repmat(area,[1 1 size(taucurl,3)]);
mask = repmat(in,[1 1 size(taucurl,3)]);
mask2 = repmat(mask2,[1 1 size(taucurl,3)]);
taucurl = taucurl.*area.*mask.*mask2;
areasum = area.*mask.*mask2;
taucurl = squeeze(nansum(taucurl,1));
taucurl = squeeze(nansum(taucurl,1));
areasum = squeeze(nansum(areasum,1));
areasum = squeeze(nansum(areasum,1));
taucurlareawght = taucurl./areasum;

savename = ['matfiles/' project_name '_taucurl_BG.mat']
save(savename,'taucurl','taucurlareawght')
