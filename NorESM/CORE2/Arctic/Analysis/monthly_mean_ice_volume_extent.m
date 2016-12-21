% this subroutine computes monthly mean ice thickness and ice concentration
clear all

%expid='NOIIA_T62_tn11_bblsr10m30d_01';
expid='NOIIA_T62_tn11_sr10m60d_01';
datesep='-';
%grid_file='/work/shared/noresm/inputdata/ocn/micom/tnx1v1/20120120/grid.nc';
grid_file='/home/fimm/bjerknes/milicak/Analysis/NorESM/climatology/Analysis/grid.nc';
%grid_file='/home/uni/milicak/Analysis/NorESM/climatology/Analysis/grid.nc';
fyear=1;
lyear=300;
fill_value=-1e33;

prefix=['/hexagon/work/milicak/archive/' expid '/ocn/hist/' expid '.micom.hm.'];
prefix2=['/hexagon/work/milicak/archive/' expid '/ice/hist/' expid '.cice.h.'];

%prefix=['/work/matsbn/archive/' expid '/ocn/hist/' expid '.micom.hm.'];
%prefix2=['/work/matsbn/archive/' expid '/ice/hist/' expid '.cice.h.'];

% Get dimensions and time attributes
sdate=sprintf('%4.4d%c%2.2d',fyear,datesep,1);
nx=1; %ncgetdim([prefix sdate '.nc'],'x');
%ny=ncgetdim([prefix sdate '.nc'],'y');
%ny=ny-1;
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
%ncid=netcdf.create([expid '_ssh_monthly_' num2str(fyear) '-' num2str(lyear) '.nc'],'NC_CLOBBER');
ncid=netcdf.create(['/bcmhsm/milicak/RUNS/noresm/CORE2/Arctic/' expid '_ice_volume_extent_monthly_' num2str(fyear) '-' num2str(lyear) '.nc'],'NC_CLOBBER');

% Define dimensions.
ni_dimid=netcdf.defDim(ncid,'ni',nx);
%nj_dimid=netcdf.defDim(ncid,'nj',ny);
time_dimid=netcdf.defDim(ncid,'time',netcdf.getConstant('NC_UNLIMITED'));
nvertices_dimid=netcdf.defDim(ncid,'nvertices',4);

% Define variables and assign attributes
time_varid=netcdf.defVar(ncid,'time','float',time_dimid);
netcdf.putAtt(ncid,time_varid,'long_name',time_long_name);
netcdf.putAtt(ncid,time_varid,'units',time_units);
netcdf.putAtt(ncid,time_varid,'calendar',time_calendar);

fice_varid=netcdf.defVar(ncid,'ice_extent','float',[ni_dimid time_dimid]);
netcdf.putAtt(ncid,fice_varid,'long_name','Ice extent');
netcdf.putAtt(ncid,fice_varid,'units','m2');
netcdf.putAtt(ncid,fice_varid,'_FillValue',single(fill_value));

hice_varid=netcdf.defVar(ncid,'ice_volume','float',[ni_dimid time_dimid]);
netcdf.putAtt(ncid,hice_varid,'long_name','Ice volume');
netcdf.putAtt(ncid,hice_varid,'units','m3');
netcdf.putAtt(ncid,hice_varid,'_FillValue',single(fill_value));

% Global attributes

% End definitions and leave define mode.
netcdf.endDef(ncid)


% Retrieve mixed layer depths and write to netcdf variables
n=0;
for year=fyear:lyear
  for month=1:12
    n=n+1;
    sdate=sprintf('%4.4d%c%2.2d',year,datesep,month);
    disp(sdate)
    tmp=ncgetvar([prefix sdate '.nc'],'fice');
    fice=tmp(:,1:end-1,:);
    tmp=ncgetvar([prefix2 sdate '.nc'],'hi');
    hice=tmp(:,1:end,:); % In tripolar grid ice has less grid point
    % Northern Hemisphere
    fice(:,1:end/2)=0; 
    hice(:,1:end/2)=0;
    icevolume=hice.*parea;
    icevolume=nansum(icevolume(:));
    fice(fice<15)=0;
    iceextent=parea(fice>=15);
    iceextent=nansum(iceextent);
    tmp=ncgetvar([prefix sdate '.nc'],'time');
    time=tmp;
    fice(isnan(fice))=fill_value;
    hice(isnan(hice))=fill_value;
    netcdf.putVar(ncid,time_varid,n-1,1,single(time));
    netcdf.putVar(ncid,fice_varid,[0 n-1],[nx 1],single(iceextent));
    netcdf.putVar(ncid,hice_varid,[0 n-1],[nx 1],single(icevolume));
  end
end

% Close netcdf file
netcdf.close(ncid)

