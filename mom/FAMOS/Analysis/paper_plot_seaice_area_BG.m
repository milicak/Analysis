clear all


matfile = 'matfiles/om3_core3_2_ice_extend_BG.mat';
out1 = load(matfile);
matfile = 'matfiles/om3_core3_2_BG_pos_ice_extend_BG.mat';
out2 = load(matfile);
matfile = 'matfiles/om3_core3_2_BG_neg_ice_extend_BG.mat';
out3 = load(matfile);

xice = containers.Map
xice('ctrl') = out1.xice(397:end);
xice('BG_pos') = out2.xice(397:end);
xice('BG_neg') = out3.xice(397:end);

savename = ['matfiles/xice_BG_time.mat']
save(savename,'xice')

figure(1)
plot((xice('BG_pos')-xice('ctrl')))
hold on
plot((xice('BG_neg')-xice('ctrl')),'r')
title('xice BG')
ylim([-3 3]*1e11)
legend('BG-pos','BG-neg','location','northwest')
printname = ['paperfigs/xice_BG.png'];
print(1,'-dpng','-r300',printname)

