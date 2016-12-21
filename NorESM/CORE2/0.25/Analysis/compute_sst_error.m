%clear all

%1 degree tripolar NorESM to 1 degree WOA
%filename='/bcmhsm/milicak/RUNS/noresm/CORE2/0.25/NOIIA_T62_tn11_sr10m60d_01_sst_annual_61-120.nc';
%map_file='/bcmhsm/milicak/RUNS/noresm/CORE2/Arctic/maps/map_tnx1v1_to_woa09_aave_20120501.nc';

%0.25 degree tripolar NorESM to 0.25 degree WOA
filename='/bcmhsm/milicak/RUNS/noresm/CORE2/0.25/NOIIA_T62_tn025_001_sst_annual_61-120.nc';
map_file='/bcmhsm/milicak/RUNS/noresm/CORE2/Arctic/maps/map_noresm_tnx0.25v1_to_woa09_0_25deg_aave_.nc';
%to 1degree WOA
%map_file='/bcmhsm/milicak/RUNS/noresm/CORE2/Arctic/maps/map_noresm_tnx0.25v1_to_woa09_1deg_aave_.nc';

%1 degree WOA
%temp_woa=ncgetvar('~/Analysis/NorESM/climatology/Analysis/WOA09_temp.nc','t');
%lat_woa=ncgetvar('~/Analysis/NorESM/climatology/Analysis/WOA09_temp.nc','lat');
%lon_woa=ncgetvar('~/Analysis/NorESM/climatology/Analysis/WOA09_temp.nc','lon');
%temp_woa=squeeze(temp_woa(:,:,1));

%0.25 degree WOA
temp_woa=ncgetvar('/export/grunchfs/unibjerknes/milicak/bckup/OISST/sst.mean_year_1981_2012.nc','sst');
lon_woa=ncgetvar('/export/grunchfs/unibjerknes/milicak/bckup/OISST/sst.mean_year_1981_2012.nc','lon');
lat_woa=ncgetvar('/export/grunchfs/unibjerknes/milicak/bckup/OISST/sst.mean_year_1981_2012.nc','lat');

% Read regrid indexes and weights
n_a=ncgetdim(map_file,'n_a');
n_b=ncgetdim(map_file,'n_b');
S=sparse(ncgetvar(map_file,'row'),ncgetvar(map_file,'col'), ...
         ncgetvar(map_file,'S'),n_b,n_a);

% Get dimensions, longitude and latitude of WOA09 grid
dst_grid_dims=ncgetvar(map_file,'dst_grid_dims');
nx_b=dst_grid_dims(1)
ny_b=dst_grid_dims(2)
lon_b=reshape(ncgetvar(map_file,'xc_b'),nx_b,ny_b);
lat_b=reshape(ncgetvar(map_file,'yc_b'),nx_b,ny_b);
lon_b=lon_b(:,1);
lat_b=lat_b(1,:)';

% Get destination area of interpolated data
destarea=reshape(S*ones(n_a,1),nx_b,ny_b);

% Read model data
sst_model_a=ncgetvar(filename,'sst');
sst_model_a=squeeze(nanmean(sst_model_a(:,:,1:60),3));

% Regrid model data on to WOA09 grid
sst_model_b=reshape(S*reshape(sst_model_a,[],1),nx_b,ny_b)./destarea;

% Shift logitude range from [0,360> to [-180,180>.
lon_b=[(lon_b((nx_b/2+1):end)-360);lon_b(1:nx_b/2)];
sst_model_b=[sst_model_b((nx_b/2+1):end,:);sst_model_b(1:nx_b/2,:)];
temp_woa=[temp_woa((nx_b/2+1):end,:);temp_woa(1:nx_b/2,:)];

lon=lon_b*ones(1,ny_b);
lat=ones(nx_b,1)*lat_b';

sst_error=sst_model_b-temp_woa;

m_proj('Equidistant Cylindrical','lon',[-180 180],'lat',[-90 90]);
m_pcolor(lon,lat,sst_error);shading interp;colorbar
colormap(bluewhitered(20));
caxis([-7 7])
xlabel('Longitude','fontsize',14)
ylabel('Latitude','fontsize',14)
m_coast('patch',[.7 .7 .7]);
m_grid








break
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

fld=extrap(sst_model_b);
figure_height_scale=0.65;
cbar_width_scale=1;
fontsize=12;
cv=[0:2:28];
figure(1);clf;hold on
m_proj('Equidistant Cylindrical','lon',[-180 180],'lat',[-90 90]);
set(gcf,'paperunits','inches','papersize',[8 6*figure_height_scale], ...
        'paperposition',[0 0 8 6*figure_height_scale],'renderer','painters')
set(gca,'outerposition',[0 0 1 1],'position',[0.1 0.2 0.8 0.75])
colormap(cbsafemap(511,'rdylbu'))
[c,h]=m_contourf(lon,lat,-fld,[-cv(1) inf],'linecolor','none');
set(findobj(h,'type','patch'),'facecolor','flat','cdata',-inf);
[c,hc]=m_contourf(lon,lat,fld,cv,'linecolor','none');
m_contour(lon,lat,fld,cv,'linecolor','k')
xlabel('Longitude','fontsize',fontsize)
ylabel('Latitude','fontsize',fontsize)
m_coast('patch',[.7 .7 .7]);
m_grid
set(gca,'DataAspectRatioMode','auto')
hb=cbarfmb([-inf inf],cv,'vertical','nonlinear');
ylabel(hb,'^{\circ}C','fontsize',fontsize);
pos=get(hb,'position');
pos(3)=pos(3)*cbar_width_scale;
set(hb,'position',pos,'fontsize',fontsize)
cdatamidlev([hc;hb],cv);
caxis([cv(1) cv(end)])
caxis(hb,[cv(1) cv(end)])

eval(['print -depsc sst_clim_' expr '.eps'])
