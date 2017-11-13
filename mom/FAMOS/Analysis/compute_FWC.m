clear all

salt_cr = 34.8;
%root_folder = '/hexagon/work/milicak/RUNS/mom/' ;
root_folder = '/export/grunchfs/unibjerknes/milicak/bckup/mom/FAMOS/';

%project_name = 'om3_core3_ctrl'
%project_name = 'om3_core3_2'
%project_name = 'om3_core3_2_BG_pos'
%project_name = 'om3_core3_2_BG_neg'
%project_name = 'om3_core3_2_GS_pos'
project_name = 'om3_core3_2_GS_neg'

%fname = [root_folder project_name '/om3_core3/history/00010101.ice_month.nc'];
fname = [root_folder project_name '/om3_core3/history/salt_19480101.ocean_month.nc'];
fname2 = [root_folder project_name '/om3_core3/history/dht_19480101.ocean_month.nc'];
aname = '/export/grunchfs/unibjerknes/milicak/bckup/noresm/CORE2/Arctic/DATA/gfdl-mom/grids_bathymetry/ocean.static.nc';
mname = ['/fimm/home/bjerknes/milicak/Analysis/mom/APE/Analysis/grid_spec_v6_regMask.nc'];

%dz = ncread(fname2,'dht');
%area = ncread(aname,'area_t');
mask = ncread(mname,'tmask');
totaltime = ncread(fname,'time');
nx = length(ncread(fname,'xt_ocean'));
ny = length(ncread(fname,'yt_ocean'));
nz = length(ncread(fname,'st_ocean'));
%salt = ncread(fname,'salt');

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

mask = repmat(mask,[1 1 nz]);
% Beaufort Gyre mask                                                            
lon1 = [-130 -130 -170 -170];                                                   
lat1 = [70.5 80.5 80.5 70.5];                                                   
lon1(end+1) = lon1(1);                                                          
lat1(end+1) = lat1(1);                                                          
in = insphpoly(lon,lat,lon1,lat1,0.,90.);                                       
in = double(in);
in = repmat(in,[1 1 nz]);
%area = repmat(area,[1 1 size(salt,3)]);
Sref = repmat(salt_cr,[nx,ny,nz]);
%Sref = repmat(salt_cr,[size(salt,1),size(salt,2),size(salt,3)]);

FWC = [];
FWC_BG = [];
for time = 1:length(totaltime)
    %S1 = squeeze(salt(:,:,:,time));
    %dz1 = squeeze(dz(:,:,:,time));
    S1 = ncread(fname,'salt',[1 1 1 time],[Inf Inf Inf 1]);
    dz1 = ncread(fname2,'dht',[1 1 1 time],[Inf Inf Inf 1]);
    dnm = (Sref - S1).*in.*dz1;
    dnm(dnm<0) = 0;
    dnm = dnm./Sref;
    dnm = squeeze(nansum(dnm,3));
    FWC_BG(:,:,time) = double(dnm);
    dnm = (Sref - S1).*mask.*dz1;
    dnm(dnm<0) = 0;
    dnm = dnm./Sref;
    dnm = squeeze(nansum(dnm,3));
    FWC(:,:,time) = double(dnm);
    time
end

savename = ['matfiles/' project_name '_FWC_time.mat']
save(savename,'FWC','FWC_BG')
