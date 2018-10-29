clear all

Nx = 360;
Ny = 200;
den_ice = 905; % density of ice kg/m3

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

fname = [root_folder project_name '/om3_core3/history/salt_19480101.ocean_month.nc'];
totaltime = ncread(fname,'time');
tstart = length(totaltime)-347; % starting from 1980 Jan

time = 1;
for timeind = tstart:length(totaltime)
%timeind = tstart
    % swflux
    fname = [root_folder project_name '/om3_core3/history/19480101.ice_month.nc'];
    icetrans = ncread(fname,'IY_TRANS',[1 1 timeind],[Inf Inf 1]);
    fice = ncread(fname,'CN',[1 1 1 timeind],[Inf Inf Inf 1]);
    fice=squeeze(nansum(fice,3));  
    hice = ncread(fname,'HI',[1 1 timeind],[Inf Inf 1]);

    tmp = (fice.*icetrans)./(den_ice.*hice);
    dnm = squeeze(tmp(266:286,191));
    icetransport(time,:,:) = nansum(dnm(:));
    
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

outname = ['data/ITU-MOM/' project_name '_ice_areatransport_Fram.nc']
nccreate(outname,[varname 'ice_areaexport'],'Dimensions',{'time',length(time)},'Datatype','double')
ncwriteatt(outname,[varname 'ice_areaexport'],'long name','Ice transport at Fram Strait')
ncwriteatt(outname,[varname 'ice_areaexport'],'unit','m2/s')
nccreate(outname,'time','Dimensions',{'time',length(time)},'Datatype','double')
ncwriteatt(outname,'time','unit','years')

ncwrite(outname,[varname 'ice_areaexport'],icetransport);

ncwrite(outname,'time',year);
