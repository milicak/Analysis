
colorbar([0.1 0.1  0.4  0.8]);
cbar_handle=colorbar('southoutside')
f=load('/fimm/home/bjerknes/milicak/matlab/tools/jet4');
c1=f(:,1);c2=f(:,2);c3=f(:,3);
for indice=1:size(c1)
   map(indice,:)=[c1(indice) c2(indice) c3(indice)];
end
colormap(map);
caxis([-2 5])
%needJet2
%cbar_handle = colorbar;

close all
colormap(map);
caxis([34.2 35.2])
cbar_handle=colorbar('southoutside')
set(gcf,'color','w');
export_fig(cbar_handle, '_salt_depth_section_colorbar_v1.eps');

close all
colormap(map);
caxis([-2 5])
cbar_handle=colorbar('southoutside')
set(gcf,'color','w');
export_fig(cbar_handle, 'depth_section_colorbar_v1.eps');

close all
colormap(map);
caxis([-1 8])
%x = [-2:0.15:2.75 3:0.5:8];
x = [-2:0.05:0 5 -1.43 -1.53 -1.33 4.4 5.4 1:0.6:8 8];
x = [-2:0.05:0 1:0.6:8 8]; %with jet4
x = [-2:0.05:0 -1.63 -1.53 -1.43 -1.33 -1.23 -1.73  1:0.6:8 8];
x=sort(x);
Nx = length(x);
clim = [min(x) max(x)];
dx = min(diff(x));
y = clim(1):dx:clim(2);
for k=1:Nx-1, y(y>x(k) & y<=x(k+1)) = x(k+1); end % NEW
cmap = colormap(jet(Nx));
f1=load('/fimm/home/bjerknes/milicak/matlab/tools/jet5');
cmap=f1;
cmap2 = [...
interp1(x(:),cmap(:,1),y(:)) ...
interp1(x(:),cmap(:,2),y(:)) ...
interp1(x(:),cmap(:,3),y(:)) ...
];
caxis([-1 8])
colormap(cmap2)
caxis(clim)
cbar_handle=colorbar('southoutside')
set(gcf,'color','w');
export_fig(cbar_handle, 'depth_section_colorbar_5m_temp.eps');

close all
colormap(map);
caxis([25 35])
cbar_handle=colorbar('southoutside')
set(gcf,'color','w');
export_fig(cbar_handle, 'depth_section_colorbar_5m_salt.eps');

%colorbar([0.1 0.1  0.4  0.8]);
caxis([-1.5 1.5])
%cbar_handle = colorbar;
cbar_handle=colorbar('southoutside')
set(gcf,'color','w');
export_fig(cbar_handle, 'Arctic_Ocean_section_colorbar_v1.eps');

%colorbar([0.1 0.1  0.4  0.8]);
caxis([-1.5 7])
interpcolormap([[0 0 .1];[0 0 1];[0 1 1];[0 1 0];[1 1 0];[1 0 1];[1 0 0];[1 .9 .8]],[1 1 1 1 1.3 .7 1.3],'l');
%cbar_handle = colorbar;
cbar_handle=colorbar('southoutside')
set(gcf,'color','w');
export_fig(cbar_handle, 'Atlantic_Inflow_section_colorbar_v1.eps');

colormap(bluewhitered(64))
caxis([-2 2])
cbar_handle=colorbar('southoutside')
set(gcf,'color','w');
export_fig(cbar_handle, 'depth_section_bias_colorbar_temp.eps');

caxis([-2 2])
NeedJet2
cbar_handle=colorbar('southoutside')
set(gcf,'color','w');
export_fig(cbar_handle, 'depth_section_bias_colorbar_salt.eps');

% mxl for mixed layer colorbar
  x = [0:3:100 100 105 110:10:300 1100 1300 900 1000 1200 1400 1500];
  x=sort(x);
  Nx = length(x);
  clim = [min(x) max(x)];
  dx = min(diff(x));
  y = clim(1):dx:clim(2);
  for k=1:Nx-1, y(y>x(k) & y<=x(k+1)) = x(k+1); end % NEW
  f1=load('/fimm/home/bjerknes/milicak/matlab/tools/jet6');
  cmap=f1;
  cmap2 = [...
  interp1(x(:),cmap(:,1),y(:)) ...
  interp1(x(:),cmap(:,2),y(:)) ...
  interp1(x(:),cmap(:,3),y(:)) ...
  ];
  colormap(cmap2)
  caxis([0 450])
cbar_handle=colorbar('southoutside')
set(gcf,'color','w');
export_fig(cbar_handle, 'mxl_colorbar_nonlinear.eps');
  
