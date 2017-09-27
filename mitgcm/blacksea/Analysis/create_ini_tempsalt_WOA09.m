close all
clear all; clear global;
more off
% Masking parameters                                                            
hFacMin = 0.1;                                                                  
hFacMinDz = 0.5;                                                                  
land = 0;        
ieee='b';                                                                       
accuracy='real*8';

tmp_out = ['woa13_Temp.data'] ;                                              
slt_out = ['woa13_Salt.data'] ; 


batfile = 'Blacksea_2km_bathy.bin' ;
ibcaofile = '/export/grunchfs/unibjerknes/milicak/bckup/world_grid/GEBCO_2014_1D.nc';
run set_blacksea_2km_grid 

fid = fopen(batfile,'r',ieee); 
h = fread(fid,[NX NY],accuracy);                                                
fclose(fid);                                                                    
[hFacC,dz3D] = hfac(delZ,h,hFacMin,hFacMinDz);                                  
mask  = (hFacC ~= 0) ;                                                          
mask2d  = mask (:,:,1);                                                         
clear hFacC    

Twoafname = '/export/grunchfs/unibjerknes/milicak/bckup/OISST/woa13_decav_t00_04v2.nc';
Swoafname = '/export/grunchfs/unibjerknes/milicak/bckup/OISST/woa13_decav_s00_04v2.nc';

tempwoa = ncread(Twoafname,'t_an');
lonwoa = ncread(Twoafname,'lon');
latwoa = ncread(Twoafname,'lat');
depthwoa = ncread(Twoafname,'depth');
saltwoa = ncread(Swoafname,'s_an');

% Map WOA13 fields to MITgcm grid.    
Mtmp = map_woa2MITgcm(tempwoa,LONC,LATC,lonwoa,latwoa,depths,depthwoa,10) ;
Mslt = map_woa2MITgcm(saltwoa,LONC,LATC,lonwoa,latwoa,depths,depthwoa,15) ;
% Remove land points.
fprintf(1,'\n Removing land points...(uses hFactors...') ;
for ii = 1:NX
    for jj = 1:NY
        inds2 = find(~squeeze(mask(ii,jj,:))) ;   % Remove land            points.
        Mtmp(ii,jj,inds2) = land.*ones(size(inds2)) ;
        Mslt(ii,jj,inds2) = land.*ones(size(inds2)); 
    end % jj
end % ii

% Write out fields.                                                             
fprintf(1,'\n Writing field to [%s].\n\n',tmp_out) ;                            
fid=fopen(tmp_out,'w',ieee);                                                    
fwrite(fid,Mtmp,accuracy);                                                      
fclose(fid);                                                                    
                                                                                
fprintf(1,'\n Writing field to [%s].\n\n',slt_out) ;                            
fid=fopen(slt_out,'w',ieee);                                                    
fwrite(fid,Mslt,accuracy);                                                      
fclose(fid);    
