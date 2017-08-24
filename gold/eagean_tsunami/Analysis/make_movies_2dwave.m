%clear all
colormaptype = 'demcmap';
%colormaptype = 'gebcoland';
%colormaptype = 'gray';

if 1
root_folder = '/hexagon/work/milicak/RUNS/gold/eagean_tsunami/';

project_name = 'Exp01.0'

grid_name = [root_folder project_name '/OUT/' 'ocean_geometry.nc'];
ini_name = [root_folder project_name '/OUT/' 'GOLD_IC.nc'];
fname = [root_folder project_name '/prog2.nc'];

mask1 = ncread(grid_name,'wet');
depth = ncread(grid_name,'D');
dnm = -depth;
dnm(dnm<0) = NaN;
lon = ncread(grid_name,'geolon');
lat = ncread(grid_name,'geolat');
mask2 = zeros(size(depth,1),size(depth,2));
mask2(depth>0) = 1;
e1 = ncread(ini_name,'eta');
e2 = ncread(fname,'e');

eta = zeros(size(e1,1),size(e1,2),size(e2,4)+1);
eta(:,:,2:end) = squeeze(e2(:,:,1,:));
eta(:,:,1) = squeeze(e1(:,:,1));


%% isosurface
%maxtracer=0.25;mintracer=0.15;
%isosurf=[mintracer:(maxtracer-mintracer)/8:maxtracer];
%facealphavalues=[0.3 0.2 0.25 0.4 0.35 0.4 0.5 0.6 1.0];
%is=1;
%p2=patch(isosurface(lon3d,lat3d,z_rho_real,tr_avg,isosurf(is)));
%%isonormals(lon3d,lat3d,z_rho_real,tr,p2);
%%set(p2,'Facecolor','r','EdgeColor','none');
%set(p2,'Facecolor',colors(is,:),'EdgeColor','none','FaceAlpha',facealphavalues(is));
%hold on

%is=4;
%p2=patch(isosurface(lon3d,lat3d,z_rho_real,tr_avg,isosurf(is)));
%%set(p2,'Facecolor',colors(is,:),'EdgeColor','none','FaceAlpha',facealphavalues(is));
%set(p2,'Facecolor',[1 1 0],'EdgeColor','none','FaceAlpha',0.5);
%hold on
end

C = [-5000.0 -4000.0 -3000.0 -2500.0 -2000.0 ...                                
     -1500.0 -1000.0  -500.0  -200.0  -100.0 ...                                
     -50.0   -25.0   -10.0     0.0    50.0 ...                                
      100.0   200.0   300.0   400.0   500.0 ...                                
      600.0   700.0   800.0  1000.0];      

% for full gebco bathy      
%[c,hc]=m_contourf(lon,lat,-depth,C,'linecolor','none');
%colormap(gebco)
%hb=cbarfmb([C(1) C(end)],C,'horizontal','nonlinear'); 
%cdatamidlev([hc;hb],C,'nonlinear'); 
topo = -depth;
topo(topo<0) = NaN;

for k=1:60
    no=num2str(k,'%.4d');
    skip = 1;
    %hhh = figure(1);
    hhh=figure('Visible','off');
    set(hhh, 'Position', [220 220 800 600]) 

    offset = 200;
    data_plot = squeeze(eta(:,:,k)).*mask2;
    data_plot(mask2==0)=NaN;

    %m_proj('lambert','lon',[26.8 28.3],'lat',[36.5 37.2]);
    % whole_domain
    m_proj('lambert','lon',[25 29],'lat',[35 38]);

    %data_plot(mask2==0)=NaN;
    m_pcolor(lon,lat,data_plot*offset);shading interp
    hold on
    %needJet2
    %colormap(map)
    %colormap(jet(2097152));
    %colormap(rainbow(2097152));
    colormap(bluewhitered(32))
    caxis([-0.5 0.5]*offset)
    freezeColors
    switch colormaptype
        case char('gray')
            %b1 = m_pcolor(lon,lat,sq(1-mask1));shading interp
            b1 = m_pcolor(lon,lat,sq(1-mask2));shading interp
            colormap(gray)
            caxis([-15 7]) % make it a little darker
        case char('gebcoland')
            [c,hc]=m_contourf(lon,lat,dnm,C(14:end),'linecolor','none');
            colormap(gebco_land)
            hb=cbarfmi([0 C(end)],C(14:end),'horizontal','nonlinear');
            cdatamidlev([hc;hb],C,'nonlinear');
        case char('demcmap')
            m_pcolor(lon,lat,dnm);shading interp 
            demcmap([0 2000])
        %end
    end
    m_grid
    printname=['gifs/Bodrum_ssh_2d' no];                                           
    set(gca,'LooseInset',get(gca,'TightInset'))                                 
    set(gca, 'visible', 'off')                                                  
    set(gcf,'color','w')                                                        
    print(hhh,'-r300','-dpng','-zbuffer',printname)  
    k
    close all
end
