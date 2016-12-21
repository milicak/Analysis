% this subroutine computes pendatal mean u-velocity
clear all

%expid='NOIIA_T62_tn11_bblsr10m30d_01';
expid='NOIIA_T62_tn11_sr10m60d_01';
datesep='-';
%grid_file='/work/shared/noresm/inputdata/ocn/micom/tnx1v1/20120120/grid.nc';
grid_file='/fimm/home/bjerknes/milicak/Analysis/NorESM/climatology/Analysis/grid.nc';
fyear=1;
lyear=296;
lyear2=300;
pendatal=4; % averaged years
fill_value=-1e33;

prefix=['/hexagon/work/milicak/archive/' expid '/ocn/hist/' expid '.micom.hm.'];
%prefix=['/hexagon/work/matsbn/archive/' expid '/ocn/hist/' expid '.micom.hm.'];
months2days=[31  28  31  30  31   30   31  31   30 31   30 31];
yeardays=sum(months2days);

% Get dimensions and time attributes
sdate=sprintf('%4.4d%c%2.2d',fyear,datesep,1);
nx=ncgetdim([prefix sdate '.nc'],'x');
ny=ncgetdim([prefix sdate '.nc'],'y');
depth=ncgetdim([prefix sdate '.nc'],'depth');
zdepth=ncgetvar([prefix sdate '.nc'],'depth');
zdepth_bnds=ncgetvar([prefix sdate '.nc'],'depth_bnds');
ny=ny-1;
time_long_name=ncgetatt([prefix sdate '.nc'],'long_name','time');
time_units=ncgetatt([prefix sdate '.nc'],'units','time');
time_calendar=ncgetatt([prefix sdate '.nc'],'calendar','time');

% Read grid information
ulon=ncgetvar(grid_file,'ulon');
ulat=ncgetvar(grid_file,'ulat');
uarea=ncgetvar(grid_file,'uarea');
uclon=ncgetvar(grid_file,'uclon');
uclat=ncgetvar(grid_file,'uclat');
ulon=ulon(:,1:end-1);
ulat=ulat(:,1:end-1);
uarea=uarea(:,1:end-1);
uclon=permute(uclon(:,1:end-1,:),[3 1 2]);
uclat=permute(uclat(:,1:end-1,:),[3 1 2]);

% Create netcdf file.
%ncid=netcdf.create([expid '_temperature_annual_' num2str(fyear) '-' num2str(lyear) '.nc'],'NC_CLOBBER');
%ncid=netcdf.create(['/work/milicak/RUNS/noresm/CORE2/CORE2_files/SSH/' expid '_temperature_annual_' num2str(fyear) '-' num2str(lyear) '.nc'],'NC_CLOBBER');
%ncid=netcdf.create(['/bcmhsm/milicak/RUNS/noresm/CORE2/Arctic/' expid '_u_velocity_pendatal_' num2str(fyear) '-' num2str(lyear2) '.nc'],'NC_CLOBBER');
ncid=netcdf.create(['/fimm/work/milicak/RUNS/noresm/CORE2/Arctic/' expid '_u_velocity_pendatal_' num2str(fyear) '-' num2str(lyear2) '.nc'],'NC_CLOBBER');

% Define dimensions.
ni_dimid=netcdf.defDim(ncid,'ni',nx);
nj_dimid=netcdf.defDim(ncid,'nj',ny);
nz_dimid=netcdf.defDim(ncid,'depth',depth);
time_dimid=netcdf.defDim(ncid,'time',netcdf.getConstant('NC_UNLIMITED'));
nvertices_dimid=netcdf.defDim(ncid,'nvertices',4);
nzvertices_dimid=netcdf.defDim(ncid,'nzvertices',2);

% Define variables and assign attributes
time_varid=netcdf.defVar(ncid,'time','float',time_dimid);
netcdf.putAtt(ncid,time_varid,'long_name',time_long_name);
netcdf.putAtt(ncid,time_varid,'units',time_units);
netcdf.putAtt(ncid,time_varid,'calendar',time_calendar);

ulon_varid=netcdf.defVar(ncid,'ULON','float',[ni_dimid nj_dimid]);
netcdf.putAtt(ncid,ulon_varid,'long_name','U grid center longitude');
netcdf.putAtt(ncid,ulon_varid,'units','degrees_east');
netcdf.putAtt(ncid,ulon_varid,'bounds','lonu_bounds');

ulat_varid=netcdf.defVar(ncid,'ULAT','float',[ni_dimid nj_dimid]);
netcdf.putAtt(ncid,ulat_varid,'long_name','U grid center latitude');
netcdf.putAtt(ncid,ulat_varid,'units','degrees_north');
netcdf.putAtt(ncid,ulat_varid,'bounds','latu_bounds');

depth_varid=netcdf.defVar(ncid,'depth','float',[nz_dimid]);
netcdf.putAtt(ncid,depth_varid,'long_name','z level');
netcdf.putAtt(ncid,depth_varid,'units','m');
netcdf.putAtt(ncid,depth_varid,'bounds','depth_bounds');

uarea_varid=netcdf.defVar(ncid,'uarea','float',[ni_dimid nj_dimid]);
netcdf.putAtt(ncid,uarea_varid,'long_name','area of U grid cells');
netcdf.putAtt(ncid,uarea_varid,'units','m^2');
netcdf.putAtt(ncid,uarea_varid,'coordinates','ULON ULAT');

lonu_bounds_varid=netcdf.defVar(ncid,'lonu_bounds','float',[nvertices_dimid ni_dimid nj_dimid]);
netcdf.putAtt(ncid,lonu_bounds_varid,'long_name','longitude boundaries of U cells');
netcdf.putAtt(ncid,lonu_bounds_varid,'units','degrees_east');

latu_bounds_varid=netcdf.defVar(ncid,'latu_bounds','float',[nvertices_dimid ni_dimid nj_dimid]);
netcdf.putAtt(ncid,latu_bounds_varid,'long_name','latitude boundaries of U cells');
netcdf.putAtt(ncid,latu_bounds_varid,'units','degrees_north');

depth_bounds_varid=netcdf.defVar(ncid,'depth_bounds','float',[nzvertices_dimid nz_dimid]);
netcdf.putAtt(ncid,depth_bounds_varid,'long_name','vertical boundaries of U cells');
netcdf.putAtt(ncid,depth_bounds_varid,'units','m');

uvel_varid=netcdf.defVar(ncid,'uvel','float',[ni_dimid nj_dimid nz_dimid time_dimid]);
netcdf.putAtt(ncid,uvel_varid,'long_name','Velocity x-component');
netcdf.putAtt(ncid,uvel_varid,'units','m s-1');
netcdf.putAtt(ncid,uvel_varid,'_FillValue',single(fill_value));
netcdf.putAtt(ncid,uvel_varid,'coordinates','ULON ULAT');
netcdf.putAtt(ncid,uvel_varid,'cell_measures','area: uarea');

% Global attributes

% End definitions and leave define mode.
netcdf.endDef(ncid)

% Provide values for time invariant variables.
netcdf.putVar(ncid,ulon_varid,single(ulon));
netcdf.putVar(ncid,ulat_varid,single(ulat));
netcdf.putVar(ncid,uarea_varid,single(uarea));
netcdf.putVar(ncid,lonu_bounds_varid,single(uclon));
netcdf.putVar(ncid,latu_bounds_varid,single(uclat));
netcdf.putVar(ncid,depth_bounds_varid,single(zdepth_bnds));
netcdf.putVar(ncid,depth_varid,single(zdepth));

% Retrieve mixed layer depths and write to netcdf variables
n=0;
for year=fyear:pendatal+1:lyear
  n=n+1;
  nn=0;
  uvel=zeros(nx,ny,depth);
  time=0;
  for year_in=year:year+pendatal
    nn=nn+1;
    for month=1:12
      sdate=sprintf('%4.4d%c%2.2d',year_in,datesep,month);
      disp(sdate)
      tmp=ncgetvar([prefix sdate '.nc'],'uvellvl');
      uvel=uvel+tmp(:,1:end-1,:)*months2days(month);
      tmp=ncgetvar([prefix sdate '.nc'],'time');
      time=time+tmp;
    end
  end
  %uvel=uvel/(12*nn);
  uvel=uvel/(yeardays*nn);
  time=time/(12*nn);
  uvel(isnan(uvel))=fill_value;
  display('netcdf data is being written')
  netcdf.putVar(ncid,time_varid,n-1,1,single(time));
  netcdf.putVar(ncid,uvel_varid,[0 0 0 n-1],[nx ny depth 1],single(uvel));
end


% Close netcdf file
netcdf.close(ncid)

