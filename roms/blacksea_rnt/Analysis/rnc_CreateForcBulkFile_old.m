 function rnc_CreateForcBulkFile(grd,filename, varargin) 
% function rnc_CreateForcBulkFile (grd,filename, varargin)
%    E. Di Lorenzo (edl@ucsd.edu)
% 
   
   opt.wind_time=720;
   opt.wind_time_cycle=720;
   opt.pair_time=720;
   opt.pair_time_cycle=720;
   opt.tair_time=720;
   opt.tair_time_cycle=720;
   opt.qair_time=720;
   opt.qair_time_cycle=720;
   opt.cloud_time=720;
   opt.cloud_time_cycle=720;
   opt.rain_time=720;
   opt.rain_time_cycle=720;
   opt.swf_time=720;
   opt.swf_time_cycle=720;
   opt.srf_time=720;
   opt.srf_time_cycle=720;
   opt.shf_time=720;
   opt.shf_time_cycle=720;
%   opt.lwf_time=360;
%   opt.lwf_time_cycle=360;

% user defined options to be overwritten
if nargin > 2
   optnew = varargin{1};
   f=fieldnames(optnew);
   for i=1:length(f)
     eval(['opt.',f{i},'=optnew.',f{i},';']);
   end
end      

%% ncdump('forc-RSM-clima.nc')   %% Generated 07-Sep-2002 14:30:48
ncid=netcdf.create(filename,'NC_64BIT_OFFSET');
%ncid=netcdf.create(clmfile,'NC_CLOBBER');

nir_dimid=netcdf.defDim(ncid,'xi_rho',grd.Lp);
niu_dimid=netcdf.defDim(ncid,'xi_u',grd.Lp-1);
niv_dimid=netcdf.defDim(ncid,'xi_v',grd.Lp);
njr_dimid=netcdf.defDim(ncid,'eta_rho',grd.Mp);
nju_dimid=netcdf.defDim(ncid,'eta_u',grd.Mp);
njv_dimid=netcdf.defDim(ncid,'eta_v',grd.Mp-1);
nzr_dimid=netcdf.defDim(ncid,'s_rho',grd.N);
nzw_dimid=netcdf.defDim(ncid,'s_w',grd.N+1);

windtime_dimid=netcdf.defDim(ncid,'wind_time',opt.wind_time);
windtime_varid=netcdf.defVar(ncid,'wind_time','float',windtime_dimid);
netcdf.putAtt(ncid,windtime_varid,'cycle_length',opt.wind_time_cycle);
netcdf.putAtt(ncid,windtime_varid,'long_name','surface wind time');
netcdf.putAtt(ncid,windtime_varid,'units','days');

pairtime_dimid=netcdf.defDim(ncid,'pair_time',opt.pair_time);
pairtime_varid=netcdf.defVar(ncid,'pair_time','float',pairtime_dimid);
netcdf.putAtt(ncid,pairtime_varid,'cycle_length',opt.pair_time_cycle);
netcdf.putAtt(ncid,pairtime_varid,'long_name','surface air pressure time');
netcdf.putAtt(ncid,pairtime_varid,'units','days');

tairtime_dimid=netcdf.defDim(ncid,'tair_time',opt.tair_time);
tairtime_varid=netcdf.defVar(ncid,'tair_time','float',tairtime_dimid);
netcdf.putAtt(ncid,tairtime_varid,'cycle_length',opt.tair_time_cycle);
netcdf.putAtt(ncid,tairtime_varid,'long_name','surface air temperature time');
netcdf.putAtt(ncid,tairtime_varid,'units','days');

qairtime_dimid=netcdf.defDim(ncid,'qair_time',opt.qair_time);
qairtime_varid=netcdf.defVar(ncid,'qair_time','float',qairtime_dimid);
netcdf.putAtt(ncid,qairtime_varid,'cycle_length',opt.qair_time_cycle);
netcdf.putAtt(ncid,qairtime_varid,'long_name','surface relative humidity time');
netcdf.putAtt(ncid,qairtime_varid,'units','days');

cloudtime_dimid=netcdf.defDim(ncid,'cloud_time',opt.cloud_time);
cloudtime_varid=netcdf.defVar(ncid,'cloud_time','float',cloudtime_dimid);
netcdf.putAtt(ncid,cloudtime_varid,'cycle_length',opt.cloud_time_cycle);
netcdf.putAtt(ncid,cloudtime_varid,'long_name','cloud fraction time');
netcdf.putAtt(ncid,cloudtime_varid,'units','days');

raintime_dimid=netcdf.defDim(ncid,'rain_time',opt.rain_time);
raintime_varid=netcdf.defVar(ncid,'rain_time','float',raintime_dimid);
netcdf.putAtt(ncid,raintime_varid,'cycle_length',opt.rain_time_cycle);
netcdf.putAtt(ncid,raintime_varid,'long_name','rain fall rate time');
netcdf.putAtt(ncid,raintime_varid,'units','days');

swftime_dimid=netcdf.defDim(ncid,'swf_time',opt.swf_time);
swftime_varid=netcdf.defVar(ncid,'swf_time','float',swftime_dimid);
netcdf.putAtt(ncid,swftime_varid,'cycle_length',opt.swf_time_cycle);
netcdf.putAtt(ncid,swftime_varid,'long_name','fresh water flux time');
netcdf.putAtt(ncid,swftime_varid,'units','days');

shftime_dimid=netcdf.defDim(ncid,'shf_time',opt.shf_time);
shftime_varid=netcdf.defVar(ncid,'shf_time','float',shftime_dimid);
netcdf.putAtt(ncid,shftime_varid,'cycle_length',opt.shf_time_cycle);
netcdf.putAtt(ncid,shftime_varid,'long_name','surface heat flux time');
netcdf.putAtt(ncid,shftime_varid,'units','days');

srftime_dimid=netcdf.defDim(ncid,'srf_time',opt.srf_time);
srftime_varid=netcdf.defVar(ncid,'srf_time','float',srftime_dimid);
netcdf.putAtt(ncid,srftime_varid,'cycle_length',opt.srf_time_cycle);
netcdf.putAtt(ncid,srftime_varid,'long_name','short wave radiation flux time');
netcdf.putAtt(ncid,srftime_varid,'units','days');

%lwftime_dimid=netcdf.defDim(ncid,'lwf_time',opt.lwf_time);
%lwftime_varid=netcdf.defVar(ncid,'lwf_time','float',lwftime_dimid);
%netcdf.putAtt(ncid,lwftime_varid,'cycle_length',opt.lwf_time_cycle);
%netcdf.putAtt(ncid,lwftime_varid,'long_name','long wave radiation flux time');
%netcdf.putAtt(ncid,lwftime_varid,'units','days');

uwind_varid=netcdf.defVar(ncid,'Uwind','float',[niu_dimid nju_dimid windtime_dimid]);
netcdf.putAtt(ncid,uwind_varid,'long_name','surface u-wind component');
netcdf.putAtt(ncid,uwind_varid,'units','m s-1');
netcdf.putAtt(ncid,uwind_varid,'coordinates','lon_u lat_u');

vwind_varid=netcdf.defVar(ncid,'Vwind','float',[niv_dimid njv_dimid windtime_dimid]);
netcdf.putAtt(ncid,vwind_varid,'long_name','surface v-wind component');
netcdf.putAtt(ncid,vwind_varid,'units','m s-1');
netcdf.putAtt(ncid,vwind_varid,'coordinates','lon_v lat_v');

pair_varid=netcdf.defVar(ncid,'Pair','float',[nir_dimid njr_dimid pairtime_dimid]);
netcdf.putAtt(ncid,pair_varid,'long_name','surface air pressure');
netcdf.putAtt(ncid,pair_varid,'units','milibar');
netcdf.putAtt(ncid,pair_varid,'coordinates','lon_r lat_r');

tair_varid=netcdf.defVar(ncid,'Tair','float',[nir_dimid njr_dimid tairtime_dimid]);
netcdf.putAtt(ncid,tair_varid,'long_name','surface air temperature');
netcdf.putAtt(ncid,tair_varid,'units','Celsius');
netcdf.putAtt(ncid,tair_varid,'coordinates','lon_r lat_r');

qair_varid=netcdf.defVar(ncid,'Qair','float',[nir_dimid njr_dimid qairtime_dimid]);
netcdf.putAtt(ncid,qair_varid,'long_name','surface air relative humidity');
netcdf.putAtt(ncid,qair_varid,'units','percentage');
netcdf.putAtt(ncid,qair_varid,'coordinates','lon_r lat_r');

cloud_varid=netcdf.defVar(ncid,'cloud','float',[nir_dimid njr_dimid cloudtime_dimid]);
netcdf.putAtt(ncid,cloud_varid,'long_name','cloud fraction');
netcdf.putAtt(ncid,cloud_varid,'units','nondimensional');
netcdf.putAtt(ncid,cloud_varid,'coordinates','lon_r lat_r');

rain_varid=netcdf.defVar(ncid,'rain','float',[nir_dimid njr_dimid raintime_dimid]);
netcdf.putAtt(ncid,rain_varid,'long_name','rain fall rate');
netcdf.putAtt(ncid,rain_varid,'units','kilogram meter-2 second-1');
netcdf.putAtt(ncid,rain_varid,'coordinates','lon_r lat_r');

swrad_varid=netcdf.defVar(ncid,'swrad','float',[nir_dimid njr_dimid srftime_dimid]);
netcdf.putAtt(ncid,swrad_varid,'long_name','swrad time');
netcdf.putAtt(ncid,swrad_varid,'units','Watts meter-2');
netcdf.putAtt(ncid,swrad_varid,'coordinates','lon_r lat_r');

swflux_varid=netcdf.defVar(ncid,'swflux','float',[nir_dimid njr_dimid swftime_dimid]);
netcdf.putAtt(ncid,swflux_varid,'long_name','swflux time');
netcdf.putAtt(ncid,swflux_varid,'units','cm day-1');
netcdf.putAtt(ncid,swflux_varid,'coordinates','lon_r lat_r');

shflux_varid=netcdf.defVar(ncid,'shflux','float',[nir_dimid njr_dimid shftime_dimid]);
netcdf.putAtt(ncid,shflux_varid,'long_name','shflux time');
netcdf.putAtt(ncid,shflux_varid,'units','Watts meter-2');
netcdf.putAtt(ncid,shflux_varid,'coordinates','lon_r lat_r');

%lwflux_varid=netcdf.defVar(ncid,'lwrad','float',[nir_dimid njr_dimid lwftime_dimid]);
%netcdf.putAtt(ncid,lwflux_varid,'long_name','lwrad time');
%netcdf.putAtt(ncid,lwflux_varid,'units','Watts meter-2');
%netcdf.putAtt(ncid,lwflux_varid,'coordinates','lon_r lat_r');


% End definitions and leave define mode.
netcdf.endDef(ncid)
% Close netcdf file
netcdf.close(ncid)


return
 
