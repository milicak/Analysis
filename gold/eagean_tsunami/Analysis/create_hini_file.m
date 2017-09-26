function  create_hini_file(L,M,Lhalf,Mhalf,grdname,title)
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

ncid = netcdf.create(grdname,'NC_CLOBBER');

% Define dimensions
nip_dimid = netcdf.defDim(ncid,'nxp',Lp);
njp_dimid = netcdf.defDim(ncid,'nyp',Mp);
ni_dimid = netcdf.defDim(ncid,'nx',L);
nj_dimid = netcdf.defDim(ncid,'ny',M);
nz_dimid = netcdf.defDim(ncid,'nz',1);
nl_dimid = netcdf.defDim(ncid,'L',Lhalf);
nm_dimid = netcdf.defDim(ncid,'M',Mhalf);

%
%  Create variables and attributes
%

hini_varid = netcdf.defVar(ncid,'h','double',[nl_dimid nm_dimid nz_dimid]);
netcdf.putAtt(ncid,hini_varid,'standard_name','Initial wave height');
netcdf.putAtt(ncid,hini_varid,'units','meters');

% End definitions and leave define mode.                                        
netcdf.endDef(ncid) 

