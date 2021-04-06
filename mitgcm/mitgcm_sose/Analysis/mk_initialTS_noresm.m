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

tmp_out = ['noresm20040101_Temp.bin'] ; 
slt_out = ['noresm20040101_Salt.bin'] ; 

% initial conditions from 2007 January since 2005 there is Weddell Sea Polynya
tempc = ncread('/okyanus/users/milicak/dataset/NorESM/NOIIAJRAOC20TR_TL319_tn14_20190709.micom.hm.1663-01.nc','templvl');
saltc = ncread('/okyanus/users/milicak/dataset/NorESM/NOIIAJRAOC20TR_TL319_tn14_20190709.micom.hm.1663-01.nc','salnlvl');
zrc = ncread('/okyanus/users/milicak/dataset/NorESM/NOIIAJRAOC20TR_TL319_tn14_20190709.micom.hm.1663-01.nc','depth');
lonc = ncread('/okyanus/users/milicak/dataset/NorESM/grid.nc','plon'); 
latc = ncread('/okyanus/users/milicak/dataset/NorESM/grid.nc','plat'); 

% size(tempc)
% 2160         320          42          72

temp_mit = -2*ones(size(lon,1),size(lon,2),Nz) ;
salt_mit = 35.5*ones(size(lon,1),size(lon,2),Nz) ;

dzf = [10.0,11.0,12.0,13.0,14.0,16.0,18.0,20.0,23.0,26.0, ... 
       29.0,33.0,37.0,42.0,48.0,55.0,63.0,72.0,82.0, ...     
       94.0,108.0,124.0,142.0,163.0,187.0,215.0,247.0, ...
       284.0,262.0,250.0,250.0,250.0,250.0,250.0,250.0, ...
       250.0,250.0,250.0,250.0,250.0,250.0,250.0];


% bathyfile = 'BATHY_4320x640_SO_9km_GEBCO.bin';
bathyfile = 'BATHY_4320x640_SO_9km_GEBCO_v2.bin';
bathy = readbin(bathyfile,[Nx Ny]);
maskc = ones(size(tempc,1),size(tempc,2),size(tempc,3)) ;
maskc(isnan(tempc))=0;
% maskc  = double(gr.maskCtrlC); 
hfac1 = rdmds('/okyanus/users/milicak/dataset/NorESM/hFacC');
mask1  = double((hfac1 ~= 0)) ;                        
% return
lonc = double(lonc);
latc = double(latc);

% For 0.25 degree micom grid
  % x=lon;
  % x=x(1000:end,:);
  % x(x<0)=x(x<0)+360;
  % lon(1000:end,:)=x;
% For 1degree tripolar micom grid
x=lonc;
x=x(260:end,:);
x(x<0)=x(x<0)+360;
lonc(260:end,:)=x;
x1 = lonc(1:290,:);
x2 = lonc(291:end,:)-360;
x = [x2; x1];

dd1 = tempc(1:290,:,:);
dd2 = tempc(291:end,:,:);
dd = [dd2; dd1];


for kk = 1:Nz
    kk
    tmpPf = squeeze(tempc(:,:,kk)) ;
    mask2d = squeeze(maskc(:,:,kk)); 
    % mask(tmpPf==0) = 0;
    tmpPfw = griddata(lonc(mask2d==1),latc(mask2d==1),tmpPf(mask2d==1),lonc(mask2d==0),latc(mask2d==0),'nearest');
    tmpPf(mask2d==0) = tmpPfw; 
    tmp = griddata(lonc,latc,tmpPf,lon,lat,'natural') ;
    tmp2 = griddata(lonc,latc,tmpPf,lon,lat,'nearest') ;
    % tmp(squeeze(mask(:,:,kk))==0)=0;
    tmp(isnan(tmp))=tmp2(isnan(tmp));
    temp_mit(:,:,kk) = tmp;

    tmpPf = squeeze(saltc(:,:,kk)) ;
    mask2d = squeeze(maskc(:,:,kk)); 
    tmpPfw = griddata(lonc(mask2d==1),latc(mask2d==1),tmpPf(mask2d==1),lonc(mask2d==0),latc(mask2d==0),'nearest');
    tmpPf(mask2d==0) = tmpPfw; 
    tmp = griddata(lonc,latc,tmpPf,lon,lat,'natural') ;
    tmp2 = griddata(lonc,latc,tmpPf,lon,lat,'nearest') ;
    % tmp(squeeze(mask(:,:,kk))==0)=0;
    tmp(isnan(tmp))=tmp2(isnan(tmp));
    salt_mit(:,:,kk) = tmp; 
end % kk


% Write out fields.                                                             
temp_mit(temp_mit<-2)=-2;
salt_mit(salt_mit<0)=0;

if 0 
% minimum salt 
salt_min = 10;
for i=1:Nx
    for j=1:Ny
        for k=1:Nz
            if(mask1(i,j,k)~=0)
                if(salt_mit(i,j,k)<salt_min)
                    if(k>1)
                        salt_mit(i,j,k) = salt_mit(i,j,k-1);
                    else
                        salt_mit(i,j,k) = salt_min;
                    end
                end
            end
        end
    end
end
% initial unstable region
salt_mit(3710:3910,4,:) = salt_min;
salt_mit(3710:3910,5,:) = salt_min+5;
salt_mit(3710:3910,6,:) = salt_min+10;
salt_mit(3710:3910,7,:) = salt_min+15;

% use salty area to down
aa=salt_mit(3745:3890,8,:);
aa=repmat(aa,[1 5 1]);
salt_mit(3745:3890,3:7,:)=aa;   
end

% unstable rho criteria
if 0
zr=zeros(4320,1,640); 
zw=cumsum(dz3D,3);     
zw=permute(zw,[1 3 2]);
dnm=[zr zw];
zw = dnm;
zw=permute(zw,[1 3 2]);  
zr = 0.5*(zw(:,:,2:end)+zw(:,:,1:end-1));
rho=sw_dens(salt_mit,temp_mit,zr)-1e3;
for i=1:Nx
    for j=1:Ny
        if(mask(i,j,1)~=0)
            for k=2:Nz
                if(rho(i,j,k-1)-rho(i,j,k) > 0)
                    disp([i j k])
                    temp_mit(i,j,k-1) = temp_mit(i,j,k);
                    salt_mit(i,j,k-1) = salt_mit(i,j,k);
                end
            end
        end
    end
end
end % unstable rho criteria

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




