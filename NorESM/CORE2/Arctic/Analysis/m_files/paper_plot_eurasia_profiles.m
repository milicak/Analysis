clear all

out.woa=load('matfiles/woa_eurasia_basin_profiles.mat');
out.hycom=load('matfiles/fsu_hycom_eurasia_basin_profiles.mat');
out.geomar=load('matfiles/geomar_orca_eurasia_basin_profiles.mat');
out.gold=load('matfiles/gfdl_gold_eurasia_basin_profiles.mat');
out.mom=load('matfiles/gfdl_mom_eurasia_basin_profiles.mat');
out.micom=load('matfiles/micom_eurasia_basin_profiles.mat');
out.mridata=load('matfiles/mir_data_eurasia_basin_profiles.mat');
out.mrifree=load('matfiles/mir_free_eurasia_basin_profiles.mat');
out.pop=load('matfiles/ncar_pop_eurasia_basin_profiles.mat');
out.cerfacs=load('matfiles/nemo_cerfacs_eurasia_basin_profiles.mat');
out.cnrm=load('matfiles/nemo_cnrm_eurasia_basin_profiles.mat');
out.fesom=load('matfiles/fesom_eurasia_basin_profiles.mat');
out.cmcc=load('matfiles/cmcc_orca_eurasia_basin_profiles.mat');
out.noc=load('matfiles/noc_orca_eurasia_basin_profiles.mat');
out.mom025=load('matfiles/mom_0_25_eurasia_basin_profiles.mat');
out.hycom2=load('matfiles/fsu_hycom2_eurasia_basin_profiles.mat');

figure(1)
plot(out.woa.temp_eurasia,-out.woa.zt,'k--','linewidth',2);
ylim([-4000 0])
load color_15
hold on

k=2;
plot(out.fesom.temp_eurasia,-out.fesom.zt,'color',[color(k,1) color(k,2) color(k,3)],'linewidth',2);

k=14;
plot(out.micom.temp_eurasia,-out.micom.zt,'color',[color(k,1) color(k,2) color(k,3)],'linewidth',2);

k=5;
plot(out.cerfacs.temp_eurasia,-out.cerfacs.zt,'color',[color(k,1) color(k,2) color(k,3)],'linewidth',2);

k=9;
plot(out.cmcc.temp_eurasia,-out.cmcc.zt,'color',[color(k,1) color(k,2) color(k,3)],'linewidth',2);

k=6;
plot(out.cnrm.temp_eurasia,-out.cnrm.zt,'color',[color(k,1) color(k,2) color(k,3)],'linewidth',2);

k=13;
plot(out.hycom.temp_eurasia,-out.hycom.ztref,'color',[color(k,1) color(k,2) color(k,3)],'linewidth',2);

k=15;
plot(out.hycom2.temp_eurasia,-out.hycom2.ztref,'color',[color(k,1) color(k,2) color(k,3)],'linewidth',2);

k=12;
plot(out.gold.temp_eurasia,-out.gold.zt,'color',[color(k,1) color(k,2) color(k,3)],'linewidth',2);

k=3;
plot(out.mom.temp_eurasia,-out.mom.zt,'color',[color(k,1) color(k,2) color(k,3)],'linewidth',2);

k=7;
plot(out.geomar.temp_eurasia,-out.geomar.zt,'color',[color(k,1) color(k,2) color(k,3)],'linewidth',2);

k=4;
plot(out.mom025.temp_eurasia,-out.mom025.zt,'color',[color(k,1) color(k,2) color(k,3)],'linewidth',2);

k=11;
plot(out.mridata.temp_eurasia,-out.mridata.zt,'color',[color(k,1) color(k,2) color(k,3)],'linewidth',2);

k=10;
plot(out.mrifree.temp_eurasia,-out.mrifree.zt,'color',[color(k,1) color(k,2) color(k,3)],'linewidth',2);

k=1;
plot(out.pop.temp_eurasia,-out.pop.zt,'color',[color(k,1) color(k,2) color(k,3)],'linewidth',2);

k=8;
plot(out.noc.temp_eurasia,-out.noc.zt,'color',[color(k,1) color(k,2) color(k,3)],'linewidth',2);



%plot(out.pop.temp_eurasia,-out.pop.zt,'color',[.7 .7 .7],'linewidth',2);
%plot(out.fesom.temp_eurasia,-out.fesom.zt,'color',rgb('dodgerblue'),'linewidth',2);
%plot(out.mom.temp_eurasia,-out.mom.zt,'m','linewidth',2);
%plot(out.mom025.temp_eurasia,-out.mom025.zt,'color',rgb('forestgreen'),'linewidth',2);
%plot(out.cerfacs.temp_eurasia,-out.cerfacs.zt,'color',[.8 .2 .0],'linewidth',2);
%plot(out.cnrm.temp_eurasia,-out.cnrm.zt,'color',[.2 .7 .7],'linewidth',2);
%plot(out.geomar.temp_eurasia,-out.geomar.zt,'r','linewidth',2);
%plot(out.noc.temp_eurasia,-out.noc.zt,'color',rgb('plum'),'linewidth',2);
%plot(out.cmcc.temp_eurasia,-out.cmcc.zt,'color',rgb('darkorange'),'linewidth',2);
%plot(out.mrifree.temp_eurasia,-out.mrifree.zt,'g','linewidth',2);
%plot(out.mridata.temp_eurasia,-out.mridata.zt,'y','linewidth',2);
%plot(out.gold.temp_eurasia,-out.gold.zt,'b','linewidth',2);
%plot(out.hycom.temp_eurasia,-out.hycom.ztref,'k','linewidth',2);
%plot(out.micom.temp_eurasia,-out.micom.zt,'c','linewidth',2);

ax1=legend('PHC3.0','AWI-FESOM','Bergen','CERFACS','CMCC','CNRM', ...
       'FSU-HYCOM','FSU-HYCOMv2','GFDL-GOLD', 'GFDL-MOM','Kiel-ORCA05', ...
       'MOM0.25','MRI-A','MRI-F','NCAR','NOC' ...
       ,'location','eastoutside');
legend(ax1,'boxoff')
xlabel('Temperature [^oC]')
ylabel('Depth [m]')
plot(out.woa.temp_eurasia,-out.woa.zt,'k--','linewidth',2);
%printname=['paperfigs/eurasia_basin_temp_profiles'];
%printname=['paperfigs2/eurasia_basin_temp_profiles'];
printname=['paperfigs2/eurasia_basin_temp_profilesv4'];
print(1,'-depsc2','-r150',printname)

break

figure(2)
plot(out.woa.salt_eurasia,-out.woa.zt,'k--','linewidth',2);
ylim([-2000 0])
hold on
plot(out.mridata.salt_eurasia,-out.mridata.zt,'y','linewidth',2);
plot(out.mrifree.salt_eurasia,-out.mrifree.zt,'g','linewidth',2);
plot(out.gold.salt_eurasia,-out.gold.zt,'b','linewidth',2);
plot(out.mom.salt_eurasia,-out.mom.zt,'m','linewidth',2);
plot(out.micom.salt_eurasia,-out.micom.zt,'c','linewidth',2);
plot(out.hycom.salt_eurasia,-out.hycom.ztref,'k','linewidth',2);
plot(out.geomar.salt_eurasia,-out.geomar.zt,'r','linewidth',2);
plot(out.pop.salt_eurasia,-out.pop.zt,'color',[.7 .7 .7],'linewidth',2);
plot(out.cerfacs.salt_eurasia,-out.cerfacs.zt,'color',[.8 .2 .0],'linewidth',2);
plot(out.cnrm.salt_eurasia,-out.cnrm.zt,'color',[.2 .7 .7],'linewidth',2);
plot(out.fesom.salt_eurasia,-out.fesom.zt,'color',rgb('dodgerblue'),'linewidth',2);
plot(out.cmcc.salt_eurasia,-out.cmcc.zt,'color',rgb('darkorange'),'linewidth',2);
plot(out.noc.salt_eurasia,-out.noc.zt,'color',rgb('plum'),'linewidth',2);
plot(out.mom025.salt_eurasia,-out.mom025.zt,'color',rgb('forestgreen'),'linewidth',2);
plot(out.woa.salt_eurasia,-out.woa.zt,'k--','linewidth',2);

ax=legend('WOA','MRI-A','MRI-F','GFDL-GOLD','GFDL-MOM','BERGEN','FSU-HYCOM','Kiel-ORCA05','NCAR','CERFACS','CNRM','AWI-FESOM' ...
       ,'CMCC','NOC','MOM0.25' ...
       ,'location','eastoutside')
legend(ax,'boxoff')
xlabel('Salt [psu]')
ylabel('Depth [m]')

printname=['paperfigs/eurasia_basin_salt_profiles'];
print(2,'-depsc2','-r150',printname)
