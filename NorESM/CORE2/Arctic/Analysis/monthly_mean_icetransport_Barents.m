% this subroutine computes monthly mean heat flux at Barents strait
clear all

%expid='NOIIA_T62_tn11_bblsr10m30d_01';
expid='NOIIA_T62_tn11_sr10m60d_01';
datesep='-';
%grid_file='/work/shared/noresm/inputdata/ocn/micom/tnx1v1/20120120/grid.nc';
grid_file='/home/fimm/bjerknes/milicak/Analysis/NorESM/climatology/Analysis/grid.nc';
fyear=1;
lyear=300;
fill_value=-1e33;
rhoice=917;

prefix=['/hexagon/work/matsbn/archive/' expid '/ice/hist/' expid '.cice.h.'];

% Get dimensions and time attributes
sdate=sprintf('%4.4d%c%2.2d',fyear,datesep,1);
time_long_name=ncgetatt([prefix sdate '.nc'],'long_name','time');
time_units=ncgetatt([prefix sdate '.nc'],'units','time');
time_calendar=ncgetatt([prefix sdate '.nc'],'calendar','time');

%Barents Strait Location
barents=[113 352  1  0
113 352  0  1
114 351  1  0
114 351  0  1
115 350  1  0
115 349  1  0
115 349  0  1
116 348  1  0
116 348  0  1
117 347  1  0
117 346  1  0
117 346  0  1
118 345  1  0
118 345  0  1
119 344  1  0
119 343  1  0
119 343  0  1
120 342  1  0
120 342  0  1
121 341  1  0
121 340  1  0
121 340  0  1
122 339  1  0
122 338  1  0];

nx=1;
ny=1;


% Create netcdf file.
%ncid=netcdf.create([expid '_temperature_annual_' num2str(fyear) '-' num2str(lyear) '.nc'],'NC_CLOBBER');
%ncid=netcdf.create(['/work/milicak/RUNS/noresm/CORE2/CORE2_files/SSH/' expid '_temperature_annual_' num2str(fyear) '-' num2str(lyear) '.nc'],'NC_CLOBBER');
ncid=netcdf.create(['/bcmhsm/milicak/RUNS/noresm/CORE2/Arctic/' expid '_ice_transport_Barents_monthly_' num2str(fyear) '-' num2str(lyear) '.nc'],'NC_CLOBBER');

% Define dimensions.
ni_dimid=netcdf.defDim(ncid,'ni',nx);
time_dimid=netcdf.defDim(ncid,'time',netcdf.getConstant('NC_UNLIMITED'));
nvertices_dimid=netcdf.defDim(ncid,'nvertices',4);
nzvertices_dimid=netcdf.defDim(ncid,'nzvertices',2);

% Define variables and assign attributes
time_varid=netcdf.defVar(ncid,'time','float',time_dimid);
netcdf.putAtt(ncid,time_varid,'long_name',time_long_name);
netcdf.putAtt(ncid,time_varid,'units',time_units);
netcdf.putAtt(ncid,time_varid,'calendar',time_calendar);

icetrin_varid=netcdf.defVar(ncid,'icetr_in','float',[ni_dimid time_dimid]);
netcdf.putAtt(ncid,icetrin_varid,'long_name','Northward ice volume transport');
netcdf.putAtt(ncid,icetrin_varid,'units','m3/s');
netcdf.putAtt(ncid,icetrin_varid,'_FillValue',single(fill_value));

icetrout_varid=netcdf.defVar(ncid,'icetr_out','float',[ni_dimid time_dimid]);
netcdf.putAtt(ncid,icetrout_varid,'long_name','Southward ice volume transport');
netcdf.putAtt(ncid,icetrout_varid,'units','m3/s');
netcdf.putAtt(ncid,icetrout_varid,'_FillValue',single(fill_value));

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
    tmp=ncgetvar([prefix sdate '.nc'],'transix');    
    tmp4=ncgetvar([prefix sdate '.nc'],'transiy');    
    for k=1:size(barents,1)    
      dnm=tmp(barents(k,1)-1,barents(k,2),:);
      dnm(isnan(dnm))=0;
      dnm2=tmp4(barents(k,1),barents(k,2)-1,:);
      dnm2(isnan(dnm2))=0; 
      tmp2(k,:)=dnm.*barents(k,3)+dnm2.*barents(k,4);
    end
    tmp2=tmp2./rhoice;
    icetrin=nansum(tmp2(tmp2>0.0));
    icetrout=nansum(tmp2(tmp2<0.0));

    tmp=ncgetvar([prefix sdate '.nc'],'time');
    time=tmp;
    icetrin(isnan(icetrin))=fill_value;
    icetrout(isnan(icetrout))=fill_value;
    icetrin(isempty(icetrin))=fill_value;
    icetrout(isempty(icetrout))=fill_value;
    
    netcdf.putVar(ncid,time_varid,n-1,1,single(time));
    netcdf.putVar(ncid,icetrin_varid,[0 n-1],[nx 1],single(icetrin));
    netcdf.putVar(ncid,icetrout_varid,[0 n-1],[nx 1],single(icetrout));
  end
end


% Close netcdf file
netcdf.close(ncid)

