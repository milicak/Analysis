% this routine computes time series of sea ice extend in different areas in
% noresm CORE2 simulations
clear all

root_folder = '/export/grunchfs/unibjerknes/milicak/bckup/noresm/CORE2/Arctic/DATA/';
modelname = 'NorESM';
gridname = '/fimm/home/bjerknes/milicak/Analysis/NorESM/climatology/Analysis/grid.nc';

lon = ncread(gridname,'plon');
lat = ncread(gridname,'plat');

% NorESM specific
lon = lon(:,1:end-1);
lat = lat(:,1:end-1);

out = load('region_masks.mat');
% lon1,lat1 is for Kara and Barents Sea
% lon2,lat2 is for Greenland Sea
% lon3,lat3 is for Hudson Bay
% lon4,lat4 is for CAA
% lon5,lat5 is for Arctic Ocean Canadian side
% lon6,lat6 is for Labrador Sea/ Baffin Bay
% lon7,lat7 is for Arctic Ocean Eurasian side
% lon8,lat8 is for Bering Sea

tmp1 = [{'out.lon1'} {'out.lon2'} {'out.lon3'} {'out.lon4'} {'out.lon5'} {'out.lon6'} {'out.lon7'} {'out.lon8'}];
tmp2 = [{'out.lat1'} {'out.lat2'} {'out.lat3'} {'out.lat4'} {'out.lat5'} {'out.lat6'} {'out.lat7'} {'out.lat8'}];

regionnames = [{'KaraBarents'} {'Greenland'} {'Hudson'} {'CAA'} {'Canadian'} {'Labrador'} {'Eurasian'} {'Bering'}];

masks = containers.Map;
ice_ext_regions = containers.Map;

fname = '/NOIIA_T62_tn11_sr10m60d_01_ice_monthly_1-300.nc';
icevariable = 'fice';
filename = [root_folder modelname '/' fname];

ice = ncread(filename,icevariable);
% year from 1979 to 2007 ==> 348 months
ice = ice(:,:,end-347:end);

for i = 1:8
    in = insphpoly(lon,lat,eval(tmp1{i}),eval(tmp2{i}),0,90);
    in = double(in);
    in(in==0) = NaN;
    masks(num2str(i)) = in;
    mask = in;
    mask = repmat(mask,[1 1 348]);
    tmp = ice.*mask;
    tmp = squeeze(nansum(tmp,1));
    tmp = squeeze(nansum(tmp,1));
    ice_ext_regions(regionnames{i}) = tmp;
end
savename = ['matfiles/' modelname '_ice_extentions.mat'];
save(savename,'ice_ext_regions')
