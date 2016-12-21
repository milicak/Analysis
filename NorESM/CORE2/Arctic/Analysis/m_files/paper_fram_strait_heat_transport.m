clear all
load matfiles/fram_heat_transports.mat
lw=2; %linewidth

figure(1)
hold on
%warm bias models
plot(fram_heat_north_fesom,'b','linewidth',lw)
plot(fram_heat_north_ncar,'r','linewidth',lw)
plot(fram_heat_north_mom,'g','linewidth',lw)
plot(fram_heat_north_mri_free,'color',rgb('HotPink'),'linewidth',lw)
plot(241:300,fram_heat_north_mri_data,'color',rgb('Black'),'linewidth',lw)
plot(fram_heat_north_hycom,'color',rgb('DarkViolet'),'linewidth',lw)
%plot(fram_heat_south_hycom*0.0,'k','linewidth',1)
ylim([-10 60])
ax=legend('FEOSM','POP','MOM','MRI-FREE','MRI-DATA','HYCOM','location','southeast');
legend(ax,'boxoff')
ylabel('Northward heat transport [TW]')
xlabel('time [years]')
printname=['paperfigs/fram_northward_heat_transport1'];
print(1,'-depsc2','-r150',printname)

%cold bias models
figure(2)
hold on
plot(fram_heat_north_geomar,'color',rgb('orange'),'linewidth',lw)
plot(fram_heat_north_noresm,'b','linewidth',lw)
plot(fram_heat_north_cnrm,'k','linewidth',lw)
plot(fram_heat_north_gold,'color',rgb('DarkCyan'),'linewidth',lw)
plot(fram_heat_north_cerfacs,'c','linewidth',lw)
plot(fram_heat_south_hycom*0.0,'k','linewidth',1)
ylim([-10 60])
ax=legend('GEOMAR','NorESM','CNRM','CERFACS','GOLD','location','northwest');
legend(ax,'boxoff')
ylabel('Northward heat transport [TW]')
xlabel('time [years]')
printname=['paperfigs/fram_northward_heat_transport2'];
print(2,'-depsc2','-r150',printname)

figure(3)
hold on
%warm bias models
plot(fram_heat_south_fesom,'b','linewidth',lw)
plot(fram_heat_south_ncar,'r','linewidth',lw)
plot(fram_heat_south_mom,'g','linewidth',lw)
plot(fram_heat_south_mri_free,'color',rgb('HotPink'),'linewidth',lw)
plot(241:300,fram_heat_south_mri_data,'color',rgb('Black'),'linewidth',lw)
plot(fram_heat_south_hycom,'color',rgb('DarkViolet'),'linewidth',lw)
plot(fram_heat_south_hycom*0.0,'k','linewidth',1)
ylim([-30 40])
ax=legend('FESOM','POP','MOM','MRI-FREE','MRI-DATA','HYCOM','location','northwest');
legend(ax,'boxoff')
ylabel('Southward heat transport [TW]')
xlabel('time [years]')
printname=['paperfigs/fram_southward_heat_transport1'];
print(3,'-depsc2','-r150',printname)

%cold bias models
figure(4)
hold on
plot(fram_heat_south_geomar,'color',rgb('orange'),'linewidth',lw)
plot(fram_heat_south_noresm,'b','linewidth',lw)
plot(fram_heat_south_cnrm,'k','linewidth',lw)
plot(fram_heat_south_gold,'color',rgb('DarkCyan'),'linewidth',lw)
plot(fram_heat_south_cerfacs,'c','linewidth',lw)
plot(fram_heat_south_hycom*0.0,'k','linewidth',1)
ylim([-30 40])
ax=legend('GEOMAR','NorESM','CNRM','CERFACS','GOLD','location','southwest');
legend(ax,'boxoff')
ylabel('Southward heat transport [TW]')
xlabel('time [years]')
printname=['paperfigs/fram_southward_heat_transport2'];
print(4,'-depsc2','-r150',printname)


figure(5)
hold on
%warm bias models
plot(fram_heat_north_fesom+fram_heat_south_fesom,'b','linewidth',lw)
plot(fram_heat_north_ncar+fram_heat_south_ncar,'r','linewidth',lw)
plot(fram_heat_north_mom+fram_heat_south_mom,'g','linewidth',lw)
plot(fram_heat_north_mri_free+fram_heat_south_mri_free,'color',rgb('HotPink'),'linewidth',lw)
plot(241:300,fram_heat_north_mri_data+fram_heat_south_mri_data,'color',rgb('Black'),'linewidth',lw)
plot(fram_heat_north_hycom+fram_heat_south_hycom,'color',rgb('DarkViolet'),'linewidth',lw)
%plot(fram_heat_south_hycom*0.0,'k','linewidth',1)
ylim([-10 60])
ax=legend('FESOM','POP','MOM','MRI-FREE','MRI-DATA','HYCOM','location','northeast');
legend(ax,'boxoff')
ylabel('Total heat transport [TW]')
xlabel('time [years]')
printname=['paperfigs/fram_total_heat_transport1'];
print(5,'-depsc2','-r150',printname)

%cold bias models
figure(6)
hold on
plot(fram_heat_north_geomar+fram_heat_south_geomar,'color',rgb('orange'),'linewidth',lw)
plot(fram_heat_north_noresm+fram_heat_south_noresm,'b','linewidth',lw)
plot(fram_heat_north_cnrm+fram_heat_south_cnrm,'k','linewidth',lw)
plot(fram_heat_north_gold+fram_heat_south_gold,'color',rgb('DarkCyan'),'linewidth',lw)
plot(fram_heat_north_cerfacs+fram_heat_south_cerfacs,'c','linewidth',lw)
%plot(fram_heat_south_hycom*0.0,'k','linewidth',1)
ylim([-10 60])
ax=legend('GEOMAR','NorESM','CNRM','CERFACS','GOLD','location','northeast');
legend(ax,'boxoff')
ylabel('Total heat transport [TW]')
xlabel('time [years]')
printname=['paperfigs/fram_total_heat_transport2'];
print(6,'-depsc2','-r150',printname)
