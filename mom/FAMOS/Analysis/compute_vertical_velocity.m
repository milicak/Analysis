clear all

%root_folder = '/hexagon/work/milicak/RUNS/mom/' ;
root_folder = '/export/grunchfs/unibjerknes/milicak/bckup/mom/FAMOS/';

%project_name = 'om3_core3_ctrl'
%project_name = 'om3_core3_2'
%project_name = 'om3_core3_2_BG_pos'
project_name = 'om3_core3_2_BG_neg'
%project_name = 'om3_core3_2_GS_pos'
%project_name = 'om3_core3_2_GS_neg'

%fname = [root_folder project_name '/om3_core3/history/00010101.ice_month.nc'];
fname = [root_folder project_name '/om3_core3/history/wt_19480101.ocean_month.nc'];
aname = '/export/grunchfs/unibjerknes/milicak/bckup/noresm/CORE2/Arctic/DATA/gfdl-mom/grids_bathymetry/ocean.static.nc';
mname = ['/fimm/home/bjerknes/milicak/Analysis/mom/APE/Analysis/grid_spec_v6_regMask.nc'];

area = ncread(aname,'area_t');
depth = ncread(aname,'ht');
depth(depth<0)=0;
depth(depth>300)=0;
depth(depth~=0)=1;
mask = ncread(mname,'tmask');
wt = ncread(fname,'wt');
% 20 meter 
wt = squeeze(wt(:,:,2,:));

% mask == 4 is for the Arctic
% Pacific ==> Arcitc
%mask(mask==3) = 4;
% Atlantic ==> Arcitc
%mask(mask==2) = 4;
% make whole new mask
mask(mask~=4) = 0;
mask(mask==4) = 1;
lon=ncread(mname,'geolon_t');
lat=ncread(mname,'geolat_t');

% Beaufort Gyre mask                                                            
lon1 = [-130 -130 -170 -170];                                                   
lat1 = [70.5 80.5 80.5 70.5];                                                   
lon1(end+1) = lon1(1);                                                          
lat1(end+1) = lat1(1);                                                          
in = insphpoly(lon,lat,lon1,lat1,0.,90.);                                       
in = double(in);
dnm2 = in.*area;
dnm3 = mask.*depth.*area;

wt_BG = [];
wt_300 = [];
for time = 1:size(wt,3)
    wt1 = squeeze(wt(:,:,time));
    dnm = wt1.*area.*in;
    wt_BG(time) = nansum(dnm(:))./nansum(dnm2(:));
    dnm = wt1.*area.*mask.*depth;
    wt_300(time) = nansum(dnm(:))./nansum(dnm3(:));
    time
end

savename = ['matfiles/' project_name '_wt_time.mat']
save(savename,'wt_BG','wt_300')
