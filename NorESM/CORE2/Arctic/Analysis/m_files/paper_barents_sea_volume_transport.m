clear all
load matfiles/barents_volume_transports.mat
lw=2; %linewidth

figure(1)
hold on
%warm bias models
plot(barents_volume_north_fesom,'b','linewidth',lw)
plot(barents_volume_north_ncar,'r','linewidth',lw)
plot(barents_volume_north_mom,'g','linewidth',lw)
plot(barents_volume_north_mri_free,'color',rgb('HotPink'),'linewidth',lw)
plot(241:300,barents_volume_north_mri_data,'color',rgb('Black'),'linewidth',lw)
plot(barents_volume_north_hycom,'color',rgb('DarkViolet'),'linewidth',lw)
%plot(barents_volume_south_hycom*0.0,'k','linewidth',1)
ylim([-0 9])
ax=legend('FESOM','POP','MOM','MRI-FREE','MRI-DATA','HYCOM','location','northwest');
legend(ax,'boxoff')
ylabel('Eastward volume transport [Sv]')
xlabel('time [years]')
printname=['paperfigs/barents_eastward_volume_transport1'];
print(1,'-depsc2','-r150',printname)

%cold bias models
figure(2)
hold on
plot(barents_volume_north_geomar,'color',rgb('orange'),'linewidth',lw)
plot(barents_volume_north_noresm,'b','linewidth',lw)
plot(barents_volume_north_cnrm,'k','linewidth',lw)
plot(barents_volume_north_gold,'color',rgb('DarkCyan'),'linewidth',lw)
plot(barents_volume_north_cerfacs,'c','linewidth',lw)
%plot(barents_volume_south_hycom*0.0,'k','linewidth',1)
ylim([-0 9])
ax=legend('GEOMAR','NorESM','CNRM','CERFACS','GOLD','location','southeast');
legend(ax,'boxoff')
ylabel('Eastward volume transport [Sv]')
xlabel('time [years]')
printname=['paperfigs/barents_eastward_volume_transport2'];
print(2,'-depsc2','-r150',printname)

figure(3)
hold on
%warm bias models
plot(barents_volume_south_fesom,'b','linewidth',lw)
plot(barents_volume_south_ncar,'r','linewidth',lw)
plot(barents_volume_south_mom,'g','linewidth',lw)
plot(barents_volume_south_mri_free,'color',rgb('HotPink'),'linewidth',lw)
plot(241:300,barents_volume_south_mri_data,'color',rgb('Black'),'linewidth',lw)
plot(barents_volume_south_hycom,'color',rgb('DarkViolet'),'linewidth',lw)
plot(barents_volume_south_hycom*0.0,'k','linewidth',1)
ylim([-5 0])
ax=legend('FESOM','POP','MOM','MRI-FREE','MRI-DATA','HYCOM','location','southwest');
legend(ax,'boxoff')
ylabel('Westward volume transport [Sv]')
xlabel('time [years]')
printname=['paperfigs/barents_westward_volume_transport1'];
print(3,'-depsc2','-r150',printname)

%cold bias models
figure(4)
hold on
plot(barents_volume_south_geomar,'color',rgb('orange'),'linewidth',lw)
plot(barents_volume_south_noresm,'b','linewidth',lw)
plot(barents_volume_south_cnrm,'k','linewidth',lw)
plot(barents_volume_south_gold,'color',rgb('DarkCyan'),'linewidth',lw)
plot(barents_volume_south_cerfacs,'c','linewidth',lw)
plot(barents_volume_south_hycom*0.0,'k','linewidth',1)
ylim([-5 0])
ax=legend('GEOMAR','NorESM','CNRM','CERFACS','GOLD','location','southwest');
legend(ax,'boxoff')
ylabel('Westward volume transport [Sv]')
xlabel('time [years]')
printname=['paperfigs/barents_westward_volume_transport2'];
print(4,'-depsc2','-r150',printname)


figure(5)
hold on
%warm bias models
plot(barents_volume_north_fesom+barents_volume_south_fesom,'b','linewidth',lw)
plot(barents_volume_north_ncar+barents_volume_south_ncar,'r','linewidth',lw)
plot(barents_volume_north_mom+barents_volume_south_mom,'g','linewidth',lw)
plot(barents_volume_north_mri_free+barents_volume_south_mri_free,'color',rgb('HotPink'),'linewidth',lw)
plot(241:300,barents_volume_north_mri_data+barents_volume_south_mri_data,'color',rgb('Black'),'linewidth',lw)
plot(barents_volume_north_hycom+barents_volume_south_hycom,'color',rgb('DarkViolet'),'linewidth',lw)
%plot(barents_volume_south_hycom*0.0,'k','linewidth',1)
ylim([-0 5.5])
ax=legend('FESOM','POP','MOM','MRI-FREE','MRI-DATA','HYCOM','location','northwest');
legend(ax,'boxoff')
ylabel('Total volume transport [Sv]')
xlabel('time [years]')
printname=['paperfigs/barents_total_volume_transport1'];
print(5,'-depsc2','-r150',printname)

%cold bias models
figure(6)
hold on
plot(barents_volume_north_geomar+barents_volume_south_geomar,'color',rgb('orange'),'linewidth',lw)
plot(barents_volume_north_noresm+barents_volume_south_noresm,'b','linewidth',lw)
plot(barents_volume_north_cnrm+barents_volume_south_cnrm,'k','linewidth',lw)
plot(barents_volume_north_gold+barents_volume_south_gold,'color',rgb('DarkCyan'),'linewidth',lw)
plot(barents_volume_north_cerfacs+barents_volume_south_cerfacs,'c','linewidth',lw)
%plot(barents_volume_south_hycom*0.0,'k','linewidth',1)
ylim([-0 5.5])
ax=legend('GEOMAR','NorESM','CNRM','CERFACS','GOLD','location','southwest');
legend(ax,'boxoff')
ylabel('Total volume transport [Sv]')
xlabel('time [years]')
printname=['paperfigs/barents_total_volume_transport2'];
print(6,'-depsc2','-r150',printname)

