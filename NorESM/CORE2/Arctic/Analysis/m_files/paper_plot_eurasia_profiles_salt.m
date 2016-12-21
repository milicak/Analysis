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

zr=0:1:7000;
dnm1=interp1(out.woa.zt,out.woa.salt_eurasia,zr);

[P_scaled,Ptick,Pticklabel,Plim,zsplit]=rescale_depth(out.woa.zt);
plot(out.woa.salt_eurasia,P_scaled,'k--','linewidth',2);
set(gca,'ylim',Plim,'ytick',Ptick,'yticklabel',-Pticklabel);
ylim([0 1200])
set(gca,'ydir','reverse');
hold on
load color_15

dnm=interp1(out.fesom.zt,out.fesom.salt_eurasia,zr);
[P_scaled,Ptick,Pticklabel,Plim,zsplit]=rescale_depth(zr);
plot(dnm-dnm1,P_scaled,'color',[color(2,1) color(2,2) color(2,3)],'linewidth',2);
xlim([-1.8 1.8])

dnm=interp1(out.micom.zt,out.micom.salt_eurasia,zr);
plot(dnm-dnm1,P_scaled,'color',[color(14,1) color(14,2) color(14,3)],'linewidth',2);

dnm=interp1(out.cerfacs.zt,out.cerfacs.salt_eurasia,zr);
plot(dnm-dnm1,P_scaled,'color',[color(5,1) color(5,2) color(5,3)],'linewidth',2);

dnm=interp1(out.cmcc.zt,out.cmcc.salt_eurasia,zr);
plot(dnm-dnm1,P_scaled,'color',[color(9,1) color(9,2) color(9,3)],'linewidth',2);

dnm=interp1(out.cnrm.zt,out.cnrm.salt_eurasia,zr);
plot(dnm-dnm1,P_scaled,'color',[color(6,1) color(6,2) color(6,3)],'linewidth',2);

dnm=interp1(out.hycom.ztref,out.hycom.salt_eurasia,zr);
plot(dnm-dnm1,P_scaled,'color',[color(13,1) color(13,2) color(13,3)],'linewidth',2);

dnm=interp1(out.hycom2.ztref,out.hycom2.salt_eurasia,zr);
plot(dnm-dnm1,P_scaled,'color',[color(15,1) color(15,2) color(15,3)],'linewidth',2);

dnm=interp1(out.gold.zt,out.gold.salt_eurasia,zr);
plot(dnm-dnm1,P_scaled,'color',[color(12,1) color(12,2) color(12,3)],'linewidth',2);

dnm=interp1(out.mom.zt,out.mom.salt_eurasia,zr);
plot(dnm-dnm1,P_scaled,'color',[color(3,1) color(3,2) color(3,3)],'linewidth',2);

dnm=interp1(out.geomar.zt,out.geomar.salt_eurasia,zr);
plot(dnm-dnm1,P_scaled,'color',[color(7,1) color(7,2) color(7,3)],'linewidth',2);

dnm=interp1(out.mom025.zt,out.mom025.salt_eurasia,zr);
plot(dnm-dnm1,P_scaled,'color',[color(4,1) color(4,2) color(4,3)],'linewidth',2);

dnm=interp1(out.mridata.zt,out.mridata.salt_eurasia,zr);
plot(dnm-dnm1,P_scaled,'color',[color(11,1) color(11,2) color(11,3)],'linewidth',2);

dnm=interp1(out.mrifree.zt,out.mrifree.salt_eurasia,zr);
plot(dnm-dnm1,P_scaled,'color',[color(10,1) color(10,2) color(10,3)],'linewidth',2);

dnm=interp1(out.pop.zt,out.pop.salt_eurasia,zr);
plot(dnm-dnm1,P_scaled,'color',[color(1,1) color(1,2) color(1,3)],'linewidth',2);

dnm=interp1(out.noc.zt,out.noc.salt_eurasia,zr);
plot(dnm-dnm1,P_scaled,'color',[color(8,1) color(8,2) color(8,3)],'linewidth',2);

%set(gca,'ylim',Plim,'ytick',Ptick,'yticklabel',-Pticklabel);
%ylim([0 1200])
%set(gca,'ydir','reverse');
%hold on

ax1=legend('PHC3.0','AWI-FESOM','Bergen','CERFACS','CMCC','CNRM', ...
       'FSU-HYCOM','FSU-HYCOMv2','GFDL-GOLD', 'GFDL-MOM','Kiel-ORCA05', ...
       'MOM0.25','MRI-A','MRI-F','NCAR','NOC' ...
       ,'location','eastoutside');
legend(ax1,'boxoff')
xlabel('Salinity [psu]')
ylabel('Depth [m]')

ax(1)=gca;
ax(2)=axes('Position',get(ax(1),'Position'),...
   'XAxisLocation','top',...
   'YAxisLocation','left',...
   'Color','none',...
   'XColor','k','YColor','w');
[P_scaled,Ptick,Pticklabel,Plim,zsplit]=rescale_depth(out.woa.zt);
line(out.woa.salt_eurasia,P_scaled,'Color','k','linestyle','--','linewidth',2,'Parent',ax(2));
%set(ax(2),'ylim',Plim,'ytick',Ptick,'yticklabel','');
set(ax(2),'ylim',Plim,'ytick',[]);
ylim([0 1200])
set(gca,'ydir','reverse');
xlim([28 36])
set(gcf,'color','w');
set(gcf, 'InvertHardCopy', 'off');
%set(ax(1),'box','off')
%set(ax(2),'box','off')
%printname=['paperfigs/eurasia_basin_salt_profilesv3'];
%printname=['paperfigs2/eurasia_basin_salt_profilesv3'];
printname=['paperfigs2/eurasia_basin_salt_profilesv4'];
print(1,'-depsc2','-r150',printname)



break

figure(2)
[P_scaled,Ptick,Pticklabel,Plim,zsplit]=rescale_depth(out.woa.zt);
plot(out.woa.salt_eurasia,P_scaled,'k--','linewidth',2);
set(gca,'ylim',Plim,'ytick',Ptick,'yticklabel',-Pticklabel);
ylim([0 1200])
set(gca,'ydir','reverse');
hold on
[P_scaled,Ptick,Pticklabel,Plim,zsplit]=rescale_depth(out.mridata.zt);
plot(out.mridata.salt_eurasia,P_scaled,'y','linewidth',2);
[P_scaled,Ptick,Pticklabel,Plim,zsplit]=rescale_depth(out.mrifree.zt);
plot(out.mrifree.salt_eurasia,P_scaled,'g','linewidth',2);
[P_scaled,Ptick,Pticklabel,Plim,zsplit]=rescale_depth(out.gold.zt);
plot(out.gold.salt_eurasia,P_scaled,'b','linewidth',2);
[P_scaled,Ptick,Pticklabel,Plim,zsplit]=rescale_depth(out.mom.zt);
plot(out.mom.salt_eurasia,P_scaled,'m','linewidth',2);
[P_scaled,Ptick,Pticklabel,Plim,zsplit]=rescale_depth(out.micom.zt);
plot(out.micom.salt_eurasia,P_scaled,'c','linewidth',2);
[P_scaled,Ptick,Pticklabel,Plim,zsplit]=rescale_depth(out.hycom.ztref);
plot(out.hycom.salt_eurasia,P_scaled,'k','linewidth',2);
[P_scaled,Ptick,Pticklabel,Plim,zsplit]=rescale_depth(out.geomar.zt);
plot(out.geomar.salt_eurasia,P_scaled,'r','linewidth',2);
[P_scaled,Ptick,Pticklabel,Plim,zsplit]=rescale_depth(out.pop.zt);
plot(out.pop.salt_eurasia,P_scaled,'color',[.7 .7 .7],'linewidth',2);
[P_scaled,Ptick,Pticklabel,Plim,zsplit]=rescale_depth(out.cerfacs.zt);
plot(out.cerfacs.salt_eurasia,P_scaled,'color',[.8 .2 .0],'linewidth',2);
[P_scaled,Ptick,Pticklabel,Plim,zsplit]=rescale_depth(out.cnrm.zt);
plot(out.cnrm.salt_eurasia,P_scaled,'color',[.2 .7 .7],'linewidth',2);
[P_scaled,Ptick,Pticklabel,Plim,zsplit]=rescale_depth(out.fesom.zt);
plot(out.fesom.salt_eurasia,P_scaled,'color',rgb('dodgerblue'),'linewidth',2);
[P_scaled,Ptick,Pticklabel,Plim,zsplit]=rescale_depth(out.cmcc.zt);
plot(out.cmcc.salt_eurasia,P_scaled,'color',rgb('darkorange'),'linewidth',2);
[P_scaled,Ptick,Pticklabel,Plim,zsplit]=rescale_depth(out.noc.zt);
plot(out.noc.salt_eurasia,P_scaled,'color',rgb('plum'),'linewidth',2);
[P_scaled,Ptick,Pticklabel,Plim,zsplit]=rescale_depth(out.mom025.zt);
plot(out.mom025.salt_eurasia,P_scaled,'color',rgb('forestgreen'),'linewidth',2);
[P_scaled,Ptick,Pticklabel,Plim,zsplit]=rescale_depth(out.woa.zt);
plot(out.woa.salt_eurasia,P_scaled,'k--','linewidth',2);

ax=legend('WOA','MRI-A','MRI-F','GFDL-GOLD','GFDL-MOM','BERGEN','FSU-HYCOM','Kiel-ORCA05','NCAR','CERFACS','CNRM','AWI-FESOM' ...
       ,'CMCC','NOC','MOM0.25' ...
       ,'location','eastoutside')
legend(ax,'boxoff')
xlabel('Salt [psu]')
ylabel('Depth [m]')

printname=['paperfigs/eurasia_basin_salt_profilesv2'];
print(2,'-depsc2','-r150',printname)
