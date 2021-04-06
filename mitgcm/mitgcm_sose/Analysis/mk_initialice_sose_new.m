clear all
close all
ieee='b';                                                                       
accuracy='real*8';
Nx = 4320;
Ny = 640;
delX = 0.08333334; 
delY = 0.08333334; 
ygOrigin = -77.9166; 
% ygOrigin = -77.9583; 
xgOrigin = 0.0;  
% xgOrigin = -280.0;  
lon = xgOrigin+0.5*delX:delX:Nx*delX; 
lat = ygOrigin+0.5*delY:delY:ygOrigin+Ny*delY; 
lon = lon';lat = lat';
[x y] = meshgrid(lon,lat);
lon = x';
lat = y';

heff_out = ['sose20090901_HEFF.bin'] ; 
fice_out = ['sose20090901_AREA.bin'] ; 
hsnow_out = ['sose20090901_HSNOW.bin'] ; 

gr = load('sosegrid_mitgcm.mat'); 
lonc = double(gr.XC);
latc = double(gr.YC);

% initial conditions from 2009 September since 2005 there is Weddell Sea Polynya
ficec = rdmds('/okyanus/users/milicak/dataset/SOSE/IceConc',100);
% dnm = squeeze(ficec(:,:,731:761));
dnm = squeeze(ficec(:,:,1704:1733));
dnm = squeeze(mean(dnm,3));
ficec = dnm;
heffc = rdmds('/okyanus/users/milicak/dataset/SOSE/SIheff',100);
dnm = squeeze(heffc(:,:,341:346));
dnm = squeeze(mean(dnm,3));
heffc = dnm;

fice_mit = griddata(lonc,latc,ficec,lon,lat,'natural') ;
heff_mit = griddata(lonc,latc,heffc,lon,lat,'natural') ;
% hsnow_mit = griddata(lonc,latc,hsnowc,lon,lat,'natural') ;
hsnow_mit = zeros(size(fice_mit,1),size(fice_mit,2));

fice_mit(heff_mit<0) = 0;
fice_mit(isnan(heff_mit)) = 0;
heff_mit(heff_mit<0) = 0;
heff_mit(isnan(heff_mit)) = 0;
% hsnow_mit(hsnow_mit<0) = 0;
% hsnow_mit(isnan(hsnow_mit)) = 0;

% hsnow_mit(hsnow_mit>0 & fice_mit==0)=0;
heff_mit(heff_mit>0 & fice_mit==0)=0;  

hfac1 = rdmds('hFacC');
mask1  = double((hfac1 ~= 0)) ;                        
mask = squeeze(mask1(:,:,1));

fice_mit = fice_mit.*mask;
heff_mit = heff_mit.*mask;
hsnow_mit = hsnow_mit.*mask;

fice_mit(fice_mit<0.05 & fice_mit ~=0) = 0.05;
heff_mit(heff_mit<0.001 & heff_mit ~=0) = 0.001;
heff_mit(fice_mit~=0 & heff_mit==0)=0.001;

% Write out fields.                                                             
writebin(fice_out,fice_mit,1,'real*4')
writebin(heff_out,heff_mit,1,'real*4')
% writebin(hsnow_out,hsnow_mit,1,'real*4')

