% this subroutine computes monthly mean ssh
clear all

%expid='NOIIA_T62_tn11_bblsr10m30d_01';
expid='NOIIA_T62_tn11_sr10m60d_02';
datesep='-';
%grid_file='/work/shared/noresm/inputdata/ocn/micom/tnx1v1/20120120/grid.nc';
grid_file='/home/fimm/bjerknes/milicak/Analysis/NorESM/climatology/Analysis/grid.nc';
region=3; %Atlantic=1; India=2; Pacific=3; Global=4
fyear=1;
lyear=540;
fill_value=-1e33;

%prefix=['/hexagon/work/milicak/archive/' expid '/ocn/hist/' expid '.micom.hm.'];
%prefix=['/export/grunchfs/green/matsbn/archive/' expid '/ocn/hist/' expid '.micom.hm.'];
prefix=['/hexagon/work/milicak/RUNS/micompp/test_ovrtrn/ovrtrn_'];

% Get dimensions and time attributes
%sdate=sprintf('%4.4d%c%2.2d',fyear,datesep,1);
sdate=sprintf('%3.3d',1);
nx=ncgetdim([prefix sdate '.nc'],'lat');
ny=ncgetdim([prefix sdate '.nc'],'depth');
time_long_name=ncgetatt([prefix sdate '.nc'],'long_name','time');
time_units=ncgetatt([prefix sdate '.nc'],'units','time');
time_calendar=ncgetatt([prefix sdate '.nc'],'calendar','time');

% Read grid information
%plat=ncgetvar(grid_file,'lat');
plat=ncgetvar([prefix sdate '.nc'],'lat');
pclat=ncgetvar([prefix sdate '.nc'],'lat_bnds');
pdepth=ncgetvar([prefix sdate '.nc'],'depth');
pcdepth=ncgetvar([prefix sdate '.nc'],'depth_bnds');
%pclat=permute(pclat(:,1:end-1,:),[3 1 2]);

% Create netcdf file.
%ncid=netcdf.create([expid '_ssh_monthly_' num2str(fyear) '-' num2str(lyear) '.nc'],'NC_CLOBBER');
ncid=netcdf.create(['/bcmhsm/milicak/RUNS/noresm/CORE2/Pacific/' expid '_Pacific_moc_monthly_' num2str(fyear) '-' num2str(lyear) '.nc'],'NC_CLOBBER');

% Define dimensions.
ni_dimid=netcdf.defDim(ncid,'ni',nx);
nj_dimid=netcdf.defDim(ncid,'nj',ny);
time_dimid=netcdf.defDim(ncid,'time',netcdf.getConstant('NC_UNLIMITED'));
nvertices_dimid=netcdf.defDim(ncid,'nvertices',2);

% Define variables and assign attributes
time_varid=netcdf.defVar(ncid,'time','float',time_dimid);
netcdf.putAtt(ncid,time_varid,'long_name',time_long_name);
netcdf.putAtt(ncid,time_varid,'units',time_units);
netcdf.putAtt(ncid,time_varid,'calendar',time_calendar);

tlat_varid=netcdf.defVar(ncid,'TLAT','float',[ni_dimid]);
netcdf.putAtt(ncid,tlat_varid,'long_name','T grid center latitude');
netcdf.putAtt(ncid,tlat_varid,'units','degrees_north');
netcdf.putAtt(ncid,tlat_varid,'bounds','latt_bounds');

pdepth_varid=netcdf.defVar(ncid,'depth','float',[nj_dimid]);
netcdf.putAtt(ncid,pdepth_varid,'long_name','depth');
netcdf.putAtt(ncid,pdepth_varid,'units','m');
netcdf.putAtt(ncid,pdepth_varid,'bounds','depth_bounds');

latt_bounds_varid=netcdf.defVar(ncid,'latt_bounds','float',[nvertices_dimid ni_dimid]);
netcdf.putAtt(ncid,latt_bounds_varid,'long_name','latitude boundaries of T cells');
netcdf.putAtt(ncid,latt_bounds_varid,'units','degrees_north');

pdepth_bounds_varid=netcdf.defVar(ncid,'depth_bounds','float',[nvertices_dimid nj_dimid]);
netcdf.putAtt(ncid,pdepth_bounds_varid,'long_name','depth boundaries of T cells');
netcdf.putAtt(ncid,pdepth_bounds_varid,'units','m');

pmoc_varid=netcdf.defVar(ncid,'pmoc','float',[ni_dimid nj_dimid time_dimid]);
netcdf.putAtt(ncid,pmoc_varid,'long_name','Pacific meridional overturning circulation');
netcdf.putAtt(ncid,pmoc_varid,'units','Sv');
netcdf.putAtt(ncid,pmoc_varid,'_FillValue',single(fill_value));
netcdf.putAtt(ncid,pmoc_varid,'coordinates','depth TLAT');

% Global attributes

% End definitions and leave define mode.
netcdf.endDef(ncid)

% Provide values for time invariant variables.
netcdf.putVar(ncid,tlat_varid,single(plat));
netcdf.putVar(ncid,latt_bounds_varid,single(pclat));
netcdf.putVar(ncid,pdepth_varid,single(pdepth));
netcdf.putVar(ncid,pdepth_bounds_varid,single(pcdepth));

% Retrieve mixed layer depths and write to netcdf variables
n=0;
for year=fyear:lyear
    n=n+1;
    %sdate=sprintf('%4.4d%c%2.2d',year,datesep,month);
    sdate=sprintf('%3.3d',year);
    disp(sdate)
    tmp=ncgetvar([prefix sdate '.nc'],'ovrtd');
    pmoc=tmp(:,:,region); %Pacific region
    tmp=ncgetvar([prefix sdate '.nc'],'time');
    time=tmp;
    pmoc(isnan(pmoc))=fill_value;
    netcdf.putVar(ncid,time_varid,n-1,1,single(time));
    netcdf.putVar(ncid,pmoc_varid,[0 0 n-1],[nx ny 1],single(pmoc));
end

% Close netcdf file
netcdf.close(ncid)

