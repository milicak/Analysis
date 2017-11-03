clear all

northdip = 1;
ShapeName = 'northdip'

switch ShapeName
    case char('northdip')
    fname = 'static_syn_northdip'
    outname = 'Eagean_Sea_mosaicN2275M1625_northdip.nc';
    %outname = 'Eagean_Sea_mosaicN1400M1500_northdip.nc';
    case char('southdip')
    fname = 'static_syn_southdip'
    outname = 'Eagean_Sea_mosaicN2275M1625_southdip.nc';
    %outname = 'Eagean_Sea_mosaicN1400M1500_southdip.nc';
    case char('gaussdist')
    fname = 'gaussian_initial.mat';
    outname = 'Eagean_Sea_mosaicN2275M1625_gaussian.nc';
end
end

%grdname = 'Eagean_Sea_mosaicN2275M1625.nc';
grdname = ['/export/grunchfs/unibjerknes/milicak/bckup/gold/eagean_tsunami/Eagean_Sea_mosaicN5000M5000.nc'];
%grdname = 'Eagean_Sea_mosaicN1400M1500.nc';
%command = ['cp ' grdname ' ' outname];
%status = system(command);

ll1 = ncread(grdname,'x');
ll2 = ncread(grdname,'y');
depth = double(ncread(grdname,'depth'));
depth(depth<=0) = 0;
mask = double(ncread(grdname,'depth'));
mask(mask>0) = 1;
mask(mask<=0) = 0;
lon = ll1(2:2:end,2:2:end);
lat = ll2(2:2:end,2:2:end);

a = load(fname);
switch ShapeName
    case char('northdip')
    lon1 = reshape(a(:,1),[51 89]);
    lat1 = reshape(a(:,2),[51 89]);
    zeta = reshape(a(:,3),[51 89]);
    %convert cm to meter;
    zeta = zeta.*1e-2;
    case char('southdip')
    lon1 = reshape(a(:,1),[51 89]);
    lat1 = reshape(a(:,2),[51 89]);
    zeta = reshape(a(:,3),[51 89]);
    %convert cm to meter;
    zeta = zeta.*1e-2;
    case char('gaussdist')
    lon1 = a.lon; 
    lat1 = a.lat;
    zeta = a.ssh;
 end
end


%initial wave is zero
hini = zeros(size(lon,1),size(lon,2));
hini = griddata(lon1,lat1,zeta,double(lon),double(lat));
hini(isnan(hini)) = 0.0;
hini = hini.*mask;
hini(hini == 0)=1e-10;
hini = depth+hini;
[nxhalf nyhalf] = size(hini);
nx = 2*nxhalf;
ny = 2*nyhalf;

create_hini_file(nx,ny,nxhalf,nyhalf,outname,fname)
ncwrite(outname,'h',hini);
