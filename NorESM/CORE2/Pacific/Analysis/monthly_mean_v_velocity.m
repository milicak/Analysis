% this subroutine computes annual mean vvel
clear all

%expid='NOIIA_T62_tn11_bblsr10m30d_01';
expid='NOIIA_T62_tn11_sr10m60d_02';
datesep='-';
%grid_file='/work/shared/noresm/inputdata/ocn/micom/tnx1v1/20120120/grid.nc';
grid_file='/home/fimm/bjerknes/milicak/Analysis/NorESM/climatology/Analysis/grid.nc';
fyear=256;
lyear=300;
fill_value=-1e33;
depth_limit=1000;

%prefix=['/hexagon/work/matsbn/archive/' expid '/ocn/hist/' expid '.micom.hm.'];
prefix=['/export/grunchfs/green/matsbn/archive/' expid '/ocn/hist/' expid '.micom.hm.'];

outpath='/bcmhsm/milicak/RUNS/noresm/CORE2/Pacific/';

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Get dimensions and time attributes
sdate=sprintf('%4.4d%c%2.2d',fyear,datesep,1);
nx=ncgetdim([prefix sdate '.nc'],'x');
ny=ncgetdim([prefix sdate '.nc'],'y');
nz_level=ncgetdim([prefix sdate '.nc'],'depth');
% Get time invariant variables
time_invariant_file=[outpath '/' expid '_time_invariant.nc'];
rho0=ncgetvar(time_invariant_file,'rho0');
parea=ncgetvar(time_invariant_file,'parea');
udy=ncgetvar(time_invariant_file,'udy');
vdx=ncgetvar(time_invariant_file,'vdx');
pdz=ncgetvar(time_invariant_file,'pdz');
udz=ncgetvar(time_invariant_file,'udz');
vdz=ncgetvar(time_invariant_file,'vdz');

% Get neighbor indexes
inw=ncgetvar(grid_file,'inw');
jnw=ncgetvar(grid_file,'jnw');
ins=ncgetvar(grid_file,'ins');
jns=ncgetvar(grid_file,'jns');
ine=ncgetvar(grid_file,'ine');
jne=ncgetvar(grid_file,'jne');
inn=ncgetvar(grid_file,'inn');
jnn=ncgetvar(grid_file,'jnn');
indw=sub2ind([nx ny nz_level], ...
             reshape(inw(:)*ones(1,nz_level),nx,ny,nz_level), ...
             reshape(jnw(:)*ones(1,nz_level),nx,ny,nz_level), ...
             reshape(ones(nx*ny,1)*(1:nz_level),nx,ny,nz_level));
inds=sub2ind([nx ny nz_level], ...
             reshape(ins(:)*ones(1,nz_level),nx,ny,nz_level), ...
             reshape(jns(:)*ones(1,nz_level),nx,ny,nz_level), ...
             reshape(ones(nx*ny,1)*(1:nz_level),nx,ny,nz_level));
inde=sub2ind([nx ny nz_level], ...
             reshape(ine(:)*ones(1,nz_level),nx,ny,nz_level), ...
             reshape(jne(:)*ones(1,nz_level),nx,ny,nz_level), ...
             reshape(ones(nx*ny,1)*(1:nz_level),nx,ny,nz_level));
indn=sub2ind([nx ny nz_level], ...
             reshape(inn(:)*ones(1,nz_level),nx,ny,nz_level), ...
             reshape(jnn(:)*ones(1,nz_level),nx,ny,nz_level), ...
             reshape(ones(nx*ny,1)*(1:nz_level),nx,ny,nz_level));
[ii jj]=ind2sub([nx ny],1:nx*ny);
indu=sub2ind([nx ny nz_level], ...
             reshape(ii(:)*ones(1,nz_level),nx,ny,nz_level), ...
             reshape(jj(:)*ones(1,nz_level),nx,ny,nz_level), ...
             reshape(ones(nx*ny,1)*[1 (1:nz_level-1)],nx,ny,nz_level));

% Compute conversion factors to get from mass flux to velocity
ufac=1./(rho0*reshape(udy(:)*ones(1,nz_level),nx,ny,nz_level).*udz);
vfac=1./(rho0*reshape(vdx(:)*ones(1,nz_level),nx,ny,nz_level).*vdz);
ufac(find(udz==0))=0;
vfac(find(vdz==0))=0;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Get dimensions and time attributes
sdate=sprintf('%4.4d%c%2.2d',fyear,datesep,1);
nx=ncgetdim([prefix sdate '.nc'],'x');
ny=ncgetdim([prefix sdate '.nc'],'y');
zdepth=ncgetvar([prefix sdate '.nc'],'depth');
zdepth_bnds=ncgetvar([prefix sdate '.nc'],'depth_bnds');
%depth=ncgetdim([prefix sdate '.nc'],'depth');
kind=max(find(zdepth<=depth_limit));
depth=kind;
zdepth=zdepth(1:kind);
zdepth_bnds=zdepth_bnds(:,1:kind);
ny=ny-1;
time_long_name=ncgetatt([prefix sdate '.nc'],'long_name','time');
time_units=ncgetatt([prefix sdate '.nc'],'units','time');
time_calendar=ncgetatt([prefix sdate '.nc'],'calendar','time');

% Read grid information
vlon=ncgetvar(grid_file,'vlon');
vlat=ncgetvar(grid_file,'vlat');
varea=ncgetvar(grid_file,'varea');
vclon=ncgetvar(grid_file,'vclon');
vclat=ncgetvar(grid_file,'vclat');
vlon=vlon(:,1:end-1);
vlat=vlat(:,1:end-1);
varea=varea(:,1:end-1);
vclon=permute(vclon(:,1:end-1,:),[3 1 2]);
vclat=permute(vclat(:,1:end-1,:),[3 1 2]);

% Create netcdf file.
ncid=netcdf.create(['/bcmhsm/milicak/RUNS/noresm/CORE2/Pacific/' expid '_v_velocity_monthly_' num2str(fyear) '-' num2str(lyear) '.nc'],'NC_CLOBBER');

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

tlon_varid=netcdf.defVar(ncid,'VLON','float',[ni_dimid nj_dimid]);
netcdf.putAtt(ncid,tlon_varid,'long_name','V grid center longitude');
netcdf.putAtt(ncid,tlon_varid,'units','degrees_east');
netcdf.putAtt(ncid,tlon_varid,'bounds','lont_bounds');

tlat_varid=netcdf.defVar(ncid,'VLAT','float',[ni_dimid nj_dimid]);
netcdf.putAtt(ncid,tlat_varid,'long_name','V grid center latitude');
netcdf.putAtt(ncid,tlat_varid,'units','degrees_north');
netcdf.putAtt(ncid,tlat_varid,'bounds','latt_bounds');

depth_varid=netcdf.defVar(ncid,'depth','float',[nz_dimid]);
netcdf.putAtt(ncid,depth_varid,'long_name','z level');
netcdf.putAtt(ncid,depth_varid,'units','m');
netcdf.putAtt(ncid,depth_varid,'bounds','depth_bounds');

tarea_varid=netcdf.defVar(ncid,'varea','float',[ni_dimid nj_dimid]);
netcdf.putAtt(ncid,tarea_varid,'long_name','area of V grid cells');
netcdf.putAtt(ncid,tarea_varid,'units','m^2');
netcdf.putAtt(ncid,tarea_varid,'coordinates','VLON VLAT');

lont_bounds_varid=netcdf.defVar(ncid,'lont_bounds','float',[nvertices_dimid ni_dimid nj_dimid]);
netcdf.putAtt(ncid,lont_bounds_varid,'long_name','longitude boundaries of V cells');
netcdf.putAtt(ncid,lont_bounds_varid,'units','degrees_east');

latt_bounds_varid=netcdf.defVar(ncid,'latt_bounds','float',[nvertices_dimid ni_dimid nj_dimid]);
netcdf.putAtt(ncid,latt_bounds_varid,'long_name','latitude boundaries of V cells');
netcdf.putAtt(ncid,latt_bounds_varid,'units','degrees_north');

depth_bounds_varid=netcdf.defVar(ncid,'depth_bounds','float',[nzvertices_dimid nz_dimid]);
netcdf.putAtt(ncid,depth_bounds_varid,'long_name','vertical boundaries of V cells');
netcdf.putAtt(ncid,depth_bounds_varid,'units','m');

vvel_varid=netcdf.defVar(ncid,'vvel','float',[ni_dimid nj_dimid nz_dimid time_dimid]);
netcdf.putAtt(ncid,vvel_varid,'long_name','Ocean velocity component in y-direction');
netcdf.putAtt(ncid,vvel_varid,'units','m s-1');
netcdf.putAtt(ncid,vvel_varid,'_FillValue',single(fill_value));
netcdf.putAtt(ncid,vvel_varid,'coordinates','VLON VLAT');
netcdf.putAtt(ncid,vvel_varid,'cell_measures','area: varea');

vveltd_varid=netcdf.defVar(ncid,'vvel_td','float',[ni_dimid nj_dimid nz_dimid time_dimid]);
netcdf.putAtt(ncid,vveltd_varid,'long_name','Ocean velocity component in y-direction due to thickness diffusion');
netcdf.putAtt(ncid,vveltd_varid,'units','m s-1');
netcdf.putAtt(ncid,vveltd_varid,'_FillValue',single(fill_value));
netcdf.putAtt(ncid,vveltd_varid,'coordinates','ULON ULAT');
netcdf.putAtt(ncid,vveltd_varid,'cell_measures','area: uarea');


% Global attributes

% End definitions and leave define mode.
netcdf.endDef(ncid)

% Provide values for time invariant variables.
netcdf.putVar(ncid,tlon_varid,single(vlon));
netcdf.putVar(ncid,tlat_varid,single(vlat));
netcdf.putVar(ncid,tarea_varid,single(varea));
netcdf.putVar(ncid,lont_bounds_varid,single(vclon));
netcdf.putVar(ncid,latt_bounds_varid,single(vclat));
netcdf.putVar(ncid,depth_bounds_varid,single(zdepth_bnds));
netcdf.putVar(ncid,depth_varid,single(zdepth));

% Retrieve mixed layer depths and write to netcdf variables
n=0;
for year=fyear:lyear
  for month=1:12
    n=n+1;
    sdate=sprintf('%4.4d%c%2.2d',year,datesep,month);
    disp(sdate)
    tmp=ncgetvar([prefix sdate '.nc'],'vflxlvl');
    tmp(find(isnan(tmp)))=0;
    % Convert mass flux to velocity
    tmp2=tmp.*vfac;
    vvel=tmp2(:,1:end-1,1:kind);
    tmp=ncgetvar([prefix sdate '.nc'],'vmfltdlvl');
    tmp(find(isnan(tmp)))=0;
    % Convert mass flux to velocity
    tmp2=tmp.*vfac;
    vveltd=tmp2(:,1:end-1,1:kind);
    tmp=ncgetvar([prefix sdate '.nc'],'time');
    time=tmp;
    vvel(isnan(vvel))=fill_value;
    vveltd(isnan(vveltd))=fill_value;
    netcdf.putVar(ncid,time_varid,n-1,1,single(time));
    netcdf.putVar(ncid,vvel_varid,[0 0 0 n-1],[nx ny depth 1],single(vvel));
    netcdf.putVar(ncid,vveltd_varid,[0 0 0 n-1],[nx ny depth 1],single(vveltd));
  end
end


% Close netcdf file
netcdf.close(ncid)

