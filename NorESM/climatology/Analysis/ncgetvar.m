function var=ncgetvar(filename,varname)
% NCGETVAR Return data from netCDF file.
%    NCGETVAR(FILENAME,VARNAME) returns the variable with name VARNAME
%    from the netCDF file given by FILENAME. Missing values indicated by
%    a CF standard fill value attribute will be set to NaNs. CF standard
%    attributes for scale factor and offset will be recognised and
%    automatically applied to the variable.

% Mats Bentsen (mats.bentsen@uni.no) 2011/11/17

error(nargchk(2,2,nargin))
error(nargoutchk(1,1,nargout))

ncid=netcdf.open(filename,'NC_NOWRITE');
varid=netcdf.inqVarID(ncid,varname);
[varname_tmp,xtype,dimids,natts]=netcdf.inqVar(ncid,varid);
fill_value_used=0;
scale_factor_used=0;
add_offset_used=0;
scale_factor=1;
add_offset=0;
for attnum=0:natts-1
  attname=netcdf.inqAttName(ncid,varid,attnum);
  switch lower(attname)
    case {'_fillvalue'}
      fill_value_used=1;
      fill_value=double(netcdf.getAtt(ncid,varid,attname));
    case {'scale_factor'}
      scale_factor_used=1;
      scale_factor=double(netcdf.getAtt(ncid,varid,attname));
    case {'add_offset'}
      add_offset_used=1;
      add_offset=double(netcdf.getAtt(ncid,varid,attname));
  end
end
var=double(netcdf.getVar(ncid,varid));
netcdf.close(ncid)
if fill_value_used
  var(find(var==fill_value))=nan;
end
if scale_factor_used||add_offset_used
  var=var*scale_factor+add_offset;
end
