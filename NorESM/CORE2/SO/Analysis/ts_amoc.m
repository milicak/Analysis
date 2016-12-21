
clear all
% this subroutine computes yearly average of all the variables in the history files.
% You need to specify which time frame you want to average, for instance 0020-0039 20 years from year 20

%clc

%root_dir = '/mnt/hexwork/noresm/';
root_dir = '/work/matsbn/archive/'
%/work/matsbn/archive/NOIIA_T62_tn11_sr10m60d_01
%/work/matsbn/archive/NOIIA_T62_tn11_sr10m30d_01
%/work/matsbn/archive/NOIIA_T62_tn11_sr10m15d_01
%/work/matsbn/archive/NOIIA_T62_tn11_bblsr10m30d_01

project_name = 'NOIIA_T62_tn11_sr10m60d_01'
%project_name = 'NOIIA_T62_tn11_sr10m30d_01'
%project_name = 'NOIIA_T62_tn11_sr10m15d_01'
%project_name = 'NOIIA_T62_tn11_bblsr10m30d_01'

folder_name = [root_dir project_name '/ocn/hist/'];

time_str = 21; % initial time to start averaging
time_end = 40; % final time to start averaging
months_end = 12; % time series whole year (12 months)

% variable to create time-series
variable = [{'mmflxl'} {'mmflxd'}]

t_ind = 1;
year_time = 1;
for time_ind = time_str:time_end
no = num2str(time_ind,'%.4d');
year_name(:,year_time) = [folder_name project_name '.micom.hy.' no '-01.nc'];
for months = 1:months_end
no2 = num2str(months,'%.2d');
dnm = [folder_name project_name '.micom.hy.' no '-'  no2 '.nc'];
file_name(1:length(dnm),t_ind) = [folder_name project_name '.micom.hm.' no '-'  no2 '.nc'];
t_ind = t_ind + 1;
end
year_time = year_time+1;
end

% get the grid info
lat = nc_varget(file_name(:,1)','lat');
depth = nc_varget(file_name(:,1)','depth');
% Latitude interval for maximum AMOC search
lat1=20;
lat2=60;
ind1=min(find(lat>=lat1));
ind2=max(find(lat<=lat2));

depth2d=repmat(depth,[1 ind2-ind1+1]);

%lat 45 and 26.5
lat3=26.5;
ind3=min(find(lat>=lat3));
lat4=45;
ind4=min(find(lat>=lat4));


for kk = 1:length(variable)
amoc_info = struct('name',char(variable(kk)),'project_name',project_name,'years',[num2str(time_str) '_' num2str(time_end)]);
for ttime = 1:size(file_name,2)
var = nc_varget(file_name(:,ttime)',char(variable(kk)));
var2 = squeeze(var(1,:,ind1:ind2))*1e-9;
time(ttime) = nc_varget(file_name(:,ttime)','time');
if(kk==1)
amoc(ttime) = nanmax(var2(:));
elseif(kk==2)
[amoc(ttime) I] = nanmax(var2(:));
depth_max_amoc(ttime) = depth2d(I);
% Lat = 26.5
var2 = squeeze(var(1,:,ind3))*1e-9;
[amoc_26_5(ttime) I] = nanmax(var2(:));
depth_max_amoc_26_5(ttime) = depth(I);
% Lat = 45
var2 = squeeze(var(1,:,ind4))*1e-9;
[amoc_45(ttime) I] = nanmax(var2(:));
depth_max_amoc_45(ttime) = depth(I);
end
end %ttime

%for ttime = 1:size(year_name,2)
%var = nc_varget(year_name(:,ttime)',char(variable(kk)));
%var = squeeze(var(1,:,ind1:ind2))*1e-9;
%amoc_years(ttime) = nanmax(var(:));
%end %ttime

save_name = ['matfiles/' project_name '_' amoc_info.name '_years_' amoc_info.years]
if(kk==1)
save(save_name,'amoc','time');
elseif(kk==2)
save(save_name,'amoc_26_5','amoc_45','amoc','depth_max_amoc','depth_max_amoc_26_5','depth_max_amoc_45','time');
end
%save(save_name,'amoc_years','amoc','time');
end %kk


% 12 months averaged
% dnm = reshape(amoc,[12 20]);
% dnm = nanmean(dnm,1);



