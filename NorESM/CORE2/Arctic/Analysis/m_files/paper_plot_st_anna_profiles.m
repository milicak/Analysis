clear all

out.woa=load('matfiles/woa_st_anna_profiles.mat');
out.hycom=load('matfiles/fsu_hycom_st_anna_profiles.mat');
out.geomar=load('matfiles/geomar_orca_st_anna_profiles.mat');
out.gold=load('matfiles/gfdl_gold_st_anna_profiles.mat');
out.mom=load('matfiles/gfdl_mom_st_anna_profiles.mat');
out.micom=load('matfiles/micom_st_anna_profiles.mat');
out.mridata=load('matfiles/mir_data_st_anna_profiles.mat');
out.mrifree=load('matfiles/mir_free_st_anna_profiles.mat');
out.pop=load('matfiles/ncar_pop_st_anna_profiles.mat');
out.cerfacs=load('matfiles/nemo_cerfacs_st_anna_profiles.mat');
out.cnrm=load('matfiles/nemo_cnrm_st_anna_profiles.mat');

figure(1)
plot(out.woa.temp_st_anna,-out.woa.zt,'k--','linewidth',2);
ylim([-700 0])
hold on
plot(out.hycom.temp_st_anna,-out.hycom.ztref,'k','linewidth',2);
plot(out.geomar.temp_st_anna,-out.geomar.zt,'r','linewidth',2);
plot(out.gold.temp_st_anna,-out.gold.zt,'b','linewidth',2);
plot(out.mom.temp_st_anna,-out.mom.zt,'m','linewidth',2);
plot(out.micom.temp_st_anna,-out.micom.zt,'c','linewidth',2);
plot(out.mridata.temp_st_anna,-out.mridata.zt,'y','linewidth',2);
plot(out.mrifree.temp_st_anna,-out.mrifree.zt,'g','linewidth',2);
plot(out.pop.temp_st_anna,-out.pop.zt,'color',[.7 .7 .7],'linewidth',2);
plot(out.cerfacs.temp_st_anna,-out.cerfacs.zt,'color',[.8 .2 .0],'linewidth',2);
plot(out.cnrm.temp_st_anna,-out.cnrm.zt,'color',[.2 .7 .7],'linewidth',2);

ax=legend('WOA','HYCOM','GEOMAR','GOLD','MOM','NorESM','MRI-DATA','MRI-FREE','POP','CERFACS','CNRM' ...
       ,'location','southeast')
legend(ax,'boxoff')
xlabel('Temp [^oC]')
ylabel('Depth [m]')
printname=['paperfigs/st_anna_temp_profiles'];
print(1,'-depsc2','-r150',printname)

figure(2)
plot(out.woa.salt_st_anna,-out.woa.zt,'k--','linewidth',2);
ylim([-150 0])
hold on
plot(out.hycom.salt_st_anna,-out.hycom.ztref,'k','linewidth',2);
plot(out.geomar.salt_st_anna,-out.geomar.zt,'r','linewidth',2);
plot(out.gold.salt_st_anna,-out.gold.zt,'b','linewidth',2);
plot(out.mom.salt_st_anna,-out.mom.zt,'m','linewidth',2);
plot(out.micom.salt_st_anna,-out.micom.zt,'c','linewidth',2);
plot(out.mridata.salt_st_anna,-out.mridata.zt,'y','linewidth',2);
plot(out.mrifree.salt_st_anna,-out.mrifree.zt,'g','linewidth',2);
plot(out.pop.salt_st_anna,-out.pop.zt,'color',[.7 .7 .7],'linewidth',2);
plot(out.cerfacs.salt_st_anna,-out.cerfacs.zt,'color',[.8 .2 .0],'linewidth',2);
plot(out.cnrm.salt_st_anna,-out.cnrm.zt,'color',[.2 .7 .7],'linewidth',2);

ax=legend('WOA','HYCOM','GEOMAR','GOLD','MOM','NorESM','MRI-DATA','MRI-FREE','POP','CERFACS','CNRM' ...
       ,'location','southwest')
legend(ax,'boxoff')
xlabel('Salt [psu]')
ylabel('Depth [m]')

printname=['paperfigs/st_anna_salt_profiles'];
print(2,'-depsc2','-r150',printname)
