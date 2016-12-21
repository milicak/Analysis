clear all
lw=2;


%rpe1=load('/export/grunchfs/unibjerknes/milicak/bckup/mitgcm/adjustment_3d/matfiles/Exp01.0_ape_rpe_spatial_newflux.mat','rpe');
%rpe2=load('/export/grunchfs/unibjerknes/milicak/bckup/mitgcm/adjustment_3d/matfiles/Exp01.1_ape_rpe_spatial_newflux.mat','rpe');
%rpe3=load('/export/grunchfs/unibjerknes/milicak/bckup/mitgcm/adjustment_3d/matfiles/Exp01.2_ape_rpe_spatial_newflux.mat','rpe');
%r%pe4=load('/export/grunchfs/unibjerknes/milicak/bckup/mitgcm/adjustment_3d/matfiles/Exp01.3_ape_rpe_spatial_newfluxv4.mat','rpe');
%rpe5=load('/export/grunchfs/unibjerknes/milicak/bckup/mitgcm/adjustment_3d/matfiles/Exp01.4_ape_rpe_spatial_newfluxv4.mat','rpe');
%time=load('/export/grunchfs/unibjerknes/milicak/bckup/mitgcm/adjustment_3d/matfiles/Exp01.1_ape_rpe_spatial_newflux.mat','time_days');

rpe1=load('/export/grunchfs/unibjerknes/milicak/bckup/mitgcm/adjustment_3d/matfiles/Exp01.0_ape_rpe_spatial_newfluxv4_onlyrpe.mat','rpe');
rpe2=load('/export/grunchfs/unibjerknes/milicak/bckup/mitgcm/adjustment_3d/matfiles/Exp01.1_ape_rpe_spatial_newfluxv4_onlyrpe.mat','rpe');
rpe3=load('/export/grunchfs/unibjerknes/milicak/bckup/mitgcm/adjustment_3d/matfiles/Exp01.2_ape_rpe_spatial_newfluxv4_onlyrpe.mat','rpe');
rpe4=load('/export/grunchfs/unibjerknes/milicak/bckup/mitgcm/adjustment_3d/matfiles/Exp01.3_ape_rpe_spatial_newfluxv4_onlyrpe.mat','rpe');
rpe5=load('/export/grunchfs/unibjerknes/milicak/bckup/mitgcm/adjustment_3d/matfiles/Exp01.4_ape_rpe_spatial_newfluxv4_onlyrpe.mat','rpe');
time=load('/export/grunchfs/unibjerknes/milicak/bckup/mitgcm/adjustment_3d/matfiles/Exp01.1_ape_rpe_spatial_newfluxv4_onlyrpe.mat','time_days');


len=1100; %1100;

%rpe1=load('/export/grunchfs/unibjerknes/milicak/bckup/mitgcm/adjustment_3d/matfiles/Exp01.0_ape_rpe_spatial.mat','rpe');
%rpe2=load('/export/grunchfs/unibjerknes/milicak/bckup/mitgcm/adjustment_3d/matfiles/Exp01.1_ape_rpe_spatial.mat','rpe');
%time=load('/export/grunchfs/unibjerknes/milicak/bckup/mitgcm/adjustment_3d/matfiles/Exp01.1_ape_rpe_spatial.mat','time_days');

figure
hold on
plot(time.time_days(1:len),-(rpe1.rpe(1:len)-rpe1.rpe(1))./rpe1.rpe(1),'r','linewidth',lw)
plot(time.time_days(1:len),-(rpe2.rpe(1:len)-rpe2.rpe(1))./rpe2.rpe(1),'b','linewidth',lw)
plot(time.time_days(1:len),-(rpe3.rpe(1:len)-rpe3.rpe(1))./rpe3.rpe(1),'k','linewidth',lw)
plot(time.time_days(1:len),-(rpe4.rpe(1:len)-rpe4.rpe(1))./rpe4.rpe(1),'g','linewidth',lw)
plot(time.time_days(1:len),-(rpe5.rpe(1:len)-rpe5.rpe(1))./rpe5.rpe(1),'m','linewidth',lw)
xlim([0 140])
%legend('\kappa_v=0 Smagorinsky C=2.2','\kappa_v=0 Leith C=2.2','\kappa_v=0 Leith C=2.2 and CD=2.2','Location','southeast')
%legend('\kappa_v=0 Smagorinsky C=2.2','\kappa_v=0 Leith C=2.2','Location','southeast')
%legend('\kappa_v=0 ; Smagorinsky','\kappa_v=0 ; Leith original','\kappa_v=0 ; Leith modified','Location','southeast')
legend('Smagorinsky','Leith original','Leith modified', 'Laplacian','Biharmonic','Location','southeast')
xlabel('Time [days]')
ylabel('(RPE-RPE(t=0))/RPE(t=0)')

savename='paperfigs/adjustment_3d_rpe_vs_time.eps'
print('-depsc2','-r300',savename)


