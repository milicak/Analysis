clear all
Sref=34.8;  % reference salinity

grid_file='/fimm/home/bjerknes/milicak/Analysis/NorESM/climatology/Analysis/WOA09_salt.nc';
lon=ncgetvar(grid_file,'lon');
lat=ncgetvar(grid_file,'lat');
[lon lat]=meshgrid(lon,lat);
lon=lon';lat=lat';

filename_s='/fimm/home/bjerknes/milicak/Analysis/NorESM/climatology/Analysis/WOA09_salt.nc';
salt=ncgetvar(filename_s,'s');
zt=nc_varget(filename_s,'depth');
zw(2:length(zt))=0.5*(zt(2:end)+zt(1:end-1));
zw(end+1)=zt(end)+(zt(end)-zw(end));
dz=zw(2:end)-zw(1:end-1);
dz3d=repmat(dz,[size(lon,1) 1 size(lon,2)]);
dz3d=permute(dz3d,[1 3 2]);


sln=squeeze(salt(:,:,:));
nx=size(salt,1);ny=size(salt,2);
for i=1:nx;for j=1:ny
%if(sln(i,j,1)<=Sref)
%  kind=max(find(sln(i,j,:)<=Sref));
%   if(isempty(kind)==0)
%     sln(i,j,kind+1:end)=NaN;
%   else
%     sln(i,j,:)=NaN;
%   end
%else
% sln(i,j,:)=NaN;
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
FWC(:,:)=tmp;

save('matfiles/woa_fresh_water_content.mat','FWC','lon','lat')


