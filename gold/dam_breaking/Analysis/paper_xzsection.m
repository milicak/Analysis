clear all
%close all

root_name=['/hexagon/work/milicak/RUNS/gold/lock_exchange/'];
n=500;
project_name=['Exp01.0'];

foldername=[root_name project_name '/']
filename=[foldername 'prog.nc'];

n=[500]
h=nc_varget(filename,'h',[n-1 0 0 0],[1 -1 -1 -1]);
temp=nc_varget(filename,'temp',[n-1 0 0 0],[1 -1 -1 -1]);
rho=1e3-0.2*temp+35*0.8;
x=250:500:64e3-250;

  figure (1)
  hFig = figure(1);
  set(gcf,'PaperPositionMode','auto')
  set(hFig, 'Position', [0 0 800 200])
  gcolor(squeeze(rho(:,2,:)),squeeze(h(:,2,:)),x./1e3);
  caxis([1022 1027])
  colorbar
  set(gca,'PlotBoxAspectRatio',[4 1 1])
  ylabel('z [m]')
  xlabel('x [km]')

  printname=['paperfigs/gold_xzsection_spurious_mix_' [project_name] '_50000.eps']
  print(1,'-depsc2','-r300',printname);
  close

