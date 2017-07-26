clear all

k=1;
rho_cp       = 1; rho0         = 1035;
sv2mks = 1e9; 

project_name = 'om3_core3_2'
%project_name = 'om3_core3_2_BG_neg'
%project_name = 'om3_core3_2_BG_pos'
%project_name = 'om3_core3_2_GS_neg'
%project_name = 'om3_core3_2_GS_pos'
%project_name = 'om3_core3_ctrl'
root_folder = '/hexagon/work/milicak/RUNS/mom/' ;
%root_folder = '/export/grunchfs/unibjerknes/milicak/bckup/mom/';

%variable = [{'temp_xflux_adv_int_z'}];

% x-direction
fname = [root_folder project_name '/om3_core3/history/temp_xflux_adv_int_z_19480101.ocean_month.nc'];
temp_xflux_adv_int_z = ncread(fname,'temp_xflux_adv_int_z');

fname = [root_folder project_name '/om3_core3/history/temp_xflux_gm_int_z_19480101.ocean_month.nc'];
temp_xflux_gm_int_z = ncread(fname,'temp_xflux_gm_int_z');

fname = [root_folder project_name '/om3_core3/history/temp_xflux_ndiffuse_int_z_19480101.ocean_month.nc'];
temp_xflux_ndiffuse_int_z = ncread(fname,'temp_xflux_ndiffuse_int_z');

fname = [root_folder project_name '/om3_core3/history/temp_xflux_sigma_19480101.ocean_month.nc'];
temp_xflux_sigma = ncread(fname,'temp_xflux_sigma');
temp_xflux_sigma = squeeze(nansum(temp_xflux_sigma,3));

fname = [root_folder project_name '/om3_core3/history/temp_xflux_submeso_int_z_19480101.ocean_month.nc'];
temp_xflux_submeso_int_z = ncread(fname,'temp_xflux_submeso_int_z');

fname = [root_folder project_name '/om3_core3/history/tx_trans_19480101.ocean_month.nc'];
transx = ncread(fname,'tx_trans');

% y-direction
fname = [root_folder project_name '/om3_core3/history/temp_yflux_adv_int_z_19480101.ocean_month.nc'];
temp_yflux_adv_int_z = ncread(fname,'temp_yflux_adv_int_z');

fname = [root_folder project_name '/om3_core3/history/temp_yflux_gm_int_z_19480101.ocean_month.nc'];
temp_yflux_gm_int_z = ncread(fname,'temp_yflux_gm_int_z');

fname = [root_folder project_name '/om3_core3/history/temp_yflux_ndiffuse_int_z_19480101.ocean_month.nc'];
temp_yflux_ndiffuse_int_z = ncread(fname,'temp_yflux_ndiffuse_int_z');

fname = [root_folder project_name '/om3_core3/history/temp_yflux_sigma_19480101.ocean_month.nc'];
temp_yflux_sigma = ncread(fname,'temp_yflux_sigma');
temp_yflux_sigma = squeeze(nansum(temp_yflux_sigma,3));

fname = [root_folder project_name '/om3_core3/history/temp_yflux_submeso_int_z_19480101.ocean_month.nc'];
temp_yflux_submeso_int_z = ncread(fname,'temp_yflux_submeso_int_z');

fname = [root_folder project_name '/om3_core3/history/tx_trans_19480101.ocean_month.nc'];
transx = ncread(fname,'tx_trans');

fname = [root_folder project_name '/om3_core3/history/ty_trans_19480101.ocean_month.nc'];
transy = ncread(fname,'ty_trans');

% heat transport
transx_heat  = rho_cp*(temp_xflux_adv_int_z+temp_xflux_gm_int_z+temp_xflux_ndiffuse_int_z+temp_xflux_sigma+temp_xflux_submeso_int_z);
transy_heat  = rho_cp*(temp_yflux_adv_int_z+temp_yflux_gm_int_z+temp_yflux_ndiffuse_int_z+temp_yflux_sigma+temp_yflux_submeso_int_z);
% seawater transport
transx = sv2mks*squeeze(nansum(transx,3));
transy = sv2mks*squeeze(nansum(transy,3));
% compute the Fram and barents sea sections
heat_trans_fram = squeeze(transy_heat(266:286,191,:));
heat_trans_barents = squeeze(transx_heat(295,177:190,:));
volume_trans_fram = squeeze(transy(266:286,191,:));
volume_trans_barents = squeeze(transx(295,177:190,:));

heat_trans_fram = reshape(heat_trans_fram,[size(heat_trans_fram,1) 12 size(heat_trans_fram,2)/12]); 
heat_trans_barents = reshape(heat_trans_barents,[size(heat_trans_barents,1) 12 size(heat_trans_barents,2)/12]);
heat_trans_fram = squeeze(nanmean(heat_trans_fram,2));
heat_trans_barents = squeeze(nanmean(heat_trans_barents,2));

volume_trans_fram= reshape(volume_trans_fram,[size(volume_trans_fram,1) 12 size(volume_trans_fram,2)/12]);
volume_trans_fram = squeeze(nanmean(volume_trans_fram,2));
volume_trans_barents = reshape(volume_trans_barents,[size(volume_trans_barents,1) 12 size(volume_trans_barents,2)/12]);
volume_trans_barents = squeeze(nanmean(volume_trans_barents,2));

 
k = 1;
for year=1:size(volume_trans_fram,2)
%Fram
ind = find(volume_trans_fram(:,year)>0);
ind2 = find(volume_trans_fram(:,year)<=0);
fram_volume_total(k) = nansum(volume_trans_fram(:,year));
fram_heat_total(k) = nansum(heat_trans_fram(:,year));
fram_volume_inflow(k) = nansum(volume_trans_fram(ind,year));
fram_heat_inflow(k) = nansum(heat_trans_fram(ind,year));
fram_volume_outflow(k) = nansum(volume_trans_fram(ind2,year));
fram_heat_outflow(k) = nansum(heat_trans_fram(ind2,year));
%Barents
ind = find(volume_trans_barents(:,year)>0);
ind2 = find(volume_trans_barents(:,year)<=0);
barents_volume_total(k) = nansum(volume_trans_barents(:,year));
barents_heat_total(k) = nansum(heat_trans_barents(:,year));
barents_volume_inflow(k) = nansum(volume_trans_barents(ind,year));
barents_heat_inflow(k) = nansum(heat_trans_barents(ind,year));
barents_volume_outflow(k) = nansum(volume_trans_barents(ind2,year));
barents_heat_outflow(k) = nansum(heat_trans_barents(ind2,year));
k = k+1;
end

savename = ['matfiles/' project_name '_fram_transports.mat']
save(savename,'fram_heat_inflow','fram_heat_outflow','fram_heat_total','fram_volume_inflow','fram_volume_outflow','fram_volume_total')
savename = ['matfiles/' project_name '_barents_transports.mat']
save(savename,'barents_heat_inflow','barents_heat_outflow','barents_heat_total','barents_volume_inflow','barents_volume_outflow','barents_volume_total')
