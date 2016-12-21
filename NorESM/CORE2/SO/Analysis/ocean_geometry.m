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
pmask=ncgetvar(grid_file,'pmask');
pclon=ncgetvar(grid_file,'pclon');
pclat=ncgetvar(grid_file,'pclat');
plon=plon(:,1:end-1);
plat=plat(:,1:end-1);
parea=parea(:,1:end-1);
pmask=pmask(:,1:end-1);
parea(pmask==0)=0; % land mask built into areas

% Read world ocean mask of destination grid
mask_file='world_ocean_mask.dat';
fid=fopen(mask_file,'r');
nx1=fscanf(fid,'%d',1);
ny1=fscanf(fid,'%d',1);
world_ocean_mask_a=reshape(fscanf(fid,'%1d'),ny1,nx1)';
fclose(fid);
world_ocean_mask_a(find(world_ocean_mask_a==3))=2;
world_ocean_mask_a=world_ocean_mask_a(:,1:end-1);

parea3d=repmat(parea,[1 1 sigma]);
pclon=permute(pclon(:,1:end-1,:),[3 1 2]);
pclat=permute(pclat(:,1:end-1,:),[3 1 2]);

% Create netcdf file.
%ncid=netcdf.create([expid '_temperature_annual_' num2str(fyear) '-' num2str(lyear) '.nc'],'NC_CLOBBER');
%ncid=netcdf.create(['/work/milicak/RUNS/noresm/CORE2/CORE2_files/SSH/' expid '_temperature_annual_' num2str(fyear) '-' num2str(lyear) '.nc'],'NC_CLOBBER');
ncid=netcdf.create(['/bcmhsm/milicak/RUNS/noresm/CORE2/SSH/' expid '_NorESM_model_geometry_' num2str(fyear) '-' num2str(lyear) '.nc'],'NC_CLOBBER');

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

tmask_varid=netcdf.defVar(ncid,'TMASK','float',[ni_dimid nj_dimid]);
netcdf.putAtt(ncid,tmask_varid,'long_name','T grid center mask');
netcdf.putAtt(ncid,tmask_varid,'units','mask=0 for land; mask=1 for ocean; mask=2 for Black Sea and Caspian Sea');

sigma_varid=netcdf.defVar(ncid,'sigma','float',[nz_dimid]);
netcdf.putAtt(ncid,sigma_varid,'long_name','Potential density');
netcdf.putAtt(ncid,sigma_varid,'units','kg m-3');

tarea_varid=netcdf.defVar(ncid,'tarea','float',[ni_dimid nj_dimid nz_dimid]);
netcdf.putAtt(ncid,tarea_varid,'long_name','area of T grid cells');
netcdf.putAtt(ncid,tarea_varid,'units','m^2');
netcdf.putAtt(ncid,tarea_varid,'coordinates','TLON TLAT');

lont_bounds_varid=netcdf.defVar(ncid,'lont_bounds','float',[nvertices_dimid ni_dimid nj_dimid]);
netcdf.putAtt(ncid,lont_bounds_varid,'long_name','longitude boundaries of T cells');
netcdf.putAtt(ncid,lont_bounds_varid,'units','degrees_east');

latt_bounds_varid=netcdf.defVar(ncid,'latt_bounds','float',[nvertices_dimid ni_dimid nj_dimid]);
netcdf.putAtt(ncid,latt_bounds_varid,'long_name','latitude boundaries of T cells');
netcdf.putAtt(ncid,latt_bounds_varid,'units','degrees_north');

dp_varid=netcdf.defVar(ncid,'dp','float',[ni_dimid nj_dimid nz_dimid time_dimid]);
netcdf.putAtt(ncid,dp_varid,'long_name','Layer pressure thickness');
netcdf.putAtt(ncid,dp_varid,'units','Pa');
netcdf.putAtt(ncid,dp_varid,'_FillValue',single(fill_value));
netcdf.putAtt(ncid,dp_varid,'coordinates','TLON TLAT');
netcdf.putAtt(ncid,dp_varid,'cell_measures','area: tarea');

dz_varid=netcdf.defVar(ncid,'dz','float',[ni_dimid nj_dimid nz_dimid time_dimid]);
netcdf.putAtt(ncid,dz_varid,'long_name','Layer thickness');
netcdf.putAtt(ncid,dz_varid,'units','m');
netcdf.putAtt(ncid,dz_varid,'_FillValue',single(fill_value));
netcdf.putAtt(ncid,dz_varid,'coordinates','TLON TLAT');
netcdf.putAtt(ncid,dz_varid,'cell_measures','area: tarea');

vol_varid=netcdf.defVar(ncid,'volume','float',[ni_dimid nj_dimid nz_dimid time_dimid]);
netcdf.putAtt(ncid,vol_varid,'long_name','Ocean volume');
netcdf.putAtt(ncid,vol_varid,'units','m3');
netcdf.putAtt(ncid,vol_varid,'_FillValue',single(fill_value));
netcdf.putAtt(ncid,vol_varid,'coordinates','TLON TLAT');
netcdf.putAtt(ncid,vol_varid,'cell_measures','area: tarea');

% Global attributes

% End definitions and leave define mode.
netcdf.endDef(ncid)

% Provide values for time invariant variables.
netcdf.putVar(ncid,tlon_varid,single(plon));
netcdf.putVar(ncid,tlat_varid,single(plat));
netcdf.putVar(ncid,tarea_varid,single(parea3d));
netcdf.putVar(ncid,tmask_varid,single(world_ocean_mask_a));
netcdf.putVar(ncid,lont_bounds_varid,single(pclon));
netcdf.putVar(ncid,latt_bounds_varid,single(pclat));
netcdf.putVar(ncid,sigma_varid,single(sigma2));

n=0;
for year=fyear:lyear
  n=n+1;
  dz=zeros(nx,ny,sigma);
  dp=zeros(nx,ny,sigma);
  time=0;
  for month=1:12
    sdate=sprintf('%4.4d%c%2.2d',year,datesep,month);
    disp(sdate)
    tmp=ncgetvar([prefix sdate '.nc'],'dz');
    tmp2=ncgetvar([prefix sdate '.nc'],'dp');
    dz=dz+tmp(:,1:end-1,:);
    dp=dp+tmp2(:,1:end-1,:);
    tmp=ncgetvar([prefix sdate '.nc'],'time');
    time=time+tmp;
  end
  dp=dp/12;
  dz=dz/12;
  time=time/12;
  vol=parea3d.*dz;
  dz(isnan(dz))=fill_value;
  dp(isnan(dp))=fill_value;
  vol(isnan(vol))=fill_value;
  netcdf.putVar(ncid,time_varid,n-1,1,single(time));
  netcdf.putVar(ncid,dz_varid,[0 0 0 n-1],[nx ny sigma 1],single(dz));
  netcdf.putVar(ncid,dp_varid,[0 0 0 n-1],[nx ny sigma 1],single(dp));
  netcdf.putVar(ncid,vol_varid,[0 0 0 n-1],[nx ny sigma 1],single(vol));
end

% Close netcdf file
netcdf.close(ncid)

