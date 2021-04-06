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
gr = load('/home/milicak/models/MITgcm/Projects/mitgcm_sose/input/grid.mat');
lonc = gr.XC;
latc = gr.YC;
% mask = ones(2160,320); 
% mask(gr.Depth==0) = 0;

tmp_out = ['sose20070101_Temp.data'] ; 
slt_out = ['sose20070101_Salt.data'] ; 


out = load('sosegrid_mitgcm.mat'); 
tempc = rdmds('/media/milicak/DATA1/datasets/sose/THETA',100,'rec',147);
saltc = rdmds('/media/milicak/DATA1/datasets/sose/SALT',100,'rec',147);

% size(tempc)
% 2160         320          42          72

temp_mit = zeros(size(lon,1),size(lon,2),Nz) ;
salt_mit = zeros(size(lon,1),size(lon,2),Nz) ;

dzf = [10.0,11.0,12.0,13.0,14.0,16.0,18.0,20.0,23.0,26.0, ... 
       29.0,33.0,37.0,42.0,48.0,55.0,63.0,72.0,82.0, ...     
       94.0,108.0,124.0,142.0,163.0,187.0,215.0,247.0, ...
       284.0,262.0,250.0,250.0,250.0,250.0,250.0,250.0, ...
       250.0,250.0,250.0,250.0,250.0,250.0,250.0];


bathyfile = 'BATHY_4320x640_SO_9km_GEBCO.bin';
bathy = readbin(bathyfile,[Nx Ny]);
hFacMin = 0.3;                                                                  
hFacMinDz = 50;                                                                  
[hFacC,dz3D] = hfac(dzf,bathy,hFacMin,hFacMinDz);
mask  = (hFacC ~= 0) ;                        
maskc  = (gr.hFacC ~= 0) ;                        
% return

for kk = 1:Nz
    kk
    tmpPf = squeeze(tempc(:,:,kk)) ;
    mask2d = squeeze(maskc(:,:,kk)); 
    % mask(tmpPf==0) = 0;
    tmpPfw = griddata(lonc(mask2d==1),latc(mask2d==1),tmpPf(mask2d==1),lonc(mask2d==0),latc(mask2d==0),'nearest');
    tmpPf(mask2d==0) = tmpPfw; 
    tmp = griddata(lonc,latc,tmpPf,lon,lat,'cubic') ;
    tmp2 = griddata(lonc,latc,tmpPf,lon,lat,'nearest') ;
    tmp(squeeze(mask(:,:,kk))==0)=0;
    tmp(isnan(tmp))=tmp2(isnan(tmp));
    temp_mit(:,:,kk) = tmp;

    tmpPf = squeeze(saltc(:,:,kk)) ;
    tmpPfw = griddata(lonc(mask2d==1),latc(mask2d==1),tmpPf(mask2d==1),lonc(mask2d==0),latc(mask2d==0),'nearest');
    tmpPf(mask2d==0) = tmpPfw; 
    tmp = griddata(lonc,latc,tmpPf,lon,lat,'cubic') ;
    tmp2 = griddata(lonc,latc,tmpPf,lon,lat,'nearest') ;
    tmp(squeeze(mask(:,:,kk))==0)=0;
    tmp(isnan(tmp))=tmp2(isnan(tmp));
    salt_mit(:,:,kk) = tmp; 
end % kk



% Write out fields.                                                             
temp_mit(temp_mit<-2)=-2;
salt_mit(salt_mit<-2)=-2;

writebin(tmp_out,temp_mit,1,'real*4')
writebin(slt_out,salt_mit,1,'real*4')


% temp_mit(1:2:end-1,1:2:end-1,:) = tempc;
% temp_mit(2:2:end,2:2:end,:) = tempc;
% temp_mit(1:2:end-1,2:2:end,:) = tempc;
% temp_mit(2:2:end,1:2:end-1,:) = tempc;
%
% salt_mit(1:2:end-1,1:2:end-1,:) = saltc;
% salt_mit(2:2:end,2:2:end,:) = saltc;
% salt_mit(1:2:end-1,2:2:end,:) = saltc;
% salt_mit(2:2:end,1:2:end-1,:) = saltc;
%
% % Write out fields.                                                             
% temp_mit(temp_mit<-2)=-2;




