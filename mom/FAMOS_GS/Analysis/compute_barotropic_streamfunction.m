clear all

Nx = 360;
Ny = 200;

%project_name = 'om3_core3_2'
%project_name = 'om3_core3_2_BG_neg'
%project_name = 'om3_core3_2_BG_pos'
%project_name = 'om3_core3_2_GS_neg'
project_name = 'om3_core3_2_GS_pos'
%project_name = 'om3_core3_ctrl'
%root_folder = '/hexagon/work/milicak/RUNS/mom/' ;
%root_folder = '/export/grunchfs/unibjerknes/milicak/bckup/mom/FAMOS/';
root_folder = '/shared/projects/uniklima/globclim/milicak/mom/FAMOS/';

varnames = {'ctl' 'gsp' 'gsn'};
varname = ['gsp'];

nreg = 2;
i0 = 180;
j0 = 150;

%variable = [{'temp_xflux_adv_int_z'}];
fname = [root_folder project_name '/om3_core3/history/salt_19480101.ocean_month.nc'];
totaltime = ncread(fname,'time');
tstart = length(totaltime)-347; % starting from 1980 Jan

time = 1;
for timeind = tstart:length(totaltime)
%timeind = tstart
    % x-direction
    fname = [root_folder project_name '/om3_core3/history/tx_trans_19480101.ocean_month.nc'];
    transx = ncread(fname,'tx_trans',[1 1 1 timeind],[Inf Inf Inf 1]);

    % y-direction
    fname = [root_folder project_name '/om3_core3/history/ty_trans_19480101.ocean_month.nc'];
    transy = ncread(fname,'ty_trans',[1 1 1 timeind],[Inf Inf Inf 1]);

    % seawater transport
    transx = squeeze(nansum(transx,3));
    transy = squeeze(nansum(transy,3));
    strmf(time,:,:) = micom_strmf(transx,transy,i0,j0,nreg);
    
    time = time+1
end

% time variable
time = ncread(fname,'time');
time = time(end-347:end);
T = noleapdatevec(time);
mdays = [31    28    31    30    31    30    31    31    30    31    30    31];
days(1) = 0.5*mdays(1);
for kk=2:12
    dnm = cumsum(mdays(1:kk-1));     
    days(kk) = 0.5*mdays(kk)+dnm(end);
end
days = days./365;
days = days';
days = repmat(days,[29 1]);

year = T(:,1) + days;

%create netcdf file

outname = ['data/ITU-MOM/' project_name '_barotropic_streamfunction.nc']
nccreate(outname,[varname 'BT_streamfunction'],'Dimensions',{'time',length(time),'x',Nx,'y',Ny},'Datatype','double')
ncwriteatt(outname,[varname 'BT_streamfunction'],'long name','Barotropic Stream-function')
ncwriteatt(outname,[varname 'BT_streamfunction'],'unit','Sv')
nccreate(outname,'time','Dimensions',{'time',length(time)},'Datatype','double')
ncwriteatt(outname,'time','unit','years')

ncwrite(outname,[varname 'BT_streamfunction'],strmf);

ncwrite(outname,'time',year);
