clear all


matfile = 'matfiles/om3_core3_2_ice_volume_NWP.mat';
out1 = load(matfile);
matfile = 'matfiles/om3_core3_2_BG_pos_ice_volume_NWP.mat';
out2 = load(matfile);
matfile = 'matfiles/om3_core3_2_BG_neg_ice_volume_NWP.mat';
out3 = load(matfile);
matfile = 'matfiles/om3_core3_2_ice_volume_NSR.mat';
out4 = load(matfile);
matfile = 'matfiles/om3_core3_2_BG_pos_ice_volume_NSR.mat';
out5 = load(matfile);
matfile = 'matfiles/om3_core3_2_BG_neg_ice_volume_NSR.mat';
out6 = load(matfile);

vice = containers.Map
vice('NWP ctrl') = out1.vice(397:end);
vice('NWP BG_pos') = out2.vice(397:end);
vice('NWP BG_neg') = out3.vice(397:end);
vice('NSR ctrl') = out4.vice(397:end);
vice('NSR BG_pos') = out5.vice(397:end);
vice('NSR BG_neg') = out6.vice(397:end);

savename = ['matfiles/vice_NWP_NSR_time.mat']
save(savename,'vice')

figure(1)
plot(nanmean(reshape(vice('NWP BG_pos'),[12 29]),1) - nanmean(reshape(vice('NWP ctrl'),[12 29]),1),'b')
hold on
plot(nanmean(reshape(vice('NWP BG_neg'),[12 29]),1) - nanmean(reshape(vice('NWP ctrl'),[12 29]),1),'r')
plot(nanmean(reshape(vice('NSR BG_pos'),[12 29]),1) - nanmean(reshape(vice('NSR ctrl'),[12 29]),1),'g')
plot(nanmean(reshape(vice('NSR BG_neg'),[12 29]),1) - nanmean(reshape(vice('NSR ctrl'),[12 29]),1),'k')
%plot((vice('NWP BG_pos')-vice('NWP ctrl')))
%hold on
%plot((vice('NWP BG_neg')-vice('NWP ctrl')),'r')
%plot((vice('NSR BG_pos')-vice('NSR ctrl')),'k')
%plot((vice('NSR BG_neg')-vice('NSR ctrl')),'g')
title('Shipping routes CRFs')
ylim([-4 4]*1e11)
legend('NWP BG-pos','NWP BG-neg','NSR BG-pos','NSR BG-neg','location','northwest')
%printname = ['paperfigs/vice_NWP.png'];
%print(1,'-dpng','-r300',printname)

