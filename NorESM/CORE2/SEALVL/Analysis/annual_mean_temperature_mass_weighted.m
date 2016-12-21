% this subroutine computes annual mean temp
clear all

%expid='NOIIA_T62_tn11_bblsr10m30d_01';
expid='NOIIA_T62_tn11_sr10m60d_01';
datesep='-';
%grid_file='/work/shared/noresm/inputdata/ocn/micom/tnx1v1/20120120/grid.nc';
grid_file='/home/fimm/bjerknes/milicak/Analysis/NorESM/climatology/Analysis/grid.nc';
fyear=1;
lyear=300;
fill_value=-1e33;

prefix=['/hexagon/work/matsbn/archive/' expid '/ocn/hist/' expid '.micom.hm.'];

% Jan Feb Mar Apr May June July Aug Sep Oct Nov Dec
months2days=[31  28  31  30  31   30   31  31   30 31   30 31];
yeardays=sum(months2days);

% Get dimensions and time attributes
sdate=sprintf('%4.4d%c%2.2d',fyear,datesep,1);
nx=ncgetdim([prefix sdate '.nc'],'x');
ny=ncgetdim([prefix sdate '.nc'],'y');
sigma=ncgetdim([prefix sdate '.nc'],'sigma');
sigma2=ncgetvar([prefix sdate '.nc'],'sigma');
ny=ny-1;
time_long_name=ncgetatt([prefix sdate '.nc'],'long_name','time');
time_units=ncgetatt([prefix sdate '.nc'],'units','time');
time_calendar=ncgetatt([prefix sdate '.nc'],'calendar','time');

% Read grid information
plon=ncgetvar(grid_file,'plon');
plat=ncgetvar(grid_file,'plat');
parea=ncgetvar(grid_file,'parea');
pclon=ncgetvar(grid_file,'pclon');
pclat=ncgetvar(grid_file,'pclat');
plon=plon(:,1:end-1);
plat=plat(:,1:end-1);
parea=parea(:,1:end-1);
pclon=permute(pclon(:,1:end-1,:),[3 1 2]);
pclat=permute(pclat(:,1:end-1,:),[3 1 2]);

% Create netcdf file.
%ncid=netcdf.create([expid '_temperature_annual_' num2str(fyear) '-' num2str(lyear) '.nc'],'NC_CLOBBER');
%ncid=netcdf.create(['/work/milicak/RUNS/noresm/CORE2/CORE2_files/SSH/' expid '_temperature_annual_' num2str(fyear) '-' num2str(lyear) '.nc'],'NC_CLOBBER');
ncid=netcdf.create(['/bcmhsm/milicak/RUNS/noresm/CORE2/SSH/' expid '_temperature_mass_weighted_annual_' num2str(fyear) '-' num2str(lyear) '.nc'],'NC_CLOBBER');

% Define dimensions.
ni_dimid=netcdf.defDim(ncid,'ni',nx);
nj_dimid=netcdf.defDim(ncid,'nj',ny);
nz_dimid=netcdf.defDim(ncid,'sigma',sigma);
time_dimid=netcdf.defDim(ncid,'time',netcdf.getConstant('NC_UNLIMITED'));
nvertices_dimid=netcdf.defDim(ncid,'nvertices',4);

% Define variables and assign attributes
time_varid=netcdf.defVar(ncid,'time','float',time_dimid);
netcdf.putAtt(ncid,time_varid,'long_name',time_long_name);
netcdf.putAtt(ncid,time_varid,'units',time_units);
netcdf.putAtt(ncid,time_varid,'calendar',time_calendar);

tlon_varid=netcdf.defVar(ncid,'TLON','float',[ni_dimid nj_dimid]);
netcdf.putAtt(ncid,tlon_varid,'long_name','T grid center longitude');
netcdf.putAtt(ncid,tlon_varid,'units','degrees_east');
netcdf.putAtt(ncid,tlon_varid,'bounds','lont_bounds');

tlat_varid=netcdf.defVar(ncid,'TLAT','float',[ni_dimid nj_dimid]);
netcdf.putAtt(ncid,tlat_varid,'long_name','T grid center latitude');
netcdf.putAtt(ncid,tlat_varid,'units','degrees_north');
netcdf.putAtt(ncid,tlat_varid,'bounds','latt_bounds');

sigma_varid=netcdf.defVar(ncid,'sigma','float',[nz_dimid]);
netcdf.putAtt(ncid,sigma_varid,'long_name','Potential density');
netcdf.putAtt(ncid,sigma_varid,'units','kg m-3');

tarea_varid=netcdf.defVar(ncid,'tarea','float',[ni_dimid nj_dimid]);
netcdf.putAtt(ncid,tarea_varid,'long_name','area of T grid cells');
netcdf.putAtt(ncid,tarea_varid,'units','m^2');
netcdf.putAtt(ncid,tarea_varid,'coordinates','TLON TLAT');

lont_bounds_varid=netcdf.defVar(ncid,'lont_bounds','float',[nvertices_dimid ni_dimid nj_dimid]);
netcdf.putAtt(ncid,lont_bounds_varid,'long_name','longitude boundaries of T cells');
netcdf.putAtt(ncid,lont_bounds_varid,'units','degrees_east');

latt_bounds_varid=netcdf.defVar(ncid,'latt_bounds','float',[nvertices_dimid ni_dimid nj_dimid]);
netcdf.putAtt(ncid,latt_bounds_varid,'long_name','latitude boundaries of T cells');
netcdf.putAtt(ncid,latt_bounds_varid,'units','degrees_north');

temp_varid=netcdf.defVar(ncid,'temp','float',[ni_dimid nj_dimid nz_dimid time_dimid]);
netcdf.putAtt(ncid,temp_varid,'long_name','Temperature');
netcdf.putAtt(ncid,temp_varid,'units','C');
netcdf.putAtt(ncid,temp_varid,'_FillValue',single(fill_value));
netcdf.putAtt(ncid,temp_varid,'coordinates','TLON TLAT');
netcdf.putAtt(ncid,temp_varid,'cell_measures','area: tarea');

dp_varid=netcdf.defVar(ncid,'dp','float',[ni_dimid nj_dimid nz_dimid time_dimid]);
netcdf.putAtt(ncid,dp_varid,'long_name','Layer pressure thickness');
netcdf.putAtt(ncid,dp_varid,'units','Pa');
netcdf.putAtt(ncid,dp_varid,'_FillValue',single(fill_value));
netcdf.putAtt(ncid,dp_varid,'coordinates','TLON TLAT');
netcdf.putAtt(ncid,dp_varid,'cell_measures','area: tarea');

% Global attributes

% End definitions and leave define mode.
netcdf.endDef(ncid)

% Provide values for time invariant variables.
netcdf.putVar(ncid,tlon_varid,single(plon));
netcdf.putVar(ncid,tlat_varid,single(plat));
netcdf.putVar(ncid,tarea_varid,single(parea));
netcdf.putVar(ncid,lont_bounds_varid,single(pclon));
netcdf.putVar(ncid,latt_bounds_varid,single(pclat));
netcdf.putVar(ncid,sigma_varid,single(sigma2));

n=0;
for year=fyear:lyear
  n=n+1;
  temp=zeros(nx,ny,sigma);
  dp=zeros(nx,ny,sigma);
  time=0;
  for month=1:12
    sdate=sprintf('%4.4d%c%2.2d',year,datesep,month);
    disp(sdate)
    tmp=ncgetvar([prefix sdate '.nc'],'temp');
    tmp2=ncgetvar([prefix sdate '.nc'],'dp');
    dp=dp+tmp2(:,1:end-1,:).*months2days(month);
    temp=temp+tmp(:,1:end-1,:).*tmp2(:,1:end-1,:).*months2days(month);
    tmp=ncgetvar([prefix sdate '.nc'],'time');
    time=time+tmp;
  end
  temp=temp./dp./yeardays;
  dp=dp./yeardays;
  time=time/12;
  temp(isnan(temp))=fill_value;
  dp(isnan(dp))=fill_value;
  netcdf.putVar(ncid,time_varid,n-1,1,single(time));
  netcdf.putVar(ncid,temp_varid,[0 0 0 n-1],[nx ny sigma 1],single(temp));
  netcdf.putVar(ncid,dp_varid,[0 0 0 n-1],[nx ny sigma 1],single(dp));
end


% Close netcdf file
netcdf.close(ncid)

