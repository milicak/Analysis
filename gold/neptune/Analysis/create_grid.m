function  create_grid2(L,M,grdname,title)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%       Create an empty netcdf gridfile
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

nw = netcdf(grdname, 'clobber');
result = redef(nw);

nw('lath') = M;
nw('lonh') = L;
nw('latq') = M;
nw('lonq') = L;

%
%  Create variables and attributes
%

nw{'lath'} = ncfloat('one');
nw{'lath'}.long_name = ncchar('Latitude');
nw{'lath'}.units = ncchar('kilometers');
nw{'lath'}.cartesian_axis = ncchar('Y');

nw{'lonh'} = ncfloat('one');
nw{'lonh'}.long_name = ncchar('Longitude');
nw{'lonh'}.units = ncchar('kilometers');
nw{'lonh'}.cartesian_axis = ncchar('X');

nw{'latq'} = ncfloat('one');
nw{'latq'}.long_name = ncchar('Latitude');
nw{'latq'}.units = ncchar('kilometers');
nw{'latq'}.cartesian_axis = ncchar('Y');

nw{'lonq'} = ncfloat('one');
nw{'lonq'}.long_name = ncchar('Longitude');
nw{'lonq'}.units = ncchar('kilometers');
nw{'lonq'}.cartesian_axis = ncchar('X');


nw{'geolatb'} = ncdouble('latq', 'lonq');
nw{'geolatb'}.long_name = ncchar('latitude at q points');
nw{'geolatb'}.units = ncchar('degree');

nw{'geolonb'} = ncdouble('latq', 'lonq');
nw{'geolonb'}.long_name = ncchar('longitude at q points');
nw{'geolonb'}.units = ncchar('degree');

nw{'geolat'} = ncdouble('lath', 'lonh');
nw{'geolat'}.long_name = ncchar('latitude at h points');
nw{'geolat'}.units = ncchar('degree');

nw{'geolon'} = ncdouble('lath', 'lonh');
nw{'geolon'}.long_name = ncchar('longitude at h points');
nw{'geolon'}.units = ncchar('degree');

nw{'depth_t'} = ncdouble('lath', 'lonh');
nw{'depth_t'}.long_name = ncchar('Basin Depth');
nw{'depth_t'}.units = ncchar('meter');

%nw{'depth'} = ncdouble('lath', 'lonh');
%nw{'depth'}.long_name = ncchar('Basin Depth');
%nw{'depth'}.units = ncchar('meter');

nw{'f'} = ncdouble('latq', 'lonq');
nw{'f'}.long_name = ncchar('Coriolis Parameter');
nw{'f'}.units = ncchar('second-1');

nw{'dxv'} = ncdouble('latq', 'lonh');
nw{'dxv'}.long_name = ncchar('Zonal grid spacing at v points');
nw{'dxv'}.units = ncchar('m');

nw{'dyu'} = ncdouble('lath', 'lonq');
nw{'dyu'}.long_name = ncchar('Meridional grid spacing at u points');
nw{'dyu'}.units = ncchar('m');

nw{'dxu'} = ncdouble('lath', 'lonq');
nw{'dxu'}.long_name = ncchar('Zonal grid spacing at u points');
nw{'dxu'}.units = ncchar('m');

nw{'dyv'} = ncdouble('latq', 'lonh');
nw{'dyv'}.long_name = ncchar('Meridional grid spacing at v points');
nw{'dyv'}.units = ncchar('m');

nw{'dxh'} = ncdouble('lath', 'lonh');
nw{'dxh'}.long_name = ncchar('Zonal grid spacing at h points');
nw{'dxh'}.units = ncchar('m');

nw{'dyh'} = ncdouble('lath', 'lonh');
nw{'dyh'}.long_name = ncchar('Meridional grid spacing at h points');
nw{'dyh'}.units = ncchar('m');

nw{'dxq'} = ncdouble('latq', 'lonq');
nw{'dxq'}.long_name = ncchar('Zonal grid spacing at q points');
nw{'dxq'}.units = ncchar('m');

nw{'dyq'} = ncdouble('latq', 'lonq');
nw{'dyq'}.long_name = ncchar('Meridional grid spacing at q points');
nw{'dyq'}.units = ncchar('m');

nw{'Ah'} = ncdouble('lath', 'lonh');
nw{'Ah'}.long_name = ncchar('Area of h cells');
nw{'Ah'}.units = ncchar('m');

nw{'Aq'} = ncdouble('latq', 'lonq');
nw{'Aq'}.long_name = ncchar('Area of q cells');
nw{'Aq'}.units = ncchar('m');

nw{'wet'} = ncdouble('lath', 'lonh');
nw{'wet'}.long_name = ncchar('land or ocean?');
nw{'wet'}.units = ncchar('none');


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

