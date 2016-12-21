clear all
lw=2;
dt=100; %time step
Nx=128;
Ny=4;

rpe0=load('matfiles/GOLD_Exp01.0_rpe.mat');
rpe1=load('/fimm/work/milicak/RUNS/Analysis/mitgcm/dam_breaking/Analysis/matfiles/Exp01.1_ape_rpe_spatial.mat','rpe');
rpe1=load('/export/grunchfs/unibjerknes/milicak/bckup/mitgcm/dam_breaking/matfiles/Exp01.1_ape_rpe_spatial.mat','rpe');
rpe2=load('/export/grunchfs/unibjerknes/milicak/bckup/mitgcm/dam_breaking/matfiles/Exp01.2_ape_rpe_spatial.mat','rpe');
rpe3=load('/export/grunchfs/unibjerknes/milicak/bckup/mitgcm/dam_breaking/matfiles/Exp01.3_ape_rpe_spatial.mat','rpe');
irr_mix=load('/export/grunchfs/unibjerknes/milicak/bckup/mitgcm/dam_breaking/matfiles/Exp01.3_ape_rpe_spatial.mat','irr_mix');
time=load('/export/grunchfs/unibjerknes/milicak/bckup/mitgcm/dam_breaking/matfiles/Exp01.2_ape_rpe_spatial.mat','time_days');
dnm2=squeeze(nansum(irr_mix.irr_mix,1));
dnm2=squeeze(nansum(dnm2,1));   
dnm2=squeeze(nansum(dnm2,1));
aa=cumsum(dnm2)*dt;

figure
hold on
plot(time.time_days*24,-(rpe1.rpe(1:end-1)-rpe1.rpe(1))./rpe1.rpe(1),'r','linewidth',lw)
%plot(time.time_days,-(rpe2.rpe(1:end)-rpe2.rpe(1))./rpe2.rpe(1),'b-*','linewidth',lw)
plot(time.time_days*24,-(rpe3.rpe(1:end-1)-rpe3.rpe(1))./rpe3.rpe(1),'b','linewidth',lw)
%plot(time.time_days*24,-(rpe3.rpe(1:end-1)-rpe1.rpe(1:end-1))./rpe3.rpe(1),'k','linewidth',lw)
dnmMI=(aa(1:end-1)./((Nx-2)*Ny));
plot(time.time_days*24,-(rpe3.rpe(1:end-1)-rpe3.rpe(1)+dnmMI)./rpe3.rpe(1),'k','linewidth',lw)
plot(time.time_days*24,dnmMI./rpe3.rpe(1),'g','linewidth',lw)
%plot(time.time_days*24,(aa(1:end-1)./((Nx-2)*Ny))./rpe3.rpe(1),'g','linewidth',lw)
xlim([0 1.1*24])
%legend('Exp1 ; \kappa_h=\kappa_v=0','Exp2 ; \kappa_h=0 ; \kappa_v=10^{-4} m^2/s', ...
%       'Exp2-Exp1', 'Exp2 \Phi_{irr}', 'Location','northwest')
legend('Exp1 total','Exp2 total', ...
       'Exp2 numerical', 'Exp2 \Phi_{irr}', 'Location','northwest')
plot(rpe0.time_days*24,(rpe0.rpe-rpe0.rpe(1))./rpe0.rpe(1),'k')
xlabel('Time [hours]')
ylabel('(RPE-RPE(t=0))/RPE(t=0)')

savename='paperfigs/rpe_vs_time2.eps'
print('-depsc2','-r300',savename)


