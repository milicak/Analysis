% this subroutine computes monthly mean FWC thickness and FWC concentration
clear all

%expid='NOIIA_T62_tn11_bblsr10m30d_01';
expid='NOIIA_T62_tn11_sr10m60d_01';
datesep='-';
%grid_file='/work/shared/noresm/inputdata/ocn/micom/tnx1v1/20120120/grid.nc';
grid_file='/home/fimm/bjerknes/milicak/Analysis/NorESM/climatology/Analysis/grid.nc';
fyear=1;
lyear=300;
fill_value=-1e33;
Sref=34.8; % reference salinity
Smin=0.0;
Smax=50;
grav=9.81;
rho0=1e3;

fid=fopen('arcticoceanmask.dat','r');
Nx=fscanf(fid,'%d',1);
Ny=fscanf(fid,'%d',1);
flag=reshape(fscanf(fid,'%1d'),Ny,Nx)';
fclose(fid);
flag(flag~=1)=NaN;

prefix=['/hexagon/work/milicak/archive/' expid '/ocn/hist/' expid '.micom.hm.'];

% Get dimensions and time attributes
sdate=sprintf('%4.4d%c%2.2d',fyear,datesep,1);
nx=ncgetdim([prefix sdate '.nc'],'x');
ny=ncgetdim([prefix sdate '.nc'],'y');
ny=ny-1;
nx=1;
ny=1;
time_long_name=ncgetatt([prefix sdate '.nc'],'long_name','time');
time_units=ncgetatt([prefix sdate '.nc'],'units','time');
time_calendar=ncgetatt([prefix sdate '.nc'],'calendar','time');

% Create netcdf file.
%ncid=netcdf.create([expid '_ssh_monthly_' num2str(fyear) '-' num2str(lyear) '.nc'],'NC_CLOBBER');
ncid=netcdf.create(['/bcmhsm/milicak/RUNS/noresm/CORE2/Arctic/' expid '_freshwatercontent_' num2str(fyear) '-' num2str(lyear) '.nc'],'NC_CLOBBER');

% Define dimensions.
ni_dimid=netcdf.defDim(ncid,'ni',nx);
time_dimid=netcdf.defDim(ncid,'time',netcdf.getConstant('NC_UNLIMITED'));
nvertices_dimid=netcdf.defDim(ncid,'nvertices',4);

% Define variables and assign attributes
time_varid=netcdf.defVar(ncid,'time','float',time_dimid);
netcdf.putAtt(ncid,time_varid,'long_name',time_long_name);
netcdf.putAtt(ncid,time_varid,'units',time_units);
netcdf.putAtt(ncid,time_varid,'calendar',time_calendar);

LFWC_varid=netcdf.defVar(ncid,'LFWC','float',[ni_dimid time_dimid]);
netcdf.putAtt(ncid,LFWC_varid,'long_name','Liquid fresh Water Content');
netcdf.putAtt(ncid,LFWC_varid,'units','m');
netcdf.putAtt(ncid,LFWC_varid,'_FillValue',single(fill_value));

% Global attributes

% End definitions and leave define mode.
netcdf.endDef(ncid)

% Retrieve mixed layer depths and write to netcdf variables
n=0;
for year=fyear:lyear
  for month=1:12
    n=n+1;
    sdate=sprintf('%4.4d%c%2.2d',year,datesep,month);
    disp(sdate)
    saln=ncgetvar([prefix sdate '.nc'],'saln');
    saln(saln>Smax)=NaN;
    saln(saln<Smin)=NaN;
    dp=ncgetvar([prefix sdate '.nc'],'dp');
    tmp=(1.0-saln./Sref).*dp;
    tmp=squeeze(nansum(tmp,3));
    tmp=(tmp.*flag./grav)./rho0;
    tmp=tmp(:,1:end-1);
    LFWC=nansum(tmp(:));
    tmp=ncgetvar([prefix sdate '.nc'],'time');
    time=tmp;
    LFWC(isnan(LFWC))=fill_value;
    netcdf.putVar(ncid,time_varid,n-1,1,single(time));
    netcdf.putVar(ncid,LFWC_varid,[0 n-1],[nx 1],single(LFWC));
  end
end

% Close netcdf file
netcdf.close(ncid)

