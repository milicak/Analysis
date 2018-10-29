clear all

%root_folder = '/hexagon/work/milicak/RUNS/mom/' ;
root_folder = '/shared/projects/uniklima/globclim/milicak/mom/FAMOS/';

%project_name = 'om3_core3_ctrl'
project_name = 'om3_core3_2'
%project_name = 'om3_core3_2_BG_pos'
%project_name = 'om3_core3_2_BG_neg'
%project_name = 'om3_core3_2_GS_pos'
%project_name = 'om3_core3_2_GS_neg'

%fname = [root_folder project_name '/om3_core3/history/00010101.ice_month.nc'];
fname = [root_folder project_name '/om3_core3/history/wt_19480101.ocean_month.nc'];
aname = '/work/users/mil021/RUNS/mom/FAMOS/om3_core3_2/om3_core3/history/ocean.static.nc';
mname = ['/shared/projects/uniklima/globclim/milicak/grunchhome/milicak/Analysis/mom/APE/Analysis/grid_spec_v6_regMask.nc'];

area = ncread(aname,'area_t');
depth = ncread(aname,'ht');
depth(depth<0)=0;
mask = ncread(mname,'tmask');
% wt = ncread(fname,'wt');
% 20 meter 
wt = squeeze(ncread(fname,'wt',[1 1 2 1],[Inf Inf 1 Inf]));

mask2 = ones(size(depth,1),size(depth,2));
mask2(depth<300) = 0;

lon = ncread(aname,'geolon_t');
lat = ncread(aname,'geolat_t');
% Beaufort Gyre mask                                                            
lon1 = [-130 -130 -170 -170];                                                   
lat1 = [70.5 80.5 80.5 70.5];                                                   
lon1(end+1) = lon1(1);                                                          
lat1(end+1) = lat1(1);                                                          
in = insphpoly(lon,lat,lon1,lat1,0.,90.);                                       
in = double(in);
dnm2 = in.*area;
dnm3 = mask2.*in.*area;

wt_BG = [];
wt_BG_300 = [];
for time = 1:size(wt,3)
    wt1 = squeeze(wt(:,:,time));
    dnm = wt1.*area.*in;
    wt_BG(time) = nansum(dnm(:))./nansum(dnm2(:));
    dnm = wt1.*area.*mask2.*in;
    wt_BG_300(time) = nansum(dnm(:))./nansum(dnm3(:));
    time
end

savename = ['matfiles/' project_name '_wt_BG_time.mat']
save(savename,'wt_BG','wt_BG_300')
