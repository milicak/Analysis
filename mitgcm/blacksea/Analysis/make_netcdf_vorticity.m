clear all
colormaptype = 'demcmap';
%colormaptype = 'gebcoland';
%colormaptype = 'gray';

root_folder = '/okyanus/users/milicak/models/MITgcm_c65/Projects/Blacksea_lonlat/work';
root_folder2 = '/okyanus/users/milicak/models/MITgcm_c65/Projects/Blacksea_lonlat/2011_exp2';

latg = rdmds([root_folder '/' 'YG']);
lon = rdmds([root_folder '/' 'XC']);
lat = rdmds([root_folder '/' 'YC']);
fcor = coriolis(latg);
level = 1; % surface plot

t0 = rdmds([root_folder2 '/' 'T'],0);
t0 = squeeze(t0(:,:,1));
mask = ones(size(t0,1),size(t0,2));
mask(t0~=0) = NaN;

for i=210:210
    vort = rdmds([root_folder2 '/' 'vorticity'],i*864);
    uvel = rdmds([root_folder2 '/' 'UVEL'],i*864);
    vvel = rdmds([root_folder2 '/' 'VVEL'],i*864);
    vort2d = squeeze(vort(:,:,level));
    vort2dnon = vort2d./fcor;
end

[Nx Ny Nz] = size(vort);

nccreate('vortfield.nc','lon','Dimensions',{'lon',Nx,'lat',Ny});
nccreate('vortfield.nc','lat','Dimensions',{'lon',Nx,'lat',Ny});
nccreate('vortfield.nc','vorticity','Dimensions',{'lon',Nx,'lat',Ny,'depth',Nz});
nccreate('vortfield.nc','uvel','Dimensions',{'lon',Nx,'lat',Ny,'depth',Nz});
nccreate('vortfield.nc','vvel','Dimensions',{'lon',Nx,'lat',Ny,'depth',Nz});
nccreate('vortfield.nc','vort2d','Dimensions',{'lon',Nx,'lat',Ny});
nccreate('vortfield.nc','vort2dnon','Dimensions',{'lon',Nx,'lat',Ny});
nccreate('vortfield.nc','fcor','Dimensions',{'lon',Nx,'lat',Ny});

ncwrite('vortfield.nc','lon',lon);
ncwrite('vortfield.nc','lat',lat);
ncwrite('vortfield.nc','vorticity',vort);
ncwrite('vortfield.nc','uvel',uvel);
ncwrite('vortfield.nc','vvel',vvel);
ncwrite('vortfield.nc','vort2d',vort2d);
ncwrite('vortfield.nc','vort2dnon',vort2dnon);
ncwrite('vortfield.nc','fcor',fcor);
