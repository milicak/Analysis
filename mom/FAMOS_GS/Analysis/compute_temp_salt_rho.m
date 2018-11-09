clear all

%project_name = 'om3_core3_2'
%project_name = 'om3_core3_2_BG_neg'
%project_name = 'om3_core3_2_BG_pos'
%project_name = 'om3_core3_2_GS_neg'
project_name = 'om3_core3_2_GS_pos'
%project_name = 'om3_core3_ctrl'
%root_folder = '/hexagon/work/milicak/RUNS/mom/' ;
%root_folder = '/export/grunchfs/unibjerknes/milicak/bckup/mom/FAMOS/';
root_folder = '/shared/projects/uniklima/globclim/milicak/mom/FAMOS/';

aname = '/work/users/mil021/RUNS/mom/FAMOS/om3_core3_2/om3_core3/history/ocean.static.nc';
hname = [root_folder project_name '/om3_core3/history/dht_19480101.ocean_month.nc'];
temp_name = [root_folder project_name '/om3_core3/history/temp_19480101.ocean_month.nc'];
salt_name = [root_folder project_name '/om3_core3/history/salt_19480101.ocean_month.nc'];
area = ncread(aname,'area_t');
out = load('/shared/projects/uniklima/globclim/milicak/grunchhome/milicak/Analysis/NorESM/Arctic_seaice/Analysis/region_masks.mat');

zr = ncread(temp_name,'st_ocean');
lon = ncread(aname,'geolon_t');
lat = ncread(aname,'geolat_t');
kmt = ncread(aname,'kmt');
kmt(kmt<0) = 50;

% Beaufort Gyre mask                                                            
lon1 = [-130 -130 -170 -170];                                                   
lat1 = [70.5 80.5 80.5 70.5];                                                   
lon1(end+1) = lon1(1);                                                          
lat1(end+1) = lat1(1);                                                          
in = insphpoly(lon,lat,lon1,lat1,0.,90.);                                       
maskBG = double(in);
maskBG = repmat(maskBG,[1 1 50]);
% Eurasia Basin
lon7 = [15.945 48.013 60.165 95.128 125 139 -50 -22 13 15.945];
lat7 = [78.774 80.416 80.692 80.701 77 75 80 79 79 78.774];
in = insphpoly(lon,lat,lon7,lat7,0,90);
% in = insphpoly(lon,lat,out.lon7,out.lat7,0,90);
maskEB = double(in);
maskEB = repmat(maskEB,[1 1 50]);
% Nordic Seas mask                                                            
lon1 = [-15 10 10 -15];                                                   
lat1 = [66 66 76 76];                                                   
lon1(end+1) = lon1(1);                                                          
lat1(end+1) = lat1(1);                                                          
in = insphpoly(lon,lat,lon1,lat1,0.,90.);                                       
maskNS = double(in);
maskNS = repmat(maskNS,[1 1 50]);
% BSKS mask
in = insphpoly(lon,lat,out.lon1,out.lat1,0,90);
maskBK = double(in);
maskBK = repmat(maskBK,[1 1 50]);

area3d = repmat(area,[1 1 50]);
for i=1:size(area,1)
    for j=1:size(area,2)
        area3d(i,j,kmt(i,j)+1:end)=NaN;
    end
end

totBG = area3d.*maskBG;
totBG = squeeze(nansum(totBG,1));
totBG = squeeze(nansum(totBG,1));

totEB = area3d.*maskEB;
totEB = squeeze(nansum(totEB,1));
totEB = squeeze(nansum(totEB,1));

totBK = area3d.*maskBK;
totBK = squeeze(nansum(totBK,1));
totBK = squeeze(nansum(totBK,1));

totNS = area3d.*maskNS;
totNS = squeeze(nansum(totNS,1));
totNS = squeeze(nansum(totNS,1));

% return
k = 1;
for time=397:744
    k
    temp = squeeze(ncread(temp_name,'temp',[1 1 1 time],[Inf Inf Inf 1]));
    salt = squeeze(ncread(salt_name,'salt',[1 1 1 time],[Inf Inf Inf 1]));
    rho = gsw_rho(salt,temp,0);

    % BSKS
    dnm = temp.*area3d.*maskBK;
    dnm = squeeze(nansum(dnm,1));
    dnm = squeeze(nansum(dnm,1));
    dnm = dnm./totBK;
    Temp_BSKS(k,:) = dnm;
    dnm = salt.*area3d.*maskBK;
    dnm = squeeze(nansum(dnm,1));
    dnm = squeeze(nansum(dnm,1));
    dnm = dnm./totBK;
    Salt_BSKS(k,:) = dnm;
    dnm = rho.*area3d.*maskBK;
    dnm = squeeze(nansum(dnm,1));
    dnm = squeeze(nansum(dnm,1));
    dnm = dnm./totBK;
    Rho_BSKS(k,:) = dnm;
    % Nordic Seas
    dnm = temp.*area3d.*maskNS;
    dnm = squeeze(nansum(dnm,1));
    dnm = squeeze(nansum(dnm,1));
    dnm = dnm./totNS;
    Temp_NS(k,:) = dnm;
    dnm = salt.*area3d.*maskNS;
    dnm = squeeze(nansum(dnm,1));
    dnm = squeeze(nansum(dnm,1));
    dnm = dnm./totNS;
    Salt_NS(k,:) = dnm;
    dnm = rho.*area3d.*maskNS;
    dnm = squeeze(nansum(dnm,1));
    dnm = squeeze(nansum(dnm,1));
    dnm = dnm./totNS;
    Rho_NS(k,:) = dnm;
    % Eurasian Basin
    dnm = temp.*area3d.*maskEB;
    dnm = squeeze(nansum(dnm,1));
    dnm = squeeze(nansum(dnm,1));
    dnm = dnm./totEB;
    Temp_EB(k,:) = dnm;
    dnm = salt.*area3d.*maskEB;
    dnm = squeeze(nansum(dnm,1));
    dnm = squeeze(nansum(dnm,1));
    dnm = dnm./totEB;
    Salt_EB(k,:) = dnm;
    dnm = rho.*area3d.*maskEB;
    dnm = squeeze(nansum(dnm,1));
    dnm = squeeze(nansum(dnm,1));
    dnm = dnm./totEB;
    Rho_EB(k,:) = dnm;
    % Beaufort Gyre
    dnm = temp.*area3d.*maskBG;
    dnm = squeeze(nansum(dnm,1));
    dnm = squeeze(nansum(dnm,1));
    dnm = dnm./totBG;
    Temp_BG(k,:) = dnm;
    dnm = salt.*area3d.*maskBG;
    dnm = squeeze(nansum(dnm,1));
    dnm = squeeze(nansum(dnm,1));
    dnm = dnm./totBG;
    Salt_BG(k,:) = dnm;
    dnm = rho.*area3d.*maskBG;
    dnm = squeeze(nansum(dnm,1));
    dnm = squeeze(nansum(dnm,1));
    dnm = dnm./totBG;
    Rho_BG(k,:) = dnm;
    k = k+1;
end

savename = ['matfiles/' project_name '_temp_salt_rho.mat']
save(savename,'Temp_BG','Temp_EB','Temp_NS','Temp_BSKS', ...
    'Salt_BG','Salt_EB','Salt_NS','Salt_BSKS', ...
    'Rho_BG','Rho_EB','Rho_NS','Rho_BSKS','zr')
