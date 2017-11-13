clear all

k=1;
rho_cp = 1; 
rho0 = 1035;
sv2mks = 1e9; 
saln0r = 1/0.0348; % relative salinity 34.8

project_name = 'om3_core3_2'
%project_name = 'om3_core3_2_BG_neg'
%project_name = 'om3_core3_2_BG_pos'
%project_name = 'om3_core3_2_GS_neg'
%project_name = 'om3_core3_2_GS_pos'
%project_name = 'om3_core3_ctrl'
%root_folder = '/hexagon/work/milicak/RUNS/mom/' ;
root_folder = '/export/grunchfs/unibjerknes/milicak/bckup/mom/FAMOS/';

%variable = [{'temp_xflux_adv_int_z'}];
fname = [root_folder project_name '/om3_core3/history/salt_19480101.ocean_month.nc'];
totaltime = ncread(fname,'time');

%time = 1;
for time = 1:length(totaltime)
    % x-direction
    fname = [root_folder project_name '/om3_core3/history/salt_xflux_adv_int_z_19480101.ocean_month.nc'];
    salt_xflux_adv_int_z = ncread(fname,'salt_xflux_adv_int_z',[1 1 time],[Inf Inf 1]);

    fname = [root_folder project_name '/om3_core3/history/salt_xflux_gm_int_z_19480101.ocean_month.nc'];
    salt_xflux_gm_int_z = ncread(fname,'salt_xflux_gm_int_z',[1 1 time],[Inf Inf 1]);

    fname = [root_folder project_name '/om3_core3/history/salt_xflux_ndiffuse_int_z_19480101.ocean_month.nc'];
    salt_xflux_ndiffuse_int_z = ncread(fname,'salt_xflux_ndiffuse_int_z',[1 1 time],[Inf Inf 1]);

    fname = [root_folder project_name '/om3_core3/history/salt_xflux_sigma_19480101.ocean_month.nc'];
    salt_xflux_sigma = ncread(fname,'salt_xflux_sigma',[1 1 1 time],[Inf Inf Inf 1]);
    salt_xflux_sigma = squeeze(nansum(salt_xflux_sigma,3));

    fname = [root_folder project_name '/om3_core3/history/salt_xflux_submeso_int_z_19480101.ocean_month.nc'];
    salt_xflux_submeso_int_z = ncread(fname,'salt_xflux_submeso_int_z',[1 1 time],[Inf Inf 1]);

    fname = [root_folder project_name '/om3_core3/history/temp_xflux_adv_int_z_19480101.ocean_month.nc'];
    temp_xflux_adv_int_z = ncread(fname,'temp_xflux_adv_int_z',[1 1 time],[Inf Inf 1]);

    fname = [root_folder project_name '/om3_core3/history/temp_xflux_gm_int_z_19480101.ocean_month.nc'];
    temp_xflux_gm_int_z = ncread(fname,'temp_xflux_gm_int_z',[1 1 time],[Inf Inf 1]);

    fname = [root_folder project_name '/om3_core3/history/temp_xflux_ndiffuse_int_z_19480101.ocean_month.nc'];
    temp_xflux_ndiffuse_int_z = ncread(fname,'temp_xflux_ndiffuse_int_z',[1 1 time],[Inf Inf 1]);

    fname = [root_folder project_name '/om3_core3/history/temp_xflux_sigma_19480101.ocean_month.nc'];
    temp_xflux_sigma = ncread(fname,'temp_xflux_sigma',[1 1 1 time],[Inf Inf Inf 1]);
    temp_xflux_sigma = squeeze(nansum(temp_xflux_sigma,3));

    fname = [root_folder project_name '/om3_core3/history/temp_xflux_submeso_int_z_19480101.ocean_month.nc'];
    temp_xflux_submeso_int_z = ncread(fname,'temp_xflux_submeso_int_z',[1 1 time],[Inf Inf 1]);

    fname = [root_folder project_name '/om3_core3/history/tx_trans_19480101.ocean_month.nc'];
    transx = ncread(fname,'tx_trans',[1 1 1 time],[Inf Inf Inf 1]);

    % y-direction
    fname = [root_folder project_name '/om3_core3/history/salt_yflux_adv_int_z_19480101.ocean_month.nc'];
    salt_yflux_adv_int_z = ncread(fname,'salt_yflux_adv_int_z',[1 1 time],[Inf Inf 1]);

    fname = [root_folder project_name '/om3_core3/history/salt_yflux_gm_int_z_19480101.ocean_month.nc'];
    salt_yflux_gm_int_z = ncread(fname,'salt_yflux_gm_int_z',[1 1 time],[Inf Inf 1]);

    fname = [root_folder project_name '/om3_core3/history/salt_yflux_ndiffuse_int_z_19480101.ocean_month.nc'];
    salt_yflux_ndiffuse_int_z = ncread(fname,'salt_yflux_ndiffuse_int_z',[1 1 time],[Inf Inf 1]);

    fname = [root_folder project_name '/om3_core3/history/salt_yflux_sigma_19480101.ocean_month.nc'];
    salt_yflux_sigma = ncread(fname,'salt_yflux_sigma',[1 1 1 time],[Inf Inf Inf 1]);
    salt_yflux_sigma = squeeze(nansum(salt_yflux_sigma,3));

    fname = [root_folder project_name '/om3_core3/history/salt_yflux_submeso_int_z_19480101.ocean_month.nc'];
    salt_yflux_submeso_int_z = ncread(fname,'salt_yflux_submeso_int_z',[1 1 time],[Inf Inf 1]);

    fname = [root_folder project_name '/om3_core3/history/temp_yflux_adv_int_z_19480101.ocean_month.nc'];
    temp_yflux_adv_int_z = ncread(fname,'temp_yflux_adv_int_z',[1 1 time],[Inf Inf 1]);

    fname = [root_folder project_name '/om3_core3/history/temp_yflux_gm_int_z_19480101.ocean_month.nc'];
    temp_yflux_gm_int_z = ncread(fname,'temp_yflux_gm_int_z',[1 1 time],[Inf Inf 1]);

    fname = [root_folder project_name '/om3_core3/history/temp_yflux_ndiffuse_int_z_19480101.ocean_month.nc'];
    temp_yflux_ndiffuse_int_z = ncread(fname,'temp_yflux_ndiffuse_int_z',[1 1 time],[Inf Inf 1]);

    fname = [root_folder project_name '/om3_core3/history/temp_yflux_sigma_19480101.ocean_month.nc'];
    temp_yflux_sigma = ncread(fname,'temp_yflux_sigma',[1 1 1 time],[Inf Inf Inf 1]);
    temp_yflux_sigma = squeeze(nansum(temp_yflux_sigma,3));

    fname = [root_folder project_name '/om3_core3/history/temp_yflux_submeso_int_z_19480101.ocean_month.nc'];
    temp_yflux_submeso_int_z = ncread(fname,'temp_yflux_submeso_int_z',[1 1 time],[Inf Inf 1]);

    fname = [root_folder project_name '/om3_core3/history/ty_trans_19480101.ocean_month.nc'];
    transy = ncread(fname,'ty_trans',[1 1 1 time],[Inf Inf Inf 1]);

    % heat transport
    transx_heat  = rho_cp*(temp_xflux_adv_int_z+temp_xflux_gm_int_z+temp_xflux_ndiffuse_int_z+temp_xflux_sigma+temp_xflux_submeso_int_z);
    transy_heat  = rho_cp*(temp_yflux_adv_int_z+temp_yflux_gm_int_z+temp_yflux_ndiffuse_int_z+temp_yflux_sigma+temp_yflux_submeso_int_z);
    % salt transport
    transx_salt  = (salt_xflux_adv_int_z+salt_xflux_gm_int_z+salt_xflux_ndiffuse_int_z+salt_xflux_sigma+salt_xflux_submeso_int_z);
    transy_salt  = (salt_yflux_adv_int_z+salt_yflux_gm_int_z+salt_yflux_ndiffuse_int_z+salt_yflux_sigma+salt_yflux_submeso_int_z);
    % seawater transport
    transx = sv2mks*squeeze(nansum(transx,3));
    transy = sv2mks*squeeze(nansum(transy,3));
    % relative saln transport (kg/s)
    transx_relative_saln = saln0r*transx_salt;
    transy_relative_saln = saln0r*transy_salt;
    % relative freshwater transport (kg/s)
    relative_water_transx = transx - transx_relative_saln;
    relative_water_transy = transy - transy_relative_saln;

    % compute the Fram 
    dnmtr = squeeze(transy(266:286,191,:));
    dnmTtr = squeeze(transy_heat(266:286,191,:));
    dnmStr = squeeze(transy_salt(266:286,191,:));
    fram_volume_total(time) = nansum(dnmtr(:));
    fram_heat_total(time) = nansum(dnmTtr(:));
    fram_salt_total(time) = nansum(dnmStr(:));
    fram_volume_inflow(time) = nansum(dnmtr(dnmtr>0));
    fram_heat_inflow(time) = nansum(dnmTtr(dnmtr>0));
    fram_salt_inflow(time) = nansum(dnmStr(dnmtr>0));
    fram_volume_outflow(time) = nansum(dnmtr(dnmtr<0));
    fram_heat_outflow(time) = nansum(dnmTtr(dnmtr<0));
    fram_salt_outflow(time) = nansum(dnmStr(dnmtr<0));

    % compute the Barents
    dnmtr = squeeze(transx(295,177:190,:));
    dnmTtr = squeeze(transx_heat(295,177:190,:));
    dnmStr = squeeze(transx_salt(295,177:190,:));
    barents_volume_total(time) = nansum(dnmtr(:));
    barents_heat_total(time) = nansum(dnmTtr(:));
    barents_salt_total(time) = nansum(dnmStr(:));
    if(isempty(find(dnmtr>0)) == 1)
        barents_volume_inflow(time) = 0.0; 
        barents_heat_inflow(time) = 0.0; 
        barents_salt_inflow(time) = 0.0;
    else
        barents_volume_inflow(time) = nansum(dnmtr(dnmtr>0));
        barents_heat_inflow(time) = nansum(dnmTtr(dnmtr>0));
        barents_salt_inflow(time) = nansum(dnmStr(dnmtr>0));
    end
    if(isempty(find(dnmtr<0)) == 1)
        barents_volume_outflow(time) = 0.0; 
        barents_heat_outflow(time) = 0.0; 
        barents_salt_outflow(time) = 0.0;
    else
        barents_volume_outflow(time) = nansum(dnmtr(dnmtr<0));
        barents_heat_outflow(time) = nansum(dnmTtr(dnmtr<0));
        barents_salt_outflow(time) = nansum(dnmStr(dnmtr<0));
    end

    % compute the Bering
    dnmtr = squeeze(transy(110:113,176,:));
    dnmTtr = squeeze(transy_heat(110:113,176,:));
    dnmStr = squeeze(transy_salt(110:113,176,:));
    bering_volume_total(time) = nansum(dnmtr(:));
    bering_heat_total(time) = nansum(dnmTtr(:));
    bering_salt_total(time) = nansum(dnmStr(:));
    if(isempty(find(dnmtr>0)) == 1)
        bering_volume_inflow(time) = 0.0; 
        bering_heat_inflow(time) = 0.0; 
        bering_salt_inflow(time) = 0.0;
    else
        bering_volume_inflow(time) = nansum(dnmtr(dnmtr>0));
        bering_heat_inflow(time) = nansum(dnmTtr(dnmtr>0));
        bering_salt_inflow(time) = nansum(dnmStr(dnmtr>0));
    end
    if(isempty(find(dnmtr<0)) == 1)
        bering_volume_outflow(time) = 0.0; 
        bering_heat_outflow(time) = 0.0; 
        bering_salt_outflow(time) = 0.0;
    else
        bering_volume_outflow(time) = nansum(dnmtr(dnmtr<0));
        bering_heat_outflow(time) = nansum(dnmTtr(dnmtr<0));
        bering_salt_outflow(time) = nansum(dnmStr(dnmtr<0));
    end

    % compute the Davis
    dnmtr = squeeze(transy(217:229,176,:));
    dnmTtr = squeeze(transy_heat(217:229,176,:));
    dnmStr = squeeze(transy_salt(217:229,176,:));
    davis_volume_total(time) = nansum(dnmtr(:));
    davis_heat_total(time) = nansum(dnmTtr(:));
    davis_salt_total(time) = nansum(dnmStr(:));
    if(isempty(find(dnmtr>0)) == 1)
        davis_volume_inflow(time) = 0.0; 
        davis_heat_inflow(time) = 0.0; 
        davis_salt_inflow(time) = 0.0;
    else
        davis_volume_inflow(time) = nansum(dnmtr(dnmtr>0));
        davis_heat_inflow(time) = nansum(dnmTtr(dnmtr>0));
        davis_salt_inflow(time) = nansum(dnmStr(dnmtr>0));
    end
    if(isempty(find(dnmtr<0)) == 1)
        davis_volume_outflow(time) = 0.0; 
        davis_heat_outflow(time) = 0.0; 
        davis_salt_outflow(time) = 0.0;
    else
        davis_volume_outflow(time) = nansum(dnmtr(dnmtr<0));
        davis_heat_outflow(time) = nansum(dnmTtr(dnmtr<0));
        davis_salt_outflow(time) = nansum(dnmStr(dnmtr<0));
    end
    
    time
end

monthly_weights = [31 28 31 30 31 30 31 31 30 31 30 31]'./365;
monthly_weights = repmat(monthly_weights,[1 length(totaltime)/12]);
% fram
fram_volume_total = reshape(fram_volume_total,[12 length(totaltime)/12]).*monthly_weights;
fram_heat_total = reshape(fram_heat_total,[12 length(totaltime)/12]).*monthly_weights;
fram_salt_total = reshape(fram_salt_total,[12 length(totaltime)/12]).*monthly_weights;
fram_volume_inflow = reshape(fram_volume_inflow,[12 length(totaltime)/12]).*monthly_weights;
fram_heat_inflow = reshape(fram_heat_inflow,[12 length(totaltime)/12]).*monthly_weights;
fram_salt_inflow = reshape(fram_salt_inflow,[12 length(totaltime)/12]).*monthly_weights;
fram_volume_outflow = reshape(fram_volume_outflow,[12 length(totaltime)/12]).*monthly_weights;
fram_heat_outflow = reshape(fram_heat_outflow,[12 length(totaltime)/12]).*monthly_weights;
fram_salt_outflow = reshape(fram_salt_outflow,[12 length(totaltime)/12]).*monthly_weights;
% barents
barents_volume_total = reshape(barents_volume_total,[12 length(totaltime)/12]).*monthly_weights;
barents_heat_total = reshape(barents_heat_total,[12 length(totaltime)/12]).*monthly_weights;
barents_salt_total = reshape(barents_salt_total,[12 length(totaltime)/12]).*monthly_weights;
barents_volume_inflow = reshape(barents_volume_inflow,[12 length(totaltime)/12]).*monthly_weights;
barents_heat_inflow = reshape(barents_heat_inflow,[12 length(totaltime)/12]).*monthly_weights;
barents_salt_inflow = reshape(barents_salt_inflow,[12 length(totaltime)/12]).*monthly_weights;
barents_volume_outflow = reshape(barents_volume_outflow,[12 length(totaltime)/12]).*monthly_weights;
barents_heat_outflow = reshape(barents_heat_outflow,[12 length(totaltime)/12]).*monthly_weights;
barents_salt_outflow = reshape(barents_salt_outflow,[12 length(totaltime)/12]).*monthly_weights;
% bering
bering_volume_total = reshape(bering_volume_total,[12 length(totaltime)/12]).*monthly_weights;
bering_heat_total = reshape(bering_heat_total,[12 length(totaltime)/12]).*monthly_weights;
bering_salt_total = reshape(bering_salt_total,[12 length(totaltime)/12]).*monthly_weights;
bering_volume_inflow = reshape(bering_volume_inflow,[12 length(totaltime)/12]).*monthly_weights;
bering_heat_inflow = reshape(bering_heat_inflow,[12 length(totaltime)/12]).*monthly_weights;
bering_salt_inflow = reshape(bering_salt_inflow,[12 length(totaltime)/12]).*monthly_weights;
bering_volume_outflow = reshape(bering_volume_outflow,[12 length(totaltime)/12]).*monthly_weights;
bering_heat_outflow = reshape(bering_heat_outflow,[12 length(totaltime)/12]).*monthly_weights;
bering_salt_outflow = reshape(bering_salt_outflow,[12 length(totaltime)/12]).*monthly_weights;
% davis
davis_volume_total = reshape(davis_volume_total,[12 length(totaltime)/12]).*monthly_weights;
davis_heat_total = reshape(davis_heat_total,[12 length(totaltime)/12]).*monthly_weights;
davis_salt_total = reshape(davis_salt_total,[12 length(totaltime)/12]).*monthly_weights;
davis_volume_inflow = reshape(davis_volume_inflow,[12 length(totaltime)/12]).*monthly_weights;
davis_heat_inflow = reshape(davis_heat_inflow,[12 length(totaltime)/12]).*monthly_weights;
davis_salt_inflow = reshape(davis_salt_inflow,[12 length(totaltime)/12]).*monthly_weights;
davis_volume_outflow = reshape(davis_volume_outflow,[12 length(totaltime)/12]).*monthly_weights;
davis_heat_outflow = reshape(davis_heat_outflow,[12 length(totaltime)/12]).*monthly_weights;

fram_volume_total = nansum(fram_volume_total,1);
fram_heat_total = nansum(fram_heat_total,1);
fram_salt_total = nansum(fram_salt_total,1);
fram_volume_inflow = nansum(fram_volume_inflow,1);
fram_heat_inflow = nansum(fram_heat_inflow,1);
fram_salt_inflow = nansum(fram_salt_inflow,1);
fram_volume_outflow = nansum(fram_volume_outflow,1);
fram_heat_outflow = nansum(fram_heat_outflow,1);
fram_salt_outflow = nansum(fram_salt_outflow,1);

barents_volume_total = nansum(barents_volume_total,1);
barents_heat_total = nansum(barents_heat_total,1);
barents_salt_total = nansum(barents_salt_total,1);
barents_volume_inflow = nansum(barents_volume_inflow,1);
barents_heat_inflow = nansum(barents_heat_inflow,1);
barents_salt_inflow = nansum(barents_salt_inflow,1);
barents_volume_outflow = nansum(barents_volume_outflow,1);
barents_heat_outflow = nansum(barents_heat_outflow,1);
barents_salt_outflow = nansum(barents_salt_outflow,1);

bering_volume_total = nansum(bering_volume_total,1);
bering_heat_total = nansum(bering_heat_total,1);
bering_salt_total = nansum(bering_salt_total,1);
bering_volume_inflow = nansum(bering_volume_inflow,1);
bering_heat_inflow = nansum(bering_heat_inflow,1);
bering_salt_inflow = nansum(bering_salt_inflow,1);
bering_volume_outflow = nansum(bering_volume_outflow,1);
bering_heat_outflow = nansum(bering_heat_outflow,1);
bering_salt_outflow = nansum(bering_salt_outflow,1);

davis_volume_total = nansum(davis_volume_total,1);
davis_heat_total = nansum(davis_heat_total,1);
davis_salt_total = nansum(davis_salt_total,1);
davis_volume_inflow = nansum(davis_volume_inflow,1);
davis_heat_inflow = nansum(davis_heat_inflow,1);
davis_salt_inflow = nansum(davis_salt_inflow,1);
davis_volume_outflow = nansum(davis_volume_outflow,1);
davis_heat_outflow = nansum(davis_heat_outflow,1);
davis_salt_outflow = nansum(davis_salt_outflow,1);

savename = ['matfiles/' project_name '_fram_transports.mat']
save(savename,'fram_heat_inflow','fram_heat_outflow','fram_heat_total', ...
    'fram_volume_inflow','fram_volume_outflow','fram_volume_total', ...
    'fram_salt_inflow','fram_salt_outflow','fram_salt_total')

savename = ['matfiles/' project_name '_barents_transports.mat']
save(savename,'barents_heat_inflow','barents_heat_outflow','barents_heat_total', ...
    'barents_volume_inflow','barents_volume_outflow','barents_volume_total', ...
    'barents_salt_inflow','barents_salt_outflow','barents_salt_total')
    
savename = ['matfiles/' project_name '_bering_transports.mat']
save(savename,'bering_heat_inflow','bering_heat_outflow','bering_heat_total', ...
    'bering_volume_inflow','bering_volume_outflow','bering_volume_total', ...
    'bering_salt_inflow','bering_salt_outflow','bering_salt_total')

savename = ['matfiles/' project_name '_davis_transports.mat']
save(savename,'davis_heat_inflow','davis_heat_outflow','davis_heat_total', ...
    'davis_volume_inflow','davis_volume_outflow','davis_volume_total', ...
    'davis_salt_inflow','davis_salt_outflow','davis_salt_total')
