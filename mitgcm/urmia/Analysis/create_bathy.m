% Script to read IBCAO data and create irminger bathy for the 2km runs
% NOTE: This uses the new IBCAO 2km-res. version released in march 08
% (see paper Jakobsson et al, 2008, GRL, doi: 10.1029/2008gl033520) 
% and the geographic coords version of the IBCAO data
% 
% itimu, Jan 10 
% based on read_ibcao_SS_bathy.m by twhn Jul 04, Sep 07

close all
clear all; clear global;
fprintf(1,' Reading/writing GEBCO 2014 30min bathymetry.\n\n') ;

outfile = 'urmia_bathy.bin' ;
grfile = '/okyanus/users/milicak/dataset/urmia/ROMS_Urmia.nc'
depth = ncread(grfile, 'hraw');
mask = ncread(grfile, 'mask_rho');

depth = -depth(2:end-1,2:end-1)./100;
mask = mask(2:end-1,2:end-1);

% reduce one last point
depth = depth(2:end-1,:);
mask = mask(2:end-1,:);
% return
land = 0 ;   % height of land for fixing grid.
deep_min = -1/100;
deep_cutoff = -235/100 ; % caxis variable - deepest height plotted.
depth(depth<deep_cutoff) = deep_cutoff;
depth(depth>=deep_min) = deep_min;
depth = depth.*mask;
depth = fliplr(depth');

% Write out field.
fprintf(1,' Writing field to %s\n',outfile) ;
ieee='b';
accuracy='real*8';
fid=fopen(outfile,'w',ieee); 
fwrite(fid,depth,accuracy);
fclose(fid);


