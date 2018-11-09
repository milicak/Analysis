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

aname = '/work/users/mil021/RUNS/mom/FAMOS/om3_core3_2/om3_core3/history/ocean.static.nc';
hname = [root_folder project_name '/om3_core3/history/dht_19480101.ocean_month.nc'];
temp_name = [root_folder project_name '/om3_core3/history/temp_19480101.ocean_month.nc'];
area = ncread(aname,'area_t');
out = load('/shared/projects/uniklima/globclim/milicak/grunchhome/milicak/Analysis/NorESM/Arctic_seaice/Analysis/region_masks.mat');

rhoref = 1028;
Cp = 3991.87;
lon = ncread(aname,'geolon_t');
lat = ncread(aname,'geolat_t');

% Beaufort Gyre mask                                                            
lon1 = [-130 -130 -170 -170];                                                   
lat1 = [70.5 80.5 80.5 70.5];                                                   
lon1(end+1) = lon1(1);                                                          
lat1(end+1) = lat1(1);                                                          
in = insphpoly(lon,lat,lon1,lat1,0.,90.);                                       
maskBG = double(in);
% Eurasia Basin
lon7 = [15.945 48.013 60.165 95.128 125 139 -50 -22 13 15.945];
lat7 = [78.774 80.416 80.692 80.701 77 75 80 79 79 78.774];
% in = insphpoly(lon,lat,out.lon7,out.lat7,0,90);
in = insphpoly(lon,lat,lon7,lat7,0,90);
maskEB = double(in);
% Nordic Seas mask                                                            
lon1 = [-15 10 10 -15];                                                   
lat1 = [66 66 76 76];                                                   
lon1(end+1) = lon1(1);                                                          
lat1(end+1) = lat1(1);                                                          
in = insphpoly(lon,lat,lon1,lat1,0.,90.);                                       
maskNS = double(in);
% BSKS mask
in = insphpoly(lon,lat,out.lon1,out.lat1,0,90);
maskBK = double(in);

k = 1;
for time=397:744
    k
    temp = squeeze(ncread(temp_name,'temp',[1 1 1 time],[Inf Inf Inf 1]));
    dht = squeeze(ncread(hname,'dht',[1 1 1 time],[Inf Inf Inf 1]));
    dnm = dht.*temp;
    dnm = squeeze(nansum(dnm,3));
    % BSKS
    tmp = dnm.*maskBK.*area;
    HC_BSKS(k) = nansum(tmp(:));
    % Nordic Seas
    tmp = dnm.*maskNS.*area;
    HC_NS(k) = nansum(tmp(:));
    % Eurasian Basin
    tmp = dnm.*maskEB.*area;
    HC_EB(k) = nansum(tmp(:));
    % Beaufort Gyre
    tmp = dnm.*maskBG.*area;
    HC_BG(k) = nansum(tmp(:));
    k = k+1;
end

savename = ['matfiles/' project_name '_heat_content.mat']
save(savename,'HC_BSKS','HC_NS','HC_EB','HC_BG')
