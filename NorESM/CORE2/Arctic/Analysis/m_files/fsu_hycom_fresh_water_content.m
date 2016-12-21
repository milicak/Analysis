
clear all
Sref=34.8;  % reference salinity

grid_file='/bcmhsm/milicak/RUNS/noresm/CORE2/Arctic/DATA/fsu-hycom/bathy_2darea_glb1x3.nc';
area=ncgetvar(grid_file,'area');
bathy=ncgetvar(grid_file,'bathy');
bathy3d=repmat(bathy,[1 1 60]);
filename_s='/bcmhsm/milicak/RUNS/noresm/CORE2/Arctic/DATA/fsu-hycom/TSuv_pentadals_glb1x3.nc';
salt=ncgetvar(filename_s,'salinity');
lon=ncgetvar(filename_s,'Longitude');
lat=ncgetvar(filename_s,'Latitude');
zt=ncgetvar(filename_s,'Depth');
filename_t='/bcmhsm/milicak/RUNS/noresm/CORE2/Arctic/DATA/NorESM/NOIIA_T62_tn11_sr10m60d_01_temperature_pendatal_1-300.nc';
ztref=ncgetvar(filename_t,'depth');
ztref=ztref(2:end);Nz=size(ztref,1);

salt(salt<-100)=NaN;
zw(:,:,2:size(zt,3),:)=0.5*(zt(:,:,2:end,:)+zt(:,:,1:end-1,:));
zw(:,:,end+1,:)=bathy3d;
dz3d=zw(:,:,2:end,:)-zw(:,:,1:end-1,:);
dz3d(dz3d<0)=0;

nx=size(salt,1);ny=size(salt,2);
for time=1:size(salt,4)
sln=squeeze(salt(:,:,:,time));
for i=1:nx;for j=1:ny
%kind=max(find(sln(i,j,:)<=Sref));
%if(isempty(kind)==0)
%sln(i,j,kind+1:end)=NaN;
%end
k=1;
fwclogic=true;
for kk=1:size(salt,3)
if (fwclogic==true)
  if(sln(i,j,k)<=Sref)
    k=k+1;
  else
    fwclogic=false;
  end
end
end
sln(i,j,k:end)=NaN;
end;end
dztmp=squeeze(dz3d(:,:,:,time));
tmp=(Sref-sln).*dztmp./Sref;
tmp=nansum(tmp,3);
FWC(:,:,time)=tmp;
time
end

save('matfiles/fsu_hycom_fresh_water_content.mat','FWC','lon','lat')



