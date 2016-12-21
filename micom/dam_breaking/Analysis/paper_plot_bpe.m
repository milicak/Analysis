clear all

thickness=2;

load matfiles/Exp001_rpe_aja.mat %control exp. no keps current noresm
time_days=time_days*0.5; %hours saving is every half an hour
plot(time_days,(BPE-BPE(1))./-BPE(1),'k','linewidth',thickness);
%plot(time_days,abs(BPE),'k','linewidth',thickness);
hold on

load matfiles/Exp003_rpe_aja.mat %control exp. full keps
time_days=time_days*0.5; %hours saving is every half an hour
plot(time_days,(BPE-BPE(1))./-BPE(1),'b','linewidth',thickness);
%plot(time_days,abs(BPE),'b','linewidth',thickness);

load matfiles/Exp005_rpe_aja.mat %control exp. keps one equation
time_days=time_days*0.5; %hours saving is every half an hour
plot(time_days,(BPE-BPE(1))./-BPE(1),'r','linewidth',thickness);
%plot(time_days,abs(BPE),'r','linewidth',thickness);

xlim([0 20])
ylim([0 4.5e-4])
xlabel('Time [hours]')
ylabel('(BPE(t)-BPE(t=0))/BPE(t=0)')
legend('ctrl','k-\epsilon','TKE','location','northwest')

print_name='paperfigs/dam_breaking_BPE'

print(1,'-painters','-r300','-depsc2',print_name);

