clear all


matfile = 'matfiles/om3_core3_2_SSH_BG_time.mat';
out1 = load(matfile);
matfile = 'matfiles/om3_core3_2_BG_pos_SSH_BG_time.mat';
out2 = load(matfile);
matfile = 'matfiles/om3_core3_2_BG_neg_SSH_BG_time.mat';
out3 = load(matfile);

SSH_BG = containers.Map
SSH_BG('ctrl') = out1.SSH_BG(397:end);
SSH_BG('BG_pos') = out2.SSH_BG(397:end);
SSH_BG('BG_neg') = out3.SSH_BG(397:end);

savename = ['matfiles/SSH_BG_time.mat']
save(savename,'SSH_BG')

figure(1)
plot((SSH_BG('BG_pos')-SSH_BG('ctrl')))
hold on
plot((SSH_BG('BG_neg')-SSH_BG('ctrl')),'r')
title('SSH BG')
ylim([-3 3]*1e-1)
legend('BG-pos','BG-neg','location','northwest')
printname = ['paperfigs/SSH_BG.png'];
print(1,'-dpng','-r300',printname)
