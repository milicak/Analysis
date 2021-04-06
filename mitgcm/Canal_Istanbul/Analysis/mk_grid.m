clear all

Nx = 1728;
Ny = 648;

root_folder = '/okyanus/users/milicak/models/MITgcm_c65/Projects/TSS_NETFLUX/INPUT/';

lon = readbin([root_folder 'LONC.bin'],[1728 648]);
lat = readbin([root_folder 'LATC.bin'],[1728 648]);
depth = readbin([root_folder 'bathy_MITgcm.bin'],[1728 648]);

if ~exist('Marmaragrid_1sec_gebco.mat')
    xrange = ncread('/okyanus/users/milicak/dataset/world_bathy/GEBCO_2014_1D.nc','x_range');
    yrange = ncread('/okyanus/users/milicak/dataset/world_bathy/GEBCO_2014_1D.nc','y_range');
    dim = ncread('/okyanus/users/milicak/dataset/world_bathy/GEBCO_2014_1D.nc','dimension');
    spc = ncread('/okyanus/users/milicak/dataset/world_bathy/GEBCO_2014_1D.nc','spacing');
    
    depthgebco = ncread('/okyanus/users/milicak/dataset/world_bathy/GEBCO_2014_1D.nc','z');
    depthgebco = reshape(depthgebco,[dim(1) dim(2)]);
    depthgebco=depthgebco';
    depthgebco=flipud(depthgebco);
    depthgebco=depthgebco';
    
    lonmin = 25.0;
    lonmax = 31.0;
    latmin = 39.5;
    latmax = 42.0;
    
    long = xrange(1)+0.5*spc(1):double(xrange(2)-xrange(1))/double(dim(1)):xrange(2)-0.5*spc(1);
    latg = yrange(1)+0.5*spc(2):double(yrange(2)-yrange(1))/double(dim(2)):yrange(2)-0.5*spc(2);
    
    iind1 = max(find(long<lonmin));
    iind2 = max(find(long<lonmax));
    jind1 = max(find(latg<latmin));
    jind2 = max(find(latg<latmax));
    
    long = long(iind1:iind2);
    latg = latg(jind1:jind2);
    depthgebco = depthgebco(iind1:iind2,jind1:jind2);
    save('Marmaragrid_1sec_gebco','long','latg','depthgebco')

else
    load('Marmaragrid_1sec_gebco.mat')
    load('lonlat_path_CI.mat')
    dxcanal = 500/111e3; % half width of the canal
    x1 = x-dxcanal;
    x2 = x+dxcanal;
    XX = [x1,fliplr(x2)];
    YY = [y,fliplr(y)];
    XX(end+1) = XX(1);
    YY(end+1) = YY(1);
    in = insphpoly(lon,lat,XX,YY,0,90);
    in = double(in);
    dnm = depth;
    dnm(depth==0 & in==1)=-20;
end



