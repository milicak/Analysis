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
%root_folder = '/export/grunchfs/unibjerknes/milicak/bckup/mom/FAMOS/';
root_folder = '/shared/projects/uniklima/globclim/milicak/mom/FAMOS/';

varnames = {'ctl' 'gsp' 'gsn'};
varname = ['ctl'];

aname = '/work/users/mil021/RUNS/mom/FAMOS/om3_core3_2/om3_core3/history/ocean.static.nc';
area = ncread(aname,'area_t');
out = load('/export/grunchfs/unibjerknes/milicak/bckup/grunchhome/milicak/Analysis/NorESM/Arctic_seaice/Analysis/region_masks.mat');
lon = ncread(aname,'geolon_t');
lat = ncread(aname,'geolat_t');
regionnames = [{'KaraBarents'}];
in = insphpoly(lon,lat,out.lon1,out.lat1,0,90);
in = double(in);
in = repmat(in,[1 1 50]);
area = repmat(area,[1 1 50]);

fname = [root_folder project_name '/om3_core3/history/salt_19480101.ocean_month.nc'];
totaltime = ncread(fname,'time');
tstart = length(totaltime)-347; % starting from 1980 Jan

time = 1;
for timeind = tstart:length(totaltime)
    fname = [root_folder project_name '/om3_core3/history/dht_19480101.ocean_month.nc'];
    dht = ncread(fname,'dht',[1 1 1 timeind],[Inf Inf Inf 1]);
    % passive 02 
    fname = [root_folder project_name '/om3_core3/history/passive_tracer02_19480101.ocean_month.nc'];
    passive02 = ncread(fname,'passive_tracer02',[1 1 1 timeind],[Inf Inf Inf 1]);
    dnm = passive02.*in;
    dnm = squeeze(nansum(dnm,1));
    dnm = squeeze(nansum(dnm,1));
    pass2(time) = nansum(dnm(:));
    dnm = passive02.*in.*area.*dht;
    dnm = squeeze(nansum(dnm,1));
    dnm = squeeze(nansum(dnm,1));
    pass2vol(time) = nansum(dnm(:));

    time = time+1
end

% time variable
time=ncread(fname,'time');
time = time(end-347:end);
T = noleapdatevec(time);
mdays = [31    28    31    30    31    30    31    31    30    31    30    31];
mwght = mdays./sum(mdays(:));
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

outname = ['data/ITU-MOM/' project_name '_passive02_Barents.nc']
nccreate(outname,[varname 'passive02'],'Dimensions',{'time',length(time)},'Datatype','double')
nccreate(outname,[varname 'passive02_vol'],'Dimensions',{'time',length(time)},'Datatype','double')

nccreate(outname,'time','Dimensions',{'time',length(time)},'Datatype','double')

ncwriteatt(outname,[varname 'passive02'],'long name','passive tracer02 Barents Sea')
ncwriteatt(outname,[varname 'passive02'],'unit','unitless')
ncwriteatt(outname,[varname 'passive02_vol'],'long name','passive tracer02 volume Barents Sea')
ncwriteatt(outname,[varname 'passive02_vol'],'unit','m^3')

ncwriteatt(outname,'time','unit','years')

ncwrite(outname,[varname 'passive02'],pass2);
ncwrite(outname,[varname 'passive02_vol'],pass2vol);
ncwrite(outname,'time',year);

