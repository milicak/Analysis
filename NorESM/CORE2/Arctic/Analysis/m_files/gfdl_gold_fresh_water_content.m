clear all
Sref=34.8;  % reference salinity

filename_s='/bcmhsm/milicak/RUNS/noresm/CORE2/Arctic/DATA/gfdl-gold/annual_tracers/ocean_z.1708-2007.salt.nc';
grid_file='/bcmhsm/milicak/RUNS/noresm/CORE2/Arctic/DATA/gfdl-gold/grids_bathymetry/ocean_geometry.nc';
lon=ncgetvar(grid_file,'geolon');
lat=ncgetvar(grid_file,'geolat');
area=ncgetvar(grid_file,'Ah');
salt=ncgetvar(filename_s,'salt');
zt=ncgetvar(filename_s,'zt');
salt(salt<-100)=NaN;

zw(2:length(zt))=0.5*(zt(2:end)+zt(1:end-1));
zw(end+1)=zt(end)+(zt(end)-zw(end));
dz=zw(2:end)-zw(1:end-1);
dz3d=repmat(dz,[size(lon,1) 1 size(lon,2)]);
dz3d=permute(dz3d,[1 3 2]);

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
tmp=(Sref-sln).*dz3d./Sref;
tmp=nansum(tmp,3);
FWC(:,:,time)=tmp;
time
end

save('matfiles/gfdl_gold_fresh_water_content.mat','FWC','lon','lat')



