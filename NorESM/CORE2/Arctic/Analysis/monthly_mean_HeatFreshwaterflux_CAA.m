% this subroutine computes monthly mean heat flux at CAA strait
clear all

%expid='NOIIA_T62_tn11_bblsr10m30d_01';
expid='NOIIA_T62_tn11_sr10m60d_01';
datesep='-';
%grid_file='/work/shared/noresm/inputdata/ocn/micom/tnx1v1/20120120/grid.nc';
grid_file='/home/fimm/bjerknes/milicak/Analysis/NorESM/climatology/Analysis/grid.nc';
fyear=1;
lyear=300;
fill_value=-1e33;
Sref=34.8; % reference salinity

prefix=['/hexagon/work/matsbn/archive/' expid '/ocn/hist/' expid '.micom.hm.'];

% Get dimensions and time attributes
sdate=sprintf('%4.4d%c%2.2d',fyear,datesep,1);
nx=ncgetdim([prefix sdate '.nc'],'x');
ny=ncgetdim([prefix sdate '.nc'],'y');
depth=ncgetdim([prefix sdate '.nc'],'depth');
zdepth=ncgetvar([prefix sdate '.nc'],'depth');
zdepth_bnds=ncgetvar([prefix sdate '.nc'],'depth_bnds');
ny=ny-1;
time_long_name=ncgetatt([prefix sdate '.nc'],'long_name','time');
time_units=ncgetatt([prefix sdate '.nc'],'units','time');
time_calendar=ncgetatt([prefix sdate '.nc'],'calendar','time');


%CAA Strait Location
caa=[324 362  0 -1
324 362 -1  0
323 363  0 -1
323 363 -1  0
323 364 -1  0
322 365  0 -1
322 365 -1  0
322 366 -1  0
315 375  0 -1
315 375 -1  0
314 376  0 -1
314 376 -1  0
313 377  0 -1
313 377 -1  0
312 378  0 -1
312 378 -1  0
311 379  0 -1
310 380 -1  0
309 381  0 -1
309 381 -1  0
308 382  0 -1
308 382 -1  0
 56 385  0  1
 57 384  1  0
 57 384  0  1
 58 383  1  0
 58 383  0  1
 59 382  1  0
 60 381  0  1
 61 380  1  0
 61 380  0  1
 62 379  1  0
 62 379  0  1
 63 378  1  0
 76 367  1  0];

nx=1;
ny=1;


% Create netcdf file.
%ncid=netcdf.create([expid '_temperature_annual_' num2str(fyear) '-' num2str(lyear) '.nc'],'NC_CLOBBER');
%ncid=netcdf.create(['/work/milicak/RUNS/noresm/CORE2/CORE2_files/SSH/' expid '_temperature_annual_' num2str(fyear) '-' num2str(lyear) '.nc'],'NC_CLOBBER');
ncid=netcdf.create(['/bcmhsm/milicak/RUNS/noresm/CORE2/Arctic/' expid '_heat_freshwater_CAA_monthly_' num2str(fyear) '-' num2str(lyear) '.nc'],'NC_CLOBBER');

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

vhflxin_varid=netcdf.defVar(ncid,'vhflx_in','float',[ni_dimid time_dimid]);
netcdf.putAtt(ncid,vhflxin_varid,'long_name','Northward heat flux');
netcdf.putAtt(ncid,vhflxin_varid,'units','W');
netcdf.putAtt(ncid,vhflxin_varid,'_FillValue',single(fill_value));

vhflxout_varid=netcdf.defVar(ncid,'vhflx_out','float',[ni_dimid time_dimid]);
netcdf.putAtt(ncid,vhflxout_varid,'long_name','Southward heat flux');
netcdf.putAtt(ncid,vhflxout_varid,'units','W');
netcdf.putAtt(ncid,vhflxout_varid,'_FillValue',single(fill_value));

vsflxin_varid=netcdf.defVar(ncid,'vsflx_in','float',[ni_dimid time_dimid]);
netcdf.putAtt(ncid,vsflxin_varid,'long_name','Northward salt flux');
netcdf.putAtt(ncid,vsflxin_varid,'units','kg s-1');
netcdf.putAtt(ncid,vsflxin_varid,'_FillValue',single(fill_value));

vsflxout_varid=netcdf.defVar(ncid,'vsflx_out','float',[ni_dimid time_dimid]);
netcdf.putAtt(ncid,vsflxout_varid,'long_name','Southward salt flux');
netcdf.putAtt(ncid,vsflxout_varid,'units','kg s-1');
netcdf.putAtt(ncid,vsflxout_varid,'_FillValue',single(fill_value));

FWvflxin_varid=netcdf.defVar(ncid,'FWvflx_in','float',[ni_dimid time_dimid]);
netcdf.putAtt(ncid,FWvflxin_varid,'long_name','Northward fresh water flux');
netcdf.putAtt(ncid,FWvflxin_varid,'units','kg s-1');
netcdf.putAtt(ncid,FWvflxin_varid,'_FillValue',single(fill_value));

FWvflxout_varid=netcdf.defVar(ncid,'FWvflx_out','float',[ni_dimid time_dimid]);
netcdf.putAtt(ncid,FWvflxout_varid,'long_name','Southward fresh water flux');
netcdf.putAtt(ncid,FWvflxout_varid,'units','kg s-1');
netcdf.putAtt(ncid,FWvflxout_varid,'_FillValue',single(fill_value));

Massflxin_varid=netcdf.defVar(ncid,'Massflx_in','float',[ni_dimid time_dimid]);
netcdf.putAtt(ncid,Massflxin_varid,'long_name','Northward mass flux');
netcdf.putAtt(ncid,Massflxin_varid,'units','kg s-1');
netcdf.putAtt(ncid,Massflxin_varid,'_FillValue',single(fill_value));

Massflxout_varid=netcdf.defVar(ncid,'Massflx_out','float',[ni_dimid time_dimid]);
netcdf.putAtt(ncid,Massflxout_varid,'long_name','Southward Mass flux');
netcdf.putAtt(ncid,Massflxout_varid,'units','kg s-1');
netcdf.putAtt(ncid,Massflxout_varid,'_FillValue',single(fill_value));

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
    tmp=ncgetvar([prefix sdate '.nc'],'vhflxlvl');
    tmp4=ncgetvar([prefix sdate '.nc'],'uhflxlvl');
    for k=1:size(caa,1)    
      tmp2(k,:)=tmp4(caa(k,1),caa(k,2),:).*caa(k,3)+tmp(caa(k,1),caa(k,2),:).*caa(k,4);
    end
    vhflxin=nansum(tmp2(tmp2>0.0));
    vhflxout=nansum(tmp2(tmp2<0.0));
    tmp=ncgetvar([prefix sdate '.nc'],'vsflxlvl');
    tmp4=ncgetvar([prefix sdate '.nc'],'usflxlvl');
    for k=1:size(caa,1)    
      tmp2(k,:)=tmp4(caa(k,1),caa(k,2),:).*caa(k,3)+tmp(caa(k,1),caa(k,2),:).*caa(k,4);
    end
    vsflxin=nansum(tmp2(tmp2>0.0));
    vsflxout=nansum(tmp2(tmp2<0.0));
    tmp=ncgetvar([prefix sdate '.nc'],'vflxlvl');
    tmp4=ncgetvar([prefix sdate '.nc'],'uflxlvl');
    for k=1:size(caa,1)    
      tmp3(k,:)=tmp4(caa(k,1),caa(k,2),:).*caa(k,3)+tmp(caa(k,1),caa(k,2),:).*caa(k,4);
    end
    tmp=-(tmp2-Sref.*tmp3)./Sref; % FW=-(Saltflux-Sref*massflux)/Sref
    Massflxin=nansum(tmp3(tmp3>0.0));
    Massflxout=nansum(tmp3(tmp3<0.0));
    FWvflxin=nansum(tmp(tmp>0.0));
    FWvflxout=nansum(tmp(tmp<0.0));
    Massflxin(isnan(Massflxin))=fill_value;
    Massflxout(isnan(Massflxout))=fill_value;
    FWvflxin(isnan(FWvflxin))=fill_value;
    FWvflxout(isnan(FWvflxout))=fill_value;
    tmp=ncgetvar([prefix sdate '.nc'],'time');
    time=tmp;
    vhflxin(isnan(vhflxin))=fill_value;
    vhflxout(isnan(vhflxout))=fill_value;
    netcdf.putVar(ncid,time_varid,n-1,1,single(time));
    netcdf.putVar(ncid,vhflxin_varid,[0 n-1],[nx 1],single(vhflxin));
    netcdf.putVar(ncid,vhflxout_varid,[0 n-1],[nx 1],single(vhflxout));
    netcdf.putVar(ncid,vsflxin_varid,[0 n-1],[nx 1],single(vsflxin));
    netcdf.putVar(ncid,vsflxout_varid,[0 n-1],[nx 1],single(vsflxout));
    netcdf.putVar(ncid,FWvflxin_varid,[0 n-1],[nx 1],single(FWvflxin));
    netcdf.putVar(ncid,FWvflxout_varid,[0 n-1],[nx 1],single(FWvflxout));
    netcdf.putVar(ncid,Massflxin_varid,[0 n-1],[nx 1],single(Massflxin));
    netcdf.putVar(ncid,Massflxout_varid,[0 n-1],[nx 1],single(Massflxout));
  end
end


% Close netcdf file
netcdf.close(ncid)

