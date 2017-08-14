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

%L= NXTOT; M=NYTOT
Lp=L;
Mp=M;
%Lp=L+1;
%Mp=M+1;

nw = netcdf(grdname, 'clobber');
result = redef(nw);

nw('nxp') = Lp;
nw('nyp') = Mp;
nw('nx') = L-1;
nw('ny') = M-1;
nw('L') = Lhalf;
nw('M') = Mhalf;

%
%  Create variables and attributes
%

nw{'lon'} = ncfloat('one');
nw{'lon'}.long_name = ncchar('Longitude');
nw{'lon'}.units = ncchar('kilometers');
nw{'lon'}.cartesian_axis = ncchar('X');

nw{'lat'} = ncfloat('one');
nw{'lat'}.long_name = ncchar('Latitude');
nw{'lat'}.units = ncchar('kilometers');
nw{'lat'}.cartesian_axis = ncchar('Y');

nw{'x'} = ncdouble('nyp', 'nxp');
nw{'x'}.long_name = ncchar('geographic_longitude');
nw{'x'}.units = ncchar('kilometers');

nw{'y'} = ncdouble('nyp', 'nxp');
nw{'y'}.long_name = ncchar('geographic_latitude');
nw{'y'}.units = ncchar('kilometers');

nw{'dx'} = ncdouble('nyp', 'nx');
nw{'dx'}.long_name = ncchar('grid_edge_x_distance');
nw{'dx'}.units = ncchar('meters');

nw{'dy'} = ncdouble('ny', 'nxp');
nw{'dy'}.long_name = ncchar('grid_edge_y_distance');
nw{'dy'}.units = ncchar('meters');

nw{'angle'} = ncdouble('nyp', 'nxp');
nw{'angle'}.long_name = ncchar('grid_vertex_x_angle_WRT_geographic_east');
nw{'angle'}.units = ncchar('degrees_east');

nw{'area'} = ncdouble('ny', 'nx');
nw{'area'}.long_name = ncchar('grid_cell_area');
nw{'area'}.units = ncchar('m2');

nw{'depth'} = ncdouble('M', 'L');
nw{'depth'}.long_name = ncchar('Basin Depth');
nw{'depth'}.units = ncchar('meter');



% Close the netcdf

result = endef(nw);


%
% Create global attributes
%

nw.title = ncchar(title);
nw.title = title;
nw.date = ncchar(date);
nw.date = date;
nw.type = ncchar('GOLD grid file');
nw.type = 'GOLD grid file';

result = close(nw);
      
