clear all
%close all

%root_name=['/hexagon/work/milicak/RUNS/mitgcm/dam_breaking/'];
root_name=['/export/grunchfs/unibjerknes/milicak/bckup/mitgcm/dam_breaking/'];
dt=100; %seconds output freq
n=[0 18] % 0.5 hours
%n=[360 504] % between 10 hours and 14 hours
itr=100*n;
grav=9.81;
project_name=['Exp01.1'];

foldername=[root_name project_name '/']

variable_name=['T']; %T for temp; S for salt

H=-20; %meter


depth=rdmds([foldername 'Depth']);
xc=rdmds([foldername 'XC']);
drc=rdmds([foldername 'DRC']);
hFacC=rdmds([foldername 'hFacC']);
x=squeeze(xc(:,1));
%Z=cumsum(sq(drc));
Z=0.5:1:19.5;
section=2;

for k=1:2
  if k==2
    %load(['/fimm/work/milicak/RUNS/Analysis/mitgcm/dam_breaking/Analysis/matfiles/' project_name '_ape_rpe_spatial.mat']);
    load(['/fimm/work/milicak/RUNS/Analysis/mitgcm/dam_breaking/Analysis/matfiles/' project_name '_ape_rpe_spatial_newflux.mat']);
    dnm=squeeze(dnm_rpe(:,section,:,n(k)+1)-dnm_rpe(:,section,:,n(k-1)+1));
    flxBPEx=squeeze(flxBPEx(:,section,:,1:n(k)+1));
    flxBPEy=squeeze(flxBPEy(:,section,:,1:n(k)+1));
    flxBPEz=squeeze(flxBPEz(:,section,:,1:n(k)+1));
    flxAPEz=squeeze(flxAPEz(:,section,:,1:n(k)+1));
    flxPEz=squeeze(flxPEz(:,section,:,1:n(k)+1));
    wrhoz_zdz=squeeze(wrhoz_zdz(:,section,:,1:n(k)+1));
    rhow=squeeze(rhow(:,section,:,1:n(k)+1));
    %irr_mix=squeeze(irr_mix(:,section,:,1:n(k)+1));
    %flxtotal=flxBPEx+flxBPEy-(flxBPEz+grav.*rhow);
   
    %flxtotal=(flxBPEx+flxBPEy)+1.*(0.0*grav*wrhoz_zdz+1.0*(-1.*flxBPEz+0.0*grav*rhow)+0.0*flxAPEz);

    if(exist('irr_mix')==0)
      flxtotal=(flxBPEx+flxBPEy)-(flxBPEz+grav*rhow-grav*wrhoz_zdz);
    else
      irr_mix=squeeze(irr_mix(:,section,:,1:n(k)+1));
      flxtotal=(flxBPEx+flxBPEy+irr_mix)-(flxBPEz+grav*rhow-grav*wrhoz_zdz);
      flxtotalirr=(flxBPEx+flxBPEy)-(flxBPEz+grav*rhow-grav*wrhoz_zdz);
      %flxtotal=flxBPEx+flxBPEy+irr_mix-(flxBPEz+grav.*rhow);
    end

%keyboard
    for i=n(k-1)+2:n(k)+1
     totalmixing(:,:,i)=squeeze(((dnm_rpe(:,section,:,i)-dnm_rpe(:,section,:,i-1))./dt))+flxtotal(:,:,i);
     if(exist('irr_mix')==1)
       totalmixing2(:,:,i)=squeeze(((dnm_rpe(:,section,:,i)-dnm_rpe(:,section,:,i-1))./dt))+flxtotalirr(:,:,i);
     end
    end
    dnm=squeeze(nansum(totalmixing,3));
    if(exist('irr_mix')==1)
      dnm2=squeeze(nansum(totalmixing2,3));
    end

    figno=2;
    figure (figno)
    hFig = figure(figno);
    set(gcf,'PaperPositionMode','auto')
    set(hFig, 'Position', [0 0 800 200])
    if(exist('irr_mix')==0)
      pcolorjw(x./1e3,-Z,dnm');shading flat;colorbar
    else
      pcolorjw(x./1e3,-Z,dnm2');shading flat;colorbar
    end
    caxis([0 5])
    colorbar
    set(gca,'PlotBoxAspectRatio',[4 1 1])
    ylabel('z [m]')
    xlabel('x [km]')
    printname=['paperfigs/mitgcm_xzsection_spurious_mix_' [project_name] '_spurious_rpe_' num2str(itr(1)) '_' num2str(itr(2)) '.eps']
    print(figno,'-depsc2','-r300',printname);
    close


    if(exist('irr_mix')==1)
      figno=2;
      figure (figno)
      hFig = figure(figno);
      set(gcf,'PaperPositionMode','auto')
      set(hFig, 'Position', [0 0 800 200])
      pcolorjw(x./1e3,-Z,dnm2'-dnm');shading flat;colorbar
      caxis([-0.3 0.3])
      colorbar
      set(gca,'PlotBoxAspectRatio',[4 1 1])
      ylabel('z [m]')
      xlabel('x [km]') 
      printname=['paperfigs/mitgcm_xzsection_spurious_mix_' [project_name] '_irr_mix_' num2str(itr(1)) '_' num2str(itr(2)) '.eps']
      print(figno,'-depsc2','-r300',printname);
      close

      figno=2;
      figure (figno)
      hFig = figure(figno);
      set(gcf,'PaperPositionMode','auto')
      set(hFig, 'Position', [0 0 800 200])
      pcolorjw(x./1e3,-Z,dnm');shading flat;colorbar
      caxis([0 5])
      colorbar
      set(gca,'PlotBoxAspectRatio',[4 1 1])
      ylabel('z [m]')
      xlabel('x [km]')
      printname=['paperfigs/mitgcm_xzsection_spurious_mix_' [project_name] '_spurious_mix_' num2str(itr(1)) '_' num2str(itr(2)) '.eps']
      print(figno,'-depsc2','-r300',printname);
      close
    end

  end
end
