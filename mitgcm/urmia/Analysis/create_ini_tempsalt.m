close all
clear all; clear global;
more off
% Masking parameters                                                            
hFacMin = 0.1;                                                                  
hFacMinDz = 0.01;                                                                  
land = 0;        
ieee='b';                                                                       
accuracy='real*8';

tmp_out = ['Temp_ini.bin'] ;                                              
slt_out = ['Salt_ini.bin'] ; 


batfile = 'urmia_bathy.bin';
run set_urmia_grid

fid = fopen(batfile,'r',ieee); 
h = fread(fid,[NX NY],accuracy);                                                
fclose(fid);                                                                    

delZ = [0.01, 0.01, 0.01, 0.01, 0.01, 0.05, 0.05, 0.05, 0.05, 0.2, 0.2, 0.2, 0.2, 0.2, 0.2, 0.2, 0.2, 0.25, 0.25];
NZ = length(delZ);

[hFacC,dz3D] = hfac(delZ,h,hFacMin,hFacMinDz);                                  
mask  = (hFacC ~= 0) ;                                                          
clear hFacC    
% return

Mtmp = 18*ones(NX,NY,NZ);
Mslt = 270*ones(NX,NY,NZ);


load('/okyanus/users/milicak/python_tools/Analysis/mitgcm/urmia/Analysis/dens_april_deep.mat')
load('/okyanus/users/milicak/python_tools/Analysis/mitgcm/urmia/Analysis/dens_april_shallow.mat')

% surface rho
rho_s_mit = griddata(dens_april_shallow(1,:),dens_april_shallow(2,:),dens_april_shallow(3,:),LONC,LATC,'nearest');
% deep rho
rho_d_mit = griddata(dens_april_deep(1,:),dens_april_deep(2,:),dens_april_deep(3,:),LONC,LATC,'nearest');

rho_s_mit = rho_s_mit*1e3;
rho_d_mit = rho_d_mit*1e3;
% where ρ0 = 1237 kgm−3 , α = 3.5 · 10−4 C−1 , β = 9.5 · 10−4 , T0 = 23 ◦C, and S0 = 278 ppt. W
alpha = 3.5e-4;
beta = 9.5e-4;
S0 = 278;
T0 = 23;
rho0 = 1237;

salt_shallow = S0 + ((rho_s_mit./rho0) - 1 + alpha*(18-23))./beta;
salt_deep = S0 + ((rho_d_mit./rho0) - 1 + alpha*(18-23))./beta;

% salt_shallow = repmat(salt_shallow,[1 1 NZ]);
% salt_deep = repmat(salt_deep,[1 1 NZ]);
if 1
for i = 1:NX
    for j = 1:NY
        mask1d  = squeeze(mask (i,j,:));
        kind = sum(mask1d);
        if (kind~=0)
            if(kind~=1)
            for kk=1:kind
                Mslt(i,j,kk) = salt_shallow(i,j) + (kk-1)*(salt_deep(i,j)-salt_shallow(i,j))/(kind-1);
            end
            else
                Mslt(i,j,1) = salt_shallow(i,j) ;
            end
        end
    end
end
end

% only first three layer are shallow profile, the rest is deep profile
if 0
for k=1:NZ
    if(k<4)
        Mslt(:,:,k) = salt_shallow;
    else
        Mslt(:,:,k) = salt_deep;
    end
end
end

% remove 25 psu to balance the salinitification in the model
Mslt = Mslt-25;

% return
% Mslt(:,:,1:5) = salt_shallow(:,:,1:5); 
% Mslt(:,:,6:NZ) = salt_deep(:,:,6:NZ); 

% Remove land points.
%fprintf(1,'\n Removing land points...(uses hFactors...') ;
%for ii = 1:NX
%    for jj = 1:NY
%        inds2 = find(~squeeze(mask(ii,jj,:))) ;   % Remove land            points.
%        Mtmp(ii,jj,inds2) = land.*ones(size(inds2)) ;
%        Mslt(ii,jj,inds2) = land.*ones(size(inds2)); 
%    end % jj
%end % ii


% Write out fields.                                                             
fprintf(1,'\n Writing field to [%s].\n\n',tmp_out) ;                            
fid=fopen(tmp_out,'w',ieee);                                                    
fwrite(fid,Mtmp,accuracy);                                                      
fclose(fid);                                                                    
                                                                                
fprintf(1,'\n Writing field to [%s].\n\n',slt_out) ;                            
fid=fopen(slt_out,'w',ieee);                                                    
fwrite(fid,Mslt,accuracy);                                                      
fclose(fid);    


