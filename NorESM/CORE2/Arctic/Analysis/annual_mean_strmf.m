expid='NOIIA_T62_tn11_sr10m60d_01';
datesep='-';
grid_file='/hexagon/work/shared/noresm/inputdata/ocn/micom/tnx1v1/20120120/grid.nc';
fyear=241;
lyear=300;
fill_value=-1e33;
mw=[31 28 31 30 31 30 31 31 30 31 30 31]/365;

prefix=['/hexagon/work/matsbn/archive/' expid '/ocn/hist/' expid '.micom.hm.'];
outpath='/export/grunchfs/green/matsbn/CORE2/AMOC/';

% Get dimensions and time attributes
sdate=sprintf('%4.4d%c%2.2d',fyear,datesep,1);
nx=ncgetdim([prefix sdate '.nc'],'x');
ny=ncgetdim([prefix sdate '.nc'],'y');
ny=ny-1;
time_long_name=ncgetatt([prefix sdate '.nc'],'long_name','time');
time_units=ncgetatt([prefix sdate '.nc'],'units','time');
time_calendar=ncgetatt([prefix sdate '.nc'],'calendar','time');

% Read grid information
nreg=ncgetatt(grid_file,'nreg');
qlon=ncgetvar(grid_file,'qlon');
qlat=ncgetvar(grid_file,'qlat');
qarea=ncgetvar(grid_file,'qarea');
qclon=ncgetvar(grid_file,'qclon');
qclat=ncgetvar(grid_file,'qclat');
pmask=ncgetvar(grid_file,'pmask');
ins=ncgetvar(grid_file,'ins')+(ncgetvar(grid_file,'jns')-1)*nx;
inw=ncgetvar(grid_file,'inw')+(ncgetvar(grid_file,'jnw')-1)*nx;
insw=ncgetvar(grid_file,'insw')+(ncgetvar(grid_file,'jnsw')-1)*nx;
qlon=qlon(:,1:end-1);
qlat=qlat(:,1:end-1);
qarea=qarea(:,1:end-1);
qclon=permute(qclon(:,1:end-1,:),[3 1 2]);
qclat=permute(qclat(:,1:end-1,:),[3 1 2]);

psi_mask=zeros(nx,ny+1);
psi_mask=min(pmask+pmask(ins)+pmask(inw)+pmask(insw),1);

% Create netcdf file.
ncid=netcdf.create([outpath '/' expid '_barotropic_streamfunction_annual_' num2str(fyear) '-' num2str(lyear) '.nc'],'NC_CLOBBER');

% Define dimensions.
ni_dimid=netcdf.defDim(ncid,'ni',nx);
nj_dimid=netcdf.defDim(ncid,'nj',ny);
time_dimid=netcdf.defDim(ncid,'time',netcdf.getConstant('NC_UNLIMITED'));
nvertices_dimid=netcdf.defDim(ncid,'nvertices',4);

% Define variables and assign attributes
time_varid=netcdf.defVar(ncid,'time','double',time_dimid);
netcdf.putAtt(ncid,time_varid,'long_name',time_long_name);
netcdf.putAtt(ncid,time_varid,'units',time_units);
netcdf.putAtt(ncid,time_varid,'calendar',time_calendar);

qlon_varid=netcdf.defVar(ncid,'QLON','double',[ni_dimid nj_dimid]);
netcdf.putAtt(ncid,qlon_varid,'long_name','Q grid center longitude');
netcdf.putAtt(ncid,qlon_varid,'units','degrees_east');
netcdf.putAtt(ncid,qlon_varid,'bounds','lont_bounds');

qlat_varid=netcdf.defVar(ncid,'QLAT','double',[ni_dimid nj_dimid]);
netcdf.putAtt(ncid,qlat_varid,'long_name','Q grid center latitude');
netcdf.putAtt(ncid,qlat_varid,'units','degrees_north');
netcdf.putAtt(ncid,qlat_varid,'bounds','latt_bounds');

qarea_varid=netcdf.defVar(ncid,'qarea','double',[ni_dimid nj_dimid]);
netcdf.putAtt(ncid,qarea_varid,'long_name','area of Q grid cells');
netcdf.putAtt(ncid,qarea_varid,'units','m^2');
netcdf.putAtt(ncid,qarea_varid,'coordinates','QLON QLAT');

lont_bounds_varid=netcdf.defVar(ncid,'lont_bounds','double',[nvertices_dimid ni_dimid nj_dimid]);
netcdf.putAtt(ncid,lont_bounds_varid,'long_name','longitude boundaries of Q cells');
netcdf.putAtt(ncid,lont_bounds_varid,'units','degrees_east');

latt_bounds_varid=netcdf.defVar(ncid,'latt_bounds','double',[nvertices_dimid ni_dimid nj_dimid]);
netcdf.putAtt(ncid,latt_bounds_varid,'long_name','latitude boundaries of Q cells');
netcdf.putAtt(ncid,latt_bounds_varid,'units','degrees_north');

psi_varid=netcdf.defVar(ncid,'psi','float',[ni_dimid nj_dimid time_dimid]);
netcdf.putAtt(ncid,psi_varid,'long_name','barotropic stream function');
netcdf.putAtt(ncid,psi_varid,'units','kg s-1');
netcdf.putAtt(ncid,psi_varid,'_FillValue',single(fill_value));
netcdf.putAtt(ncid,psi_varid,'coordinates','QLON QLAT');
netcdf.putAtt(ncid,psi_varid,'cell_measures','area: qarea');

% Global attributes

% End definitions and leave define mode.
netcdf.endDef(ncid)

% Provide values for time invariant variables.
netcdf.putVar(ncid,qlon_varid,qlon);
netcdf.putVar(ncid,qlat_varid,qlat);
netcdf.putVar(ncid,qarea_varid,qarea);
netcdf.putVar(ncid,lont_bounds_varid,qclon);
netcdf.putVar(ncid,latt_bounds_varid,qclat);

% Retrieve mass fluxes, compute stream function, and write to netcdf variables
n=0;
for year=fyear:lyear
  n=n+1;
  time=0;
  uflx=zeros(nx,ny+1);
  vflx=zeros(nx,ny+1);
  for month=1:12
    sdate=sprintf('%4.4d%c%2.2d',year,datesep,month);
    disp(sdate)
    uflx=uflx+sum(ncgetvar([prefix sdate '.nc'],'uflx'),3)*mw(month);
    vflx=vflx+sum(ncgetvar([prefix sdate '.nc'],'vflx'),3)*mw(month);
    time=time+ncgetvar([prefix sdate '.nc'],'time')*mw(month);
  end
  psi=micom_strmf(uflx,vflx,180,384,nreg);
  psi(find(psi_mask==0))=nan;
  psi(isnan(psi))=fill_value;
  psi=psi(:,1:end-1);
  netcdf.putVar(ncid,time_varid,n-1,1,time);
  netcdf.putVar(ncid,psi_varid,[0 0 n-1],[nx ny 1],single(psi));
end

% Close netcdf file
netcdf.close(ncid)

