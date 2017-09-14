
clear all

matfile = 'matfiles/om3_core3_2_taucurl_BG.mat';
out1 = load(matfile);
matfile = 'matfiles/om3_core3_2_BG_pos_taucurl_BG.mat';
out2 = load(matfile);
matfile = 'matfiles/om3_core3_2_BG_neg_taucurl_BG.mat';
out3 = load(matfile);

taucurl_BG = containers.Map
taucurl_BG('ctrl') = out1.taucurl(397:end);
taucurl_BG('BG_pos') = out2.taucurl(397:end);
taucurl_BG('BG_neg') = out3.taucurl(397:end);

savename = ['matfiles/taucurl_BG_time.mat']
save(savename,'taucurl_BG')

figure(1)
plot((taucurl_BG('BG_pos')-taucurl_BG('ctrl')))
hold on
plot((taucurl_BG('BG_neg')-taucurl_BG('ctrl')),'r')
title('taucurl BG')
ylim([-1.5 1.5]*1e5)
legend('BG-pos','BG-neg','location','northwest')
printname = ['paperfigs/taucurl_BG.png'];
print(1,'-dpng','-r300',printname)
