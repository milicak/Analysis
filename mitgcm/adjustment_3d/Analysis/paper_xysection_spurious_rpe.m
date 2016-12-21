clear all
%close all

%root_name=['/hexagon/work/milicak/RUNS/mitgcm/adjustment_3d/'];
root_name=['/bcmhsm/milicak/RUNS/mitgcm/adjustment_3d/'];
dt=10800; %seconds output freq
%n=[296 312] %37-39 days
n=[800 816] %100-102 days
%n=[500 516] %62-64 days
grav=9.81;
project_name=['Exp01.0'];
%project_name=['Exp01.0'];

foldername=[root_name project_name '/']

variable_name=['T']; %T for temp; S for salt

H=-1000; %meter
depth=rdmds([foldername 'Depth']);
xc=rdmds([foldername 'XC']);
yc=rdmds([foldername 'YC']);
drc=rdmds([foldername 'DRC']);
hFacC=rdmds([foldername 'hFacC']);
x=squeeze(xc(:,1));
dz=50; %meter
%Z=cumsum(sq(drc));
Z=25:dz:975;
section=13;
%section=17; %3 and 17

for k=1:2
  if k==2
    %load(['/export/grunchfs/unibjerknes/milicak/bckup/mitgcm/adjustment_3d/matfiles/' project_name '_ape_rpe_spatial_newflux.mat']);
    load(['/export/grunchfs/unibjerknes/milicak/bckup/mitgcm/adjustment_3d/matfiles/' project_name '_ape_rpe_spatial_newfluxv3.mat']);
    flxBPEx2=squeeze(flxBPEx(:,:,section,1:n(k)+1));
    flxBPEy2=squeeze(flxBPEy(:,:,section,1:n(k)+1));
    flxBPEz2=squeeze(flxBPEz(:,:,section,1:n(k)+1));
    flxPEz2=squeeze(flxPEz(:,:,section,1:n(k)+1));
    flxAPEz2=squeeze(flxAPEz(:,:,section,1:n(k)+1));
    rhow2=squeeze(rhow(:,:,section,1:n(k)+1));
    %wrhoz_zdz2=0.5*(squeeze(wrhoz_zdz(:,:,section+1,1:n(k)+1)) +squeeze(wrhoz_zdz(:,:,section,1:n(k)+1)) );
    wrhoz_zdz2=squeeze(wrhoz_zdz(:,:,section,1:n(k)+1));

    %rhow2 is divided by dz because it shouldn't be in the computation I made a mistake
    %flxtotal=(flxBPEx2+flxBPEy2)-(flxBPEz2+grav*rhow2./dz-grav*wrhoz_zdz2./dz); 

    % if the matfiles is v2
    flxtotal=(flxBPEx2+flxBPEy2)-(flxBPEz2+grav*rhow2-grav*wrhoz_zdz2); 

    clear totalmixing
    for i=n(k-1)+1:n(k)
     totalmixing(:,:,i)=squeeze(((dnm_rpe(:,:,section,i)-dnm_rpe(:,:,section,i-1))./dt))+flxtotal(:,:,i);
    end
    dnm2=squeeze(nansum(totalmixing,3));

    figure (1)
    hFig = figure(1);
    %set(gcf,'PaperPositionMode','auto')
    %set(hFig, 'Position', [0 0 800 200])
    %pcolorjw(xc*1e-3,yc.*1e-3,abs(dnm2));shading flat;colorbar
    %marpcolor(xc*1e-3,yc.*1e-3,abs(dnm2));shading flat;colorbar
    imagesc(xc(:,1)*1e-3,yc(1,:).*1e-3,abs(dnm2)');shading flat;colorbar
    axis xy
    if(section == 13) 
      caxis([0 .5])
    elseif(section == 17) 
      caxis([0 2])
    end
    set(gca,'PlotBoxAspectRatio',[1 3.125 1])
    ylabel('y [km]')
    xlabel('x [km]')
    printname=['paperfigs/mitgcm_adjustment_3d_xysection_spurious_mix_' [project_name] '_spurious_rpe_' num2str(n(1)) '_' num2str(n(2)) '_section' num2str(section) '.eps']
    print(1,'-depsc2','-r300',printname);
    %%export_fig(1,printname,'-eps','-r300');  
    %fix_pcolor_eps(printname)
    %%close
  end
end

break

