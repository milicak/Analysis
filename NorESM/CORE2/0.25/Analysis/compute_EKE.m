clear all

filename1='/bcmhsm/milicak/RUNS/noresm/CORE2/0.25/NOIIA_T62_tn11_sr10m60d_01_u_velocity_annual_1-120.nc';
filename2='/bcmhsm/milicak/RUNS/noresm/CORE2/0.25/NOIIA_T62_tn11_sr10m60d_01_v_velocity_annual_1-120.nc';
filename3='/bcmhsm/milicak/RUNS/noresm/CORE2/0.25/NOIIA_T62_tn025_001_u_velocity_annual_1-120.nc';
filename4='/bcmhsm/milicak/RUNS/noresm/CORE2/0.25/NOIIA_T62_tn025_001_v_velocity_annual_1-120.nc';

uvel1=nc_varget(filename1,'uvel',[100 0 0 0],[-1 1 -1 -1]);
vvel1=nc_varget(filename2,'vvel',[100 0 0 0],[-1 1 -1 -1]);
uvel2=nc_varget(filename3,'uvel',[100 0 0 0],[-1 1 -1 -1]);
vvel2=nc_varget(filename4,'vvel',[100 0 0 0],[-1 1 -1 -1]);

vvel1(:,end+1,:)=vvel1(:,1,:);
uvel1(:,:,end+1)=uvel1(:,:,end);
dnm=0.5*(vvel1(:,1:end-1,:)+vvel1(:,2:end,:));
vvel1=dnm;
dnm=0.5*(uvel1(:,:,1:end-1)+uvel1(:,:,2:end));
uvel1=dnm;

vvel2(:,end+1,:)=vvel2(:,1,:);
uvel2(:,:,end+1)=uvel2(:,:,end);
dnm=0.5*(vvel2(:,1:end-1,:)+vvel2(:,2:end,:));
vvel2=dnm;
dnm=0.5*(uvel2(:,:,1:end-1)+uvel2(:,:,2:end));
uvel2=dnm;

uvel1mean=(nanmean(uvel1,1));
vvel1mean=(nanmean(vvel1,1));
uvel2mean=(nanmean(uvel2,1));
vvel2mean=(nanmean(vvel2,1));

uvel1mean=repmat(uvel1mean,[20 1 1]);
vvel1mean=repmat(vvel1mean,[20 1 1]);
uvel2mean=repmat(uvel2mean,[20 1 1]);
vvel2mean=repmat(vvel2mean,[20 1 1]);

u1eddy=uvel1-uvel1mean;
v1eddy=vvel1-vvel1mean;
u2eddy=uvel2-uvel2mean;
v2eddy=vvel2-vvel2mean;

KE1=0.5*(uvel1.^2+vvel1.^2);
KE2=0.5*(uvel2.^2+vvel2.^2);
MKE1=0.5*(uvel1mean.^2+vvel1mean.^2);
MKE2=0.5*(uvel2mean.^2+vvel2mean.^2);
EKE1=u1eddy.^2+v1eddy.^2;
EKE2=u2eddy.^2+v2eddy.^2;

pclon=reshape(ncgetvar('../../../climatology/Analysis/grid.nc','pclon'),[],4)';
pclat=reshape(ncgetvar('../../../climatology/Analysis/grid.nc','pclat'),[],4)';
dnm=squeeze(nanmean(EKE1,1));
global pclon pclat MAP_PROJECTION

micom_flat(log10(dnm'.*1e4))
colorbar
%caxis([-0.5 3.5])
%colormap(rainbow)
colormap(jet(256))
caxis([0 3.5])
xlabel('Lon')
ylabel('Lat')
m_coast('patch',[.7 .7 .7],'edgecolor','b');
m_grid
print -dpng -r300 EKE_1degree
close

pclon=reshape(ncgetvar('/work/milicak/0.25/grid.nc','pclon'),[],4)';
pclat=reshape(ncgetvar('/work/milicak/0.25/grid.nc','pclat'),[],4)';
dnm=squeeze(nanmean(EKE2,1));
global pclon pclat MAP_PROJECTION

micom_flat(log10(dnm'.*1e4))
%micom_flat((dnm'.*1e4))
colorbar
colormap(jet(256))
caxis([0 3.5])
%caxis([-0.5 3.5])
%colormap(rainbow)
xlabel('Lon')
ylabel('Lat')
m_coast('patch',[.7 .7 .7],'edgecolor','b');
m_grid
print -dpng -r300 EKE_0_25degree
close



