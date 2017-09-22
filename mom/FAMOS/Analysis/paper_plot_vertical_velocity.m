clear all


matfile = 'matfiles/om3_core3_2_wt_time.mat';
out1 = load(matfile);
matfile = 'matfiles/om3_core3_2_BG_pos_wt_time.mat';
out2 = load(matfile);
matfile = 'matfiles/om3_core3_2_BG_neg_wt_time.mat';
out3 = load(matfile);
aname = '/export/grunchfs/unibjerknes/milicak/bckup/noresm/CORE2/Arctic/DATA/gfdl-mom/grids_bathymetry/ocean.static.nc';
mname = ['/fimm/home/bjerknes/milicak/Analysis/mom/APE/Analysis/grid_spec_v6_regMask.nc'];

wvel = containers.Map
wvel('ctrl') = out1.wt_BG(397:end);
wvel('BG_pos') = out2.wt_BG(397:end);
wvel('BG_neg') = out3.wt_BG(397:end);

savename = ['matfiles/wvel_all_time.mat']
save(savename,'wvel')

figure(1)
plot((wvel('BG_pos')-wvel('ctrl')))
hold on
plot((wvel('BG_neg')-wvel('ctrl')),'r')
title('wvel BG')
ylim([-6 6]*1e-7)
legend('BG-pos','BG-neg','location','northwest')
printname = ['paperfigs/wvel.png'];
print(1,'-dpng','-r300',printname)

wvel300 = containers.Map
wvel300('ctrl') = out1.wt_300(397:end);
wvel300('BG_pos') = out2.wt_300(397:end);
wvel300('BG_neg') = out3.wt_300(397:end);

savename = ['matfiles/wvel300_all_time.mat']
save(savename,'wvel')

figure(2)
plot((wvel300('BG_pos')-wvel300('ctrl')))
hold on
plot((wvel300('BG_neg')-wvel300('ctrl')),'r')
title('wvel 300')
break
ylim([-6 6]*1e-7)
legend('BG-pos','BG-neg','location','northwest')
printname = ['paperfigs/wvel300.png'];
print(1,'-dpng','-r300',printname)
