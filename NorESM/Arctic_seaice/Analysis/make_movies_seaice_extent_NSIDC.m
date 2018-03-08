clear all
warning off

rgb = imread('land_shallow_topo_2048.jpg');  
[X map] = rgb2ind(rgb,256);
lon_x = -180:360/2047:180;
lat_y = -90:180/1023:90;
lat_y = lat_y';
[lon_x lat_y] = meshgrid(lon_x,lat_y);
X = flipdim(double(X),1);
icevalue = X(950,760);

%grdname = '/media/milicak/Mehmet_Lacie_10TB/grunch_export/noresm/CORE2/Arctic/DATA/seaice_obs/nsidc_sic_north_1979_2015_landundef_latlon.nc';
%lon = ncread(grdname,'lon');
%lat = ncread(grdname,'lat');
%grdname = 'G10010_SIBT1850_v1.1.nc';
grdname = 'NSIDC_sea_ice_concentration_1979_2016.nc';
lon = ncread(grdname,'longitude');
lat = ncread(grdname,'latitude');

resolution = 0.23045; %1; %0.5;
[nx ny] = size(lon);
%nx = size(lon,1);
%ny = size(lat,1);
%[x y] = meshgrid(lon,lat);
%lon = x';
%lat = y';
deg2rad = pi/180;
grid_corner_lat = zeros(4,nx,ny);
grid_corner_lon = zeros(4,nx,ny);
grid_corner_lat(1,:,:) = lat-0.5*resolution;
grid_corner_lat(2,:,:) = lat-0.5*resolution;
grid_corner_lat(3,:,:) = lat+0.5*resolution;
grid_corner_lat(4,:,:) = lat+0.5*resolution;
grid_corner_lon(1,:,:) = lon-0.5*resolution;
grid_corner_lon(2,:,:) = lon+0.5*resolution;
grid_corner_lon(3,:,:) = lon+0.5*resolution;
grid_corner_lon(4,:,:) = lon-0.5*resolution;
grid_area = 2*(sin(grid_corner_lat(4,1,:)*deg2rad) ...
                -sin(grid_corner_lat(1,1,:)*deg2rad))*pi/nx;
grid_area=ones(nx,1)*reshape(grid_area,1,[]);
rad2m=distdim(1,'rad','m');
area = grid_area*rad2m*rad2m;
%area = 25000*25000*ones(nx,ny);
ice_cr = 0.15;
%fice = ncread(grdname,'seaice_conc');
%fice = ncread(grdname,'seaice_conc_monthly_cdr');
fice = ncread(grdname,'goddard_bt_seaice_conc_monthly');
%fice = ncread(grdname,'goddard_nt_seaice_conc_monthly');
%fice = ncread(grdname,'goddard_merged_seaice_conc_monthly');
%fice = fice./100;
%fice = fice(:,:,end-419:end);
%fice = ncread(grdname,'sic');
fice(isnan(fice)) = 0.0;
fice(fice<ice_cr) = 0.0;
fice(fice>=ice_cr) = 1.0;
fice = reshape(fice,[nx ny 12 size(fice,3)/12]);
area = repmat(area,[1 1 12 size(fice,4)]);
% March
%fice = (fice(:,:,3,:));
%area = (area(:,:,3,:));
% September
fice = (fice(:,:,9,:));
area = (area(:,:,9,:));
tmp = fice.*area;
tmp = squeeze(nanmean(tmp,3));
tmp = nansum(squeeze(nansum(tmp,1)),1);
fice = squeeze(nanmean(fice,3));

time = 1979:2016;
% The values below are downloaded from the excel file of NSIDC
dataname = 'Sea_Ice_Index_Monthly_Data_by_Year_G02135_v3.0.xlsx';
seaicedata = xlsread(dataname,'NH-Extent','B3:N41');
% seaicedata(:,1:12) are monthly mean seaicedata(:,end) annual mean

kk = 36;
for timeind = 36:38
    hhh=figure('Visible','off');
    m_proj('stereographic','lat',90,'long',0,'radius',45);
    m_pcolor(lon_x,lat_y,X);shading flat;colormap(map) 
    hold on
    freezeColors
    m_pcolor(lon,lat,sq(fice(:,:,timeind)))
    shading interp
    colormap(white)
    m_grid('xticklabels',[],'yticklabels',[]);
    axes('Position',[.1 .1 .8 .84])
    plot(time(1:timeind),seaicedata(1:timeind,13),'r','linewidth',2)
    set(gca,'color','none')
    xlabel('years')
    %title('Arctic Sea Ice Extent March 1979 - 2016')
    title('Arctic Sea Ice Extent September 1979 - 2016')
    text(2008.2,10.12,'Source=NSIDC','color','b','fontsize',14)
    text(2011,12.32,num2str(time(timeind)),'color','k','fontsize',18,'fontweight','bold')
    xlim([1978 2020])
    ylim([10 12.5])
    set(gca,'yticklabel',{'10' '10.5' '11' '11.5' '12' ' '})
    xTicks = get(gca, 'xtick');
    yTicks = get(gca,'ytick');
    ylabel('Annual Sea Ice Extent')
    minX = min(xTicks);
    text(minX - 7.2, yTicks(6), ['$$\begin{array}{c}', ...
      '\mathrm{millions}','\\','\mathrm{km^2}','\end{array}$$'], ...
      'fontsize',16,'Interpreter', 'latex','fontname','Helvetica');
    fig = gcf;
    fig.PaperPosition = [0 0 8 6];
    no = num2str(kk,'%.4d');
    kk = kk+1
    printname = ['gifs/seaice_extent_' no]
    print(printname,'-dpng','-r0')
    close all
end
return

if 0
figure
lat = double(lat);
lon = double(lon);
fice = double(fice);
axesm ('ortho', 'Origin',[90 0],'MapLatLimit',[40 90],'Frame', 'on', 'Grid', 'on');
pcolorm(lat_y,lon_x,X);shading flat;colormap(map) 
hold on
freezeColors
%grys = contrast(sq(fice(:,:,1)));
%surflm(lat,lon,sq(fice(:,:,1)))
pcolorm(lat,lon,sq(fice(:,:,1)))
shading flat
%colormap(grys)
colormap(white)
%caxis([0 1])
return
end

figure
m_proj('stereographic','lat',90,'long',0,'radius',45);
m_pcolor(lon_x,lat_y,X);shading flat;colormap(map) 
hold on
freezeColors
m_pcolor(lon,lat,sq(fice(:,:,1)))
shading interp
colormap(white)
m_grid('xticklabels',[],'yticklabels',[]);
axes('Position',[.1 .1 .8 .84])
plot(time,tmp,'r','linewidth',2)
set(gca,'color','none')
xlabel('years')
ylabel('millions km^2')
title('Arctic Sea Ice Extent')
xlim([1970 2020])
ylim([10 12.5])
return

figure
axesm ('ortho', 'Origin',[90 0],'MapLatLimit',[40 90],'Frame', 'on', 'Grid', 'on');
geoshow(topo,topolegend,'DisplayType','texturemap')
hold on
freezeColors
pcolorm(lat,lon,sq(fice(:,:,1)));
shading flat


