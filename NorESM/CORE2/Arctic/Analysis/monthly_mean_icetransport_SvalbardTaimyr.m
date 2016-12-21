% this subroutine computes monthly mean heat flux at Svalbardtaimyr strait
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

%SvalbardTaimyr Strait Location
svalbardtaimyr=[112 363  0  1
113 363 -1  0
113 364 -1  0
113 365 -1  0
113 366 -1  0
113 367  0  1
114 367 -1  0
114 368 -1  0
114 369 -1  0
114 370  0  1
115 370 -1  0
115 371 -1  0
115 372 -1  0
115 373 -1  0
115 374  0  1
116 376 -1  0
116 377  0  1
117 377 -1  0
118 381 -1  0
118 383 -1  0
118 384 -1  0
244 384  1  0
243 384  0 -1
243 383  1  0
243 382  1  0
243 381  1  0
243 380  1  0
242 380  0 -1
242 379  1  0
242 378  1  0
242 377  1  0
242 376  1  0
242 375  1  0
242 374  1  0
241 374  0 -1
241 373  1  0
241 372  1  0
241 371  1  0
241 370  1  0
241 369  1  0
241 368  1  0
241 367  1  0
240 367  0 -1
240 366  1  0
240 365  1  0
240 364  1  0];

clear svalbardtaimyr
svalbardtaimyr=[115 359 -1  0
115 360  0  1
116 360 -1  0
116 361 -1  0
116 362 -1  0
116 363  0  1
117 363 -1  0
117 364 -1  0
117 365 -1  0
117 366  0  1
118 366 -1  0
118 367 -1  0
118 368 -1  0
118 369  0  1
119 369 -1  0
119 370 -1  0
119 371 -1  0
119 372  0  1
120 372 -1  0
120 373 -1  0
120 374 -1  0
120 375  0  1
121 375 -1  0
121 376 -1  0
121 377 -1  0
121 378 -1  0
121 379  0  1
122 379 -1  0
122 380 -1  0
122 381 -1  0
122 382 -1  0
122 383  0  1
123 383 -1  0
123 384 -1  0
239 384  1  0
239 383  1  0
238 383  0 -1
238 382  1  0
238 381  1  0
238 380  1  0
238 379  1  0
238 378  1  0
237 378  0 -1
237 377  1  0
237 376  1  0
237 375  1  0
237 374  1  0
237 373  1  0
237 372  1  0
236 372  0 -1
236 371  1  0
236 370  1  0
236 369  1  0
236 368  1  0
236 367  1  0
236 366  1  0
236 365  1  0
236 364  1  0];

nx=1;
ny=1;


% Create netcdf file.
%ncid=netcdf.create([expid '_temperature_annual_' num2str(fyear) '-' num2str(lyear) '.nc'],'NC_CLOBBER');
%ncid=netcdf.create(['/work/milicak/RUNS/noresm/CORE2/CORE2_files/SSH/' expid '_temperature_annual_' num2str(fyear) '-' num2str(lyear) '.nc'],'NC_CLOBBER');
ncid=netcdf.create(['/bcmhsm/milicak/RUNS/noresm/CORE2/Arctic/' expid '_ice_transport_SvalbardTaimyr_monthly_' num2str(fyear) '-' num2str(lyear) '.nc'],'NC_CLOBBER');

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
    for k=1:size(svalbardtaimyr,1)    
      dnm=tmp(svalbardtaimyr(k,1)-1,svalbardtaimyr(k,2),:);
      dnm(isnan(dnm))=0;
      dnm2=tmp4(svalbardtaimyr(k,1),svalbardtaimyr(k,2)-1,:);
      dnm2(isnan(dnm2))=0; 
      tmp2(k,:)=dnm.*svalbardtaimyr(k,3)+dnm2.*svalbardtaimyr(k,4);
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

