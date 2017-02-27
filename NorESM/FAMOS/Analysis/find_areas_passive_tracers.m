clear all
lonmicom

ncfile = 'passive_tracer_mask.nc'
grid_file = '/fimm/home/bjerknes/milicak/Analysis/NorESM/climatology/Analysis/grid.nc';
lon = ncread(grid_file,'plon');
lat = ncread(grid_file,'plat');
mask = double(ncread(grid_file,'pmask'));

% region 1 Fram Strait
%(79.5°N,0.0°E) (79.5°N,11.0°E)
%(79.0°N,0.0°E) (79.0°N,11.0°E)
lon1 = [0 11 11 0 0];
lat1 = [79.5 79.5 79 79 79.5];
in = insphpoly(lon,lat,lon1,lat1,0,90);
in = double(in);
in(in==0) = NaN;
in1 = in.*mask;

% region 2 Barents Sea opening
% (74.0°N,19.0°E) (74.0°N,20.5°E)
% (70.3°N,19.0°E) (70.3°N,20.5°E)

lon2 = [19.0 20.5 20.5 19.0 19.0];
lat2 = [74.0 74.0 70.3 70.3 70.3];
in = insphpoly(lon,lat,lon2,lat2,0,90);
in = double(in);
in(in==0) = NaN;
in2 = in.*mask;

% region 3 Bering Strait 
% 298,299 325 for tnx1v1

%lon3 = [-169.0 -168 -168 -169 -169];
%lat3 = [66 66 65.5 65.5 66];
lon3 = [-166.1 -171.3 -171.2 -177 -166.1];
lat3 = [65.74 66.16 65.75 65.48 65.74];
in = insphpoly(lon,lat,lon3,lat3,0,90);
in = double(in);
in(in==0) = NaN;
in3 = in.*mask;
in3(297,324) = 1;
in3(298,324) = 1;
in3(299,324) = 1;

% region 4
% (64.65°N,0.5°E) (62.5°N,6.0°E)
% (64.15°N,0.5°W) (62.0°N,5.0°E)

lon4 = [0.5 6.0 5.0 -0.5 0.5];
lat4 = [64.65 62.5 62.0 64.15 64.65];
in = insphpoly(lon,lat,lon4,lat4,0,90);
in = double(in);
in(in==0) = NaN;
in4 = in.*mask;

% region 5 Kara Sea river

lon5 = [ 55.3079
   54.2920
   54.4847
   55.7771
   57.1748
   59.6685
   63.1141
   66.5448
  104.0750
  103.0789
   96.9152
   90.8714
   85.8436
   75.5052
   68.5785
   64.2055
   63.1660
   62.1246
   62.7433
   59.6288
   56.6101];

lat5 = [70.8896
   71.8168
   72.5062
   73.5405
   74.4301
   75.4505
   75.9749
   76.5922
   77.2584
   74.3141
   70.4680
   67.3739
   64.7325
   63.8903
   63.2120
   63.3555
   66.2293
   68.3550
   68.8838
   69.9497
   70.7360];

lon5(end+1) = lon5(1);
lat5(end+1) = lat5(1);
in = insphpoly(lon,lat,lon5,lat5,0,90);
in = double(in);
in(in==0) = NaN;
in5 = in.*mask;

% region 6
lon6 = [103.7895
  136.7715
  145.5714
  121.5331
  100.6823
  101.6999];

lat6 = [77.3837
   78.0630
   69.6951
   68.1200
   71.3921
   73.8558]; 

lon6(end+1) = lon6(1);
lat6(end+1) = lat6(1);
in = insphpoly(lon,lat,lon6,lat6,0,90);
in = double(in);
in(in==0) = NaN;
in6 = in.*mask;

lon7 = [-113.1693
 -116.8147
 -136.2827
 -152.5271
 -149.0507
 -117.3057];

lat7 = [73.9349
   67.5917
   66.7082
   69.2223
   74.6023
   74.2187];

lon7(end+1) = lon7(1);
lat7(end+1) = lat7(1);
in = insphpoly(lon,lat,lon7,lat7,0,90);
in = double(in);
in(in==0) = NaN;
in7 = in.*mask;

% remove nans
in1(isnan(in1)) = 0.0;

in2(in2==1) = 2.0;
in2(isnan(in2)) = 0.0;

in3(in3==1) = 3.0;
in3(isnan(in3)) = 0.0;

in4(in4==1) = 4.0;
in4(isnan(in4)) = 0.0;

in5(in5==1) = 5.0;
in5(isnan(in5)) = 0.0;

in6(in6==1) = 6.0;
in6(isnan(in6)) = 0.0;

in7(in7==1) = 7.0;
in7(isnan(in7)) = 0.0;

in = in1+in2+in3+in4+in5+in6+in7;

nx = size(lon,1);
ny = size(lon,2);
% Create netcdf file.
ncid=netcdf.create(ncfile,'NC_CLOBBER');

% Define dimensions.
nj_dimid=netcdf.defDim(ncid,'lat',ny);
ni_dimid=netcdf.defDim(ncid,'lon',nx);
time_dimid=netcdf.defDim(ncid,'time',netcdf.getConstant('NC_UNLIMITED'));

% Define variables and assign attributes
tlon_varid=netcdf.defVar(ncid,'lon','double',[ni_dimid nj_dimid]);
netcdf.putAtt(ncid,tlon_varid,'long_name','longitude');
netcdf.putAtt(ncid,tlon_varid,'units','degrees_east');

tlat_varid=netcdf.defVar(ncid,'lat','double',[ni_dimid nj_dimid]);
netcdf.putAtt(ncid,tlat_varid,'long_name','latitude');
netcdf.putAtt(ncid,tlat_varid,'units','degrees_north');

slp_varid=netcdf.defVar(ncid,'tr_mask','double',[ni_dimid nj_dimid]);
netcdf.putAtt(ncid,slp_varid,'long_name','passive tracer mask');
netcdf.putAtt(ncid,slp_varid,'units','unitless');
netcdf.putAtt(ncid,slp_varid,'coordinates','lon lat');

% Global attributes

% End definitions and leave define mode.
netcdf.endDef(ncid)

% Provide values for time invariant variables.
netcdf.putVar(ncid,tlon_varid,lon);
netcdf.putVar(ncid,tlat_varid,lat);
netcdf.putVar(ncid,slp_varid,in);
% Close netcdf file
netcdf.close(ncid)
