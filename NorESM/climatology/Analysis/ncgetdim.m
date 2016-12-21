function dim=ncgetdim(filename,dimname)
% NCGETDIM Return dimension from netCDF file.
%    NCGETDIM(FILENAME,DIMNAME) returns the dimension with name DIMNAME
%    from the netCDF file given by FILENAME.

% Mats Bentsen (mats.bentsen@uni.no) 2011/11/17

error(nargchk(2,2,nargin))
error(nargoutchk(1,1,nargout))

ncid=netcdf.open(filename,'NC_NOWRITE');
dimid=netcdf.inqDimID(ncid,dimname);
[dimname_tmp,dim]=netcdf.inqDim(ncid,dimid);
netcdf.close(ncid)
