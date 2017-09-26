function  create_hgrid(L,M,Lhalf,Mhalf,grdname,title)
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

x_varid = netcdf.defVar(ncid,'x','float',[nip_dimid njp_dimid]);
netcdf.putAtt(ncid,x_varid,'standard_name','geographic_longitude');
netcdf.putAtt(ncid,x_varid,'units','degrees_east');

y_varid = netcdf.defVar(ncid,'y','float',[nip_dimid njp_dimid]);
netcdf.putAtt(ncid,y_varid,'standard_name','geographic_latitude');
netcdf.putAtt(ncid,y_varid,'units','degrees_north');

dx_varid = netcdf.defVar(ncid,'dx','float',[ni_dimid njp_dimid]);
netcdf.putAtt(ncid,dx_varid,'standard_name','grid_edge_x_distance');
netcdf.putAtt(ncid,dx_varid,'units','meters');

dy_varid = netcdf.defVar(ncid,'dy','float',[nip_dimid nj_dimid]);
netcdf.putAtt(ncid,dy_varid,'standard_name','grid_edge_y_distance');
netcdf.putAtt(ncid,dy_varid,'units','meters');

angle_varid = netcdf.defVar(ncid,'angle','float',[nip_dimid njp_dimid]);
netcdf.putAtt(ncid,angle_varid,'standard_name','grid_vertex_x_angle_WRT_geographic_east');
netcdf.putAtt(ncid,angle_varid,'units','degrees_east');

area_varid = netcdf.defVar(ncid,'area','float',[ni_dimid nj_dimid]);
netcdf.putAtt(ncid,area_varid,'standard_name','grid_cell_area');
netcdf.putAtt(ncid,area_varid,'units','m2');

depth_varid = netcdf.defVar(ncid,'depth','float',[nl_dimid nm_dimid]);
netcdf.putAtt(ncid,depth_varid,'standard_name','Basin Depth');
netcdf.putAtt(ncid,depth_varid,'units','meters');

% End definitions and leave define mode.                                        
netcdf.endDef(ncid) 

