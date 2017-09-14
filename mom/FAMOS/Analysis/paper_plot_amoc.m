clear all


matfile = 'matfiles/om3_core3_2_amoc_max_time.mat';
out1 = load(matfile);
matfile = 'matfiles/om3_core3_2_BG_pos_amoc_max_time.mat';
out2 = load(matfile);
matfile = 'matfiles/om3_core3_2_BG_neg_amoc_max_time.mat';
out3 = load(matfile);
matfile = 'matfiles/om3_core3_2_GS_pos_amoc_max_time.mat';
out4 = load(matfile);
matfile = 'matfiles/om3_core3_2_GS_neg_amoc_max_time.mat';
out5 = load(matfile);

amoc = containers.Map
amoc('ctrl') = out1.amoc_max(397:end);
amoc('BG_pos') = out2.amoc_max(397:end);
amoc('BG_neg') = out3.amoc_max(397:end);
amoc('GS_pos') = out4.amoc_max(397:end);
amoc('GS_neg') = out5.amoc_max(397:end);

savename = ['matfiles/amoc_max_all_time.mat']
save(savename,'amoc')

figure(1)
plot((amoc('BG_pos')-amoc('ctrl')))
hold on
plot((amoc('BG_neg')-amoc('ctrl')),'r')
plot((amoc('GS_pos')-amoc('ctrl')),'k')
plot((amoc('GS_neg')-amoc('ctrl')),'g')
title('amoc BG')
ylim([-1 1])
break
legend('BG-pos','BG-neg','location','northwest')
printname = ['paperfigs/amoc_max.png'];
print(1,'-dpng','-r300',printname)

