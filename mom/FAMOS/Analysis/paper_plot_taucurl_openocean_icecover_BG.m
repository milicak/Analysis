
clear all

matfile = 'matfiles/om3_core3_2_taucurl_openocean_icecover_BG.mat';
out1 = load(matfile);
matfile = 'matfiles/om3_core3_2_BG_pos_taucurl_openocean_icecover_BG.mat';
out2 = load(matfile);
matfile = 'matfiles/om3_core3_2_BG_neg_taucurl_openocean_icecover_BG.mat';
out3 = load(matfile);

taucurl_openocean_BG = containers.Map
taucurl_openocean_BG('ctrl') = out1.taucurl_openocean(397:end);
taucurl_openocean_BG('BG_pos') = out2.taucurl_openocean(397:end);
taucurl_openocean_BG('BG_neg') = out3.taucurl_openocean(397:end);

taucurl_icecover_BG = containers.Map
taucurl_icecover_BG('ctrl') = out1.taucurl_icecover(397:end);
taucurl_icecover_BG('BG_pos') = out2.taucurl_icecover(397:end);
taucurl_icecover_BG('BG_neg') = out3.taucurl_icecover(397:end);

savename = ['matfiles/taucurl_openocean_BG_time.mat']
save(savename,'taucurl_openocean_BG')

savename = ['matfiles/taucurl_icecover_BG_time.mat']
save(savename,'taucurl_icecover_BG')

figure(1)
plot((taucurl_openocean_BG('BG_pos')-taucurl_openocean_BG('ctrl')))
hold on
plot((taucurl_openocean_BG('BG_neg')-taucurl_openocean_BG('ctrl')),'r')
title('taucurl open ocean BG')
ylim([-1.5 1.5]*1e5)
legend('BG-pos','BG-neg','location','northwest')
printname = ['paperfigs/taucurl_openocean_BG.png'];
print(1,'-dpng','-r300',printname)

figure(2)
plot((taucurl_icecover_BG('BG_pos')-taucurl_icecover_BG('ctrl')))
hold on
plot((taucurl_icecover_BG('BG_neg')-taucurl_icecover_BG('ctrl')),'r')
title('taucurl ice cover BG')
ylim([-1.5 1.5]*1e5)
legend('BG-pos','BG-neg','location','northwest')
printname = ['paperfigs/taucurl_icecover_BG.png'];
print(2,'-dpng','-r300',printname)
