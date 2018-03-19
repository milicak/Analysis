clear all

k=1;
rho_cp = 1; 
W2TW = 1e-12;
rho0 = 1035;
sv2mks = 1e9; %already in Sv %1e9; 
saln0r = 1/0.0348; % relative salinity 34.8

project_name = 'om3_core3_2'
%project_name = 'om3_core3_2_BG_neg'
%project_name = 'om3_core3_2_BG_pos'
%project_name = 'om3_core3_2_GS_neg'
%project_name = 'om3_core3_2_GS_pos'
%project_name = 'om3_core3_ctrl'
%root_folder = '/hexagon/work/milicak/RUNS/mom/' ;
root_folder = '/export/grunchfs/unibjerknes/milicak/bckup/mom/FAMOS/';

varnames = {'ctl' 'gsp' 'gsn'};
varname = ['ctl'];

%variable = [{'temp_xflux_adv_int_z'}];
fname = [root_folder project_name '/om3_core3/history/salt_19480101.ocean_month.nc'];
totaltime = ncread(fname,'time');
tstart = length(totaltime)-347; % starting from 1980 Jan

time = 1;
for timeind = tstart:length(totaltime)
    % x-direction
    fname = [root_folder project_name '/om3_core3/history/salt_xflux_adv_int_z_19480101.ocean_month.nc'];
    salt_xflux_adv_int_z = ncread(fname,'salt_xflux_adv_int_z',[1 1 timeind],[Inf Inf 1]);

    fname = [root_folder project_name '/om3_core3/history/salt_xflux_gm_int_z_19480101.ocean_month.nc'];
    salt_xflux_gm_int_z = ncread(fname,'salt_xflux_gm_int_z',[1 1 timeind],[Inf Inf 1]);

    fname = [root_folder project_name '/om3_core3/history/salt_xflux_ndiffuse_int_z_19480101.ocean_month.nc'];
    salt_xflux_ndiffuse_int_z = ncread(fname,'salt_xflux_ndiffuse_int_z',[1 1 timeind],[Inf Inf 1]);

    fname = [root_folder project_name '/om3_core3/history/salt_xflux_sigma_19480101.ocean_month.nc'];
    salt_xflux_sigma = ncread(fname,'salt_xflux_sigma',[1 1 1 timeind],[Inf Inf Inf 1]);
    salt_xflux_sigma = squeeze(nansum(salt_xflux_sigma,3));

    fname = [root_folder project_name '/om3_core3/history/salt_xflux_submeso_int_z_19480101.ocean_month.nc'];
    salt_xflux_submeso_int_z = ncread(fname,'salt_xflux_submeso_int_z',[1 1 timeind],[Inf Inf 1]);

    fname = [root_folder project_name '/om3_core3/history/temp_xflux_adv_int_z_19480101.ocean_month.nc'];
    temp_xflux_adv_int_z = ncread(fname,'temp_xflux_adv_int_z',[1 1 timeind],[Inf Inf 1]);

    fname = [root_folder project_name '/om3_core3/history/temp_xflux_gm_int_z_19480101.ocean_month.nc'];
    temp_xflux_gm_int_z = ncread(fname,'temp_xflux_gm_int_z',[1 1 timeind],[Inf Inf 1]);

    fname = [root_folder project_name '/om3_core3/history/temp_xflux_ndiffuse_int_z_19480101.ocean_month.nc'];
    temp_xflux_ndiffuse_int_z = ncread(fname,'temp_xflux_ndiffuse_int_z',[1 1 timeind],[Inf Inf 1]);

    fname = [root_folder project_name '/om3_core3/history/temp_xflux_sigma_19480101.ocean_month.nc'];
    temp_xflux_sigma = ncread(fname,'temp_xflux_sigma',[1 1 1 timeind],[Inf Inf Inf 1]);
    temp_xflux_sigma = squeeze(nansum(temp_xflux_sigma,3));

    fname = [root_folder project_name '/om3_core3/history/temp_xflux_submeso_int_z_19480101.ocean_month.nc'];
    temp_xflux_submeso_int_z = ncread(fname,'temp_xflux_submeso_int_z',[1 1 timeind],[Inf Inf 1]);

    fname = [root_folder project_name '/om3_core3/history/tx_trans_19480101.ocean_month.nc'];
    transx = ncread(fname,'tx_trans',[1 1 1 timeind],[Inf Inf Inf 1]);

    % y-direction
    fname = [root_folder project_name '/om3_core3/history/salt_yflux_adv_int_z_19480101.ocean_month.nc'];
    salt_yflux_adv_int_z = ncread(fname,'salt_yflux_adv_int_z',[1 1 timeind],[Inf Inf 1]);

    fname = [root_folder project_name '/om3_core3/history/salt_yflux_gm_int_z_19480101.ocean_month.nc'];
    salt_yflux_gm_int_z = ncread(fname,'salt_yflux_gm_int_z',[1 1 timeind],[Inf Inf 1]);

    fname = [root_folder project_name '/om3_core3/history/salt_yflux_ndiffuse_int_z_19480101.ocean_month.nc'];
    salt_yflux_ndiffuse_int_z = ncread(fname,'salt_yflux_ndiffuse_int_z',[1 1 timeind],[Inf Inf 1]);

    fname = [root_folder project_name '/om3_core3/history/salt_yflux_sigma_19480101.ocean_month.nc'];
    salt_yflux_sigma = ncread(fname,'salt_yflux_sigma',[1 1 1 timeind],[Inf Inf Inf 1]);
    salt_yflux_sigma = squeeze(nansum(salt_yflux_sigma,3));

    fname = [root_folder project_name '/om3_core3/history/salt_yflux_submeso_int_z_19480101.ocean_month.nc'];
    salt_yflux_submeso_int_z = ncread(fname,'salt_yflux_submeso_int_z',[1 1 timeind],[Inf Inf 1]);

    fname = [root_folder project_name '/om3_core3/history/temp_yflux_adv_int_z_19480101.ocean_month.nc'];
    temp_yflux_adv_int_z = ncread(fname,'temp_yflux_adv_int_z',[1 1 timeind],[Inf Inf 1]);

    fname = [root_folder project_name '/om3_core3/history/temp_yflux_gm_int_z_19480101.ocean_month.nc'];
    temp_yflux_gm_int_z = ncread(fname,'temp_yflux_gm_int_z',[1 1 timeind],[Inf Inf 1]);

    fname = [root_folder project_name '/om3_core3/history/temp_yflux_ndiffuse_int_z_19480101.ocean_month.nc'];
    temp_yflux_ndiffuse_int_z = ncread(fname,'temp_yflux_ndiffuse_int_z',[1 1 timeind],[Inf Inf 1]);

    fname = [root_folder project_name '/om3_core3/history/temp_yflux_sigma_19480101.ocean_month.nc'];
    temp_yflux_sigma = ncread(fname,'temp_yflux_sigma',[1 1 1 timeind],[Inf Inf Inf 1]);
    temp_yflux_sigma = squeeze(nansum(temp_yflux_sigma,3));

    fname = [root_folder project_name '/om3_core3/history/temp_yflux_submeso_int_z_19480101.ocean_month.nc'];
    temp_yflux_submeso_int_z = ncread(fname,'temp_yflux_submeso_int_z',[1 1 timeind],[Inf Inf 1]);

    fname = [root_folder project_name '/om3_core3/history/ty_trans_19480101.ocean_month.nc'];
    transy = ncread(fname,'ty_trans',[1 1 1 timeind],[Inf Inf Inf 1]);

    % heat transport [convert to TW]
    transx_heat  = W2TW*(temp_xflux_adv_int_z+temp_xflux_gm_int_z+temp_xflux_ndiffuse_int_z+temp_xflux_sigma+temp_xflux_submeso_int_z);
    transy_heat  = W2TW*(temp_yflux_adv_int_z+temp_yflux_gm_int_z+temp_yflux_ndiffuse_int_z+temp_yflux_sigma+temp_yflux_submeso_int_z);
    % salt transport
    transx_salt  = (salt_xflux_adv_int_z+salt_xflux_gm_int_z+salt_xflux_ndiffuse_int_z+salt_xflux_sigma+salt_xflux_submeso_int_z);
    transy_salt  = (salt_yflux_adv_int_z+salt_yflux_gm_int_z+salt_yflux_ndiffuse_int_z+salt_yflux_sigma+salt_yflux_submeso_int_z);
    % seawater transport
    transx = squeeze(nansum(transx,3));
    transy = squeeze(nansum(transy,3));

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
    
    time = time+1
end

barents_heat_inflow = barents_heat_inflow';
barents_heat_outflow = barents_heat_outflow';
barents_heat_total = barents_heat_total';
barents_salt_inflow = barents_salt_inflow';
barents_salt_outflow = barents_salt_outflow';
barents_salt_total = barents_salt_total';
barents_volume_inflow = barents_volume_inflow';
barents_volume_outflow = barents_volume_outflow';
barents_volume_total = barents_volume_total';

bering_heat_inflow = bering_heat_inflow';
bering_heat_outflow = bering_heat_outflow';
bering_heat_total = bering_heat_total';
bering_salt_inflow = bering_salt_inflow';
bering_salt_outflow = bering_salt_outflow';
bering_salt_total = bering_salt_total';
bering_volume_inflow = bering_volume_inflow';
bering_volume_outflow = bering_volume_outflow';
bering_volume_total = bering_volume_total';

fram_heat_inflow = fram_heat_inflow';
fram_heat_outflow = fram_heat_outflow';
fram_heat_total = fram_heat_total';
fram_salt_inflow = fram_salt_inflow';
fram_salt_outflow = fram_salt_outflow';
fram_salt_total = fram_salt_total';
fram_volume_inflow = fram_volume_inflow';
fram_volume_outflow = fram_volume_outflow';
fram_volume_total = fram_volume_total';

davis_heat_inflow = davis_heat_inflow';
davis_heat_outflow = davis_heat_outflow';
davis_heat_total = davis_heat_total';
davis_salt_inflow = davis_salt_inflow';
davis_salt_outflow = davis_salt_outflow';
davis_salt_total = davis_salt_total';
davis_volume_inflow = davis_volume_inflow';
davis_volume_outflow = davis_volume_outflow';
davis_volume_total = davis_volume_total';

% time variable
time = ncread(fname,'time');
time = time(end-347:end);
T = noleapdatevec(time);
mdays = [31    28    31    30    31    30    31    31    30    31    30    31];
days(1) = 0.5*mdays(1);
for kk=2:12
dnm=cumsum(mdays(1:kk-1));     
days(kk)=0.5*mdays(kk)+dnm(end);
end
days = days./365;
days = days';
days = repmat(days,[29 1]);

year = T(:,1) + days;

%create netcdf file

outname = ['data/ITU-MOM/' project_name '_transports.nc']
% Davis
nccreate(outname,[varname 'davis_volumetotal'],'Dimensions',{'time',length(time)},'Datatype','double')
ncwriteatt(outname,[varname 'davis_volumetotal'],'long name','Total volume transport at Davis Strait')
ncwriteatt(outname,[varname 'davis_volumetotal'],'unit','Sv')

nccreate(outname,[varname 'davis_volumeinflow'],'Dimensions',{'time',length(time)},'Datatype','double')
ncwriteatt(outname,[varname 'davis_volumeinflow'],'long name','Inflow volume transport at Davis Strait')
ncwriteatt(outname,[varname 'davis_volumeinflow'],'unit','Sv')

nccreate(outname,[varname 'davis_volumeoutflow'],'Dimensions',{'time',length(time)},'Datatype','double')
ncwriteatt(outname,[varname 'davis_volumeoutflow'],'long name','Outflow volume transport at Davis Strait')
ncwriteatt(outname,[varname 'davis_volumeoutflow'],'unit','Sv')

nccreate(outname,[varname 'davis_heattotal'],'Dimensions',{'time',length(time)},'Datatype','double')
ncwriteatt(outname,[varname 'davis_heattotal'],'long name','Total heat transport at Davis Strait')
ncwriteatt(outname,[varname 'davis_heattotal'],'unit','TW')

nccreate(outname,[varname 'davis_heatinflow'],'Dimensions',{'time',length(time)},'Datatype','double')
ncwriteatt(outname,[varname 'davis_heatinflow'],'long name','Inflow heat transport at Davis Strait')
ncwriteatt(outname,[varname 'davis_heatinflow'],'unit','TW')

nccreate(outname,[varname 'davis_heatoutflow'],'Dimensions',{'time',length(time)},'Datatype','double')
ncwriteatt(outname,[varname 'davis_heatoutflow'],'long name','Outflow heat transport at Davis Strait')
ncwriteatt(outname,[varname 'davis_heatoutflow'],'unit','Sv')

nccreate(outname,[varname 'davis_salttotal'],'Dimensions',{'time',length(time)},'Datatype','double')
ncwriteatt(outname,[varname 'davis_salttotal'],'long name','Total salt transport at Davis Strait')
ncwriteatt(outname,[varname 'davis_salttotal'],'unit','kg/s')

nccreate(outname,[varname 'davis_saltinflow'],'Dimensions',{'time',length(time)},'Datatype','double')
ncwriteatt(outname,[varname 'davis_saltinflow'],'long name','Inflow salt transport at Davis Strait')
ncwriteatt(outname,[varname 'davis_saltinflow'],'unit','kg/s')

nccreate(outname,[varname 'davis_saltoutflow'],'Dimensions',{'time',length(time)},'Datatype','double')
ncwriteatt(outname,[varname 'davis_saltoutflow'],'long name','Outflow salt transport at Davis Strait')
ncwriteatt(outname,[varname 'davis_saltoutflow'],'unit','kg/s')

% fram
nccreate(outname,[varname 'fram_volumetotal'],'Dimensions',{'time',length(time)},'Datatype','double')
ncwriteatt(outname,[varname 'fram_volumetotal'],'long name','Total volume transport at Fram Strait')
ncwriteatt(outname,[varname 'fram_volumetotal'],'unit','Sv')

nccreate(outname,[varname 'fram_volumeinflow'],'Dimensions',{'time',length(time)},'Datatype','double')
ncwriteatt(outname,[varname 'fram_volumeinflow'],'long name','Inflow volume transport at Fram Strait')
ncwriteatt(outname,[varname 'fram_volumeinflow'],'unit','Sv')

nccreate(outname,[varname 'fram_volumeoutflow'],'Dimensions',{'time',length(time)},'Datatype','double')
ncwriteatt(outname,[varname 'fram_volumeoutflow'],'long name','Outflow volume transport at Fram Strait')
ncwriteatt(outname,[varname 'fram_volumeoutflow'],'unit','Sv')

nccreate(outname,[varname 'fram_heattotal'],'Dimensions',{'time',length(time)},'Datatype','double')
ncwriteatt(outname,[varname 'fram_heattotal'],'long name','Total heat transport at Fram Strait')
ncwriteatt(outname,[varname 'fram_heattotal'],'unit','TW')

nccreate(outname,[varname 'fram_heatinflow'],'Dimensions',{'time',length(time)},'Datatype','double')
ncwriteatt(outname,[varname 'fram_heatinflow'],'long name','Inflow heat transport at Fram Strait')
ncwriteatt(outname,[varname 'fram_heatinflow'],'unit','TW')

nccreate(outname,[varname 'fram_heatoutflow'],'Dimensions',{'time',length(time)},'Datatype','double')
ncwriteatt(outname,[varname 'fram_heatoutflow'],'long name','Outflow heat transport at Fram Strait')
ncwriteatt(outname,[varname 'fram_heatoutflow'],'unit','Sv')

nccreate(outname,[varname 'fram_salttotal'],'Dimensions',{'time',length(time)},'Datatype','double')
ncwriteatt(outname,[varname 'fram_salttotal'],'long name','Total salt transport at Fram Strait')
ncwriteatt(outname,[varname 'fram_salttotal'],'unit','kg/s')

nccreate(outname,[varname 'fram_saltinflow'],'Dimensions',{'time',length(time)},'Datatype','double')
ncwriteatt(outname,[varname 'fram_saltinflow'],'long name','Inflow salt transport at Fram Strait')
ncwriteatt(outname,[varname 'fram_saltinflow'],'unit','kg/s')

nccreate(outname,[varname 'fram_saltoutflow'],'Dimensions',{'time',length(time)},'Datatype','double')
ncwriteatt(outname,[varname 'fram_saltoutflow'],'long name','Outflow salt transport at Fram Strait')
ncwriteatt(outname,[varname 'fram_saltoutflow'],'unit','kg/s')

% bering
nccreate(outname,[varname 'bering_volumetotal'],'Dimensions',{'time',length(time)},'Datatype','double')
ncwriteatt(outname,[varname 'bering_volumetotal'],'long name','Total volume transport at Bering Strait')
ncwriteatt(outname,[varname 'bering_volumetotal'],'unit','Sv')

nccreate(outname,[varname 'bering_volumeinflow'],'Dimensions',{'time',length(time)},'Datatype','double')
ncwriteatt(outname,[varname 'bering_volumeinflow'],'long name','Inflow volume transport at Bering Strait')
ncwriteatt(outname,[varname 'bering_volumeinflow'],'unit','Sv')

nccreate(outname,[varname 'bering_volumeoutflow'],'Dimensions',{'time',length(time)},'Datatype','double')
ncwriteatt(outname,[varname 'bering_volumeoutflow'],'long name','Outflow volume transport at Bering Strait')
ncwriteatt(outname,[varname 'bering_volumeoutflow'],'unit','Sv')

nccreate(outname,[varname 'bering_heattotal'],'Dimensions',{'time',length(time)},'Datatype','double')
ncwriteatt(outname,[varname 'bering_heattotal'],'long name','Total heat transport at Bering Strait')
ncwriteatt(outname,[varname 'bering_heattotal'],'unit','TW')

nccreate(outname,[varname 'bering_heatinflow'],'Dimensions',{'time',length(time)},'Datatype','double')
ncwriteatt(outname,[varname 'bering_heatinflow'],'long name','Inflow heat transport at Bering Strait')
ncwriteatt(outname,[varname 'bering_heatinflow'],'unit','TW')

nccreate(outname,[varname 'bering_heatoutflow'],'Dimensions',{'time',length(time)},'Datatype','double')
ncwriteatt(outname,[varname 'bering_heatoutflow'],'long name','Outflow heat transport at Bering Strait')
ncwriteatt(outname,[varname 'bering_heatoutflow'],'unit','Sv')

nccreate(outname,[varname 'bering_salttotal'],'Dimensions',{'time',length(time)},'Datatype','double')
ncwriteatt(outname,[varname 'bering_salttotal'],'long name','Total salt transport at Bering Strait')
ncwriteatt(outname,[varname 'bering_salttotal'],'unit','kg/s')

nccreate(outname,[varname 'bering_saltinflow'],'Dimensions',{'time',length(time)},'Datatype','double')
ncwriteatt(outname,[varname 'bering_saltinflow'],'long name','Inflow salt transport at Bering Strait')
ncwriteatt(outname,[varname 'bering_saltinflow'],'unit','kg/s')

nccreate(outname,[varname 'bering_saltoutflow'],'Dimensions',{'time',length(time)},'Datatype','double')
ncwriteatt(outname,[varname 'bering_saltoutflow'],'long name','Outflow salt transport at Bering Strait')
ncwriteatt(outname,[varname 'bering_saltoutflow'],'unit','kg/s')

% barents
nccreate(outname,[varname 'barents_volumetotal'],'Dimensions',{'time',length(time)},'Datatype','double')
ncwriteatt(outname,[varname 'barents_volumetotal'],'long name','Total volume transport at Barents Sea Openning')
ncwriteatt(outname,[varname 'barents_volumetotal'],'unit','Sv')

nccreate(outname,[varname 'barents_volumeinflow'],'Dimensions',{'time',length(time)},'Datatype','double')
ncwriteatt(outname,[varname 'barents_volumeinflow'],'long name','Inflow volume transport at Barents Sea Openning')
ncwriteatt(outname,[varname 'barents_volumeinflow'],'unit','Sv')

nccreate(outname,[varname 'barents_volumeoutflow'],'Dimensions',{'time',length(time)},'Datatype','double')
ncwriteatt(outname,[varname 'barents_volumeoutflow'],'long name','Outflow volume transport at Barents Sea Openning')
ncwriteatt(outname,[varname 'barents_volumeoutflow'],'unit','Sv')

nccreate(outname,[varname 'barents_heattotal'],'Dimensions',{'time',length(time)},'Datatype','double')
ncwriteatt(outname,[varname 'barents_heattotal'],'long name','Total heat transport at Barents Sea Openning')
ncwriteatt(outname,[varname 'barents_heattotal'],'unit','TW')

nccreate(outname,[varname 'barents_heatinflow'],'Dimensions',{'time',length(time)},'Datatype','double')
ncwriteatt(outname,[varname 'barents_heatinflow'],'long name','Inflow heat transport at Barents Sea Openning')
ncwriteatt(outname,[varname 'barents_heatinflow'],'unit','TW')

nccreate(outname,[varname 'barents_heatoutflow'],'Dimensions',{'time',length(time)},'Datatype','double')
ncwriteatt(outname,[varname 'barents_heatoutflow'],'long name','Outflow heat transport at Barents Sea Openning')
ncwriteatt(outname,[varname 'barents_heatoutflow'],'unit','Sv')

nccreate(outname,[varname 'barents_salttotal'],'Dimensions',{'time',length(time)},'Datatype','double')
ncwriteatt(outname,[varname 'barents_salttotal'],'long name','Total salt transport at Barents Sea Openning')
ncwriteatt(outname,[varname 'barents_salttotal'],'unit','kg/s')

nccreate(outname,[varname 'barents_saltinflow'],'Dimensions',{'time',length(time)},'Datatype','double')
ncwriteatt(outname,[varname 'barents_saltinflow'],'long name','Inflow salt transport at Barents Sea Openning')
ncwriteatt(outname,[varname 'barents_saltinflow'],'unit','kg/s')

nccreate(outname,[varname 'barents_saltoutflow'],'Dimensions',{'time',length(time)},'Datatype','double')
ncwriteatt(outname,[varname 'barents_saltoutflow'],'long name','Outflow salt transport at Barents Sea Openning')
ncwriteatt(outname,[varname 'barents_saltoutflow'],'unit','kg/s')

nccreate(outname,'time','Dimensions',{'time',length(time)},'Datatype','double')
ncwriteatt(outname,'time','unit','years')

ncwrite(outname,[varname 'barents_volumetotal'],barents_volume_total);
ncwrite(outname,[varname 'barents_volumeinflow'],barents_volume_inflow);
ncwrite(outname,[varname 'barents_volumeoutflow'],barents_volume_outflow);
ncwrite(outname,[varname 'barents_heattotal'],barents_heat_total);
ncwrite(outname,[varname 'barents_heatinflow'],barents_heat_inflow);
ncwrite(outname,[varname 'barents_heatoutflow'],barents_heat_outflow);
ncwrite(outname,[varname 'barents_salttotal'],barents_salt_total);
ncwrite(outname,[varname 'barents_saltinflow'],barents_salt_inflow);
ncwrite(outname,[varname 'barents_saltoutflow'],barents_salt_outflow);

ncwrite(outname,[varname 'fram_volumetotal'],fram_volume_total);
ncwrite(outname,[varname 'fram_volumeinflow'],fram_volume_inflow);
ncwrite(outname,[varname 'fram_volumeoutflow'],fram_volume_outflow);
ncwrite(outname,[varname 'fram_heattotal'],fram_heat_total);
ncwrite(outname,[varname 'fram_heatinflow'],fram_heat_inflow);
ncwrite(outname,[varname 'fram_heatoutflow'],fram_heat_outflow);
ncwrite(outname,[varname 'fram_salttotal'],fram_salt_total);
ncwrite(outname,[varname 'fram_saltinflow'],fram_salt_inflow);
ncwrite(outname,[varname 'fram_saltoutflow'],fram_salt_outflow);

ncwrite(outname,[varname 'davis_volumetotal'],davis_volume_total);
ncwrite(outname,[varname 'davis_volumeinflow'],davis_volume_inflow);
ncwrite(outname,[varname 'davis_volumeoutflow'],davis_volume_outflow);
ncwrite(outname,[varname 'davis_heattotal'],davis_heat_total);
ncwrite(outname,[varname 'davis_heatinflow'],davis_heat_inflow);
ncwrite(outname,[varname 'davis_heatoutflow'],davis_heat_outflow);
ncwrite(outname,[varname 'davis_salttotal'],davis_salt_total);
ncwrite(outname,[varname 'davis_saltinflow'],davis_salt_inflow);
ncwrite(outname,[varname 'davis_saltoutflow'],davis_salt_outflow);

ncwrite(outname,[varname 'bering_volumetotal'],bering_volume_total);
ncwrite(outname,[varname 'bering_volumeinflow'],bering_volume_inflow);
ncwrite(outname,[varname 'bering_volumeoutflow'],bering_volume_outflow);
ncwrite(outname,[varname 'bering_heattotal'],bering_heat_total);
ncwrite(outname,[varname 'bering_heatinflow'],bering_heat_inflow);
ncwrite(outname,[varname 'bering_heatoutflow'],bering_heat_outflow);
ncwrite(outname,[varname 'bering_salttotal'],bering_salt_total);
ncwrite(outname,[varname 'bering_saltinflow'],bering_salt_inflow);
ncwrite(outname,[varname 'bering_saltoutflow'],bering_salt_outflow);

ncwrite(outname,'time',year);
