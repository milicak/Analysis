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

tmp_out = ['soda20070101_Temp.data'] ; 
slt_out = ['soda20070101_Salt.data'] ; 


woafname = 'soda3.7.2shrt_5dy_ocean_or_2007_01_01.nc';

tempc = ncread(woafname,'temp');
saltc = ncread(woafname,'salt');
dzc = ncread(woafname,'st_ocean');

lonc = ncread('topog.nc','x_T');
latc = ncread('topog.nc','y_T');
topoc = ncread('topog.nc','depth');


dzf = [10.0,11.0,12.0,13.0,14.0,16.0,18.0,20.0,23.0,26.0, ... 
       29.0,33.0,37.0,42.0,48.0,55.0,63.0,72.0,82.0, ...     
       94.0,108.0,124.0,142.0,163.0,187.0,215.0,247.0, ...
       284.0,262.0,250.0,250.0,250.0,250.0,250.0,250.0, ...
       250.0,250.0,250.0,250.0,250.0,250.0,250.0];


bathyfile = 'BATHY_4320x640_SO_9km.bin';
bathy = readbin(bathyfile,[Nx Ny]);
hFacMin = 0.3;                                                                  
hFacMinDz = 50;                                                                  
[hFacC,dz3D] = hfac(dzf,bathy,hFacMin,hFacMinDz);
mask  = (hFacC ~= 0) ;                        
       
depths = dzc;
depths2 = cumsum(dzf);
depths2 = depths2';    


%dnm = lon;
%dnm(dnm>80) = dnm(dnm>80)-360;
%aa = dnm(dnm<0);
%aa = reshape(aa,[size(aa,1)/Ny Ny]);
%bb = dnm(dnm>0);
%bb = reshape(bb,[size(bb,1)/Ny Ny]);
%lon = [aa ;bb];


tempc = tempc(:,1:415,:);
saltc = saltc(:,1:415,:);
lonc = lonc(:,1:415);
latc = latc(:,1:415);
topoc = topoc(:,1:415);

% flip temp and salt
for kk=1:size(tempc,3)
    dnm = squeeze(tempc(:,:,kk));
    aa = dnm(lonc<0);
    aa = reshape(aa,[size(aa,1)/415 415]); 
    bb = dnm(lonc>0);                     
    bb = reshape(bb,[size(bb,1)/415 415]); 
    tempc(:,:,kk) = [bb ;aa];                      
    dnm = squeeze(saltc(:,:,kk));
    aa = dnm(lonc<0);
    aa = reshape(aa,[size(aa,1)/415 415]); 
    bb = dnm(lonc>0);                     
    bb = reshape(bb,[size(bb,1)/415 415]); 
    saltc(:,:,kk) = [bb ;aa];                      
end
dnm = lonc; 
aa = dnm(lonc<0);
aa = reshape(aa,[size(aa,1)/415 415]); 
aa = aa+360;
bb = dnm(lonc>0);                     
bb = reshape(bb,[size(bb,1)/415 415]); 
lonc = [bb;aa];


% use Objective Analysis (OA) to remove NaNs from woa fields                    
for k=1:size(tempc,3)                                                              
    tempc(:,:,k) = get_missing_val(lonc,latc,squeeze(tempc(:,:,k)),NaN,0,0);
    saltc(:,:,k) = get_missing_val(lonc,latc,squeeze(saltc(:,:,k)),NaN,0,35);
end                                                                             

% Extend PHC field at the bottom so no extrapolation is needed.
maxdep = max(depths2) + 100 ;  % Add 100m to deepest depth in MITgcm model
depths = [depths ;maxdep];
tempc = cat(3,tempc,tempc(:,:,end)) ; % Add level at bottom to the PHC field itself
saltc = cat(3,saltc,saltc(:,:,end)) ; % Add level at bottom to the PHC field itself

% Stage 1.
% Loop through each PHC grid point and interpolate vertically to MITgcm
% taking into account only the PHC's sea values
temp_new = NaN*ones(size(lonc,1),size(lonc,2),length(depths2)) ;
salt_new = NaN*ones(size(lonc,1),size(lonc,2),length(depths2)) ;
fprintf(1,' Interpolate PHC levs to MITgcm depths...') ;
for jj = 1:size(lonc,2)
   fprintf(1,'.') ; 
   for ii = 1:size(lonc,1)      
      tmpPf = squeeze(tempc(ii,jj,:)) ;    
      temp_new(ii,jj,:) = interp1(depths,tmpPf,depths2,'linear',NaN) ;
      tmpPf = squeeze(saltc(ii,jj,:)) ;    
      salt_new(ii,jj,:) = interp1(depths,tmpPf,depths2,'linear',NaN) ;
   end % ii
end % jj
fprintf(1,'done.\n') ;

fprintf(1,' Loop over depths interpolating to MITgcm grid...(slow!)') ;
temp_mit = zeros(size(lon,1),size(lon,2),length(depths2)) ;
salt_mit = zeros(size(lon,1),size(lon,2),length(depths2)) ;
for kk = 1:length(depths2)   % Loop over MITgcm levels.
    kk
    tmpPf = squeeze(temp_new(:,:,kk)) ;
    temp_mit(:,:,kk) = griddata(lonc,latc,tmpPf,lon,lat,'cubic') ;
    tmpPf = squeeze(salt_new(:,:,kk)) ;
    salt_mit(:,:,kk) = griddata(lonc,latc,tmpPf,lon,lat,'cubic') ;
end % kk

% temp_mit = temp_mit.*mask;
% salt_mit = salt_mit.*mask;
temp_mit(1,:,:) = temp_mit(2,:,:);
temp_mit(end-1,:,:) = temp_mit(end-2,:,:);
temp_mit(end,:,:) = temp_mit(end-1,:,:);
salt_mit(1,:,:) = salt_mit(2,:,:);
salt_mit(end-1,:,:) = salt_mit(end-2,:,:);
salt_mit(end,:,:) = salt_mit(end-1,:,:);
% Write out fields.                                                             
temp_mit(temp_mit<-2)=-2;

writebin(tmp_out,temp_mit,1,'real*4')
writebin(slt_out,salt_mit,1,'real*4')

