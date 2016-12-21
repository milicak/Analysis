clear all

expid='NOIIA_T62_tn11_sr10m60d_01';
datesep='-';
%grid_file='/work/shared/noresm/inputdata/ocn/micom/tnx1v1/20120120/grid.nc';
grid_file='/home/fimm/bjerknes/milicak/Analysis/NorESM/climatology/Analysis/grid.nc';
fyear=241;
lyear=300;
fill_value=-1e33;

prefix=['/hexagon/work/matsbn/archive/' expid '/ocn/hist/' expid '.micom.hm.'];

% Get dimensions and time attributes
sdate=sprintf('%4.4d%c%2.2d',fyear,datesep,1);
nx=ncgetdim([prefix sdate '.nc'],'x');
ny=ncgetdim([prefix sdate '.nc'],'y');
%ny=ny-1;
time_long_name=ncgetatt([prefix sdate '.nc'],'long_name','time');
time_units=ncgetatt([prefix sdate '.nc'],'units','time');
time_calendar=ncgetatt([prefix sdate '.nc'],'calendar','time');

% Read grid information
qlon=ncgetvar(grid_file,'qlon');
qlat=ncgetvar(grid_file,'qlat');
qarea=ncgetvar(grid_file,'qarea');
qclon=ncgetvar(grid_file,'qclon');
qclat=ncgetvar(grid_file,'qclat');
angle=ncgetvar(grid_file,'angle');
qclon=permute(qclon(:,:,:),[3 1 2]);
qclat=permute(qclat(:,:,:),[3 1 2]);

%qlon=qlon(:,1:end-1);
%qlat=qlat(:,1:end-1);
%qarea=qarea(:,1:end-1);
%qclon=permute(qclon(:,1:end-1,:),[3 1 2]);
%qclat=permute(qclat(:,1:end-1,:),[3 1 2]);
%angle=angle(:,1:end-1);

qdx=ncgetvar(grid_file,'qdx');
qdy=ncgetvar(grid_file,'qdy');
inw=ncgetvar(grid_file,'inw');
jnw=ncgetvar(grid_file,'jnw');
ins=ncgetvar(grid_file,'ins');
jns=ncgetvar(grid_file,'jns');


% Create netcdf file.
%ncid=netcdf.create([expid '_wind_stress_curl_monthly_' num2str(fyear) '-' num2str(lyear) '.nc'],'NC_CLOBBER');
ncid=netcdf.create(['/bcmhsm/milicak/RUNS/noresm/CORE2/SSH/' expid '_wind_stress_curl_monthly_' num2str(fyear) '-' num2str(lyear) '.nc'],'NC_CLOBBER');

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

tlon_varid=netcdf.defVar(ncid,'TLON','double',[ni_dimid nj_dimid]);
netcdf.putAtt(ncid,tlon_varid,'long_name','T grid center longitude');
netcdf.putAtt(ncid,tlon_varid,'units','degrees_east');
netcdf.putAtt(ncid,tlon_varid,'bounds','lont_bounds');

tlat_varid=netcdf.defVar(ncid,'TLAT','double',[ni_dimid nj_dimid]);
netcdf.putAtt(ncid,tlat_varid,'long_name','T grid center latitude');
netcdf.putAtt(ncid,tlat_varid,'units','degrees_north');
netcdf.putAtt(ncid,tlat_varid,'bounds','latt_bounds');

tarea_varid=netcdf.defVar(ncid,'tarea','double',[ni_dimid nj_dimid]);
netcdf.putAtt(ncid,tarea_varid,'long_name','area of T grid cells');
netcdf.putAtt(ncid,tarea_varid,'units','m^2');
netcdf.putAtt(ncid,tarea_varid,'coordinates','TLON TLAT');

lont_bounds_varid=netcdf.defVar(ncid,'lont_bounds','double',[nvertices_dimid ni_dimid nj_dimid]);
netcdf.putAtt(ncid,lont_bounds_varid,'long_name','longitude boundaries of T cells');
netcdf.putAtt(ncid,lont_bounds_varid,'units','degrees_east');

latt_bounds_varid=netcdf.defVar(ncid,'latt_bounds','double',[nvertices_dimid ni_dimid nj_dimid]);
netcdf.putAtt(ncid,latt_bounds_varid,'long_name','latitude boundaries of T cells');
netcdf.putAtt(ncid,latt_bounds_varid,'units','degrees_north');

taucurl_varid=netcdf.defVar(ncid,'taucurl','float',[ni_dimid nj_dimid time_dimid]);
netcdf.putAtt(ncid,taucurl_varid,'long_name','wind stress curl');
netcdf.putAtt(ncid,taucurl_varid,'units','N m-3');
netcdf.putAtt(ncid,taucurl_varid,'_FillValue',single(fill_value));
netcdf.putAtt(ncid,taucurl_varid,'coordinates','TLON TLAT');
netcdf.putAtt(ncid,taucurl_varid,'cell_measures','area: tarea');

% Global attributes

% End definitions and leave define mode.
netcdf.endDef(ncid)

% Provide values for time invariant variables.
netcdf.putVar(ncid,tlon_varid,qlon);
netcdf.putVar(ncid,tlat_varid,qlat);
netcdf.putVar(ncid,tarea_varid,qarea);
netcdf.putVar(ncid,lont_bounds_varid,qclon);
netcdf.putVar(ncid,latt_bounds_varid,qclat);

% Retrieve zonal wind stress and write to netcdf variables
n=0;
for year=fyear:lyear
%  taux=zeros(nx,ny);
%  tauy=zeros(nx,ny);
  for month=1:12
    n=n+1;
    sdate=sprintf('%4.4d%c%2.2d',year,datesep,month);
    disp(sdate)
    tmp=ncgetvar([prefix sdate '.nc'],'taux');
    taux=tmp;
    tmp=ncgetvar([prefix sdate '.nc'],'tauy');
    tauy=tmp;
    tmp=ncgetvar([prefix sdate '.nc'],'time');
    time=tmp;
    for i=1:nx
    for j=1:ny
      tauy_dx(i,j)=(tauy(i,j)-tauy(inw(i,j),jnw(i,j)))./(qdx(i,j));
      taux_dy(i,j)=(taux(i,j)-taux(ins(i,j),jns(i,j)))./(qdy(i,j));
    end
    end
    
    taucurl=tauy_dx-taux_dy;     
    taucurl(isnan(taucurl))=fill_value;
    netcdf.putVar(ncid,time_varid,n-1,1,time);
    netcdf.putVar(ncid,taucurl_varid,[0 0 n-1],[nx ny 1],single(taucurl));
  end %month
end

% Close netcdf file
netcdf.close(ncid)

