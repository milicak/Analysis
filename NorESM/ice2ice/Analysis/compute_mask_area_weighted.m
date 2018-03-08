clear all

mask = ncread('mask_fwf_50to70N.nc','fwf_mask'); 
mask1 = ones(size(mask,1),size(mask,2));
mask1(mask==0) = 0;
area = ncread('../../climatology/Analysis/grid.nc','parea');

Nconstant = sum(mask1(:));
Ninv = 1./Nconstant;

fwf = Ninv./(area);
fwf(mask1==0) = 0;

ncwrite('mask_fwf_50to70N_areaweighted.nc','fwf_mask',fwf);

