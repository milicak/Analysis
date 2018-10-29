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
area = ncread(aname,'area_t');

fice = ncread(fname,'CN');

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
%fice(fice<fice_cr) = 0.0;
area = repmat(area,[1 1 size(fice,3)]);
mask2 = ones(size(fice,1),size(fice,2));
mask2(depth<300) = 0;
mask = repmat(in,[1 1 size(fice,3)]);
mask2 = repmat(mask2,[1 1 size(fice,3)]);
fice = fice.*mask.*mask2.*area;
fice = fice(:,100:end,:);
fice = squeeze(nansum(fice,1));
fice = squeeze(nansum(fice,1));

tmp = mask.*mask2.*area;
tmp = tmp(:,100:end,:);
tmp = squeeze(nansum(tmp,1));
tmp = squeeze(nansum(tmp,1));

fice = fice./tmp;

savename = ['matfiles/' project_name '_ice_concentration_BG.mat']
save(savename,'fice')
