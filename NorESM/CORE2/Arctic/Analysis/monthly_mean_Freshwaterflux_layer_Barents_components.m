% this subroutine computes monthly mean heat flux at Barents
clear all

%expid='NOIIA_T62_tn11_bblsr10m30d_01';
expid='NOIIA_T62_tn11_sr10m60d_01';
datesep='-';
%grid_file='/work/shared/noresm/inputdata/ocn/micom/tnx1v1/20120120/grid.nc';
grid_file='/home/fimm/bjerknes/milicak/Analysis/NorESM/climatology/Analysis/grid.nc';
grid_file='/fimm/home/bjerknes/milicak/Analysis/NorESM/climatology/Analysis/grid.nc';
dx=ncgetvar(grid_file,'pdx');
dy=ncgetvar(grid_file,'pdy');
%fyear=1;
fyear=241
lyear=300;
fill_value=-1e33;
Sref=34.8; % reference salinity
mw=[31 28 31 30 31 30 31 31 30 31 30 31]/365;

prefix=['/work-common/shared/bjerknes/milicak/mnt/norstore/NS2345K/noresm/cases/' expid '/ocn/hist/' expid '.micom.hm.'];
%prefix=['/hexagon/work/milicak/archive/' expid '/ocn/hist/' expid '.micom.hm.'];
%prefix=['/export/grunchfs/green/matsbn/archive/' expid '/ocn/hist/' expid '.micom.hm.'];

% Get dimensions and time attributes
sdate=sprintf('%4.4d%c%2.2d',fyear,datesep,1);
nx=ncgetdim([prefix sdate '.nc'],'x');
ny=ncgetdim([prefix sdate '.nc'],'y');
nz=ncgetdim([prefix sdate '.nc'],'depth');
time_long_name=ncgetatt([prefix sdate '.nc'],'long_name','time');
time_units=ncgetatt([prefix sdate '.nc'],'units','time');
time_calendar=ncgetatt([prefix sdate '.nc'],'calendar','time');

%Barents Strait Location
barents=[113 352  1  1
114 351  1  1
115 350  1  0
115 349  1  1
116 348  1  1
117 347  1  0
117 346  1  1
118 345  1  1
119 344  1  0
119 343  1  1
120 342  1  1
121 341  1  0
121 340  1  1
122 339  1  0
122 338  1  0];

nx=1;
ny=1;
nk=length(barents);

% Create netcdf file.
%ncid=netcdf.create([expid '_temperature_annual_' num2str(fyear) '-' num2str(lyear) '.nc'],'NC_CLOBBER');
%ncid=netcdf.create(['/work/milicak/RUNS/noresm/CORE2/CORE2_files/SSH/' expid '_temperature_annual_' num2str(fyear) '-' num2str(lyear) '.nc'],'NC_CLOBBER');
ncid=netcdf.create(['/bcmhsm/milicak/RUNS/noresm/CORE2/Arctic/' expid '_heat_freshwater_layer_Barents_new_monthly_' num2str(fyear) '-' num2str(lyear) '.nc'],'NC_CLOBBER');

% Define dimensions.
ni_dimid=netcdf.defDim(ncid,'ni',nk);
nj_dimid=netcdf.defDim(ncid,'nj',nz);
time_dimid=netcdf.defDim(ncid,'time',netcdf.getConstant('NC_UNLIMITED'));
nvertices_dimid=netcdf.defDim(ncid,'nvertices',4);
nzvertices_dimid=netcdf.defDim(ncid,'nzvertices',2);

% Define variables and assign attributes
time_varid=netcdf.defVar(ncid,'time','float',time_dimid);
netcdf.putAtt(ncid,time_varid,'long_name',time_long_name);
netcdf.putAtt(ncid,time_varid,'units',time_units);
netcdf.putAtt(ncid,time_varid,'calendar',time_calendar);

%vsflxtotal_varid=netcdf.defVar(ncid,'vsflx_total','float',[ni_dimid time_dimid]);
%netcdf.putAtt(ncid,vsflxtotal_varid,'long_name','Total salt flux');
%netcdf.putAtt(ncid,vsflxtotal_varid,'units','kg s-1');
%netcdf.putAtt(ncid,vsflxtotal_varid,'_FillValue',single(fill_value));

saltsec_varid=netcdf.defVar(ncid,'saltsec','float',[ni_dimid nj_dimid time_dimid]);
netcdf.putAtt(ncid,saltsec_varid,'long_name','Total salt');
netcdf.putAtt(ncid,saltsec_varid,'units','psu');
netcdf.putAtt(ncid,saltsec_varid,'_FillValue',single(fill_value));

utransec_varid=netcdf.defVar(ncid,'utransec','float',[ni_dimid nj_dimid time_dimid]);
netcdf.putAtt(ncid,utransec_varid,'long_name','Total transport');
netcdf.putAtt(ncid,utransec_varid,'units','m^2/s');
netcdf.putAtt(ncid,utransec_varid,'_FillValue',single(fill_value));


% Global attributes

% End definitions and leave define mode.
netcdf.endDef(ncid)

% Retrieve mixed layer depths and write to netcdf variables
n=0;
for year=fyear:lyear
  dzsec=zeros(nk,nz);
  saltsec=zeros(nk,nz);
  utransec=zeros(nk,nz);
    n=n+1;

  for month=1:12
    sdate=sprintf('%4.4d%c%2.2d',year,datesep,month);
    disp(sdate)

    tmpu=ncgetvar([prefix sdate '.nc'],'uvellvl');
    tmpv=ncgetvar([prefix sdate '.nc'],'vvellvl');
    saln=ncgetvar([prefix sdate '.nc'],'salnlvl');
    for k=1:size(barents,1)
      tmp3(k,:)=tmpu(barents(k,1),barents(k,2),:).*dx(barents(k,1),barents(k,2)).*barents(k,3) ...
               +tmpv(barents(k,1),barents(k,2),:).*dy(barents(k,1),barents(k,2)).*barents(k,4);
      saltsectmp(k,:)=saln(barents(k,1),barents(k,2),:);
    end
    saltsec=saltsec+saltsectmp.*mw(month);
    utransec=utransec+tmp3.*mw(month);

%    C=(Sref-saltsec)./Sref;
%    FWflux=C.*utransec;

%    Massflxtotal=nansum(utransec(:));
%    FWvflxtotal=nansum(FWflux(:));


  end

    saltsec(isnan(saltsec))=fill_value;
    utransec(isnan(utransec))=fill_value;

    tmp=ncgetvar([prefix sdate '.nc'],'time');
    time=tmp;
    netcdf.putVar(ncid,time_varid,n-1,1,single(time));

    netcdf.putVar(ncid,utransec_varid,[0 0 n-1],[nk nz 1],single(utransec));
    netcdf.putVar(ncid,saltsec_varid,[0 0 n-1],[nk nz 1],single(saltsec));
end

% Close netcdf file
netcdf.close(ncid)

