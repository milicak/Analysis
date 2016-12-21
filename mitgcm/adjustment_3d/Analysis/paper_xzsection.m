clear all
%close all

%root_name=['/hexagon/work/milicak/RUNS/mitgcm/adjustment_3d/'];
root_name=['/bcmhsm/milicak/RUNS/mitgcm/adjustment_3d/'];

dtfreq=10800; %seconds output freq
dt=200; %seconds model time step
%n=[296 312]
%n=[800 816] %100-102 days
n=[500 516] %62-64 days
project_name=['Exp01.0'];

foldername=[root_name project_name '/']

variable_name=['T']; %T for temp; S for salt

H=-1000; %meter

itr=(dtfreq/dt)*n;

depth=rdmds([foldername 'Depth']);
xc=rdmds([foldername 'XC']);
drc=rdmds([foldername 'DRC']);
hFacC=rdmds([foldername 'hFacC']);
x=squeeze(xc(:,1));
%Z=cumsum(sq(drc));
dz=50;
Z=25:dz:975;

for k=1:2

  variable=rdmds([foldername variable_name],itr(k));
  variable(variable==0)=NaN;

  section=63;  %section 
  if(itr(k)==0)
    section = 32;
  end
  dnm=1e3-0.2*squeeze(variable(:,section,:))+35*0.8;

  figure (1)
  hFig = figure(1);
  %set(gcf,'PaperPositionMode','auto')
  %set(hFig, 'Position', [0 0 800 200])
  pcolorjw(x./1e3,-Z,dnm');shading flat;colorbar
  caxis([1025.4 1026.2])
  colorbar
  set(gca,'PlotBoxAspectRatio',[1 1 1])
  ylabel('z [m]')
  xlabel('x [km]')

  if(itr(k)==0)
    printname=['paperfigs/mitgcm_adjustment_3d_xzsection_spurious_mix_' [project_name] '_initial.eps']
  else
    printname=['paperfigs/mitgcm_adjustment_3d_xzsection_spurious_mix_' [project_name] '_' num2str(itr(k)) '.eps']
  end
  print(1,'-depsc2','-r300',printname);
  close

  ape=load(['/export/grunchfs/unibjerknes/milicak/bckup/mitgcm/adjustment_3d/matfiles/' project_name '_ape_rpe_spatial_newfluxv3.mat'],'dnm_ape');
  dnm=squeeze(ape.dnm_ape(:,section,:,n(k)+1));
  figure (1)
  hFig = figure(1);
  %set(gcf,'PaperPositionMode','auto')
  %set(hFig, 'Position', [0 0 800 200])
  pcolorjw(x./1e3,-Z,dnm');shading flat;colorbar
  if (n(k)==500 || n(k)==516)
    caxis([0 100])
  else
    caxis([0 40])
  end
  colorbar
  set(gca,'PlotBoxAspectRatio',[1 1 1])
  ylabel('z [m]')
  xlabel('x [km]')
  if(itr(k)==0)
    printname=['paperfigs/mitgcm_adjustment_3d_xzsection_spurious_mix_' [project_name] '_ape_initial.eps']
  else
    printname=['paperfigs/mitgcm_adjustment_3d_xzsection_spurious_mix_' [project_name] '_ape_' num2str(itr(k)) '.eps']
  end
  print(1,'-depsc2','-r300',printname);
  close

  if k==2
    rpe=load(['/export/grunchfs/unibjerknes/milicak/bckup/mitgcm/adjustment_3d/matfiles/' project_name '_ape_rpe_spatial_newfluxv3.mat'],'dnm_rpe');
    dnm=squeeze(rpe.dnm_rpe(:,section,:,n(k)+1)-rpe.dnm_rpe(:,section,:,n(k-1)+1));
    figure (1)
    hFig = figure(1);
    %set(gcf,'PaperPositionMode','auto')
    %set(hFig, 'Position', [0 0 800 200])
    pcolorjw(x./1e3,-Z,dnm');shading flat;colorbar
    caxis([-5000 5000])
    colorbar
    set(gca,'PlotBoxAspectRatio',[1 1 1])
    ylabel('z [m]')
    xlabel('x [km]')
    printname=['paperfigs/mitgcm_adjustment_3d_xzsection_spurious_mix_' [project_name] '_rpe_' num2str(itr(k)) '.eps']
    print(1,'-depsc2','-r300',printname);
    close
  end
end
