% this routine computes time series of sea ice extend in different areas in
% noresm CORE2 simulations
clear all

root_folder = '/export/grunchfs/unibjerknes/milicak/bckup/noresm/CORE2/Arctic/DATA/';
modelname = 'gfdl-gold';
gridname = '/export/grunchfs/unibjerknes/milicak/bckup/noresm/CORE2/Arctic/DATA/gfdl-gold/grids_bathymetry/ocean_geometry.nc';

lon = ncread(gridname,'geolon');
lat = ncread(gridname,'geolat');
area = ncread(gridname,'Ah');
area = repmat(area,[1 1 348]);
ice_cr = 0.15;


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

fname = '/seaice_extent_thick_conc/ice.194801-200712.CN.nc';
icevariable = 'CN';
filename = [root_folder modelname '/' fname];

ice = ncread(filename,icevariable);
%specific to gold
ice = squeeze(nansum(ice,3));
ice(ice<0) = NaN;
% year from 1979 to 2007 ==> 348 months
ice = ice(:,:,end-347:end);
ice(ice < ice_cr) = NaN;

for i = 1:8
    in = insphpoly(lon,lat,eval(tmp1{i}),eval(tmp2{i}),0,90);
    in = double(in);
    in(in==0) = NaN;
    masks(num2str(i)) = in;
    mask = in;
    mask = repmat(mask,[1 1 348]);
    tmp = ice.*mask.*area;
    tmp = squeeze(nansum(tmp,1));
    tmp = squeeze(nansum(tmp,1));
    ice_ext_regions(regionnames{i}) = tmp;
end
savename = ['matfiles/' modelname '_ice_extentions.mat'];
save(savename,'ice_ext_regions')
