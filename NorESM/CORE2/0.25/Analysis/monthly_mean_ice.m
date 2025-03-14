% this subroutine computes annual mean ice
clear all

expid='NOIIA_T62_tn11_sr10m60d_02'
%expid='NOIIA_T62_tn025_001'

m2y=1;

datesep='-';
if m2y==1
  grid_file='/home/fimm/bjerknes/milicak/Analysis/NorESM/climatology/Analysis/grid.nc';
else
  grid_file='/work/milicak/0.25/grid.nc';
end

fyear=61;
lyear=120;
fill_value=-1e33;

if m2y==1
  %prefix=['/hexagon/work/milicak/archive/' expid '/ocn/hist/' expid '.micom.hm.'];
  %prefix2=['/hexagon/work/milicak/archive/' expid '/ice/hist/' expid '.cice.h.'];
  prefix=['/hexagon/work/matsbn/archive/' expid '/ocn/hist/' expid '.micom.hm.'];
  prefix2=['/hexagon/work/matsbn/archive/' expid '/ice/hist/' expid '.cice.h.'];
  months2days=[31  28  31  30  31   30   31  31   30 31   30 31];
  yeardays=sum(months2days);
else
  prefix=['/hexagon/work/milicak/archive/' expid '/ocn/hist/' expid '.micom.hy.'];
end

% Get dimensions and time attributes
if m2y==1
  sdate=sprintf('%4.4d%c%2.2d',fyear,datesep,1);
else
  sdate=sprintf('%4.4d%c%2.2d',fyear);
end
nx=ncgetdim([prefix sdate '.nc'],'x');
ny=ncgetdim([prefix sdate '.nc'],'y');
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
ncid=netcdf.create(['/bcmhsm/milicak/RUNS/noresm/CORE2/0.25/' expid '_ice_annual_' num2str(fyear) '-' num2str(lyear) '.nc'],'NC_CLOBBER');

% Define dimensions.
ni_dimid=netcdf.defDim(ncid,'ni',nx);
nj_dimid=netcdf.defDim(ncid,'nj',ny);
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

hice_varid=netcdf.defVar(ncid,'hice','float',[ni_dimid nj_dimid time_dimid]);
netcdf.putAtt(ncid,hice_varid,'long_name','Sea ice thickness');
netcdf.putAtt(ncid,hice_varid,'units','m');
netcdf.putAtt(ncid,hice_varid,'_FillValue',single(fill_value));
netcdf.putAtt(ncid,hice_varid,'coordinates','TLON TLAT');
netcdf.putAtt(ncid,hice_varid,'cell_measures','area: tarea');

fice_varid=netcdf.defVar(ncid,'fice','float',[ni_dimid nj_dimid time_dimid]);
netcdf.putAtt(ncid,fice_varid,'long_name','Sea ice fraction');
netcdf.putAtt(ncid,fice_varid,'units','percentage');
netcdf.putAtt(ncid,fice_varid,'_FillValue',single(fill_value));
netcdf.putAtt(ncid,fice_varid,'coordinates','TLON TLAT');
netcdf.putAtt(ncid,fice_varid,'cell_measures','area: tarea');

% Global attributes

% End definitions and leave define mode.
netcdf.endDef(ncid)

% Provide values for time invariant variables.
netcdf.putVar(ncid,tlon_varid,single(plon));
netcdf.putVar(ncid,tlat_varid,single(plat));
netcdf.putVar(ncid,tarea_varid,single(parea));
netcdf.putVar(ncid,lont_bounds_varid,single(pclon));
netcdf.putVar(ncid,latt_bounds_varid,single(pclat));

% Retrieve mixed layer depths and write to netcdf variables
n=0;
for year=fyear:lyear
  n=n+1;
  hice=zeros(nx,ny);
  fice=zeros(nx,ny);
  time=0;
  if m2y==1
    for month=1:12
      sdate=sprintf('%4.4d%c%2.2d',year,datesep,month);
      disp(sdate)
      tmp=ncgetvar([prefix2 sdate '.nc'],'hi');
      hice=hice+tmp.*months2days(month);
      tmp=ncgetvar([prefix sdate '.nc'],'fice');
      fice=fice+tmp(:,1:end-1).*months2days(month);
      tmp=ncgetvar([prefix sdate '.nc'],'time');
      time=time+tmp;
    end
    hice=hice/yeardays;
break
    fice=fice/yeardays;
    time=time/12;
  else
     sdate=sprintf('%4.4d%c%2.2d',year);
     disp(sdate)
     tmp=ncgetvar([prefix sdate '.nc'],'hice');
     hice=tmp(:,1:end-1);
     tmp=ncgetvar([prefix sdate '.nc'],'fice');
     fice=tmp(:,1:end-1);
     tmp=ncgetvar([prefix sdate '.nc'],'time');
     time=time+tmp;
  end  
  hice(isnan(hice))=fill_value;
  fice(isnan(fice))=fill_value;
  netcdf.putVar(ncid,time_varid,n-1,1,single(time));
  netcdf.putVar(ncid,hice_varid,[0 0 n-1],[nx ny 1],single(hice));
  netcdf.putVar(ncid,fice_varid,[0 0 n-1],[nx ny 1],single(fice));
end

% Close netcdf file
netcdf.close(ncid)

