clear all


matfile = 'matfiles/om3_core3_2_SSS_BG_time.mat';
out1 = load(matfile);
matfile = 'matfiles/om3_core3_2_BG_pos_SSS_BG_time.mat';
out2 = load(matfile);
matfile = 'matfiles/om3_core3_2_BG_neg_SSS_BG_time.mat';
out3 = load(matfile);

SSS_BG = containers.Map
SSS_BG('ctrl') = out1.SSS_BG(397:end);
SSS_BG('BG_pos') = out2.SSS_BG(397:end);
SSS_BG('BG_neg') = out3.SSS_BG(397:end);

savename = ['matfiles/SSS_BG_time.mat']
save(savename,'SSS_BG')

figure(1)
plot((SSS_BG('BG_pos')-SSS_BG('ctrl')))
hold on
plot((SSS_BG('BG_neg')-SSS_BG('ctrl')),'r')
title('SSS BG')
ylim([-3 3]*1e-1)
legend('BG-pos','BG-neg','location','northwest')
printname = ['paperfigs/SSS_BG.png'];
print(1,'-dpng','-r300',printname)

