clear all
grid_name='grid.nc';
clim_name='inicon.nc';
Nz=53;

lon=nc_varget(grid_name,'plon');
lat=nc_varget(grid_name,'plat');
area=double(nc_varget(grid_name,'parea'));

%mask=ones(200,360).*NaN;
%mask=nc_varget(grid_name,'pmask');

temp=double(nc_varget(clim_name,'temp'));
salt=double(nc_varget(clim_name,'saln'));
dz=nc_varget(clim_name,'dz'); 

for i=1:360      
for j=1:385      
if(lat(j,i)>80)
mask(j,i)=1;
else
mask(j,i)=NaN;       
end
end
end

mask3d=repmat(mask,[1 1 Nz]);  
mask3d=permute(mask3d,[3 1 2]);
area3d=repmat(area,[1 1 Nz]);                
area3d=permute(area3d,[3 1 2]);

area1d=squeeze(nansum(area3d.*mask3d,3));            
area1d=squeeze(nansum(area1d,2));

dnm=temp.*mask3d.*area3d;
dnm=squeeze(nansum(dnm,3));
dnm=squeeze(nansum(dnm,2));

dnm=dnm./area1d;

dnm2=salt.*mask3d.*area3d;
dnm2=squeeze(nansum(dnm2,3));
dnm2=squeeze(nansum(dnm2,2));

dnm2=dnm2./area1d;

dnm3=dz.*mask3d.*area3d;
dnm3=squeeze(nansum(dnm3,3));
dnm3=squeeze(nansum(dnm3,2));

dnm3=dnm3./area1d;
z_w(1)=0;
for k=1:Nz
z_w(k+1)=z_w(k)+dnm3(k);
end
z_r=0.5*(z_w(2:end)+z_w(1:end-1));



m_proj('stereographic','lat',90,'radius',25);
m_pcolor(lon,lat,squeeze(salt(1,:,:)));shading flat;colorbar
m_grid
m_coast('patch',[.7 .7 .7])
caxis([28 36])


