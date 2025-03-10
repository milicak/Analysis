clear all

fice_cr = 0.15;
%project_name = 'om3_core3_2'
%project_name = 'om3_core3_2_BG_neg'
project_name = 'om3_core3_2_BG_pos'
%project_name = 'om3_core3_2_GS_neg'
%project_name = 'om3_core3_2_GS_pos'
%project_name = 'om3_core3_ctrl'
%root_folder = '/hexagon/work/milicak/RUNS/mom/' ;
root_folder = '/shared/projects/uniklima/globclim/milicak/mom/FAMOS/';

%fname = [root_folder project_name '/om3_core3/history/00010101.ice_month.nc'];
fname = [root_folder project_name '/om3_core3/history/19480101.ice_month.nc'];
%fname = [root_folder project_name '/history_1-62years/00010101.ice_month.nc'];
aname = '/work/users/mil021/RUNS/mom/FAMOS/om3_core3_2/om3_core3/history/ocean.static.nc';
depth = ncread(aname,'ht');
mask2 = ones(size(depth,1),size(depth,2));
mask2(depth<300) = 0;

fice = ncread(fname,'CN');
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

fice = squeeze(nansum(fice,3));
fice(fice<fice_cr) = 0.0;
area = repmat(area,[1 1 size(fice,3)]);
mask = repmat(in,[1 1 size(fice,3)]);
mask2 = repmat(mask2,[1 1 size(fice,3)]);
xice = fice.*area.*mask.*mask2;
xice = xice(:,100:end,:);
xice = squeeze(nansum(xice,1));
xice = squeeze(nansum(xice,1));

savename = ['matfiles/' project_name '_ice_extend_BG.mat']
save(savename,'xice')
