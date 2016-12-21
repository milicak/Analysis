% this subroutine computes monthly mean heat flux at Fram strait
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


%Fram Strait Location
fram=[ 94 360  0  1
 95 360  0  1
 96 360  0  1
 97 360  0  1
 98 360  0  1
 99 360  0  1
100 360  0  1
101 359  1  0
101 359  0  1
102 359  0  1
103 359  0  1
104 359  0  1
105 359  0  1];

nx=1;
ny=1;


% Create netcdf file.
%ncid=netcdf.create([expid '_temperature_annual_' num2str(fyear) '-' num2str(lyear) '.nc'],'NC_CLOBBER');
%ncid=netcdf.create(['/work/milicak/RUNS/noresm/CORE2/CORE2_files/SSH/' expid '_temperature_annual_' num2str(fyear) '-' num2str(lyear) '.nc'],'NC_CLOBBER');
ncid=netcdf.create(['/bcmhsm/milicak/RUNS/noresm/CORE2/Arctic/' expid '_ice_transport_Fram_monthly_' num2str(fyear) '-' num2str(lyear) '.nc'],'NC_CLOBBER');

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
    for k=1:size(fram,1)    
      dnm=tmp(fram(k,1)-1,fram(k,2),:);
      dnm(isnan(dnm))=0;
      dnm2=tmp4(fram(k,1),fram(k,2)-1,:);
      dnm2(isnan(dnm2))=0; 
      tmp2(k,:)=dnm.*fram(k,3)+dnm2.*fram(k,4);
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

