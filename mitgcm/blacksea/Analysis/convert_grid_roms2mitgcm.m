% compute lonc and latc                                 
% LONC (x,y) dimensions                                 
% LATC (x,y) dimensions                                 
% LONC.bin  longitude east of cell center               
% LATC.bin  latitude north of cell center               
% LONG.bin  longitude east of southwest corner of cell  
% LATG.bin  latitude north of southwest corner of cell  
% DYF.bin   meridional distance in m between V-points   
% DXF.bin   zonal distance in m between U-points        
% DYU.bin   meridional distance in m between U-points   
% DXV.bin   zonal distance in m between V-points        
% DYC.bin   meridional distance in m between tracer poin
% DXC.bin   zonal distance in m between tracer points   
% DYG.bin   meridional distance in m between cell corner
% DXG.bin   zonal distance in m between cell corners    
% RAZ.bin   vertical face area in m^2 for vorticity poin
% RAW.bin   vertical face area in m^2 for u cells       
% RAS.bin   vertical face area in m^2 for v cells       
% RA.bin    vertical face area in m^2 for tracer cells  

clear all

% note that ROMS creates WEIRDLY one point wrong points!!!!
grdname = 'ROMS_bottom_left_corner_grid.nc'
lonr = ncread(grdname,'lon_rho');
latr = ncread(grdname,'lat_rho');

% second dimension is x and first dimension is y!
Nx = size(lonr,1);
Ny = size(lonr,2);

long = zeros(Nx+1,Ny+1);
latg = zeros(Nx+1,Ny+1);
lonu = zeros(Nx+1,Ny);
latu = zeros(Nx+1,Ny);
lonv = zeros(Nx,Ny+1);
latv = zeros(Nx,Ny+1);

% first read q points
dnm = ncread(grdname,'lon_psi');
long(2:end-1,2:end-1) = dnm;
dnm = ncread(grdname,'lat_psi');
latg(2:end-1,2:end-1) = dnm;

% read u and v points
dnm = ncread(grdname,'lon_u');
lonu(2:end-1,:) = dnm;
dnm = ncread(grdname,'lat_u');
latu(2:end-1,:) = dnm;
dx1 = lonu(2,:)-lonr(1,:);
lonu(1,:) = lonr(1,:)-dx1;
latu(1,:) = latu(2,:);
dx1 = lonr(end,:)-lonu(end-1,:);
lonu(end,:) = lonr(end,:)+dx1;
latu(end,:) = latu(end-1,:);

long(1,1:end-1) = lonu(1,:);
long(end,1:end-1) = lonu(end,:);
long(:,end) = lonu(:,end);
long(2:end,1) = lonu(2:end,1);

latg(1:end-1,1) = latv(:,1);
latg(1:end-1,end) = latv(:,end);
latg(end,:) = latv(end,:);
latg(1,2:end) = latv(1,2:end);

dnm = ncread(grdname,'lon_v');
lonv(:,2:end-1) = dnm;
dnm = ncread(grdname,'lat_v');
latv(:,2:end-1) = dnm;
dy1 = latv(:,2)-latr(:,1);
latv(:,1) = latr(:,1)-dy1;
lonv(:,1) = lonv(:,2);
dy1 = latr(:,end)-latv(:,end-1);
latv(:,end) = latr(:,end)+dy1;
lonv(:,end) = lonv(:,end-1);


% MITgcm variables
LONC = lonr;
LATC = latr;

LONG = long(1:end-1,1:end-1);
LATG = latg(1:end-1,1:end-1);



% dx=1/pm and dy=1/pn
pm = ncread(grdname,'pm');
pn = ncread(grdname,'pn');
dx = 1./pm;   
dy = 1./pn; 

for i=1:Nx
for j=1:Ny

    DXG(i,j) = m_lldist([long(i+1,j) long(i,j)],[latg(i+1,j) latg(i,j)])*1e3; % convert to meter
    DYG(i,j) = m_lldist([long(i,j+1) long(i,j)],[latg(i,j+1) latg(i,j)])*1e3; % convert to meter

 
    if (i>=2 & j>=2)
        DXC(i,j) = m_lldist([lonr(i,j) lonr(i-1,j)],[latr(i,j) latr(i-1,j)])*1e3;
        DYC(i,j) = m_lldist([lonr(i,j) lonr(i,j-1)],[latr(i,j) latr(i,j-1)])*1e3;
    elseif (i==1 & j>=2)
        DXC(i,j) = 2*m_lldist([lonr(i,j) lonu(i,j)],[latr(i,j) latu(i,j)])*1e3;
        DYC(i,j) = m_lldist([lonr(i,j) lonr(i,j-1)],[latr(i,j) latr(i,j-1)])*1e3;
    elseif (j==1 & i>=2)
        DXC(i,j) = m_lldist([lonr(i,j) lonr(i-1,j)],[latr(i,j) latr(i-1,j)])*1e3;
        DYC(i,j) = 2*m_lldist([lonr(i,j) lonv(i,j)],[latr(i,j) latv(i,j)])*1e3;
    elseif (i==1 & j==1)
        DXC(i,j) = 2*m_lldist([lonr(i,j) lonu(i,j)],[latr(i,j) latu(i,j)])*1e3;
        DYC(i,j) = 2*m_lldist([lonr(i,j) lonv(i,j)],[latr(i,j) latv(i,j)])*1e3;
    end

    DXF(i,j) = m_lldist([lonu(i+1,j) lonu(i,j)],[latu(i+1,j) latu(i,j)])*1e3;
    DYF(i,j) = m_lldist([lonv(i,j+1) lonv(i,j)],[latv(i,j+1) latv(i,j)])*1e3;

    if (i>=2)
        DXV(i,j) = m_lldist([lonv(i,j) lonv(i-1,j)],[latv(i,j) latv(i-1,j)])*1e3;
    elseif (i==1)
        DXV(i,j) = 2*m_lldist([lonv(i,j) long(i,j)],[latv(i,j) latg(i,j)])*1e3;
    end

    if (j>=2)
        DYU(i,j) = m_lldist([lonu(i,j) lonu(i,j-1)],[latu(i,j) latu(i,j-1)])*1e3;
    elseif (j==1)
        DYU(i,j) = 2*m_lldist([lonu(i,j) long(i,j)],[latu(i,j) latg(i,j)])*1e3;
    end
end
end


