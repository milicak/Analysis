clear all
%close all

root_name=['/hexagon/work/milicak/RUNS/mitgcm/dam_breaking/'];
root_name=['/export/grunchfs/unibjerknes/milicak/bckup/mitgcm/dam_breaking/'];
%project_name=['Exp01.1']
project_name=['Exp01.3']

foldername=[root_name project_name '/']

variable_name=['T']; %T for temp; S for salt

H=-20; %meter

%n=[0 360] ; %10 hours
n=[0 504]; %14 hours
%n=[0 18]; %0.5 hours
itr=100*n;

depth=rdmds([foldername 'Depth']);
xc=rdmds([foldername 'XC']);
drc=rdmds([foldername 'DRC']);
hFacC=rdmds([foldername 'hFacC']);
x=squeeze(xc(:,1));
%Z=cumsum(sq(drc));
Z=0.5:1:19.5;

for k=1:2

  variable=rdmds([foldername variable_name],itr(k));
  variable(variable==0)=NaN;

  section=size(variable,2)*0.5;  %section 
  dnm=1e3-0.2*squeeze(variable(:,section,:))+35*0.8;

  figure (1)
  hFig = figure(1);
  set(gcf,'PaperPositionMode','auto')
  set(hFig, 'Position', [0 0 800 200])
  pcolorjw(x./1e3,-Z,dnm');shading flat;colorbar
  caxis([1022 1027])
  colorbar
  set(gca,'PlotBoxAspectRatio',[4 1 1])
  ylabel('z [m]')
  xlabel('x [km]')

  if(itr(k)==0)
    printname=['paperfigs/mitgcm_xzsection_spurious_mix_' [project_name] '_initial.eps']
  else
    printname=['paperfigs/mitgcm_xzsection_spurious_mix_' [project_name] '_' num2str(itr(k)) '.eps']
  end
  print(1,'-depsc2','-r300',printname);
  close

  ape=load(['/fimm/work/milicak/RUNS/Analysis/mitgcm/dam_breaking/Analysis/matfiles/' project_name '_ape_rpe_spatial.mat'],'dnm_ape');
  dnm=squeeze(ape.dnm_ape(:,section,:,n(k)+1));
  figure (1)
  hFig = figure(1);
  set(gcf,'PaperPositionMode','auto')
  set(hFig, 'Position', [0 0 800 200])
  pcolorjw(x./1e3,-Z,dnm');shading flat;colorbar
  caxis([0 450])
  colorbar
  set(gca,'PlotBoxAspectRatio',[4 1 1])
  ylabel('z [m]')
  xlabel('x [km]')
  if(itr(k)==0)
    printname=['paperfigs/mitgcm_xzsection_spurious_mix_' [project_name] '_ape_initial.eps']
  else
    printname=['paperfigs/mitgcm_xzsection_spurious_mix_' [project_name] '_ape_' num2str(itr(k)) '.eps']
  end
  print(1,'-depsc2','-r300',printname);
  close

  if k==2
    rpe=load(['/fimm/work/milicak/RUNS/Analysis/mitgcm/dam_breaking/Analysis/matfiles/' project_name '_ape_rpe_spatial.mat'],'dnm_rpe');
    dnm=squeeze(rpe.dnm_rpe(:,section,:,n(k)+1)-rpe.dnm_rpe(:,section,:,n(k-1)+1));
    figure (1)
    hFig = figure(1);
    set(gcf,'PaperPositionMode','auto')
    set(hFig, 'Position', [0 0 800 200])
    pcolorjw(x./1e3,-Z,dnm');shading flat;colorbar
    caxis([-450 450])
    colorbar
    set(gca,'PlotBoxAspectRatio',[4 1 1])
    ylabel('z [m]')
    xlabel('x [km]')
    printname=['paperfigs/mitgcm_xzsection_spurious_mix_' [project_name] '_rpe_' num2str(itr(k)) '.eps']
    print(1,'-depsc2','-r300',printname);
    close
  end
end
