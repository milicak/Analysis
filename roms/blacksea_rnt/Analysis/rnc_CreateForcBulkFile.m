 function rnc_CreateForcBulkFile(grd,filename, varargin) 
% function rnc_CreateForcBulkFile (grd,filename, varargin)
%    E. Di Lorenzo (edl@ucsd.edu)
% 


   
   opt.wind_time=12;
   opt.wind_time_cycle=360;
   opt.pair_time=12;
   opt.pair_time_cycle=360;
   opt.tair_time=12;
   opt.tair_time_cycle=360;
   opt.qair_time=12;
   opt.qair_time_cycle=360;
   opt.cloud_time=12;
   opt.cloud_time_cycle=360;
   opt.rain_time=12;
   opt.rain_time_cycle=360;
   opt.swf_time=12;
   opt.swf_time_cycle=360;

% user defined options to be overwritten
if nargin > 2
   optnew = varargin{1};
   f=fieldnames(optnew);
   for i=1:length(f)
     eval(['opt.',f{i},'=optnew.',f{i},';']);
   end
end      

%% ncdump('forc-RSM-clima.nc')   %% Generated 07-Sep-2002 14:30:48
 
nc = netcdf(filename, 'clobber');
if isempty(nc), return, end
 
%% Global attributes:
 
nc.title = ncchar('');
nc.out_file = ncchar('');
nc.grd_file = ncchar('');
nc.oa_file = ncchar('');
nc.type = ncchar('');
nc.version = ncchar('');
nc.history = ncchar('');
 
%% Dimensions:
 
nc('xi_rho') = grd.Lp;
nc('xi_u') = grd.L;
nc('xi_v') = grd.Lp;
nc('eta_rho') = grd.Mp;
nc('eta_u') = grd.Mp;
nc('eta_v') = grd.M;
nc('s_rho') = grd.N;
nc('s_w') = grd.N+1;


nc('wind_time') = opt.wind_time;
nc('pair_time') = opt.pair_time;
nc('tair_time') = opt.tair_time;
nc('qair_time') = opt.qair_time;
nc('cloud_time') = opt.cloud_time;
nc('rain_time') = opt.rain_time;
nc('swf_time') = opt.swf_time;
 
%% Variables and attributes:
 
nc{'wind_time'} = ncdouble('wind_time'); %% 12 elements.
nc{'wind_time'}.cycle_length = ncdouble(opt.wind_time_cycle);
nc{'wind_time'}.long_name = ncchar('surface wind time');
nc{'wind_time'}.units = ncchar('days');
nc{'wind_time'}.field = ncchar('wind_time, scalar, series');
 
nc{'pair_time'} = ncdouble('pair_time'); %% 12 elements.
nc{'pair_time'}.cycle_length = ncdouble(opt.pair_time_cycle);
nc{'pair_time'}.long_name = ncchar('surface air pressure time');
nc{'pair_time'}.units = ncchar('days');
nc{'pair_time'}.field = ncchar('pair_time, scalar, series');
 
nc{'tair_time'} = ncdouble('tair_time'); %% 12 elements.
nc{'tair_time'}.cycle_length = ncdouble(opt.tair_time_cycle);
nc{'tair_time'}.long_name = ncchar('surface air temperature time');
nc{'tair_time'}.units = ncchar('days');
nc{'tair_time'}.field = ncchar('tair_time, scalar, series');
 
nc{'qair_time'} = ncdouble('qair_time'); %% 12 elements.
nc{'qair_time'}.cycle_length = ncdouble(opt.qair_time_cycle);
nc{'qair_time'}.long_name = ncchar('surface relative humidity time');
nc{'qair_time'}.units = ncchar('days');
nc{'qair_time'}.field = ncchar('qair_time, scalar, series');
 
nc{'cloud_time'} = ncdouble('cloud_time'); %% 12 elements.
nc{'cloud_time'}.cycle_length = ncdouble(opt.cloud_time_cycle);
nc{'cloud_time'}.long_name = ncchar('cloud fraction time');
nc{'cloud_time'}.units = ncchar('days');
nc{'cloud_time'}.field = ncchar('cloud_time, scalar, series');
 
nc{'rain_time'} = ncdouble('rain_time'); %% 12 elements.
nc{'rain_time'}.cycle_length = ncdouble(opt.rain_time_cycle);
nc{'rain_time'}.long_name = ncchar('rain fall rate time');
nc{'rain_time'}.units = ncchar('days');
nc{'rain_time'}.field = ncchar('rain_time, scalar, series');
 
nc{'swf_time'} = ncdouble('swf_time'); %% 12 elements.
nc{'swf_time'}.cycle_length = ncdouble(opt.swf_time_cycle);
nc{'swf_time'}.long_name = ncchar('surface momentum stress time');
nc{'swf_time'}.units = ncchar('days');
nc{'swf_time'}.field = ncchar('swf_time, scalar, series');
 
nc{'Uwind'} = ncshort('wind_time', 'eta_rho', 'xi_rho'); %% 1359456 elements.
nc{'Uwind'}.cycle_length = ncdouble(opt.wind_time_cycle);
nc{'Uwind'}.long_name = ncchar('surface u-wind component');
nc{'Uwind'}.units = ncchar('meter second-1');
nc{'Uwind'}.field = ncchar('u-wind, scalar, series');
nc{'Uwind'}.scale_factor = ncdouble(0.000303136060762626);
 
nc{'Vwind'} = ncshort('wind_time', 'eta_rho', 'xi_rho'); %% 1359456 elements.
nc{'Vwind'}.cycle_length = ncdouble(opt.wind_time_cycle);
nc{'Vwind'}.long_name = ncchar('surface v-wind component');
nc{'Vwind'}.units = ncchar('meter second-1');
nc{'Vwind'}.field = ncchar('v-wind , scalar, series');
nc{'Vwind'}.scale_factor = ncdouble(0.000276488595469484);
 
nc{'Pair'} = ncshort('pair_time', 'eta_rho', 'xi_rho'); %% 1359456 elements.
nc{'Pair'}.cycle_length = ncdouble(opt.pair_time_cycle);
nc{'Pair'}.long_name = ncchar('surface air pressure');
nc{'Pair'}.units = ncchar('milibar');
nc{'Pair'}.field = ncchar('Pair, scalar, series');
nc{'Pair'}.scale_factor = ncdouble(0.0316270000751984);
 
nc{'Tair'} = ncshort('tair_time', 'eta_rho', 'xi_rho'); %% 1359456 elements.
nc{'Tair'}.cycle_length = ncdouble(opt.tair_time_cycle);
nc{'Tair'}.long_name = ncchar('surface air temperature');
nc{'Tair'}.units = ncchar('Celsius');
nc{'Tair'}.field = ncchar('Tair, scalar, series');
nc{'Tair'}.scale_factor = ncdouble(0.00124522239181609);
 
nc{'Qair'} = ncshort('qair_time', 'eta_rho', 'xi_rho'); %% 1359456 elements.
nc{'Qair'}.cycle_length = ncdouble(opt.qair_time_cycle);
nc{'Qair'}.long_name = ncchar('surface air relative humidity');
nc{'Qair'}.units = ncchar('percentage');
nc{'Qair'}.field = ncchar('Qair, scalar, series');
nc{'Qair'}.scale_factor = ncdouble(0.00301982759646877);
 
nc{'cloud'} = ncshort('cloud_time', 'eta_rho', 'xi_rho'); %% 1359456 elements.
nc{'cloud'}.cycle_length = ncdouble(opt.cloud_time_cycle);
nc{'cloud'}.long_name = ncchar('cloud fraction');
nc{'cloud'}.units = ncchar('nondimensional');
nc{'cloud'}.field = ncchar('cloud, scalar, series');
nc{'cloud'}.scale_factor = ncdouble(2.58507842892579e-05);
 
nc{'rain'} = ncshort('rain_time', 'eta_rho', 'xi_rho'); %% 1359456 elements.
nc{'rain'}.cycle_length = ncdouble(opt.rain_time_cycle);
nc{'rain'}.long_name = ncchar('rain fall rate');
nc{'rain'}.units = ncchar('kilogram meter-2 second-1');
nc{'rain'}.field = ncchar('rain, scalar, series');
nc{'rain'}.scale_factor = ncdouble(9.34813737185398e-09);
 
nc{'swflux'} = ncshort('swf_time', 'eta_rho', 'xi_rho'); %% 1359456 elements.
nc{'swflux'}.long_name = ncchar('surface freshwater flux (E-P)');
nc{'swflux'}.units = ncchar('centimeter day-1');
nc{'swflux'}.field = ncchar('surface freshwater flux, scalar, series');
nc{'swflux'}.positive = ncchar('net evaporation');
nc{'swflux'}.cycle_length = ncdouble(opt.swf_time_cycle);
nc{'swflux'}.negative = ncchar('net precipitation');
nc{'swflux'}.scale_factor = ncdouble(6.86125771241447e-05);
 
  
endef(nc)
close(nc)
