clear all
close all
ieee='b';                                                                       
accuracy='real*8';
Nx = 4320;
Ny = 640;
Nz = 42;
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
gr = load('sosegrid_mitgcm.mat'); 
lonc = double(gr.XC);
latc = double(gr.YC);

tmp_out = ['sose20090901_Uvel_ice.bin'] ; 
slt_out = ['sose20090901_Vvel_ice.bin'] ; 

% initial conditions from 2009 September since 2005 there is Weddell Sea Polynya
tempc = rdmds('/okyanus/users/milicak/dataset/SOSE/SIuice',100);
dnm = squeeze(tempc(:,:,341:346));
dnm = squeeze(mean(dnm,3));
tempc= dnm;
saltc = rdmds('/okyanus/users/milicak/dataset/SOSE/SIvice',100);
dnm = squeeze(saltc(:,:,341:346));
dnm = squeeze(mean(dnm,3));
saltc = dnm;


temp_mit = griddata(lonc,latc,tempc,lon,lat,'natural') ;
salt_mit = griddata(lonc,latc,saltc,lon,lat,'natural') ;

hfac1 = rdmds('hFacC');
mask1  = double((hfac1 ~= 0)) ;                        
mask = squeeze(mask1(:,:,1));
temp_mit = temp_mit.*mask;
salt_mit = salt_mit.*mask;

fice = readbin('sose20090901_AREA.bin',[Nx Ny]);
mask2 = zeros(Nx,Ny);             
mask2(fice>0)=1;               

temp_mit = temp_mit.*mask2;
salt_mit = salt_mit.*mask2;
temp_mit(isnan(temp_mit))=0;
salt_mit(isnan(salt_mit))=0;

writebin(tmp_out,temp_mit,1,'real*4')
writebin(slt_out,salt_mit,1,'real*4')


