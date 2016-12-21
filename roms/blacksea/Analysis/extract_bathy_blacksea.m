%
%  EXTRACT_BATH:  Driver script to extract bathymetry data
%
%  This user modifiable script can extract bathymetry from ETOPO-5 database
%  at the specified coordinates.
%

% svn $Id: extract_bath.m 586 2012-01-03 20:19:25Z arango $
%===========================================================================%
%  Copyright (c) 2002-2012 The ROMS/TOMS Group                              %
%    Licensed under a MIT/X style license                                   %
%    See License_ROMS.txt                           Hernan G. Arango        %
%===========================================================================%

% job='seagrid';          %  prepare bathymetry for seagrid
 job='netcdf';           %  Extract a bathymetry NetCDF file

%database='etopo5';
database='sandwell';

switch job,
  case 'seagrid'
    Oname='blacksea_bathy.mat';
  
  case 'netcdf'
    Oname='blacksea_bathy.nc';
end,

switch database,
  case 'etopo5'
    Bname='/home/mil021/matlab/roms_tools/bathymetry/etopo5.nc';
end,

Llon=27.5;                % Left   corner longitude     % Black Sea
Rlon=41.8;                % Right  corner longitude
Blat=40.0;                % Bottom corner latitude
Tlat=47.5;                % Top    corner latitude

%-----------------------------------------------------------------------
%  Read and extract bathymetry.
%-----------------------------------------------------------------------
% h has to be negative
switch database,
  case 'etopo5'
    [lon,lat,h]=x_etopo5(Llon,Rlon,Blat,Tlat,Bname);
  case 'sandwell'
    [h,lat,lon]=mygrid_sand([Blat Tlat Llon Rlon]);
end,

%-----------------------------------------------------------------------
%  Process extracted data for requested task.
%-----------------------------------------------------------------------

switch job,
  case 'seagrid'
    xbathy=reshape(lon,1,prod(size(lon)))';
    ybathy=reshape(lat,1,prod(size(lat)))';
    zbathy=reshape(h,1,prod(size(h)))';
    zbathy=-zbathy;
    ind=find(zbathy<0);
    if (~isempty(ind)),
      zbathy(ind)=0;
    end;
    display('seagrid mat file saved')
    save(Oname,'xbathy','ybathy','zbathy');
  
  case 'netcdf'
    [Im,Jm]=size(h);  
    status=c_bath(Im,Jm,Oname);
    status=nc_write(Oname,'spherical',1);
    status=nc_write(Oname,'lon',lon);
    status=nc_write(Oname,'lat',lat);
    status=nc_write(Oname,'hraw',h,1);
    display('netcdf file saved')
end
