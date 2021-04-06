clear all
close all

casename = 'tau'
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


if casename=='ctl'
    tmp_out = ['OBNt_SO_pop_ctl_2007_2013_4320x640.sose'] ; 
    slt_out = ['OBNs_SO_pop_ctl_2007_2013_4320x640.sose'] ; 
    uvl_out = ['OBNu_SO_pop_ctl_2007_2013_4320x640.sose'] ; 
    vvl_out = ['OBNv_SO_pop_ctl_2007_2013_4320x640.sose'] ; 
    woatname = '/okyanus/users/milicak/dataset/pop_0_1degree/ctrl.g.e11.G.T62_t12.002.pop.h.0026-0032.26_5_S.nc';
elseif casename=='tau'
    tmp_out = ['OBNt_SO_pop_tau_2007_2013_4320x640.sose'] ; 
    slt_out = ['OBNs_SO_pop_tau_2007_2013_4320x640.sose'] ; 
    uvl_out = ['OBNu_SO_pop_tau_2007_2013_4320x640.sose'] ; 
    vvl_out = ['OBNv_SO_pop_tau_2007_2013_4320x640.sose'] ; 
    woatname = '/okyanus/users/milicak/dataset/pop_0_1degree/tau15.g.e11.G.T62_t12.002.pop.h.0026-0032.26_5_S.nc';
end
woasname = woatname;
woauname = woatname;
woavname = woatname;

tempc = ncread(woatname,'TEMP');
saltc = ncread(woasname,'SALT');
uvelc = ncread(woauname,'UVEL');
vvelc = ncread(woavname,'VVEL');
dzc = ncread(woatname,'z_t');
dzc = dzc*1e-2;
tempc = squeeze(tempc);
saltc = squeeze(saltc);
uvelc = squeeze(uvelc);
vvelc = squeeze(vvelc);
tempc(tempc==-1) = NaN;
uvelc(uvelc==-1) = NaN;
vvelc(vvelc==-1) = NaN;
saltc(saltc==-1000) = NaN;
uvelc = uvelc*1e-2;
vvelc = vvelc*1e-2;

lonc = ncread(woatname,'TLONG');

nxshift = 1100; 
% shift the data
tmp = lonc(nxshift+1:end);
tmp(end+1:end+nxshift) = lonc(1:nxshift);
lonc = tmp;
% shift temperature
tmp = tempc(nxshift+1:end,:,:);
tmp(end+1:end+nxshift,:,:) = tempc(1:nxshift,:,:);
tempc = tmp;
% shift salinity
tmp = saltc(nxshift+1:end,:,:);
tmp(end+1:end+nxshift,:,:) = saltc(1:nxshift,:,:);
saltc  = tmp;
% shift uvel
tmp = uvelc(nxshift+1:end,:,:);
tmp(end+1:end+nxshift,:,:) = uvelc(1:nxshift,:,:);
uvelc  = tmp;
% shift vvel
tmp = vvelc(nxshift+1:end,:,:);
tmp(end+1:end+nxshift,:,:) = vvelc(1:nxshift,:,:);
vvelc  = tmp;

dzf = [10.0,11.0,12.0,13.0,14.0,16.0,18.0,20.0,23.0,26.0, ... 
       29.0,33.0,37.0,42.0,48.0,55.0,63.0,72.0,82.0, ...     
       94.0,108.0,124.0,142.0,163.0,187.0,215.0,247.0, ...
       284.0,262.0,250.0,250.0,250.0,250.0,250.0,250.0, ...
       250.0,250.0,250.0,250.0,250.0,250.0,250.0];


% bathyfile = '/okyanus/users/milicak/models/MITgcm_c65/Projects/mitgcm_sose/Exp0vanilla/BATHY_4320x640_SO_9km.bin';
bathyfile = 'BATHY_4320x640_SO_9km_GEBCO_v2.bin';
bathy = readbin(bathyfile,[Nx Ny]);
hFacMin = 0.3;                                                                  
hFacMinDz = 50;                                                                  
[hFacC,dz3D] = hfac(dzf,bathy,hFacMin,hFacMinDz);
mask  = (hFacC ~= 0) ;                        
       
depths = dzc;
zrc = repmat(depths,[1 size(tempc,1)]);
zrc = double(zrc');
lonc = repmat(lonc,[1 length(dzc)]);

% MITgcm grid info
depths2 = cumsum(dzf);
depths2 = depths2';    
zrmit = repmat(depths2,[1 size(lon,1)]);
zrmit = zrmit';
lon = lon(:,end);
lon = repmat(lon,[1 length(depths2)]);

% use Objective Analysis (OA) to remove NaNs from woa fields                    
for k=1:size(tempc,3)                                                              
    tempc(:,:,k) = get_missing_val(lonc,zrc,squeeze(tempc(:,:,k)),NaN,0,0);
    saltc(:,:,k) = get_missing_val(lonc,zrc,squeeze(saltc(:,:,k)),NaN,0,35);
    uvelc(:,:,k) = get_missing_val(lonc,zrc,squeeze(uvelc(:,:,k)),NaN,0,35);
    vvelc(:,:,k) = get_missing_val(lonc,zrc,squeeze(vvelc(:,:,k)),NaN,0,35);
end                                                                             

% Extend PHC field at the bottom so no extrapolation is needed.
% maxdep = max(depths2) + 100 ;  % Add 100m to deepest depth in MITgcm model
% depths = [depths ;maxdep];
% tempc = cat(2,tempc,tempc(:,end,:)) ; % Add level at bottom to the PHC field itself
% saltc = cat(2,saltc,saltc(:,end,:)) ; % Add level at bottom to the PHC field itself
% uvelc = cat(2,uvelc,uvelc(:,end,:)) ; % Add level at bottom to the PHC field itself
% vvelc = cat(2,vvelc,vvelc(:,end,:)) ; % Add level at bottom to the PHC field itself

% Stage 1.
% Loop through each PHC grid point and interpolate vertically to MITgcm
% taking into account only the PHC's sea values
temp_new = NaN*ones(size(lonc,1),length(depths2),size(tempc,3)) ;
salt_new = NaN*ones(size(lonc,1),length(depths2),size(tempc,3)) ;
uvel_new = NaN*ones(size(lonc,1),length(depths2),size(tempc,3)) ;
vvel_new = NaN*ones(size(lonc,1),length(depths2),size(tempc,3)) ;
fprintf(1,' Interpolate PHC levs to MITgcm depths...') ;
for jj = 1:size(tempc,3)
   fprintf(1,'.') ; 
   for ii = 1:size(lonc,1)      
      tmpPf = squeeze(tempc(ii,:,jj)) ;    
      temp_new(ii,:,jj) = interp1(depths,tmpPf,depths2,'linear',NaN) ;
      tmpPf = squeeze(saltc(ii,:,jj)) ;    
      salt_new(ii,:,jj) = interp1(depths,tmpPf,depths2,'linear',NaN) ;
      tmpPf = squeeze(uvelc(ii,:,jj)) ;    
      uvel_new(ii,:,jj) = interp1(depths,tmpPf,depths2,'linear',NaN) ;
      tmpPf = squeeze(vvelc(ii,:,jj)) ;    
      vvel_new(ii,:,jj) = interp1(depths,tmpPf,depths2,'linear',NaN) ;
   end % ii
end % jj
fprintf(1,'done.\n') ;

fprintf(1,' Loop over depths interpolating to MITgcm grid...(slow!)') ;
temp_mit = zeros(size(lon,1),length(depths2),size(tempc,3)) ;
salt_mit = zeros(size(lon,1),length(depths2),size(tempc,3)) ;
uvel_mit = zeros(size(lon,1),length(depths2),size(tempc,3)) ;
vvel_mit = zeros(size(lon,1),length(depths2),size(tempc,3)) ;
for kk = 1:size(tempc,3)   % Loop over MITgcm time levels.
    kk
    tmpPf = squeeze(temp_new(:,:,kk)) ;
    temp_mit(:,:,kk) = griddata(lonc(:,1:size(zrmit,2)),zrmit(1:size(lonc,1),:),tmpPf,lon,zrmit,'nearest') ;
    tmpPf = squeeze(salt_new(:,:,kk)) ;
    salt_mit(:,:,kk) = griddata(lonc(:,1:size(zrmit,2)),zrmit(1:size(lonc,1),:),tmpPf,lon,zrmit,'nearest') ;
    tmpPf = squeeze(uvel_new(:,:,kk)) ;
    uvel_mit(:,:,kk) = griddata(lonc(:,1:size(zrmit,2)),zrmit(1:size(lonc,1),:),tmpPf,lon,zrmit,'nearest') ;
    tmpPf = squeeze(vvel_new(:,:,kk)) ;
    vvel_mit(:,:,kk) = griddata(lonc(:,1:size(zrmit,2)),zrmit(1:size(lonc,1),:),tmpPf,lon,zrmit,'nearest') ;
end % kk


% ctrl simulation is from day 9491 to 12044 (852) times
% tau  simulation is from day 9497 to 12044 (850) times
if casename=='ctl'
    save('obcs_ctl_pop','temp_mit','salt_mit','uvel_mit','vvel_mit')
elseif casename=='tau'
    % let's add 2 values at the beginning 
    dnm = temp_mit(:,:,1);
    dnm = repmat(dnm,[1 1 2]);
    dnm(:,:,end+1:end+size(temp_mit,3)) = temp_mit;
    temp_mit = dnm;

    dnm = salt_mit(:,:,1);
    dnm = repmat(dnm,[1 1 2]);
    dnm(:,:,end+1:end+size(salt_mit,3)) = salt_mit;
    salt_mit = dnm;
    
    dnm = uvel_mit(:,:,1);
    dnm = repmat(dnm,[1 1 2]);
    dnm(:,:,end+1:end+size(uvel_mit,3)) = uvel_mit;
    uvel_mit = dnm;

    dnm = vvel_mit(:,:,1);
    dnm = repmat(dnm,[1 1 2]);
    dnm(:,:,end+1:end+size(vvel_mit,3)) = vvel_mit;
    vvel_mit = dnm;
    save('obcs_tau_pop','temp_mit','salt_mit','uvel_mit','vvel_mit')
end
% return

% add last 5 values same as last time;
dnm = temp_mit(:,:,end);
dnm=repmat(dnm,[1 1 5]);
temp_mit(:,:,end+1:end+5) = dnm;
dnm = salt_mit(:,:,end);
dnm=repmat(dnm,[1 1 5]);
salt_mit(:,:,end+1:end+5) = dnm;
dnm = uvel_mit(:,:,end);
dnm=repmat(dnm,[1 1 5]);
uvel_mit(:,:,end+1:end+5) = dnm;
dnm = vvel_mit(:,:,end);
dnm=repmat(dnm,[1 1 5]);
vvel_mit(:,:,end+1:end+5) = dnm;

% mask = double(squeeze(mask(:,end,:)));
% temp_mit = temp_mit.*mask;
% salt_mit = salt_mit.*mask;
% Write out fields.                                                             

writebin(tmp_out,temp_mit,1,'real*4')
writebin(slt_out,salt_mit,1,'real*4')
writebin(uvl_out,uvel_mit,1,'real*4')
writebin(vvl_out,vvel_mit,1,'real*4')

