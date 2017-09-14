clear all
lonmicom

ncfile = 'passive_tracer_mask.nc'
grid_file = '/fimm/home/bjerknes/milicak/Analysis/NorESM/climatology/Analysis/grid.nc';
lon = ncread(grid_file,'plon');
lat = ncread(grid_file,'plat');
mask = double(ncread(grid_file,'pmask'));

% region 1 
lon1 = [-47.4194  -68.4332  -67.3272  -44.3779  -44.9309  -47.4194];
lat1 = [66.7742   66.7742   52.9493   51.8433   63.4562   66.7742];
in = insphpoly(lon,lat,lon1,lat1,0,90);
in = double(in);
in(in==0) = NaN;
in1 = in.*mask;

% region 2 
lon2 = [-162.4424 -159.9539 -141.1521 -117.9263 -122.0737 -149.4470 -162.4424];
lat2 = [61.2442   48.5253   39.6774   40.7834   64.5622   65.3917   61.2442];
in = insphpoly(lon,lat,lon2,lat2,0,90);
in = double(in);
in(in==0) = NaN;
in2 = in.*mask;

lon3 = [-184.1935 -166.2212 -166.7742 -190.8295 -201.6129 -202.4424 -184.1935];
lat3 = [66.4229   57.8059   48.4707   50.6250   56.3697   64.9867   66.4229];
in = insphpoly(lon,lat,lon3,lat3,0,90);
in = double(in);
in(in==0) = NaN;
in3 = in.*mask;


lon4 = [-142.4424 -160.9677 -175.6221 -171.1982 -121.9816 -102.0737 -105.1152 -140.2304 -142.4424];
lat4 = [36.2633   42.0080   36.9814   25.0133   18.7899   20.4654   35.3059 35.3059   36.2633];
in = insphpoly(lon,lat,lon4,lat4,0,90);
in = double(in);
in(in==0) = NaN;
in4 = in.*mask;

% remove nans
in1(isnan(in1)) = 0.0;

in2(in2==1) = 2.0;
in2(isnan(in2)) = 0.0;

in3(in3==1) = 3.0;
in3(isnan(in3)) = 0.0;

in4(in4==1) = 4.0;
in4(isnan(in4)) = 0.0;

in = in1+in2+in3+in4;

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
