clear all 
close all
ieee='b';                                                                       
accuracy='real*8';

tmp_out = ['woa13_Temp.data'] ;                                              
slt_out = ['woa13_Salt.data'] ; 
load grid
nx = 3360;
ny = 3072;
fact = 6370/6.378137;  % factor used to convert km output from m_lldist on
                     % a sphere with 6378.137 km to m on a sphere with
                     % radius 6370 km
%read 2 km lon lat values                    
LONC = LON(3:1:(end-3),3:1:(end-3));
LATC = LAT(3:1:(end-3),3:1:(end-3));
%read 4 km lon lat values                    
lonc = LON(4:2:(end-3),4:2:(end-3));
latc = LAT(4:2:(end-3),4:2:(end-3));

%read 4km bathy file
tempc = readbin('/home/milicak/models/MITgcm/Projects/Arctic_4km/input/WOA05_THETA_JAN_1680x1536x50_arctic',[1680 1536 50]);
saltc = readbin('/home/milicak/models/MITgcm/Projects/Arctic_4km/input/WOA05_SALT_JAN_1680x1536x50_arctic',[1680 1536 50]);

dzc = [10.00, 10.00, 10.00, 10.00, 10.00, 10.00, 10.00, 10.01, ... 
 10.03, 10.11, 10.32, 10.80, 11.76, 13.42, 16.04 , 19.82, 24.85, ...              
 31.10, 38.42, 46.50, 55.00, 63.50, 71.58, 78.90, 85.15, 90.18, ...
 93.96, 96.58, 98.25, 99.25,100.01,101.33,104.56,111.33,122.83, ...             
 139.09,158.94,180.83,203.55,226.50,249.50,272.50,295.50,318.50, ...             
 341.50,364.50,387.50,410.50,433.50,456.50];

dzr = [5.00, 5.00, 5.00, 5.00, 5.00, 5.00, 5.00, 5.00, ... 
 5.00, 5.00, 5.00, 5.00, 5.00, 5.00, 5.00, 5.00, ... 
 5.015, 5.05, 5.16, 5.40, 5.88, 6.71, 8.02 , 9.91, 10.0, ...              
 10.00, 10.00, 10.00, 10.00, 10.00, 10.00, 10.00, 10.00, ... 
 10.03, 10.11, 10.32, 10.80, 11.76, 13.42, 16.04 , 19.82, 24.85, ...              
 31.10, 38.42, 46.50, 55.00, 63.50, 71.58, 78.90, 85.15, 90.18, ...
 93.96, 96.58, 98.25, 99.25,100.01,101.33,104.56,111.33,122.83, ...             
 139.09,158.94,180.83,203.55,226.50,249.50,272.50,295.50,318.50, ...             
 330.0, 350,367.50,385.5,400.00,420.0];

depths = cumsum(dzr);
depths = depths';
depths2 = cumsum(dzc);
depths2 = depths2';
%interpolate to the 2km grid
% bathy = griddata(lonc, latc, Depth, lon, lat);


%Twoafname = '/okyanus/users/milicak/obs/woa13_decav_t13_04v2.nc';
%Swoafname = '/okyanus/users/milicak/obs/woa13_decav_s13_04v2.nc';
%tempwoa = ncread(Twoafname,'t_an');                                             
%lonwoa = ncread(Twoafname,'lon');                                               
%latwoa = ncread(Twoafname,'lat');                                               
%depthwoa = ncread(Twoafname,'depth');                                           
%saltwoa = ncread(Swoafname,'s_an');

tmp = zeros(size(LONC,1),size(LATC,2),length(dzc));
for ii=1:size(lonc,1)
    for jj=1:size(lonc,2)
        tmp(2*ii-1,2*jj-1,:) = saltc(ii,jj,:);
        tmp(2*ii,2*jj-1,:) = saltc(ii,jj,:);
        tmp(2*ii,2*jj,:) = saltc(ii,jj,:);
        tmp(2*ii-1,2*jj,:) = saltc(ii,jj,:);
    end
end
Mslt = zeros(size(LONC,1),size(LATC,2),length(dzr));
for ii=1:size(LONC,1)
    for jj=1:size(LONC,2)
        Mslt(ii,jj,:) = interp1(cumsum(dzc),squeeze(tmp(ii,jj,:)),cumsum(dzr),'linear');
    end
end
Mslt(:,:,1) = tmp(:,:,1);
Mslt(:,:,end) = tmp(:,:,end);

tmp = zeros(size(LONC,1),size(LATC,2),length(dzc));
for ii=1:size(lonc,1)
    for jj=1:size(lonc,2)
        tmp(2*ii-1,2*jj-1,:) = tempc(ii,jj,:);
        tmp(2*ii,2*jj-1,:) = tempc(ii,jj,:);
        tmp(2*ii,2*jj,:) = tempc(ii,jj,:);
        tmp(2*ii-1,2*jj,:) = tempc(ii,jj,:);
    end
end
Mtmp = zeros(size(LONC,1),size(LATC,2),length(dzr));
for ii=1:size(LONC,1)
    for jj=1:size(LONC,2)
        Mtmp(ii,jj,:) = interp1(cumsum(dzc),squeeze(tmp(ii,jj,:)),cumsum(dzr),'linear');
    end
end
Mtmp(:,:,1) = tmp(:,:,1);
Mtmp(:,:,end) = tmp(:,:,end);


% Write out fields.                                                             
fprintf(1,'\n Writing field to [%s].\n\n',tmp_out) ;                            
fid=fopen(tmp_out,'w',ieee);                                                    
fwrite(fid,Mtmp,accuracy);                                                      
fclose(fid);                                                                    
                                                                                
fprintf(1,'\n Writing field to [%s].\n\n',slt_out) ;                            
fid=fopen(slt_out,'w',ieee);                                                    
fwrite(fid,Mslt,accuracy);                                                      
fclose(fid);    
