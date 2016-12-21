% this subroutine computes monthly mean FWC thickness and FWC concentration
clear all

%expid='NOIIA_T62_tn11_bblsr10m30d_01';
expid='NOIIA_T62_tn11_sr10m60d_01';
datesep='-';
%grid_file='/work/shared/noresm/inputdata/ocn/micom/tnx1v1/20120120/grid.nc';
grid_file='/home/fimm/bjerknes/milicak/Analysis/NorESM/climatology/Analysis/grid.nc';
area=ncgetvar(grid_file,'parea');
fyear=1;
lyear=300;
fill_value=-1e33;

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
ncid=netcdf.create(['/bcmhsm/milicak/RUNS/noresm/CORE2/Arctic/' expid '_restoring_freshwatervolumeflux_' num2str(fyear) '-' num2str(lyear) '.nc'],'NC_CLOBBER');

% Define dimensions.
ni_dimid=netcdf.defDim(ncid,'ni',nx);
time_dimid=netcdf.defDim(ncid,'time',netcdf.getConstant('NC_UNLIMITED'));
nvertices_dimid=netcdf.defDim(ncid,'nvertices',4);

% Define variables and assign attributes
time_varid=netcdf.defVar(ncid,'time','float',time_dimid);
netcdf.putAtt(ncid,time_varid,'long_name',time_long_name);
netcdf.putAtt(ncid,time_varid,'units',time_units);
netcdf.putAtt(ncid,time_varid,'calendar',time_calendar);

fwrflx_varid=netcdf.defVar(ncid,'fwrflx','float',[ni_dimid time_dimid]);
netcdf.putAtt(ncid,fwrflx_varid,'long_name','Fresh water restoring flux');
netcdf.putAtt(ncid,fwrflx_varid,'units','kg s-1');
netcdf.putAtt(ncid,fwrflx_varid,'_FillValue',single(fill_value));

srflx_varid=netcdf.defVar(ncid,'srflx','float',[ni_dimid time_dimid]);
netcdf.putAtt(ncid,srflx_varid,'long_name','Restoring salt flux received by ocean');
netcdf.putAtt(ncid,srflx_varid,'units','kg s-1');
netcdf.putAtt(ncid,srflx_varid,'_FillValue',single(fill_value));

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
    srf=ncgetvar([prefix sdate '.nc'],'srflx');
    tmp=srf.*flag.*area;
    tmp=tmp(:,1:end-1);
    srflx=nansum(tmp(:));
    sss=ncgetvar([prefix sdate '.nc'],'sss');
    tmp=-srf./(sss.*1e-3);
    tmp=tmp.*flag.*area;
    tmp=tmp(:,1:end-1);
    fwrflx=nansum(tmp(:));
    tmp=ncgetvar([prefix sdate '.nc'],'time');
    time=tmp;
    fwrflx(isnan(fwrflx))=fill_value;
    srflx(isnan(srflx))=fill_value;
    netcdf.putVar(ncid,time_varid,n-1,1,single(time));
    netcdf.putVar(ncid,fwrflx_varid,[0 n-1],[nx 1],single(fwrflx));
    netcdf.putVar(ncid,srflx_varid,[0 n-1],[nx 1],single(srflx));
  end
end

% Close netcdf file
netcdf.close(ncid)

