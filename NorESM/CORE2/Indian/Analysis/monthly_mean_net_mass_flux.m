% this subroutine computes monthly mean net mass flux which is
% sum of precip (lip+sop) + eva (eva) + melt (fmltfz) + river (rnf+rfi)
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
ncid=netcdf.create(['/bcmhsm/milicak/RUNS/noresm/CORE2/Indian/' expid '_water_salt_fluxes_monthly_' num2str(fyear) '-' num2str(lyear) '.nc'],'NC_CLOBBER');

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

mass_flux_varid=netcdf.defVar(ncid,'mass_flux','float',[ni_dimid nj_dimid time_dimid]);
netcdf.putAtt(ncid,mass_flux_varid,'long_name','Net mass flux');
netcdf.putAtt(ncid,mass_flux_varid,'units','kg m-2 s-1');
netcdf.putAtt(ncid,mass_flux_varid,'_FillValue',single(fill_value));
netcdf.putAtt(ncid,mass_flux_varid,'coordinates','TLON TLAT');
netcdf.putAtt(ncid,mass_flux_varid,'cell_measures','area: tarea');

prep_flux_varid=netcdf.defVar(ncid,'precip','float',[ni_dimid nj_dimid time_dimid]);
netcdf.putAtt(ncid,prep_flux_varid,'long_name','Precipitation');
netcdf.putAtt(ncid,prep_flux_varid,'units','kg m-2 s-1');
netcdf.putAtt(ncid,prep_flux_varid,'_FillValue',single(fill_value));
netcdf.putAtt(ncid,prep_flux_varid,'coordinates','TLON TLAT');
netcdf.putAtt(ncid,prep_flux_varid,'cell_measures','area: tarea');

eva_flux_varid=netcdf.defVar(ncid,'eva','float',[ni_dimid nj_dimid time_dimid]);
netcdf.putAtt(ncid,eva_flux_varid,'long_name','Evaporation');
netcdf.putAtt(ncid,eva_flux_varid,'units','kg m-2 s-1');
netcdf.putAtt(ncid,eva_flux_varid,'_FillValue',single(fill_value));
netcdf.putAtt(ncid,eva_flux_varid,'coordinates','TLON TLAT');
netcdf.putAtt(ncid,eva_flux_varid,'cell_measures','area: tarea');

river_flux_varid=netcdf.defVar(ncid,'river_flux','float',[ni_dimid nj_dimid time_dimid]);
netcdf.putAtt(ncid,river_flux_varid,'long_name','River runoff');
netcdf.putAtt(ncid,river_flux_varid,'units','kg m-2 s-1');
netcdf.putAtt(ncid,river_flux_varid,'_FillValue',single(fill_value));
netcdf.putAtt(ncid,river_flux_varid,'coordinates','TLON TLAT');
netcdf.putAtt(ncid,river_flux_varid,'cell_measures','area: tarea');

icemelt_flux_varid=netcdf.defVar(ncid,'ice_melt','float',[ni_dimid nj_dimid time_dimid]);
netcdf.putAtt(ncid,icemelt_flux_varid,'long_name','Ice melt flux');
netcdf.putAtt(ncid,icemelt_flux_varid,'units','kg m-2 s-1');
netcdf.putAtt(ncid,icemelt_flux_varid,'_FillValue',single(fill_value));
netcdf.putAtt(ncid,icemelt_flux_varid,'coordinates','TLON TLAT');
netcdf.putAtt(ncid,icemelt_flux_varid,'cell_measures','area: tarea');

salt_flux_varid=netcdf.defVar(ncid,'salt_flux','float',[ni_dimid nj_dimid time_dimid]);
netcdf.putAtt(ncid,salt_flux_varid,'long_name','Total salt flux');
netcdf.putAtt(ncid,salt_flux_varid,'units','kg m-2 s-1');
netcdf.putAtt(ncid,salt_flux_varid,'_FillValue',single(fill_value));
netcdf.putAtt(ncid,salt_flux_varid,'coordinates','TLON TLAT');
netcdf.putAtt(ncid,salt_flux_varid,'cell_measures','area: tarea');

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
    tmp=ncgetvar([prefix sdate '.nc'],'lip');
    lip=tmp(:,1:end-1,:);
    tmp=ncgetvar([prefix sdate '.nc'],'sop');
    sop=tmp(:,1:end-1,:);
    Precip=lip+sop;
    tmp=ncgetvar([prefix sdate '.nc'],'eva');
    Eva=tmp(:,1:end-1,:);
    tmp=ncgetvar([prefix sdate '.nc'],'fmltfz');
    Melting=tmp(:,1:end-1,:);
    tmp=ncgetvar([prefix sdate '.nc'],'rnf');
    rnf=tmp(:,1:end-1,:);
    tmp=ncgetvar([prefix sdate '.nc'],'rfi');
    rfi=tmp(:,1:end-1,:);
    River=rnf+rfi;
    tmp=ncgetvar([prefix sdate '.nc'],'sflx');
    sflx=tmp(:,1:end-1,:);
    tmp=ncgetvar([prefix sdate '.nc'],'srflx');
    srflx=tmp(:,1:end-1,:);

    mass_flux=Precip+Eva+Melting+River;
    salt_flux=sflx+srflx;
    tmp=ncgetvar([prefix sdate '.nc'],'time');
    time=tmp;
    mass_flux(isnan(mass_flux))=fill_value;
    Precip(isnan(Precip))=fill_value;
    Eva(isnan(Eva))=fill_value;
    Melting(isnan(Melting))=fill_value;
    River(isnan(River))=fill_value;
    salt_flux(isnan(salt_flux))=fill_value;
    netcdf.putVar(ncid,time_varid,n-1,1,single(time));
    netcdf.putVar(ncid,prep_flux_varid,[0 0 n-1],[nx ny 1],single(Precip));
    netcdf.putVar(ncid,eva_flux_varid,[0 0 n-1],[nx ny 1],single(Eva));
    netcdf.putVar(ncid,river_flux_varid,[0 0 n-1],[nx ny 1],single(River));
    netcdf.putVar(ncid,icemelt_flux_varid,[0 0 n-1],[nx ny 1],single(Melting));
    netcdf.putVar(ncid,mass_flux_varid,[0 0 n-1],[nx ny 1],single(mass_flux));
    netcdf.putVar(ncid,salt_flux_varid,[0 0 n-1],[nx ny 1],single(salt_flux));
  end
end

% Close netcdf file
netcdf.close(ncid)

