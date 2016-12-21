function att=ncgetatt(filename,attname,varname)
% NCGETATT Return attribute from netCDF file.
%    NCGETATT(FILENAME,ATTNAME,VARNAME) returns the attribute with name
%    ATTNAME from the netCDF file given by FILENAME. If a variable name
%    is provided in VARNAME, the attribute will be associated with that
%    variable. If VARNAME is omitted a global attribute is assumed.

% Mats Bentsen (mats.bentsen@uni.no) 2011/11/17

error(nargchk(2,3,nargin))
error(nargoutchk(0,1,nargout))

ncid=netcdf.open(filename,'NC_NOWRITE');
if nargin==2
  att=netcdf.getAtt(ncid,netcdf.getConstant('NC_GLOBAL'),attname);
else
  varid=netcdf.inqVarID(ncid,varname);
  att=netcdf.getAtt(ncid,varid,attname);
end
netcdf.close(ncid)
