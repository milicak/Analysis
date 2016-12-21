clear all
%close all

%root_name=['/hexagon/work/milicak/RUNS/mitgcm/adjustment_3d/'];
root_name=['/bcmhsm/milicak/RUNS/mitgcm/adjustment_3d/'];
dt=10800; %seconds output freq
%n=[296 312] %37-39 days
n=[800 816] %100-102 days
n=[500 516] %62-64 days
grav=9.81;
project_name=['Exp01.0'];

foldername=[root_name project_name '/']

variable_name=['T']; %T for temp; S for salt

H=-1000; %meter
depth=rdmds([foldername 'Depth']);
xc=rdmds([foldername 'XC']);
yc=rdmds([foldername 'YC']);
drc=rdmds([foldername 'DRC']);
hFacC=rdmds([foldername 'hFacC']);
y=squeeze(yc(1,:));
dz=50; %meter
%Z=cumsum(sq(drc));
Z=25:dz:975;
section=15; %64;

for k=1:2
  if k==2
    %load(['/export/grunchfs/unibjerknes/milicak/bckup/mitgcm/adjustment_3d/matfiles/' project_name '_ape_rpe_spatial_newflux.mat']);
    load(['/export/grunchfs/unibjerknes/milicak/bckup/mitgcm/adjustment_3d/matfiles/' project_name '_ape_rpe_spatial_newfluxv3.mat']);
    dnm=squeeze(dnm_rpe(:,:,1,n(k)+1)-dnm_rpe(:,:,1,n(k-1)+1));
    dnm=squeeze(dnm_rpe(section,:,:,n(k)+1)-dnm_rpe(section,:,:,n(k-1)+1));
    flxBPEx=squeeze(flxBPEx(section,:,:,1:n(k)+1));
    flxBPEy=squeeze(flxBPEy(section,:,:,1:n(k)+1));
    flxBPEz=squeeze(flxBPEz(section,:,:,1:n(k)+1));
    rhow=squeeze(rhow(section,:,:,1:n(k)+1));
    wrhoz_zdz=squeeze(wrhoz_zdz(section,:,:,1:n(k)+1));
    %irr_mix=squeeze(irr_mix(:,section,:,1:n(k)+1));

    %rhow2 is divided by dz because it shouldn't be in the computation I made a mistake
    %flxtotal=(flxBPEx+flxBPEy)-(flxBPEz+grav*rhow./dz-1.*grav*wrhoz_zdz./dz); 

    % if the matfiles is v2
    flxtotal=(flxBPEx+flxBPEy)-(flxBPEz+grav*rhow-1.*grav*wrhoz_zdz); 

    clear totalmixing
    for i=n(k-1)+1:n(k)
     totalmixing(:,:,i)=squeeze(((dnm_rpe(section,:,:,i)-dnm_rpe(section,:,:,i-1))./dt))+flxtotal(:,:,i);
    end
    dnm2=squeeze(nansum(totalmixing,3));

    figure (1)
    hFig = figure(1);
    %set(gcf,'PaperPositionMode','auto')
    %set(hFig, 'Position', [0 0 800 200])
    pcolorjw(y*1e-3,-Z,abs(dnm2)');shading flat;colorbar
    caxis([0 2])
    colorbar
    set(gca,'PlotBoxAspectRatio',[1 1 1])
    ylabel('z [m]')
    xlabel('y [km]')
keyboard
    printname=['paperfigs/mitgcm_adjustment_3d_yzsection_spurious_mix_' [project_name] '_spurious_rpe_' num2str(n(1)) '_' num2str(n(2)) '.eps']
    print(1,'-depsc2','-r300',printname);
    %close
  end
end
