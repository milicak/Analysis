clear all

fice_cr = 0.15;
project_name = 'om3_core3_2'
%project_name = 'om3_core3_2_BG_neg'
%project_name = 'om3_core3_2_BG_pos'
%project_name = 'om3_core3_2_GS_neg'
%project_name = 'om3_core3_2_GS_pos'
%project_name = 'om3_core3_ctrl'
%root_folder = '/work/users/mil021/RUNS/mom/FAMOS/' ;
root_folder = '/export/grunchfs/unibjerknes/milicak/bckup/mom/FAMOS/';
varnames = {'ctl' 'gsp' 'gsn'};
varname = ['ctl'];

fname = [root_folder project_name '/om3_core3/history/19480101.ice_month.nc'];
%fname = [root_folder project_name '/history_1-62years/00010101.ice_month.nc'];
%aname = '/export/grunchfs/unibjerknes/milicak/bckup/noresm/CORE2/Arctic/DATA/gfdl-mom/grids_bathymetry/ocean.static.nc';
aname = '/work/users/mil021/RUNS/mom/FAMOS/om3_core3_2/om3_core3/history/ocean.static.nc';

fice = ncread(fname,'CN');
hice = ncread(fname,'HI');
area = ncread(aname,'area_t');

fice = squeeze(nansum(fice,3));
fice(fice<fice_cr) = 0.0;
fice(fice>=fice_cr) = 1.0;
fice = fice(:,:,end-347:end);
hice = hice(:,:,end-347:end);
area = repmat(area,[1 1 size(fice,3)]);
vice = fice.*hice.*area;
vice = squeeze(nansum(vice,1));
vice = squeeze(nansum(vice,1));

vice = vice';

% time variable
time=ncread(fname,'time');
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

outname = ['data/ITU-MOM/' project_name '_ice_volume_NH.nc']
nccreate(outname,[varname 'vice'],'Dimensions',{'time',length(time)},'Datatype','double')
nccreate(outname,'time','Dimensions',{'time',length(time)},'Datatype','double')
ncwriteatt(outname,[varname 'vice'],'long name','sea-ice Volume Northern Hemisphere')
ncwriteatt(outname,[varname 'vice'],'unit','m^3')
ncwriteatt(outname,'time','unit','years')

ncwrite(outname,[varname 'vice'],vice);
ncwrite(outname,'time',year);
