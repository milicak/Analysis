clear all

mmap=2; %plot using m_map=1
datesep='-';
rgb = imread('land_shallow_topo_2048.jpg');
[X map]=rgb2ind(rgb,256);
lon_x=-180:360/2047:180;
lat_y=-90:180/1023:90;
lat_y=lat_y';
[lon_x lat_y]=meshgrid(lon_x,lat_y);
X=flipdim(double(X),1);
icevalue=X(950,760);

%to change min_lon to -110 for noresm
xx=lon_x(:,400:end);
xx(:,end+1:2048)=lon_x(:,1:399)+360;
X1=X(:,400:end);X1(:,end+1:2048)=X(:,1:399);
lon_x=xx;
X=X1;
clear xx X1

%icevalue=X(1,1);
%convert sea values to ice-values
%X(X==24)=icevalue;

lon=ncgetvar('/work/milicak/0.25/grid.nc','plon');
lat=ncgetvar('/work/milicak/0.25/grid.nc','plat');

foldername=['/hexagon/work/milicak/archive/NOIIA_T62_tn025_001/ocn/hist/'];
prefix=[foldername 'NOIIA_T62_tn025_001.micom.hd.'];

%if(mmap==0)
% For 0.25 degree micom grid
  x=lon;
  x=x(1000:end,:);
  x(x<0)=x(x<0)+360;
  lon(1000:end,:)=x;
% For 1degree tripolar micom grid
  %x=lon;
  %x=x(260:end,:);
  %x(x<0)=x(x<0)+360;
  %lon(260:end,:)=x;
%end


%ssh=nc_varget('/work/milicak/noresm/NOIIA_T62_tn025_001/run/NOIIA_T62_tn025_001.micom.hd.0011-01.nc','sealv');
%ssh=nc_varget('/work/milicak/archive/NOIIA_T62_tn025_001/ocn/hist/NOIIA_T62_tn025_001.micom.hd.0011-01.nc','sealv');
%ssh=nc_varget('/work/milicak/archive/NOIIA_T62_tn025_001/ocn/hist/NOIIA_T62_tn025_001.micom.hd.0011-01.nc','sst');

k=1;
for year=88:92
for month=1:12 
  sdate=sprintf('%4.4d%c%2.2d',year,datesep,month);
  disp(sdate)
  %sst=ncgetvar([prefix sdate '.nc'],'sst');
  ssh=ncgetvar([prefix sdate '.nc'],'sealv');
  timereal=nc_varget([prefix sdate '.nc'],'time');
  for day=[1 4 7 10 13 16 19 22 25 28]  %1:size(ssh,3)
    data_plot=sq(ssh(:,:,day)); %mid of the month
    hhh=figure('Visible','off');
    set(hhh, 'Position', [220 220 800 600])
      %l1 = light;
      %l2 = light;
      l3 = light;
      %lightangle(l1, -90, 40)
      %lightangle(l2, 90, 75)
      lightangle(l3, 0, 90)

      %set(gcf,'Renderer','opengl')
      %set(gcf,'Renderer','zbuffer')

      % Colorbar for SSH
      pcolor(lon_x,lat_y,X);shading flat;colormap(map)
      hold on
      freezeColors
      
      offset=5;
      h1 = surf( lon, lat, data_plot+offset,'facecolor','interp','edgecolor','none');
      %colormap(jet(2097152));
      colormap(rainbow(2097152));

      set(findobj(gca,'type','surface'),...
      'FaceLighting','phong',...
      'AmbientStrength',.5,'DiffuseStrength',.5,...
      'SpecularStrength',.1,'SpecularExponent',2,...
      'BackFaceLighting','reverselit')
      l3 = light;
      %l1 = light;
      % Agulhas region
      caxis( [-2+offset  1.5+offset] );


      lighting phong      
      %Agulhas
      lightangle(l3, 0, 60)
      %lightangle(l1, 0, 60)
      view(2)
      xlim([-110 249])
      set(gca,'xticklabel',{})
      set(gca,'yticklabel',{}) 
      %camlight %left      

    %cb=colorbar
    %set(cb,'yticklabel',{'-20','40','60'})
    no=num2str(k,'%.4d');
    %time=datestr(timereal(day));
    %title(time);
    printname=['gifs/NorESM_SSH' no];
    set(gca,'LooseInset',get(gca,'TightInset'))
    set(gca, 'visible', 'off')
    set(gcf,'color','w') 
    print(hhh,'-r300','-djpeg','-zbuffer',printname)
%      keyboard
    %print(hhh,'-r0','-dpng',printname)
    close all
    k=k+1
  end
end
end


