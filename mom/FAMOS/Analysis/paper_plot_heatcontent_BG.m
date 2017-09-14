clear all


matfile = 'matfiles/om3_core3_2_heatcontent_BG_time.mat';
out1 = load(matfile);
matfile = 'matfiles/om3_core3_2_BG_pos_heatcontent_BG_time.mat';
out2 = load(matfile);
matfile = 'matfiles/om3_core3_2_BG_neg_heatcontent_BG_time.mat';
out3 = load(matfile);

heatcontent_BG = containers.Map
heatcontent_BG('ctrl') = out1.heatcontent_BG(397:end);
heatcontent_BG('BG_pos') = out2.heatcontent_BG(397:end);
heatcontent_BG('BG_neg') = out3.heatcontent_BG(397:end);

savename = ['matfiles/heatcontent_BG_time.mat']
save(savename,'heatcontent_BG')

figure(1)
plot((heatcontent_BG('BG_pos')-heatcontent_BG('ctrl')))
hold on
plot((heatcontent_BG('BG_neg')-heatcontent_BG('ctrl')),'r')
title('heatcontent BG')
ylim([-.65 .65]*1e21)
grid
legend('BG-pos','BG-neg','location','northwest')
printname = ['paperfigs/heatcontent_BG.png'];
print(1,'-dpng','-r300',printname)

