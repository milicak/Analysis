clear all
load matfiles/fram_volume_transports.mat
lw=2; %linewidth
time=1948:2007;

load color_15

figure(5);
coef=1.0;
hold on
aa=(fram_volume_north_fesom(end-59:end)+fram_volume_south_fesom(end-59:end)) - ...
   coef.*mean((fram_volume_north_fesom(end-59:end)+fram_volume_south_fesom(end-59:end)));
k=2;
plot(time,aa,'color',[color(k,1) color(k,2) color(k,3)],'linewidth',lw)
aa=fram_volume_north_noresm(end-59:end)+fram_volume_south_noresm(end-59:end) - ...
   coef.*mean(fram_volume_north_noresm(end-59:end)+fram_volume_south_noresm(end-59:end));
k=14;
plot(time,aa,'color',[color(k,1) color(k,2) color(k,3)],'linewidth',lw)
aa=fram_volume_north_cerfacs(end-59:end)+fram_volume_south_cerfacs(end-59:end) - ...
   coef.*mean(fram_volume_north_cerfacs(end-59:end)+fram_volume_south_cerfacs(end-59:end));
k=5;
plot(time,aa,'color',[color(k,1) color(k,2) color(k,3)],'linewidth',lw)
%aa=fram_volume_total_cmcc(end-59:end) - coef.*mean(fram_volume_total_cmcc(end-59:end));
aa=fram_volume_north_cmcc(end-59:end)+fram_volume_south_cmcc(end-59:end) - ...
   coef.*mean(fram_volume_north_cmcc(end-59:end)+fram_volume_south_cmcc(end-59:end));
k=9;
plot(time,aa,'color',[color(k,1) color(k,2) color(k,3)],'linewidth',lw)
aa=fram_volume_north_cnrm(end-59:end)+fram_volume_south_cnrm(end-59:end) - ...
   coef.*mean(fram_volume_north_cnrm(end-59:end)+fram_volume_south_cnrm(end-59:end));
k=6;
plot(time,aa,'color',[color(k,1) color(k,2) color(k,3)],'linewidth',lw)
ylim([-2 2])
ax=legend('AWI-FESOM','Bergen','CERFACS','CMCC','CNRM','location','Eastoutside');
ylabel('Anomaly of total volume transport [Sv]')
xlabel('time [years]')
set(gca,'Box','on')
set(gcf, 'units', 'centimeters', 'pos', [0 0 22.5 10])
set(gca, 'units', 'centimeters', 'pos', [2 1.2 15 8])
set(gcf, 'PaperPositionMode','auto')
plot(time,aa*0,'k')
xlim([1948 2007])
printname=['paperfigs2/fram_total_volume_transportv1'];
print(5,'-depsc2','-r150',printname)

figure(6)
hold on
aa=fram_volume_north_hycom(end-59:end)+fram_volume_south_hycom(end-59:end) - ...
   coef.*mean(fram_volume_north_hycom(end-59:end)+fram_volume_south_hycom(end-59:end));
k=13;
plot(time,aa,'color',[color(k,1) color(k,2) color(k,3)],'linewidth',lw)
aa=fram_volume_north_hycom2(end-59:end)+fram_volume_south_hycom2(end-59:end) - ...
   coef.*mean(fram_volume_north_hycom2(end-59:end)+fram_volume_south_hycom2(end-59:end));
k=15;
plot(time,aa,'color',[color(k,1) color(k,2) color(k,3)],'linewidth',lw)
aa=fram_volume_north_gold(end-59:end)+fram_volume_south_gold(end-59:end) - ...
   coef.*mean(fram_volume_north_gold(end-59:end)+fram_volume_south_gold(end-59:end));
k=12;
plot(time,aa,'color',[color(k,1) color(k,2) color(k,3)],'linewidth',lw)
aa=fram_volume_north_mom(end-59:end)+fram_volume_south_mom(end-59:end) - ...
   coef.*mean(fram_volume_north_mom(end-59:end)+fram_volume_south_mom(end-59:end));
k=3;
plot(time,aa,'color',[color(k,1) color(k,2) color(k,3)],'linewidth',lw)
aa=fram_volume_north_geomar(end-59:end)+fram_volume_south_geomar(end-59:end) - ...
   coef.*mean(fram_volume_north_geomar(end-59:end)+fram_volume_south_geomar(end-59:end));
k=7;
plot(time,aa,'color',[color(k,1) color(k,2) color(k,3)],'linewidth',lw)
ylim([-2 2])
ax=legend('FSU-HYCOM','FSU-HYCOMv2','GFDL-GOLD','GFDL-MOM','Kiel-ORCA05','location','Eastoutside');
ylabel('Anomaly of total volume transport [Sv]')
xlabel('time [years]')
set(gca,'Box','on')
set(gcf, 'units', 'centimeters', 'pos', [0 0 22.5 10])
set(gca, 'units', 'centimeters', 'pos', [2 1.2 15 8])
set(gcf, 'PaperPositionMode','auto')
plot(time,aa*0,'k')
xlim([1948 2007])
printname=['paperfigs2/fram_total_volume_transportv2'];
print(6,'-depsc2','-r150',printname)

figure(7)
hold on
aa=fram_volume_total_mom_0_25(267:326)-coef.*mean(fram_volume_total_mom_0_25(267:326));
k=4;
plot(time,aa,'color',[color(k,1) color(k,2) color(k,3)],'linewidth',lw)
aa=fram_volume_north_mri_data+fram_volume_south_mri_data - ...
   coef.*mean(fram_volume_north_mri_data+fram_volume_south_mri_data);
k=11;
plot(time,aa,'color',[color(k,1) color(k,2) color(k,3)],'linewidth',lw)
aa=fram_volume_north_mri_free(end-59:end)+fram_volume_south_mri_free(end-59:end) - ...
   coef.*mean(fram_volume_north_mri_free(end-59:end)+fram_volume_south_mri_free(end-59:end));
k=10;
plot(time,aa,'color',[color(k,1) color(k,2) color(k,3)],'linewidth',lw)
aa=fram_volume_north_ncar(end-59:end)+fram_volume_south_ncar(end-59:end) - ...
   coef.*mean(fram_volume_north_ncar(end-59:end)+fram_volume_south_ncar(end-59:end));
k=1;
plot(time,aa,'color',[color(k,1) color(k,2) color(k,3)],'linewidth',lw)
aa=fram_volume_total_noc(end-57:end) - coef.*mean(fram_volume_total_noc(end-57:end));
k=8;
plot(time(1:end-2),aa,'color',[color(k,1) color(k,2) color(k,3)],'linewidth',lw)
ylim([-2 2])
ax=legend('MOM0.25','MRI-A','MRI-F','NCAR','NOC','location','Eastoutside');
ylabel('Anomaly of total volume transport [Sv]')
xlabel('time [years]')
set(gca,'Box','on')
set(gcf, 'units', 'centimeters', 'pos', [0 0 22.5 10])
set(gca, 'units', 'centimeters', 'pos', [2 1.2 15 8])
set(gcf, 'PaperPositionMode','auto')
aa=fram_volume_north_ncar(end-59:end)+fram_volume_south_ncar(end-59:end) - ...
   coef.*mean(fram_volume_north_ncar(end-59:end)+fram_volume_south_ncar(end-59:end));
plot(time,aa*0,'k')
xlim([1948 2007])
printname=['paperfigs2/fram_total_volume_transportv3'];
print(7,'-depsc2','-r150',printname)
break







coef=0;
a1=fram_volume_north_fesom(end-59:end)+fram_volume_south_fesom(end-59:end) - ...
   coef.*mean(fram_volume_north_fesom(end-59:end)+fram_volume_south_fesom(end-59:end));
a2=fram_volume_north_noresm(end-59:end)+fram_volume_south_noresm(end-59:end) - ...
   coef.*mean(fram_volume_north_noresm(end-59:end)+fram_volume_south_noresm(end-59:end));
a3=fram_volume_north_cerfacs(end-59:end)+fram_volume_south_cerfacs(end-59:end) - ...
   coef.*mean(fram_volume_north_cerfacs(end-59:end)+fram_volume_south_cerfacs(end-59:end));
a4=fram_volume_north_cmcc(end-59:end)+fram_volume_south_cmcc(end-59:end) - ...
   coef.*mean(fram_volume_north_cmcc(end-59:end)+fram_volume_south_cmcc(end-59:end));
a5=fram_volume_north_cnrm(end-59:end)+fram_volume_south_cnrm(end-59:end) - ...
   coef.*mean(fram_volume_north_cnrm(end-59:end)+fram_volume_south_cnrm(end-59:end));
a6=fram_volume_north_hycom(end-59:end)+fram_volume_south_hycom(end-59:end) - ...
   coef.*mean(fram_volume_north_hycom(end-59:end)+fram_volume_south_hycom(end-59:end));
a7=fram_volume_north_hycom2(end-59:end)+fram_volume_south_hycom2(end-59:end) - ...
   coef*mean(fram_volume_north_hycom2(end-59:end)+fram_volume_south_hycom2(end-59:end));
a8=fram_volume_north_gold(end-59:end)+fram_volume_south_gold(end-59:end) - ...
   coef.*mean(fram_volume_north_gold(end-59:end)+fram_volume_south_gold(end-59:end));
a9=fram_volume_north_mom(end-59:end)+fram_volume_south_mom(end-59:end) - ...
   coef.*mean(fram_volume_north_mom(end-59:end)+fram_volume_south_mom(end-59:end));
a10=fram_volume_north_geomar(end-59:end)+fram_volume_south_geomar(end-59:end) - ...
   coef.*mean(fram_volume_north_geomar(end-59:end)+fram_volume_south_geomar(end-59:end));
a11=fram_volume_total_mom_0_25(267:326)-coef.*mean(fram_volume_total_mom_0_25(267:326));
a12=fram_volume_north_mri_free(end-59:end)+fram_volume_south_mri_free(end-59:end) - ...
   coef.*mean(fram_volume_north_mri_free(end-59:end)+fram_volume_south_mri_free(end-59:end));
a13=fram_volume_north_mri_data+fram_volume_south_mri_data - ...
   coef.*mean(fram_volume_north_mri_data+fram_volume_south_mri_data);
a14=fram_volume_north_ncar(end-59:end)+fram_volume_south_ncar(end-59:end) - ...
   coef.*mean(fram_volume_north_ncar(end-59:end)+fram_volume_south_ncar(end-59:end));
a15=fram_volume_total_noc(end-57:end)-coef.*mean(fram_volume_total_noc(end-57:end));
a15(end+1)=a15(end);
a15(end+1)=a15(end);

aT=[a1;a2;a3;a4;a5;a6;a7;a8;a9;a10;a11;a12;a14;a15];
aTmean=nanmean(aT,1);
aTstd=nanstd(aT,1);

figure(1)
coef=1;
a1=fram_volume_north_fesom(end-59:end)+fram_volume_south_fesom(end-59:end) - ...
   coef.*mean(fram_volume_north_fesom(end-59:end)+fram_volume_south_fesom(end-59:end));
a2=fram_volume_north_noresm(end-59:end)+fram_volume_south_noresm(end-59:end) - ...
   coef.*mean(fram_volume_north_noresm(end-59:end)+fram_volume_south_noresm(end-59:end));
a3=fram_volume_north_cerfacs(end-59:end)+fram_volume_south_cerfacs(end-59:end) - ...
   coef.*mean(fram_volume_north_cerfacs(end-59:end)+fram_volume_south_cerfacs(end-59:end));
a4=fram_volume_north_cmcc(end-59:end)+fram_volume_south_cmcc(end-59:end) - ...
   coef.*mean(fram_volume_north_cmcc(end-59:end)+fram_volume_south_cmcc(end-59:end));
a5=fram_volume_north_cnrm(end-59:end)+fram_volume_south_cnrm(end-59:end) - ...
   coef.*mean(fram_volume_north_cnrm(end-59:end)+fram_volume_south_cnrm(end-59:end));
a6=fram_volume_north_hycom(end-59:end)+fram_volume_south_hycom(end-59:end) - ...
   coef.*mean(fram_volume_north_hycom(end-59:end)+fram_volume_south_hycom(end-59:end));
a7=fram_volume_north_hycom2(end-59:end)+fram_volume_south_hycom2(end-59:end) - ...
   coef*mean(fram_volume_north_hycom2(end-59:end)+fram_volume_south_hycom2(end-59:end));
a8=fram_volume_north_gold(end-59:end)+fram_volume_south_gold(end-59:end) - ...
   coef.*mean(fram_volume_north_gold(end-59:end)+fram_volume_south_gold(end-59:end));
a9=fram_volume_north_mom(end-59:end)+fram_volume_south_mom(end-59:end) - ...
   coef.*mean(fram_volume_north_mom(end-59:end)+fram_volume_south_mom(end-59:end));
a10=fram_volume_north_geomar(end-59:end)+fram_volume_south_geomar(end-59:end) - ...
   coef.*mean(fram_volume_north_geomar(end-59:end)+fram_volume_south_geomar(end-59:end));
a11=fram_volume_total_mom_0_25(267:326)-coef.*mean(fram_volume_total_mom_0_25(267:326));
a12=fram_volume_north_mri_free(end-59:end)+fram_volume_south_mri_free(end-59:end) - ...
   coef.*mean(fram_volume_north_mri_free(end-59:end)+fram_volume_south_mri_free(end-59:end));
a13=fram_volume_north_mri_data+fram_volume_south_mri_data - ...
   coef.*mean(fram_volume_north_mri_data+fram_volume_south_mri_data);
a14=fram_volume_north_ncar(end-59:end)+fram_volume_south_ncar(end-59:end) - ...
   coef.*mean(fram_volume_north_ncar(end-59:end)+fram_volume_south_ncar(end-59:end));
a15=fram_volume_total_noc(end-57:end)-coef.*mean(fram_volume_total_noc(end-57:end));

figure(1)
ax=legend('NCAR','GFDL-MOM','MRI-F','MRI-A','FSU-HYCOM','FSU-HYCOMv2','location','Eastoutside');
ylabel('Volume transport [Sv]')
xlabel('time [years]')
if coef~=1
else
  ylim([-4 4])
end
set(gca,'Box','on')
set(gcf, 'units', 'centimeters', 'pos', [0 0 22.5 10])
set(gcf, 'PaperPositionMode','auto')
printname=['paperfigs2/fram_total_volume_transportv1'];
print(1,'-depsc2','-r150',printname)

break


figure(1);
hold on
%warm bias models
plot(time,fram_volume_north_fesom(end-59:end),'b','linewidth',lw)
plot(time,fram_volume_north_ncar(end-59:end),'r','linewidth',lw)
plot(time,fram_volume_north_mom(end-59:end),'g','linewidth',lw)
plot(time,fram_volume_north_mri_free(end-59:end),'color',rgb('HotPink'),'linewidth',lw)
plot(time,fram_volume_north_mri_data,'color',rgb('Black'),'linewidth',lw)
plot(time,fram_volume_north_hycom(end-59:end),'color',rgb('DarkViolet'),'linewidth',lw)
plot(time,fram_volume_north_hycom2(end-59:end),'color',rgb('DarkGray'),'linewidth',lw)
ax=legend('AWI-FESOM','NCAR','GFDL-MOM','MRI-F','MRI-A','FSU-HYCOM','FSU-HYCOMv2','location','Eastoutside');
ylabel('Northward volume transport [Sv]')
xlabel('time [years]')
set(gca,'Box','on')
set(gcf, 'units', 'centimeters', 'pos', [0 0 22.5 10])
set(gcf, 'PaperPositionMode','auto')
printname=['paperfigs2/fram_northward_volume_transportv1'];
print(1,'-depsc2','-r150',printname)


figure(2);
hold on
plot(time,fram_volume_north_geomar(end-59:end),'color',rgb('orange'),'linewidth',lw)
plot(time,fram_volume_north_noresm(end-59:end),'b','linewidth',lw)
plot(time,fram_volume_north_cnrm(end-59:end),'k','linewidth',lw)
plot(time,fram_volume_north_gold(end-59:end),'color',rgb('DarkCyan'),'linewidth',lw)
plot(time,fram_volume_north_cerfacs(end-59:end),'c','linewidth',lw)
%plot(fram_volume_south_hycom*0.0,'k','linewidth',1)
ax=legend('Kiel-ORCA05','BERGEN','CNRM','GFDL-GOLD','CERFACS','location','Eastoutside');
ylabel('Northward volume transport [Sv]')
xlabel('time [years]')
set(gca,'Box','on')
set(gcf, 'units', 'centimeters', 'pos', [0 0 22.5 10])
set(gcf, 'PaperPositionMode','auto')
printname=['paperfigs2/fram_northward_volume_transportv2'];
print(2,'-depsc2','-r150',printname)

figure(3);
hold on
%warm bias models
plot(time,fram_volume_south_fesom(end-59:end),'b','linewidth',lw)
plot(time,fram_volume_south_ncar(end-59:end),'r','linewidth',lw)
plot(time,fram_volume_south_mom(end-59:end),'g','linewidth',lw)
plot(time,fram_volume_south_mri_free(end-59:end),'color',rgb('HotPink'),'linewidth',lw)
plot(time,fram_volume_south_mri_data,'color',rgb('Black'),'linewidth',lw)
plot(time,fram_volume_south_hycom(end-59:end),'color',rgb('DarkViolet'),'linewidth',lw)
plot(time,fram_volume_south_hycom2(end-59:end),'color',rgb('DarkGray'),'linewidth',lw)
ax=legend('AWI-FESOM','NCAR','GFDL-MOM','MRI-F','MRI-A','FSU-HYCOM','FSU-HYCOMv2','location','Eastoutside');
ylabel('Southward volume transport [Sv]')
xlabel('time [years]')
set(gca,'Box','on')
set(gcf, 'units', 'centimeters', 'pos', [0 0 22.5 10])
set(gcf, 'PaperPositionMode','auto')
printname=['paperfigs2/fram_southward_volume_transportv1'];
print(3,'-depsc2','-r150',printname)


figure(4);
hold on
plot(time,fram_volume_south_geomar(end-59:end),'color',rgb('orange'),'linewidth',lw)
plot(time,fram_volume_south_noresm(end-59:end),'b','linewidth',lw)
plot(time,fram_volume_south_cnrm(end-59:end),'k','linewidth',lw)
plot(time,fram_volume_south_gold(end-59:end),'color',rgb('DarkCyan'),'linewidth',lw)
plot(time,fram_volume_south_cerfacs(end-59:end),'c','linewidth',lw)
%plot(fram_volume_south_hycom*0.0,'k','linewidth',1)
ax=legend('Kiel-ORCA05','BERGEN','CNRM','GFDL-GOLD','CERFACS','location','Eastoutside');
ylabel('Southward volume transport [Sv]')
xlabel('time [years]')
set(gca,'Box','on')
set(gcf, 'units', 'centimeters', 'pos', [0 0 22.5 10])
set(gcf, 'PaperPositionMode','auto')
printname=['paperfigs2/fram_southward_volume_transportv2'];
print(4,'-depsc2','-r150',printname)

figure(5);
hold on
coef=1.0;
%warm bias models
aa=fram_volume_north_ncar(end-59:end)+fram_volume_south_ncar(end-59:end) - ...
   coef.*mean(fram_volume_north_ncar(end-59:end)+fram_volume_south_ncar(end-59:end));
plot(time,aa,'r','linewidth',lw)
aa=fram_volume_north_mom(end-59:end)+fram_volume_south_mom(end-59:end) - ...
   coef.*mean(fram_volume_north_mom(end-59:end)+fram_volume_south_mom(end-59:end));
plot(time,aa,'g','linewidth',lw)
aa=fram_volume_north_mri_free(end-59:end)+fram_volume_south_mri_free(end-59:end) - ...
   coef.*mean(fram_volume_north_mri_free(end-59:end)+fram_volume_south_mri_free(end-59:end));
plot(time,aa,'color',rgb('HotPink'),'linewidth',lw)
aa=fram_volume_north_mri_data+fram_volume_south_mri_data - ...
   coef.*mean(fram_volume_north_mri_data+fram_volume_south_mri_data);
plot(time,aa,'color',rgb('Black'),'linewidth',lw)
aa=fram_volume_north_hycom(end-59:end)+fram_volume_south_hycom(end-59:end) - ...
   coef.*mean(fram_volume_north_hycom(end-59:end)+fram_volume_south_hycom(end-59:end));
plot(time,aa,'color',rgb('DarkViolet'),'linewidth',lw)
aa=fram_volume_north_hycom2(end-59:end)+fram_volume_south_hycom2(end-59:end) - ...
   coef*mean(fram_volume_north_hycom2(end-59:end)+fram_volume_south_hycom2(end-59:end));
plot(time,aa,'color',rgb('DarkGray'),'linewidth',lw)
ax=legend('NCAR','GFDL-MOM','MRI-F','MRI-A','FSU-HYCOM','FSU-HYCOMv2','location','Eastoutside');
ylabel('Total volume transport [Sv]')
xlabel('time [years]')
if coef~=1
else
  ylim([-2 2])
end
set(gca,'Box','on')
set(gcf, 'units', 'centimeters', 'pos', [0 0 22.5 10])
set(gcf, 'PaperPositionMode','auto')
printname=['paperfigs2/fram_total_volume_transportv1'];
print(5,'-depsc2','-r150',printname)


figure(6);
hold on
aa=fram_volume_north_noresm(end-59:end)+fram_volume_south_noresm(end-59:end) - ...
   coef.*mean(fram_volume_north_noresm(end-59:end)+fram_volume_south_noresm(end-59:end));
plot(time,aa,'b','linewidth',lw)
aa=fram_volume_north_cnrm(end-59:end)+fram_volume_south_cnrm(end-59:end) - ...
   coef.*mean(fram_volume_north_cnrm(end-59:end)+fram_volume_south_cnrm(end-59:end));
plot(time,aa,'k','linewidth',lw)
aa=fram_volume_north_gold(end-59:end)+fram_volume_south_gold(end-59:end) - ...
   coef.*mean(fram_volume_north_gold(end-59:end)+fram_volume_south_gold(end-59:end));
plot(time,aa,'color',rgb('DarkCyan'),'linewidth',lw)
aa=fram_volume_north_cerfacs(end-59:end)+fram_volume_south_cerfacs(end-59:end) - ...
   coef.*mean(fram_volume_north_cerfacs(end-59:end)+fram_volume_south_cerfacs(end-59:end));
plot(time,aa,'c','linewidth',lw)
%plot(fram_volume_south_hycom*0.0,'k','linewidth',1)
ax=legend('BERGEN','CNRM','GFDL-GOLD','CERFACS','location','Eastoutside');
ylabel('Total volume transport [Sv]')
xlabel('time [years]')
if coef~=1
else
  ylim([-2 2])
end
set(gca,'Box','on')
set(gcf, 'units', 'centimeters', 'pos', [0 0 22.5 10])
set(gcf, 'PaperPositionMode','auto')
printname=['paperfigs2/fram_total_volume_transportv2'];
print(6,'-depsc2','-r150',printname)

figure(7)
hold on
%warm bias models
aa=fram_volume_north_fesom(end-59:end)+fram_volume_south_fesom(end-59:end) - ...
   coef.*mean(fram_volume_north_fesom(end-59:end)+fram_volume_south_fesom(end-59:end));
plot(time,aa,'b','linewidth',lw)
aa=fram_volume_north_geomar(end-59:end)+fram_volume_south_geomar(end-59:end) - ...
   coef.*mean(fram_volume_north_geomar(end-59:end)+fram_volume_south_geomar(end-59:end));
plot(time,aa,'color',rgb('orange'),'linewidth',lw)
aa=fram_volume_north_cmcc(end-59:end)+fram_volume_south_cmcc(end-59:end) - ...
   coef.*mean(fram_volume_north_cmcc(end-59:end)+fram_volume_south_cmcc(end-59:end));
plot(time,aa,'k','linewidth',lw)
aa=fram_volume_total_noc(end-57:end)-coef.*mean(fram_volume_total_noc(end-57:end));
plot(time(1:end-2),aa,'r','linewidth',lw)
%aa=fram_volume_total_mom_0_25(end-59:end)-coef.*mean(fram_volume_total_mom_0_25(end-59:end));
%aa=fram_volume_total_mom_0_25(end-59-33:end-33)-coef.*mean(fram_volume_total_mom_0_25(end-59-33:end-33));
aa=fram_volume_total_mom_0_25(267:326)-coef.*mean(fram_volume_total_mom_0_25(267:326));
plot(time,aa,'g','linewidth',lw)
ax=legend('AWI-FESOM','Kiel-ORCA05','CMCC-ORCA','NOC-ORCA','MOM-0.25','location','Eastoutside');
ylabel('Total volume transport [Sv]')
xlabel('time [years]')
if coef~=1
else
  ylim([-2 2])
end
set(gca,'Box','on')
set(gcf, 'units', 'centimeters', 'pos', [0 0 22.5 10])
set(gcf, 'PaperPositionMode','auto')
printname=['paperfigs2/fram_total_volume_transportv3'];
print(7,'-depsc2','-r150',printname)


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

mean(fram_volume_north_ncar(end-59:end)+fram_volume_south_ncar(end-59:end))

mean(fram_volume_north_mom(end-59:end)+fram_volume_south_mom(end-59:end))

mean(fram_volume_north_mri_free(end-59:end)+fram_volume_south_mri_free(end-59:end))

mean(fram_volume_north_mri_data+fram_volume_south_mri_data)

mean(fram_volume_north_hycom(end-59:end)+fram_volume_south_hycom(end-59:end))

mean(fram_volume_north_hycom2(end-59:end)+fram_volume_south_hycom2(end-59:end))

mean(fram_volume_north_noresm(end-59:end)+fram_volume_south_noresm(end-59:end))

mean(fram_volume_north_cnrm(end-59:end)+fram_volume_south_cnrm(end-59:end))

mean(fram_volume_north_gold(end-59:end)+fram_volume_south_gold(end-59:end))

mean(fram_volume_north_cerfacs(end-59:end)+fram_volume_south_cerfacs(end-59:end))

mean(fram_volume_north_fesom(end-59:end)+fram_volume_south_fesom(end-59:end))

mean(fram_volume_north_geomar(end-59:end)+fram_volume_south_geomar(end-59:end))

mean(fram_volume_total_cmcc(end-59:end))

mean(fram_volume_total_noc(end-57:end))

mean(fram_volume_total_mom_0_25(end-59-33:end-33))
	
