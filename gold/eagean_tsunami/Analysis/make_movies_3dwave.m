%cl1ar all
if 0
    
root_folder = '/hexagon/work/milicak/RUNS/gold/eagean_tsunami/';

project_name = 'Exp01.0'

grid_name = [root_folder project_name '/OUT/' 'ocean_geometry.nc'];
ini_name = [root_folder project_name '/OUT/' 'GOLD_IC.nc'];
fname = [root_folder project_name '/prog2.nc'];

mask1 = ncread(grid_name,'wet');
depth = ncread(grid_name,'D');
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

for k=1:60
    no=num2str(k,'%.4d');
    skip = 1;
    hhh=figure('Visible','off');
    %hhh = figure(1)
    set(hhh, 'Position', [220 220 800 600]) 
    %l3 = light;
    %lightangle(l3, 0, 90)  

    b1 = mesh(lon,lat,-depth);
    set(b1,'Facecolor',[.8 .8 .8],'EdgeColor','none');
    camlight; lighting gouraud;
    hold on
    %view(-10,10)
    zlim([-2200 2000])
    view(3)
    view(-30,40)
    %xlim([26.8 28.3]);ylim([36.5 37.2])
    xlim([26.5 28.3]);ylim([36 37.3])
    freezeColors


    offset = 200;
    data_plot = squeeze(eta(:,:,k)).*mask2;
    h1 = surf( lon(1:skip:end,1:skip:end), lat(1:skip:end,1:skip:end), ...
    data_plot(1:skip:end,1:skip:end)*offset,'facecolor','interp','edgecolor','none');
    %CT=cbrewer('div','BrBG',256*256);
    CT=cbrewer('seq','Blues',256*256);
    %needJet2
    %colormap(map)
    %colormap(jet(2097152));
    %colormap(rainbow(2097152));
    colormap(CT)
    caxis([-0.5 0.5]*offset)
    printname=['gifs/Bodrum_ssh_333d' no];                                           
    set(gca,'LooseInset',get(gca,'TightInset'))                                 
    set(gca, 'visible', 'off')                                                  
    set(gcf,'color','w')                                                        
    print(hhh,'-r300','-dpng','-zbuffer',printname)  
    k
    close all
%set(findobj(gca,'type','surface'),'FaceLighting','phong','AmbientStrength',.5,'DiffuseStrength',.5,'SpecularStrength',.1,'SpecularExponent',2,'BackFaceLighting','reverselit')
%l3 = light;
end
