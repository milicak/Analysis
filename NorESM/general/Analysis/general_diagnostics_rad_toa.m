function [rad_toa]=general_diagnostics_rad_toa(root_folder,expid,m2y,time_str,time_end,region)
% variable to create time-series
variable = [{'FLNT'} {'FSNT'}];
project_name = expid;
folder_name = [root_folder project_name '/atm/hist/'];
%folder_name = [root_folder '/'];

t_ind = 1;
year_time = 1;
months_end = 12; % time series whole year (12 months)

for time_ind = time_str:time_end
  no = num2str(time_ind,'%.4d');
  if m2y==1
    for months = 1:months_end
      no2 = num2str(months,'%.2d');
      dnm = [folder_name project_name '.cam.h0.' no '-' no2 '.nc'];
      file_name(1:length(dnm),t_ind) = [folder_name project_name '.cam.h0.' no '-'  no2 '.nc'];
      t_ind = t_ind + 1;
    end
  else
    dnm = [folder_name project_name '.micom.hy.' no '.nc'];
    file_name(1:length(dnm),t_ind) = [folder_name project_name '.micom.hy.' no '.nc'];
    t_ind = t_ind + 1;
  end
  year_time = year_time+1;
end

for kk = 1:length(variable)
amoc_info = struct('name',char(variable(kk)),'project_name',project_name,'years',[num2str(time_str) '_' num2str(time_end)]);
for ttime = 1:size(file_name,2)
var = ncgetvar(file_name(:,ttime)',char(variable(kk)));
time(ttime) = ncgetvar(file_name(:,ttime)','time');

rad_toa(kk)=sum(var(:));

rad_toa2d(ttime,:,:)=var;

ttime
end %ttime
save_name = ['matfiles/' project_name '_' amoc_info.name '_years_' amoc_info.years '.mat'];
save(save_name,'rad_toa2d','time');
end %kk
