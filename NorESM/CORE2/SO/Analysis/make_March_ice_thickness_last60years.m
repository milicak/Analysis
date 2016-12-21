clear all

root_dir = '/work/matsbn/archive/';

project_name = 'NOIIA_T62_tn11_sr10m60d_01'

folder_name = [root_dir project_name '/ocn/hist/'];

time_str = 240; % initial time to start averaging
time_end = 265; % final time to start averaging
months_end = 12;

grid_file = '/home/uni/milicak/Analysis/NorESM/climatology/Analysis/grid.nc';
lon=nc_varget(grid_file,'plon');
lat=nc_varget(grid_file,'plat');

year = 1;

variable(1:12,1:70,1:385,1:360)=NaN;
temp_mean(time_end-time_str+1,1:70,1:385,1:360)=NaN;

for time_ind = time_str:time_end

no = num2str(time_ind,'%.4d');
display(['year = ' no]);

for months = 1:months_end
months_ind = num2str(months,'%.2d');
dnm = [folder_name project_name '.micom.hm.' no '-' months_ind '.nc'];
file_name(1:length(dnm),months) = [folder_name project_name '.micom.hm.' no '-' months_ind '.nc'];
end

for months = 1:months_end
variable(months,:,:,:) = nc_varget(file_name(:,months)','templvl'); % get data in double format
end

temp_mean(year,:,:,:)=nanmean(variable,1);
year = year+1;
end


