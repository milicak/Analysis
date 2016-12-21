function  create_climatology(Nx,Ny,Nz,filename,title)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%       Create an empty netcdf climatology file
%       L: total number of psi points in x direction  
%       M: total number of psi points in y direction  
%       grdname: name of the grid file
%       title: title in the netcdf file  
% 
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

x=Nx;
y=Ny;
z=Nz;

nw = netcdf(filename, 'clobber');
result = redef(nw);

nw('x') = Nx;
nw('y') = Ny;
nw('depth') = Nz;


%
%  Create variables and attributes
%

nw{'depth'} = ncdouble('depth');
nw{'depth'}.long_name = ncchar('Depth Levels');
nw{'depth'}.units = ncchar('meters');
nw{'depth'}.cartesian_axis = ncchar('Z');

nw{'temp'} = ncdouble('depth','y','x');
nw{'temp'}.long_name = ncchar('temperature at p points');
nw{'temp'}.units = ncchar('Celcius');

nw{'saln'} = ncdouble('depth','y','x');
nw{'saln'}.long_name = ncchar('salinity at p points');
nw{'saln'}.units = ncchar('psu');

% Close the netcdf

result = endef(nw);

%
% Create global attributes
%

nw.title = ncchar(title);
nw.title = title;
nw.date = ncchar(date);
nw.date = date;
nw.type = ncchar('Climatology PCH3.0 file');
nw.type = 'Climatology PCH3.0 file';

result = close(nw);


