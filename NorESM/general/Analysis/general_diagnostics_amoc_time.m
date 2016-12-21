function [amoc amoc_26_5 amoc_45]=general_diagnostics_amoc_time(root_folder,expid,m2y,time_str,time_end,region)
% variable to create time-series
variable = [{'mmflxd'}];
project_name = expid;
folder_name = [root_folder project_name '/ocn/hist/'];
%folder_name = [root_folder project_name '/run/'];
%folder_name = [root_folder '/'];

t_ind = 1;
year_time = 1;
months_end = 12; % time series whole year (12 months)

for time_ind = time_str:time_end
  no = num2str(time_ind,'%.4d');
  year_name(:,year_time) = [folder_name project_name '.micom.hy.' no '-01.nc'];
  if m2y==1
    for months = 1:months_end
      no2 = num2str(months,'%.2d');
      dnm = [folder_name project_name '.micom.hm.' no '-' no2 '.nc'];
      file_name(1:length(dnm),t_ind) = [folder_name project_name '.micom.hm.' no '-'  no2 '.nc'];
      t_ind = t_ind + 1;
    end
  else
    dnm = [folder_name project_name '.micom.hy.' no '.nc'];
    file_name(1:length(dnm),t_ind) = [folder_name project_name '.micom.hy.' no '.nc'];
    t_ind = t_ind + 1;
  end
  year_time = year_time+1;
end

% get the grid info
lat = ncgetvar(file_name(:,1)','lat');
depth = ncgetvar(file_name(:,1)','depth');
% Latitude interval for maximum AMOC search
lat1=20;
lat2=60;
ind1=min(find(lat>=lat1));
ind2=max(find(lat<=lat2));

depth2d=repmat(depth,[1 ind2-ind1+1]);
lat2dl=repmat(lat(ind1:ind2),[1 53])';
lat2dd=repmat(lat(ind1:ind2),[1 70])';

%lat 45 and 26.5
lat3=26.5;
ind3=min(find(lat>=lat3))-1;
lat4=45;
ind4=min(find(lat>=lat4));

for kk = 1:length(variable)
amoc_info = struct('name',char(variable(kk)),'project_name',project_name,'years',[num2str(time_str) '_' num2str(time_end)]);
for ttime = 1:size(file_name,2)
var = ncgetvar(file_name(:,ttime)',char(variable(kk)));
var = permute(var,[3 2 1]);
time(ttime) = ncgetvar(file_name(:,ttime)','time');
if(kk==2)
var2 = squeeze(var(region,:,ind1:ind2))*1e-9;
[amoc(ttime) I] = nanmax(var2(:));
lat_maxamoc(ttime)=lat2dl(I);
elseif(kk==1)
var2 = squeeze(var(region,:,ind1:ind2))*1e-9;
[amoc(ttime) I] = nanmax(var2(:));
depth_max_amoc(ttime) = depth2d(I);
lat_maxamoc(ttime)=lat2dd(I);
% Lat = 26.5
var2 = squeeze(var(region,:,ind3))*1e-9;
[amoc_26_5(ttime) I] = nanmax(var2(:));
depth_max_amoc_26_5(ttime) = depth(I);
% Lat = 45
var2 = squeeze(var(region,:,ind4))*1e-9;
[amoc_45(ttime) I] = nanmax(var2(:));
depth_max_amoc_45(ttime) = depth(I);
end
ttime
end %ttime
save_name = ['matfiles/' project_name '_' amoc_info.name '_years_' amoc_info.years];
if(kk==1)
%save(save_name,'amoc','lat_maxamoc','time');
save(save_name,'amoc_26_5','amoc_45','amoc','lat_maxamoc','depth_max_amoc','depth_max_amoc_26_5','depth_max_amoc_45','time');
elseif(kk==2)
save(save_name,'amoc_26_5','amoc_45','amoc','lat_maxamoc','depth_max_amoc','depth_max_amoc_26_5','depth_max_amoc_45','time');
end
end %kk
