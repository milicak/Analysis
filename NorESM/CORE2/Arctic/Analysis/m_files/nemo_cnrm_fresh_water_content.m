clear all
Sref=34.8;  % reference salinity

grid_file='/bcmhsm/milicak/RUNS/noresm/CORE2/Arctic/DATA/nemo-cnrm/CNRM_cell_area.nc';
area=ncgetvar(grid_file,'Cell_area');
%depth=ncgetvar('/bcmhsm/milicak/RUNS/noresm/CORE2/Arctic/DATA/nemo-cnrm/ORCA1_mesh_mask.nc','mbathy');

filename_s='/bcmhsm/milicak/RUNS/noresm/CORE2/Arctic/DATA/nemo-cnrm/CNRM_TSUV_decade.nc';
lon=ncgetvar(filename_s,'lon');
lat=ncgetvar(filename_s,'lat');
zt=ncgetvar(filename_s,'gdept');
zw(2:length(zt))=0.5*(zt(2:end)+zt(1:end-1));
zw(end+1)=zt(end)+(zt(end)-zw(end));

dz=zw(2:end)-zw(1:end-1);
dz3d=repmat(dz,[size(lon,1) 1 size(lon,2)]);
dz3d=permute(dz3d,[1 3 2]);

salt=ncgetvar(filename_s,'S_decade_Cy1');
salt(:,:,:,7:12)=ncgetvar(filename_s,'S_decade_Cy2');
salt(:,:,:,13:18)=ncgetvar(filename_s,'S_decade_Cy3');
salt(:,:,:,19:24)=ncgetvar(filename_s,'S_decade_Cy4');
salt(:,:,:,25:30)=ncgetvar(filename_s,'S_decade_Cy5');

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

save('matfiles/nemo_cnrm_fresh_water_content.mat','FWC','lon','lat')
