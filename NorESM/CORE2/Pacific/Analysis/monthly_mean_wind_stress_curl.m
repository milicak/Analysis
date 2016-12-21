clear all

expid='NOIIA_T62_tn11_sr10m60d_02';
datesep='-';
%grid_file='/work/shared/noresm/inputdata/ocn/micom/tnx1v1/20120120/grid.nc';
grid_file='/home/fimm/bjerknes/milicak/Analysis/NorESM/climatology/Analysis/grid.nc';
fyear=256;
lyear=300;
fill_value=-1e33;

%prefix=['/hexagon/work/milicak/archive/' expid '/ocn/hist/' expid '.micom.hm.'];
prefix=['/export/grunchfs/green/matsbn/archive/' expid '/ocn/hist/' expid '.micom.hm.'];

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
ulon=ncgetvar(grid_file,'ulon');
ulat=ncgetvar(grid_file,'ulat');
uarea=ncgetvar(grid_file,'uarea');
vlon=ncgetvar(grid_file,'vlon');
vlat=ncgetvar(grid_file,'vlat');
varea=ncgetvar(grid_file,'varea');
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
ncid=netcdf.create(['/bcmhsm/milicak/RUNS/noresm/CORE2/Pacific/' expid '_wind_stress_curl_monthly_' num2str(fyear) '-' num2str(lyear) '.nc'],'NC_CLOBBER');

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

ulon_varid=netcdf.defVar(ncid,'ULON','double',[ni_dimid nj_dimid]);
netcdf.putAtt(ncid,ulon_varid,'long_name','U grid center longitude');
netcdf.putAtt(ncid,ulon_varid,'units','degrees_east');
netcdf.putAtt(ncid,ulon_varid,'bounds','lont_bounds');

vlon_varid=netcdf.defVar(ncid,'VLON','double',[ni_dimid nj_dimid]);
netcdf.putAtt(ncid,vlon_varid,'long_name','V grid center longitude');
netcdf.putAtt(ncid,vlon_varid,'units','degrees_east');
netcdf.putAtt(ncid,vlon_varid,'bounds','lont_bounds');

tlat_varid=netcdf.defVar(ncid,'TLAT','double',[ni_dimid nj_dimid]);
netcdf.putAtt(ncid,tlat_varid,'long_name','T grid center latitude');
netcdf.putAtt(ncid,tlat_varid,'units','degrees_north');
netcdf.putAtt(ncid,tlat_varid,'bounds','latt_bounds');

ulat_varid=netcdf.defVar(ncid,'ULAT','double',[ni_dimid nj_dimid]);
netcdf.putAtt(ncid,ulat_varid,'long_name','U grid center latitude');
netcdf.putAtt(ncid,ulat_varid,'units','degrees_north');
netcdf.putAtt(ncid,ulat_varid,'bounds','latt_bounds');

vlat_varid=netcdf.defVar(ncid,'VLAT','double',[ni_dimid nj_dimid]);
netcdf.putAtt(ncid,vlat_varid,'long_name','V grid center latitude');
netcdf.putAtt(ncid,vlat_varid,'units','degrees_north');
netcdf.putAtt(ncid,vlat_varid,'bounds','latt_bounds');

tarea_varid=netcdf.defVar(ncid,'tarea','double',[ni_dimid nj_dimid]);
netcdf.putAtt(ncid,tarea_varid,'long_name','area of T grid cells');
netcdf.putAtt(ncid,tarea_varid,'units','m^2');
netcdf.putAtt(ncid,tarea_varid,'coordinates','TLON TLAT');

uarea_varid=netcdf.defVar(ncid,'uarea','double',[ni_dimid nj_dimid]);
netcdf.putAtt(ncid,uarea_varid,'long_name','area of U grid cells');
netcdf.putAtt(ncid,uarea_varid,'units','m^2');
netcdf.putAtt(ncid,uarea_varid,'coordinates','ULON ULAT');

varea_varid=netcdf.defVar(ncid,'varea','double',[ni_dimid nj_dimid]);
netcdf.putAtt(ncid,varea_varid,'long_name','area of V grid cells');
netcdf.putAtt(ncid,varea_varid,'units','m^2');
netcdf.putAtt(ncid,varea_varid,'coordinates','VLON VLAT');

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

taux_varid=netcdf.defVar(ncid,'taux','float',[ni_dimid nj_dimid time_dimid]);
netcdf.putAtt(ncid,taux_varid,'long_name','wind stress x-component');
netcdf.putAtt(ncid,taux_varid,'units','N m-2');
netcdf.putAtt(ncid,taux_varid,'_FillValue',single(fill_value));
netcdf.putAtt(ncid,taux_varid,'coordinates','ULON ULAT');
netcdf.putAtt(ncid,taux_varid,'cell_measures','area: uarea');

tauy_varid=netcdf.defVar(ncid,'tauy','float',[ni_dimid nj_dimid time_dimid]);
netcdf.putAtt(ncid,tauy_varid,'long_name','wind stress xy-component');
netcdf.putAtt(ncid,tauy_varid,'units','N m-2');
netcdf.putAtt(ncid,tauy_varid,'_FillValue',single(fill_value));
netcdf.putAtt(ncid,tauy_varid,'coordinates','VLON VLAT');
netcdf.putAtt(ncid,tauy_varid,'cell_measures','area: varea');

% Global attributes

% End definitions and leave define mode.
netcdf.endDef(ncid)

% Provide values for time invariant variables.
netcdf.putVar(ncid,tlon_varid,qlon);
netcdf.putVar(ncid,tlat_varid,qlat);
netcdf.putVar(ncid,tarea_varid,qarea);
netcdf.putVar(ncid,ulon_varid,ulon);
netcdf.putVar(ncid,ulat_varid,ulat);
netcdf.putVar(ncid,uarea_varid,uarea);
netcdf.putVar(ncid,vlon_varid,vlon);
netcdf.putVar(ncid,vlat_varid,vlat);
netcdf.putVar(ncid,varea_varid,varea);
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
    taux(isnan(taux))=fill_value;
    tauy(isnan(tauy))=fill_value;
    netcdf.putVar(ncid,time_varid,n-1,1,time);
    netcdf.putVar(ncid,taucurl_varid,[0 0 n-1],[nx ny 1],single(taucurl));
    netcdf.putVar(ncid,taux_varid,[0 0 n-1],[nx ny 1],single(taux));
    netcdf.putVar(ncid,tauy_varid,[0 0 n-1],[nx ny 1],single(tauy));
  end %month
end

% Close netcdf file
netcdf.close(ncid)

