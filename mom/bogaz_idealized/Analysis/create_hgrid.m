function  create_hgrid(L,M,Nk,grdname,title)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%       Create an empty netcdf HYBRID gridfile
%       L: total number of psi points in x direction  
%       M: total number of psi points in y direction  
%       grdname: name of the grid file
%       title: title in the netcdf file  
% 
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

Lp=L+1;
Mp=M+1;

cmode = netcdf.getConstant('NETCDF4');
cmode = bitor(cmode,netcdf.getConstant('CLASSIC_MODEL'));

ncid = netcdf.create(grdname,cmode);
%ncid = netcdf.create(grdname,'NC_CLOBBER');

% Define dimensions
nz_dimid = netcdf.defDim(ncid,'nz',Nk);
nl_dimid = netcdf.defDim(ncid,'L',L);
nm_dimid = netcdf.defDim(ncid,'M',M);

%
%  Create variables and attributes
%

hini_varid = netcdf.defVar(ncid,'h','double',[nl_dimid nm_dimid nz_dimid]);
netcdf.putAtt(ncid,hini_varid,'standard_name','Initial wave height');
netcdf.putAtt(ncid,hini_varid,'units','meters');

depth_varid = netcdf.defVar(ncid,'depth','float',[nl_dimid nm_dimid]);
netcdf.putAtt(ncid,depth_varid,'standard_name','Basin Depth');
netcdf.putAtt(ncid,depth_varid,'units','meters');

depth_varid = netcdf.defVar(ncid,'depth_t','float',[nl_dimid nm_dimid]);
netcdf.putAtt(ncid,depth_varid,'standard_name','Basin Depth');
netcdf.putAtt(ncid,depth_varid,'units','meters');

depth_varid = netcdf.defVar(ncid,'wet','float',[nl_dimid nm_dimid]);
netcdf.putAtt(ncid,depth_varid,'standard_name','Basin Depth');
netcdf.putAtt(ncid,depth_varid,'units','meters');

% End definitions and leave define mode.                                        
netcdf.endDef(ncid) 

