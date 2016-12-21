function  create_arctic_mask_file(x,y,filename)
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

nw = netcdf(filename, 'clobber');
result = redef(nw);

nw('x') = x;
nw('y') = y;

%keyboard
%
% Create global attributes
%
nw{'lon'} = ncdouble('y','x');
nw{'lon'}.long_name = ncchar('Longitude');
nw{'lon'}.units = ncchar('degrees');

nw{'lat'} = ncdouble('y','x');
nw{'lat'}.long_name = ncchar('Latitude');
nw{'lat'}.units = ncchar('degrees');

nw{'mask'} = ncdouble('y','x');
nw{'mask'}.long_name = ncchar('Arctic basin mask');
nw{'mask'}.units = ncchar('integer');

% Close the netcdf

result = endef(nw);

%
% Create global attributes
%

%nw.title = ncchar(title);
%nw.title = title;
nw.date = ncchar(date);
nw.date = date;
nw.type = ncchar('mask = 1 for Eurasian, 2 for Canada, 3 for Makarov');
nw.type = 'mask = 1 for Eurasian, 2 for Canada, 3 for Makarov';

result = close(nw);


