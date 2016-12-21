% this subroutine computes monthly mean net mass flux which is
% sum of precip (lip+sop) + eva (eva) + melt (fmltfz) + river (rnf+rfi)
clear all

%expid='NOIIA_T62_tn11_bblsr10m30d_01';
expid='NOIIA_T62_tn11_sr10m60d_02';
datesep='-';
%grid_file='/work/shared/noresm/inputdata/ocn/micom/tnx1v1/20120120/grid.nc';
grid_file='/home/fimm/bjerknes/milicak/Analysis/NorESM/climatology/Analysis/grid.nc';
fyear=241;
lyear=300;
fill_value=-1e33;

%prefix=['/hexagon/work/milicak/archive/' expid '/ocn/hist/' expid '.micom.hm.'];
prefix=['/export/grunchfs/green/matsbn/archive/' expid '/ocn/hist/' expid '.micom.hm.'];

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
ncid=netcdf.create(['/bcmhsm/milicak/RUNS/noresm/CORE2/Indian/' expid '_heat_transport_components_monthly_' num2str(fyear) '-' num2str(lyear) '.nc'],'NC_CLOBBER');

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

uhfluxtd_varid=netcdf.defVar(ncid,'uhflux_td','float',[ni_dimid nj_dimid time_dimid]);
netcdf.putAtt(ncid,uhfluxtd_varid,'long_name','zonal heat transport due to thickness diffusion');
netcdf.putAtt(ncid,uhfluxtd_varid,'units','Watts');
netcdf.putAtt(ncid,uhfluxtd_varid,'_FillValue',single(fill_value));
netcdf.putAtt(ncid,uhfluxtd_varid,'coordinates','TLON TLAT');
netcdf.putAtt(ncid,uhfluxtd_varid,'cell_measures','area: tarea');

vhfluxtd_varid=netcdf.defVar(ncid,'vhflux_td','float',[ni_dimid nj_dimid time_dimid]);
netcdf.putAtt(ncid,vhfluxtd_varid,'long_name','meridional heat transport due to thickness diffusion');
netcdf.putAtt(ncid,vhfluxtd_varid,'units','Watts');
netcdf.putAtt(ncid,vhfluxtd_varid,'_FillValue',single(fill_value));
netcdf.putAtt(ncid,vhfluxtd_varid,'coordinates','TLON TLAT');
netcdf.putAtt(ncid,vhfluxtd_varid,'cell_measures','area: tarea');

uhfluxld_varid=netcdf.defVar(ncid,'uhflux_ld','float',[ni_dimid nj_dimid time_dimid]);
netcdf.putAtt(ncid,uhfluxld_varid,'long_name','zonal heat transport due to lateral diffusion');
netcdf.putAtt(ncid,uhfluxld_varid,'units','Watts');
netcdf.putAtt(ncid,uhfluxld_varid,'_FillValue',single(fill_value));
netcdf.putAtt(ncid,uhfluxld_varid,'coordinates','TLON TLAT');
netcdf.putAtt(ncid,uhfluxld_varid,'cell_measures','area: tarea');

vhfluxld_varid=netcdf.defVar(ncid,'vhflux_ld','float',[ni_dimid nj_dimid time_dimid]);
netcdf.putAtt(ncid,vhfluxld_varid,'long_name','meridional heat transport due to lateral diffusion');
netcdf.putAtt(ncid,vhfluxld_varid,'units','Watts');
netcdf.putAtt(ncid,vhfluxld_varid,'_FillValue',single(fill_value));
netcdf.putAtt(ncid,vhfluxld_varid,'coordinates','TLON TLAT');
netcdf.putAtt(ncid,vhfluxld_varid,'cell_measures','area: tarea');

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
    tmp=ncgetvar([prefix sdate '.nc'],'uhfltd');
    tmp=tmp(:,1:end-1,:);
    uhfltd=squeeze(nansum(tmp,3));
    tmp=ncgetvar([prefix sdate '.nc'],'vhfltd');
    tmp=tmp(:,1:end-1,:);
    vhfltd=squeeze(nansum(tmp,3));
    tmp=ncgetvar([prefix sdate '.nc'],'uhflld');
    tmp=tmp(:,1:end-1,:);
    uhflld=squeeze(nansum(tmp,3));
    tmp=ncgetvar([prefix sdate '.nc'],'vhflld');
    tmp=tmp(:,1:end-1,:);
    vhflld=squeeze(nansum(tmp,3));
    tmp=ncgetvar([prefix sdate '.nc'],'time');
    time=tmp;
    uhfltd(isnan(uhfltd))=fill_value;
    vhfltd(isnan(vhfltd))=fill_value;
    uhflld(isnan(uhflld))=fill_value;
    vhflld(isnan(vhflld))=fill_value;
    netcdf.putVar(ncid,uhfluxtd_varid,[0 0 n-1],[nx ny 1],single(uhfltd));
    netcdf.putVar(ncid,vhfluxtd_varid,[0 0 n-1],[nx ny 1],single(vhfltd));
    netcdf.putVar(ncid,uhfluxld_varid,[0 0 n-1],[nx ny 1],single(uhflld));
    netcdf.putVar(ncid,vhfluxld_varid,[0 0 n-1],[nx ny 1],single(vhflld));
  end
end

% Close netcdf file
netcdf.close(ncid)

