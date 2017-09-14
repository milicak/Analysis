clear all


matfile = 'matfiles/om3_core3_2_ice_volume_BG.mat';
out1 = load(matfile);
matfile = 'matfiles/om3_core3_2_BG_pos_ice_volume_BG.mat';
out2 = load(matfile);
matfile = 'matfiles/om3_core3_2_BG_neg_ice_volume_BG.mat';
out3 = load(matfile);

vice = containers.Map
vice('ctrl') = out1.vice(397:end);
vice('BG_pos') = out2.vice(397:end);
vice('BG_neg') = out3.vice(397:end);

savename = ['matfiles/vice_BG_time.mat']
save(savename,'vice')

figure(1)
plot((vice('BG_pos')-vice('ctrl')))
hold on
plot((vice('BG_neg')-vice('ctrl')),'r')
title('vice BG')
ylim([-3 3]*1e11)
legend('BG-pos','BG-neg','location','northwest')
printname = ['paperfigs/vice_BG.png'];
print(1,'-dpng','-r300',printname)

