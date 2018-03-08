clear all

root_folder = '/okyanus/users/milicak/models/MITgcm_c65/Projects/Blacksea_lonlat/input/forc/2011/';

%nflx=rsns-rsnl-hfss-evspsbl

rsns = ncread([root_folder '2011.nc'],'rsns');
rsds = ncread([root_folder '2011.nc'],'rsds');
rsnl = ncread([root_folder '2011.nc'],'rsnl');
rsdl = ncread([root_folder '2011.nc'],'rsdl');
hfss = ncread([root_folder '2011.nc'],'hfss');
evspsbl = ncread([root_folder '2011.nc'],'evspsbl');
grid_center_lon = ncread([root_folder '2011.nc'],'xlon');
grid_center_lat = ncread([root_folder '2011.nc'],'xlat');
nx = size(grid_center_lon,1);
ny = size(grid_center_lon,2);

dx = distance(grid_center_lat(1:end-1,:),grid_center_lon(1:end-1,:),grid_center_lat(2:end,:),grid_center_lon(2:end,:),earthRadius);
dy = distance(grid_center_lat(:,1:end-1),grid_center_lon(:,1:end-1),grid_center_lat(:,2:end),grid_center_lon(:,2:end),earthRadius);
dx(end+1,:) = dx(end,:);
dy(:,end+1) = dy(:,end);
area = dx.*dy;
area3d = repmat(area,[1 1 365]);

mask = ncread([root_folder '2011.nc'],'mask');
mask = 0.5*(2-mask);
%remove marmara
mask(:,1:11) = 0;
mask2d = mask;
mask = repmat(mask,[1 1 365]);

rsns = reshape(rsns,[126 81 8 365]);
rsds = reshape(rsds,[126 81 8 365]);
rsnl = reshape(rsnl,[126 81 8 365]);
rsdl = reshape(rsdl,[126 81 8 365]);
hfss = reshape(hfss,[126 81 8 365]);
evspsbl = reshape(evspsbl,[126 81 8 365]);

rsns = squeeze(nanmean(rsns,3)).*mask.*area3d;
rsds = squeeze(nanmean(rsds,3)).*mask.*area3d;
rsnl = squeeze(nanmean(rsnl,3)).*mask.*area3d;
rsdl = squeeze(nanmean(rsdl,3)).*mask.*area3d;
hfss = squeeze(nanmean(hfss,3)).*mask.*area3d;
evspsbl = squeeze(nanmean(evspsbl,3)).*mask.*area3d;
totalarea = mask2d.*area;
totalarea = nansum(totalarea(:));

RSNS = squeeze(nansum(rsns,1));
RSNS = squeeze(nansum(RSNS,1))./totalarea;
RSDS = squeeze(nansum(rsds,1));
RSDS = squeeze(nansum(RSDS,1))./totalarea;
RSNL = squeeze(nansum(rsnl,1));
RSNL = squeeze(nansum(RSNL,1))./totalarea;
RSDL = squeeze(nansum(rsdl,1));
RSDL = squeeze(nansum(RSDL,1))./totalarea;
HFSS = squeeze(nansum(hfss,1));
HFSS = squeeze(nansum(HFSS,1))./totalarea;
EVSP = squeeze(nansum(evspsbl,1));
EVSP = squeeze(nansum(EVSP,1))./totalarea;


