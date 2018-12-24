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

heff_out = ['soda20070101_HEFF.data'] ; 
hsnow_out = ['soda20070101_HSNOW.data'] ; 
fice_out = ['soda20070101_AREA.data'] ; 


woafname = 'soda3.7.2shrt_5dy_ice_or_2007_01_01.nc';

ficec = ncread(woafname,'cn');
ficec = squeeze(nansum(ficec,3));
heffc = ncread(woafname,'hi');
hsnowc = ncread(woafname,'hs');

lonc = ncread('topog.nc','x_T');
latc = ncread('topog.nc','y_T');

ficec = ficec(:,1:415,:);
heffc = heffc(:,1:415,:);
hsnowc = hsnowc(:,1:415,:);
lonc = lonc(:,1:415);
latc = latc(:,1:415);

% flip heff, area, and hsnow
dnm = squeeze(heffc);
aa = dnm(lonc<0);
aa = reshape(aa,[size(aa,1)/415 415]); 
bb = dnm(lonc>0);                     
bb = reshape(bb,[size(bb,1)/415 415]); 
heffc = [bb ;aa];                      
dnm = squeeze(hsnowc);
aa = dnm(lonc<0);
aa = reshape(aa,[size(aa,1)/415 415]); 
bb = dnm(lonc>0);                     
bb = reshape(bb,[size(bb,1)/415 415]); 
hsnowc = [bb ;aa];                      
dnm = squeeze(ficec);
aa = dnm(lonc<0);
aa = reshape(aa,[size(aa,1)/415 415]); 
bb = dnm(lonc>0);                     
bb = reshape(bb,[size(bb,1)/415 415]); 
ficec = [bb ;aa];                      

dnm = lonc; 
aa = dnm(lonc<0);
aa = reshape(aa,[size(aa,1)/415 415]); 
aa = aa+360;
bb = dnm(lonc>0);                     
bb = reshape(bb,[size(bb,1)/415 415]); 
lonc = [bb;aa];

% use Objective Analysis (OA) to remove NaNs from woa fields                    
% for k=1:size(tempc,3)                                                              
    % tempc(:,:,k) = get_missing_val(lonc,latc,squeeze(tempc(:,:,k)),NaN,0,0);
    % saltc(:,:,k) = get_missing_val(lonc,latc,squeeze(saltc(:,:,k)),NaN,0,35);
% end                                                                             

fice_mit = griddata(lonc,latc,ficec,lon,lat,'cubic') ;
heff_mit = griddata(lonc,latc,heffc,lon,lat,'cubic') ;
hsnow_mit = griddata(lonc,latc,hsnowc,lon,lat,'cubic') ;

fice_mit(heff_mit<0) = 0;
fice_mit(isnan(heff_mit)) = 0;
heff_mit(heff_mit<0) = 0;
heff_mit(isnan(heff_mit)) = 0;
hsnow_mit(hsnow_mit<0) = 0;
hsnow_mit(isnan(hsnow_mit)) = 0;

hsnow_mit(hsnow_mit>0 & fice_mit==0)=0;
heff_mit(heff_mit>0 & fice_mit==0)=0;  

bathyfile = 'BATHY_4320x640_SO_9km.bin';
bathy = readbin(bathyfile,[Nx Ny]);
mask = ones(size(lon,1),size(lon,2));
mask(bathy==0) = 0;

fice_mit = fice_mit.*mask;
heff_mit = heff_mit.*mask;
hsnow_mit = hsnow_mit.*mask;
% Write out fields.                                                             

writebin(fice_out,fice_mit,1,'real*4')
writebin(heff_out,heff_mit,1,'real*4')
writebin(hsnow_out,hsnow_mit,1,'real*4')

