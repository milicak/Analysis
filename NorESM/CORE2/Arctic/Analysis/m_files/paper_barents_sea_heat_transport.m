clear all
load matfiles/barents_heat_transports.mat
lw=2; %linewidth

figure(1)
hold on
%warm bias models
plot(barents_heat_north_fesom,'b','linewidth',lw)
plot(barents_heat_north_ncar,'r','linewidth',lw)
plot(barents_heat_north_mom,'g','linewidth',lw)
plot(barents_heat_north_mri_free,'color',rgb('HotPink'),'linewidth',lw)
plot(241:300,barents_heat_north_mri_data,'color',rgb('Black'),'linewidth',lw)
plot(barents_heat_north_hycom,'color',rgb('DarkViolet'),'linewidth',lw)
%plot(barents_heat_south_hycom*0.0,'k','linewidth',1)
ylim([-10 160])
ax=legend('FESOM','POP','MOM','MRI-FREE','MRI-DATA','HYCOM','location','northwest');
legend(ax,'boxoff')
ylabel('Eastward heat transport [TW]')
xlabel('time [years]')
printname=['paperfigs/barents_eastward_heat_transport1'];
print(1,'-depsc2','-r150',printname)

%cold bias models
figure(2)
hold on
plot(barents_heat_north_geomar,'color',rgb('orange'),'linewidth',lw)
plot(barents_heat_north_noresm,'b','linewidth',lw)
plot(barents_heat_north_cnrm,'k','linewidth',lw)
plot(barents_heat_north_gold,'color',rgb('DarkCyan'),'linewidth',lw)
plot(barents_heat_north_cerfacs,'c','linewidth',lw)
%plot(barents_heat_south_hycom*0.0,'k','linewidth',1)
ylim([-10 160])
ax=legend('GEOMAR','NorESM','CNRM','CERFACS','GOLD','location','southeast');
legend(ax,'boxoff')
ylabel('Eastward heat transport [TW]')
xlabel('time [years]')
printname=['paperfigs/barents_eastward_heat_transport2'];
print(2,'-depsc2','-r150',printname)

figure(3)
hold on
%warm bias models
plot(barents_heat_south_fesom,'b','linewidth',lw)
plot(barents_heat_south_ncar,'r','linewidth',lw)
plot(barents_heat_south_mom,'g','linewidth',lw)
plot(barents_heat_south_mri_free,'color',rgb('HotPink'),'linewidth',lw)
plot(241:300,barents_heat_south_mri_data,'color',rgb('Black'),'linewidth',lw)
plot(barents_heat_south_hycom,'color',rgb('DarkViolet'),'linewidth',lw)
plot(barents_heat_south_hycom*0.0,'k','linewidth',1)
ylim([-60 10])
ax=legend('FESOM','POP','MOM','MRI-FREE','MRI-DATA','HYCOM','location','southeast');
legend(ax,'boxoff')
ylabel('Westward heat transport [TW]')
xlabel('time [years]')
printname=['paperfigs/barents_westward_heat_transport1'];
print(3,'-depsc2','-r150',printname)

%cold bias models
figure(4)
hold on
plot(barents_heat_south_geomar,'color',rgb('orange'),'linewidth',lw)
plot(barents_heat_south_noresm,'b','linewidth',lw)
plot(barents_heat_south_cnrm,'k','linewidth',lw)
plot(barents_heat_south_gold,'color',rgb('DarkCyan'),'linewidth',lw)
plot(barents_heat_south_cerfacs,'c','linewidth',lw)
plot(barents_heat_south_hycom*0.0,'k','linewidth',1)
ylim([-60 10])
ax=legend('GEOMAR','NorESM','CNRM','CERFACS','GOLD','location','southeast');
legend(ax,'boxoff')
ylabel('Westward heat transport [TW]')
xlabel('time [years]')
printname=['paperfigs/barents_westward_heat_transport2'];
print(4,'-depsc2','-r150',printname)


figure(5)
hold on
%warm bias models
plot(barents_heat_north_fesom+barents_heat_south_fesom,'b','linewidth',lw)
plot(barents_heat_north_ncar+barents_heat_south_ncar,'r','linewidth',lw)
plot(barents_heat_north_mom+barents_heat_south_mom,'g','linewidth',lw)
plot(barents_heat_north_mri_free+barents_heat_south_mri_free,'color',rgb('HotPink'),'linewidth',lw)
plot(241:300,barents_heat_north_mri_data+barents_heat_south_mri_data,'color',rgb('Black'),'linewidth',lw)
plot(barents_heat_north_hycom+barents_heat_south_hycom,'color',rgb('DarkViolet'),'linewidth',lw)
%plot(barents_heat_south_hycom*0.0,'k','linewidth',1)
ylim([-20 150])
ax=legend('FESOM','POP','MOM','MRI-FREE','MRI-DATA','HYCOM','location','northwest');
legend(ax,'boxoff')
ylabel('Total heat transport [TW]')
xlabel('time [years]')
printname=['paperfigs/barents_total_heat_transport1'];
print(5,'-depsc2','-r150',printname)

%cold bias models
figure(6)
hold on
plot(barents_heat_north_geomar+barents_heat_south_geomar,'color',rgb('orange'),'linewidth',lw)
plot(barents_heat_north_noresm+barents_heat_south_noresm,'b','linewidth',lw)
plot(barents_heat_north_cnrm+barents_heat_south_cnrm,'k','linewidth',lw)
plot(barents_heat_north_gold+barents_heat_south_gold,'color',rgb('DarkCyan'),'linewidth',lw)
plot(barents_heat_north_cerfacs+barents_heat_south_cerfacs,'c','linewidth',lw)
%plot(barents_heat_south_hycom*0.0,'k','linewidth',1)
ylim([-20 150])
ax=legend('GEOMAR','NorESM','CNRM','CERFACS','GOLD','location','northeast');
legend(ax,'boxoff')
ylabel('Total heat transport [TW]')
xlabel('time [years]')
printname=['paperfigs/barents_total_heat_transport2'];
print(6,'-depsc2','-r150',printname)

