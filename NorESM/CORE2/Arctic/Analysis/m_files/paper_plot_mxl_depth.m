clear all

files = [{'woa'} {'phc'} {'cerfacs_nemo'} {'fesom'} {'gfdl_gold'} {'mir_free'} {'noc_orca'} ...
         {'cmcc_orca'} {'fsu_hycom'} {'gfdl_mom'} {'mom_0_25'} {'noresm'} ...
         {'cnrm_nemo'} {'geomar_orca'} {'mir_data'} {'ncar_pop'} {'fsu_hycom2'}];

titles = [{'WOA'} {'PHC3'} {'CERFACS'} {'AWI-FESOM'} {'GFDL-GOLD'} {'MRI-F'} {'NOC'} ...
         {'CMCC'} {'FSU-HYCOM'} {'GFDL-MOM'} {'MOM0.25'} {'BERGEN'} ...
         {'CNRM'} {'Kiel-ORCA05'} {'MRI-A'} {'NCAR'} {'FSU-HYCOMv2'}];

%files = [{'mimoc_annual'}];
files = [{'mimoc_03'}];
titles = [{'MIMOC'}];

files = [{'mom_0_25'}];
titles = [{'MOM0.25'}];

for i = 1:length(files)
  %filename = ['matfiles/' char(files(i)) '_mxl_depth.mat'];
  filename = ['matfiles2/' char(files(i)) '_march_mxl_depth.mat'];
  load(filename)
  m_proj('stereographic','lat',90,'long',0,'radius',25);
  m_pcolor(lon,lat,mxl);shfn
  caxis([0 100])
  caxis([0 1500])
  if 1
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

  end
  colorbar off
  m_coast('patch',[.7 .7 .7]);
  m_grid('xtick',[-120 -60 0 60 120])
     fontsize=18;
     set(findall(gcf,'type','text'),'FontSize',fontsize)
     set(gca,'fontsize',fontsize)
     set(gcf,'color','w');
  title(char(titles(i)))
  printname=['paperfigs2/' char(files(i)) '_mxl_depth'];
  print(1,'-depsc2','-r150',printname)
  %close
end

break

%plot colorbar only
colorbar([0.1 0.1  0.4  0.8]);
caxis([0 1500])
needJet2
cbar_handle = colorbar;
set(gcf,'color','w');
export_fig(cbar_handle, 'march_mxl_colorbar_v1.eps');
%export_fig(cbar_handle, 'mxl_colorbar_v1.eps');

