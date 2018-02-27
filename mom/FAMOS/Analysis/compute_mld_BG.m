clear all

%project_name = 'om3_core3_2'
project_name = 'om3_core3_2_BG_neg'
%project_name = 'om3_core3_2_BG_pos'
%project_name = 'om3_core3_2_GS_neg'
%project_name = 'om3_core3_2_GS_pos'
%project_name = 'om3_core3_ctrl'
root_folder = '/work/users/mil021/RUNS/mom/FAMOS/' ;
%root_folder = '/export/grunchfs/unibjerknes/milicak/bckup/mom/FAMOS/';

fname = [root_folder project_name '/om3_core3/history/mld_19480101.ocean_month.nc'];
aname = '/work/users/mil021/RUNS/mom/FAMOS/om3_core3_2/om3_core3/history/ocean.static.nc';

area = ncread(aname,'area_t');
mld = squeeze(ncread(fname,'mld',[1 1 1],[Inf Inf Inf]));

lon = ncread(aname,'geolon_t');
lat = ncread(aname,'geolat_t');
% Beaufort Gyre mask                                                            
lon1 = [-130 -130 -170 -170];                                                   
lat1 = [70.5 80.5 80.5 70.5];                                                   
lon1(end+1) = lon1(1);                                                          
lat1(end+1) = lat1(1);                                                          
in = insphpoly(lon,lat,lon1,lat1,0.,90.);                                       
in = double(in);

area = repmat(area,[1 1 size(mld,3)]);
mask = repmat(in,[1 1 size(mld,3)]);
mld = mld.*area.*mask;
areasum = area.*mask;
mld = squeeze(nansum(mld,1));
mld = squeeze(nansum(mld,1));
areasum = squeeze(nansum(areasum,1));
areasum = squeeze(nansum(areasum,1));
mld = mld./areasum;

savename = ['matfiles/' project_name '_mld_BG.mat']
save(savename,'mld')
