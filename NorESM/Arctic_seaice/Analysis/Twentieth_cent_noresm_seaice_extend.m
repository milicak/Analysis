% this routine computes time series of sea ice extend in different areas in
% noresm CORE2 simulations
clear all

root_folder = '/hexagon/work/mmu072/archive/NOI20C_T62_tn11_CRF_CTRL/ocn/hist/';
modelname = 'NorESM_20th';
expid = 'NOI20C_T62_tn11_CRF_CTRL';
gridname = '/fimm/home/bjerknes/milicak/Analysis/NorESM/climatology/Analysis/grid.nc';

lon = ncread(gridname,'plon');
lat = ncread(gridname,'plat');
ice_cr = 0.15;

% NorESM specific
lon = lon(:,1:end-1);
lat = lat(:,1:end-1);

out = load('region_masks.mat');
out2 = load('new_region_masks.mat');
% lon1,lat1 is for Kara and Barents Sea
% lon2,lat2 is for Greenland Sea
% lon3,lat3 is for Hudson Bay
% lon4,lat4 is for CAA
% lon5,lat5 is for Arctic Ocean Canadian side
% lon6,lat6 is for Labrador Sea/ Baffin Bay
% lon7,lat7 is for Arctic Ocean Eurasian side
% lon8,lat8 is for Bering Sea
% lon9,lat9 is for Chukchi Sea
% lon10,lat10 is for East Siberian Sea


tmp1 = [{'out.lon1'} {'out.lon2'} {'out.lon3'} {'out.lon4'} {'out.lon5'} {'out.lon6'} {'out.lon7'} {'out.lon8'} {'out2.lon9'} {'out2.lon10'}];
tmp2 = [{'out.lat1'} {'out.lat2'} {'out.lat3'} {'out.lat4'} {'out.lat5'} {'out.lat6'} {'out.lat7'} {'out.lat8'} {'out2.lat9'} {'out2.lat10'}];

regionnames = [{'KaraBarents'} {'Greenland'} {'Hudson'} {'CAA'} {'Canadian'} ...
{'Labrador'} {'Eurasian'} {'Bering'} {'Chukchi'} {'EastSiber'} {'Canadanew'} {'Arctic'}];
masks = containers.Map;
ice_ext_regions = containers.Map;


% 1871–2009
datesep='-';
icevariable = 'fice';
n = 1;
ice = [];
for year = 1:139  % 1871:2009
%for year = 109:137 % 1979:2007
    for month = 1:12
        sdate=sprintf('%4.4d%c%2.2d',year,datesep,month);
        disp(sdate)
        filename = [root_folder expid '.micom.hm.' sdate '.nc'];
        ice(:,:,n) = ncread(filename,icevariable);
        n = n+1;
    end
end
% year from 1979 to 2007 ==> 348 months
ice = ice./100;
ice = ice(:,1:end-1,:);
ice(ice < ice_cr) = NaN;

area = ncread(gridname,'parea');
area = repmat(area,[1 1 size(ice,3)]);
area = area(:,1:end-1,:);

for i = 1:10
    in = insphpoly(lon,lat,eval(tmp1{i}),eval(tmp2{i}),0,90);
    in = double(in);
    in(in==0) = NaN;
    masks(num2str(i)) = in;
    mask = in;
    if 1 
        if i==9
            mask9 = mask;
            mask9(isnan(mask9)) = 0;
        elseif i==10
            mask10 = mask;
            mask10(isnan(mask10)) = 0;
        elseif i==5
            mask5 =mask;
            mask5(isnan(mask5)) = 0;
        end
    end
    if(exist('mask10'))
        mask11 = mask5-mask10-mask9;
        mask11(mask11~=1) = NaN;
    end
    mask = repmat(mask,[1 1 size(ice,3)]);
    tmp = ice.*mask.*area;
    tmp = squeeze(nansum(tmp,1));
    tmp = squeeze(nansum(tmp,1));
    ice_ext_regions(regionnames{i}) = tmp;
end
% new Canada basin
i = i+1;
mask = repmat(mask11,[1 1 size(ice,3)]);
tmp = ice.*mask.*area;
tmp = squeeze(nansum(tmp,1));
tmp = squeeze(nansum(tmp,1));
ice_ext_regions(regionnames{i}) = tmp;
% whole Arctic basin
i = i+1;
mask = NaN*zeros(size(mask11,1),size(mask11,2));
mask = repmat(mask,[1 1 size(ice,3)]);
mask(:,end/2:end,:) = 1;
tmp = ice.*mask.*area;
tmp = squeeze(nansum(tmp,1));
tmp = squeeze(nansum(tmp,1));
ice_ext_regions(regionnames{i}) = tmp;
savename = ['matfiles/' modelname '_ice_extentions_1871_2009.mat'];
%savename = ['matfiles/' modelname '_ice_extentions.mat'];
save(savename,'ice_ext_regions')
