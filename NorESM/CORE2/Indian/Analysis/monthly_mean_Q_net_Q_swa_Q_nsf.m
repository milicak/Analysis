% this subroutine computes monthly mean Q_net which is
% sum of Q_swa and Q_nsf (non-solar flux). Q_nsf=Q_LW+Q_LH+Q_SH
clear all

%expid='NOIIA_T62_tn11_bblsr10m30d_01';
expid='NOIIA_T62_tn11_sr10m60d_01';
datesep='-';
%grid_file='/work/shared/noresm/inputdata/ocn/micom/tnx1v1/20120120/grid.nc';
grid_file='/home/fimm/bjerknes/milicak/Analysis/NorESM/climatology/Analysis/grid.nc';
fyear=1;
lyear=300;
fill_value=-1e33;

prefix=['/hexagon/work/milicak/archive/' expid '/ocn/hist/' expid '.micom.hm.'];

% Get dimensions and time attributes
sdate=sprintf('%4.4d%c%2.2d',fyear,datesep,1);
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
%ncid=netcdf.create([expid '_Q_net_monthly_' num2str(fyear) '-' num2str(lyear) '.nc'],'NC_CLOBBER');
ncid=netcdf.create(['/bcmhsm/milicak/RUNS/noresm/CORE2/Indian/' expid '_Q_net_monthly_' num2str(fyear) '-' num2str(lyear) '.nc'],'NC_CLOBBER');

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

Qnet_varid=netcdf.defVar(ncid,'Q_net','float',[ni_dimid nj_dimid time_dimid]);
netcdf.putAtt(ncid,Qnet_varid,'long_name','Net surface heat flux');
netcdf.putAtt(ncid,Qnet_varid,'units','W m-2');
netcdf.putAtt(ncid,Qnet_varid,'_FillValue',single(fill_value));
netcdf.putAtt(ncid,Qnet_varid,'coordinates','TLON TLAT');
netcdf.putAtt(ncid,Qnet_varid,'cell_measures','area: tarea');

Qswa_varid=netcdf.defVar(ncid,'Q_swa','float',[ni_dimid nj_dimid time_dimid]);
netcdf.putAtt(ncid,Qswa_varid,'long_name','Shortwave heat flux');
netcdf.putAtt(ncid,Qswa_varid,'units','W m-2');
netcdf.putAtt(ncid,Qswa_varid,'_FillValue',single(fill_value));
netcdf.putAtt(ncid,Qswa_varid,'coordinates','TLON TLAT');
netcdf.putAtt(ncid,Qswa_varid,'cell_measures','area: tarea');

Qnsf_varid=netcdf.defVar(ncid,'Q_nsf','float',[ni_dimid nj_dimid time_dimid]);
netcdf.putAtt(ncid,Qnsf_varid,'long_name','Non-solar heat flux');
netcdf.putAtt(ncid,Qnsf_varid,'units','W m-2');
netcdf.putAtt(ncid,Qnsf_varid,'_FillValue',single(fill_value));
netcdf.putAtt(ncid,Qnsf_varid,'coordinates','TLON TLAT');
netcdf.putAtt(ncid,Qnsf_varid,'cell_measures','area: tarea');

Qmelt_varid=netcdf.defVar(ncid,'Q_melt','float',[ni_dimid nj_dimid time_dimid]);
netcdf.putAtt(ncid,Qmelt_varid,'long_name','Heat flux due to melting/freezing');
netcdf.putAtt(ncid,Qmelt_varid,'units','W m-2');
netcdf.putAtt(ncid,Qmelt_varid,'_FillValue',single(fill_value));
netcdf.putAtt(ncid,Qmelt_varid,'coordinates','TLON TLAT');
netcdf.putAtt(ncid,Qmelt_varid,'cell_measures','area: tarea');

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
  for month=1:12
    n=n+1;
    sdate=sprintf('%4.4d%c%2.2d',year,datesep,month);
    disp(sdate)
    tmp=ncgetvar([prefix sdate '.nc'],'swa');
    Qswa=tmp(:,1:end-1,:);
    tmp=ncgetvar([prefix sdate '.nc'],'nsf');
    Qnsf=tmp(:,1:end-1,:);
    Qnet=Qswa+Qnsf;
    tmp=ncgetvar([prefix sdate '.nc'],'hmltfz');
    Qmelt=tmp(:,1:end-1,:);
    tmp=ncgetvar([prefix sdate '.nc'],'time');
    time=tmp;
    Qnet(isnan(Qnet))=fill_value;
    Qswa(isnan(Qswa))=fill_value;
    Qnsf(isnan(Qnsf))=fill_value;
    netcdf.putVar(ncid,time_varid,n-1,1,single(time));
    netcdf.putVar(ncid,Qnet_varid,[0 0 n-1],[nx ny 1],single(Qnet));
    netcdf.putVar(ncid,Qswa_varid,[0 0 n-1],[nx ny 1],single(Qswa));
    netcdf.putVar(ncid,Qnsf_varid,[0 0 n-1],[nx ny 1],single(Qnsf));
    netcdf.putVar(ncid,Qmelt_varid,[0 0 n-1],[nx ny 1],single(Qmelt));
  end
end

% Close netcdf file
netcdf.close(ncid)

