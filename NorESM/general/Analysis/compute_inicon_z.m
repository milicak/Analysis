clear all
warning off

temp=ncgetvar('../../climatology/Analysis/inicon.nc','temp');
salt=ncgetvar('../../climatology/Analysis/inicon.nc','saln');
dz=ncgetvar('../../climatology/Analysis/inicon.nc','dz');
z=ncgetvar('../../climatology/Analysis/climatology_lvl.nc','depth');
load depth_bnds

for k=1:size(depth)
  temp_z(:,:,k)=avedepth(temp,dz,depth_bnds(1,k),depth_bnds(2,k));
  salt_z(:,:,k)=avedepth(salt,dz,depth_bnds(1,k),depth_bnds(2,k));
end

save inicon_z_1deg_micom temp_z salt_z depth depth_bnds

clear temp_z salt_z

temp=ncgetvar('/hexagon/work/milicak/shared/inicon_0_25degree.nc','temp');
dz=ncgetvar('/hexagon/work/milicak/shared/inicon_0_25degree.nc','dz');
salt=ncgetvar('/hexagon/work/milicak/shared/inicon_0_25degree.nc','saln');
for k=1:size(depth)
  temp_z(:,:,k)=avedepth(temp,dz,depth_bnds(1,k),depth_bnds(2,k));
  salt_z(:,:,k)=avedepth(salt,dz,depth_bnds(1,k),depth_bnds(2,k));
 k
end

save inicon_z_0_25deg_micom temp_z salt_z depth depth_bnds
