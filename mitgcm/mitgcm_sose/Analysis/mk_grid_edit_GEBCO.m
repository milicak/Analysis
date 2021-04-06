clear all

Nx = 4320;
Ny = 640;
shallowest_depth = 10 ;
land = 0;


bathy=readbin('BATHY_4320x640_SO_9km_GEBCO.bin',[Nx Ny]);   
dnm = bathy;
dnm(3600:3630,525:545)=0;                                      
pcolor(sq(bathy(3600:3650,515:545))');shfn


fprintf(1,'2. Removing isolated ocean points.\n') ;                             
for nn = 1:8   % 3 or 4 sweeps should be enough?                                
   for ii = 2:Nx-1                                                              
      for jj = 2:Ny-1                                                           
         sides = (dnm(ii-1,jj  ) <= - shallowest_depth) + ...                 
                 (dnm(ii  ,jj-1) <= - shallowest_depth) + ...                 
                 (dnm(ii  ,jj+1) <= - shallowest_depth) + ...                 
                 (dnm(ii+1,jj  ) <= - shallowest_depth) ;                     
         if(sides < 2 && dnm(ii,jj) <= - shallowest_depth)    % Less than 2 sides of this ocean point areocean points.
            dnm(ii,jj) = land ;                                               
%           fprintf(1,' Splat (%d, %d)!\n',ii,jj) ;                             
         end % if                                                               
      end %jj                                                                   
   end %ii                                                                      
end % nn                                                                        


dnm(1620:1700,580:610) = 0;


% north point
dnm(1827,end-1:end,:) = 0;

% not sure for the SOUTH
% dnm(:,2) = bathy(:,2);
dnm(:,1) = 0; 

writebin('BATHY_4320x640_SO_9km_GEBCO_v2.bin',dnm,1,'real*4')   
