clear all
Sref=34.8;  % reference salinity

grid_file='/bcmhsm/milicak/RUNS/noresm/CORE2/Arctic/DATA/mir-free/bathymetry_t.nc';
area=ncgetvar(grid_file,'area_t');

filename_s='/bcmhsm/milicak/RUNS/noresm/CORE2/Arctic/DATA/mir-free/salinity_pentadal.nc';
salt=ncgetvar(filename_s,'s');
gridfile='/bcmhsm/milicak/RUNS/noresm/CORE2/Arctic/DATA/mir-free/lonlat_t.nc';
lon=ncgetvar(gridfile,'glon_t');
lat=ncgetvar(gridfile,'glat_t');
zt=ncgetvar(filename_s,'level');
zw(2:length(zt))=0.5*(zt(2:end)+zt(1:end-1));
zw(end+1)=zt(end)+(zt(end)-zw(end));
dz=zw(2:end)-zw(1:end-1);
dz3d=repmat(dz,[size(lon,1) 1 size(lon,2)]);
dz3d=permute(dz3d,[1 3 2]);

salt(salt<-100)=NaN;


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

save('matfiles/mir_free_fresh_water_content.mat','FWC','lon','lat')



