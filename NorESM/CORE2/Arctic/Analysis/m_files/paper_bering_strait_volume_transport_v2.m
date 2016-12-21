clear all
load matfiles/bering_volume_transports.mat
lw=2; %linewidth
time=1948:2007;

load color_15

figure(5);
coef=1.0;
hold on
aa=(bering_volume_north_fesom(end-59:end)+bering_volume_south_fesom(end-59:end)) - ...
   coef.*mean((bering_volume_north_fesom(end-59:end)+bering_volume_south_fesom(end-59:end)));
k=2;
plot(time,aa,'color',[color(k,1) color(k,2) color(k,3)],'linewidth',lw)
aa=bering_volume_north_noresm(end-59:end)+bering_volume_south_noresm(end-59:end) - ...
   coef.*mean(bering_volume_north_noresm(end-59:end)+bering_volume_south_noresm(end-59:end));
k=14;
plot(time,aa,'color',[color(k,1) color(k,2) color(k,3)],'linewidth',lw)
aa=bering_volume_north_cerfacs(end-59:end)+bering_volume_south_cerfacs(end-59:end) - ...
   coef.*mean(bering_volume_north_cerfacs(end-59:end)+bering_volume_south_cerfacs(end-59:end));
k=5;
plot(time,aa,'color',[color(k,1) color(k,2) color(k,3)],'linewidth',lw)
%aa=bering_volume_total_cmcc(end-59:end) - coef.*mean(bering_volume_total_cmcc(end-59:end));
aa=bering_volume_north_cmcc(end-59:end)+bering_volume_south_cmcc(end-59:end) - ...
   coef.*mean(bering_volume_north_cmcc(end-59:end)+bering_volume_south_cmcc(end-59:end));
k=9;
plot(time,aa,'color',[color(k,1) color(k,2) color(k,3)],'linewidth',lw)
aa=bering_volume_north_cnrm(end-59:end)+bering_volume_south_cnrm(end-59:end) - ...
   coef.*mean(bering_volume_north_cnrm(end-59:end)+bering_volume_south_cnrm(end-59:end));
k=6;
plot(time,aa,'color',[color(k,1) color(k,2) color(k,3)],'linewidth',lw)
ylim([-0.5 0.5])
ax=legend('AWI-FESOM','Bergen','CERFACS','CMCC','CNRM','location','Eastoutside');
ylabel('Anomaly of total volume transport [Sv]')
xlabel('time [years]')
set(gca,'Box','on')
set(gcf, 'units', 'centimeters', 'pos', [0 0 22.5 10])
set(gca, 'units', 'centimeters', 'pos', [2 1.2 15 8])
set(gcf, 'PaperPositionMode','auto')
plot(time,aa*0,'k')
xlim([1948 2007])
printname=['paperfigs2/bering_total_volume_transportv1'];
print(5,'-depsc2','-r150',printname)

figure(6)
hold on
aa=bering_volume_north_hycom(end-59:end)+bering_volume_south_hycom(end-59:end) - ...
   coef.*mean(bering_volume_north_hycom(end-59:end)+bering_volume_south_hycom(end-59:end));
k=13;
plot(time,aa,'color',[color(k,1) color(k,2) color(k,3)],'linewidth',lw)
aa=bering_volume_north_hycom2(end-59:end)+bering_volume_south_hycom2(end-59:end) - ...
   coef.*mean(bering_volume_north_hycom2(end-59:end)+bering_volume_south_hycom2(end-59:end));
k=15;
plot(time,aa,'color',[color(k,1) color(k,2) color(k,3)],'linewidth',lw)
aa=bering_volume_total_gold(end-59:end) - ...
   coef.*mean(bering_volume_total_gold(end-59:end));
k=12;
plot(time,aa,'color',[color(k,1) color(k,2) color(k,3)],'linewidth',lw)
aa=bering_volume_total_mom(end-59:end) - ...
   coef.*mean(bering_volume_total_mom(end-59:end));
k=3;
plot(time,aa,'color',[color(k,1) color(k,2) color(k,3)],'linewidth',lw)
aa=bering_volume_north_geomar(end-59:end)+bering_volume_south_geomar(end-59:end) - ...
   coef.*mean(bering_volume_north_geomar(end-59:end)+bering_volume_south_geomar(end-59:end));
k=7;
plot(time,aa,'color',[color(k,1) color(k,2) color(k,3)],'linewidth',lw)
ylim([-0.5 0.5])
ax=legend('FSU-HYCOM','FSU-HYCOMv2','GFDL-GOLD','GFDL-MOM','Kiel-ORCA05','location','Eastoutside');
ylabel('Anomaly of total volume transport [Sv]')
xlabel('time [years]')
set(gca,'Box','on')
set(gcf, 'units', 'centimeters', 'pos', [0 0 22.5 10])
set(gca, 'units', 'centimeters', 'pos', [2 1.2 15 8])
set(gcf, 'PaperPositionMode','auto')
plot(time,aa*0,'k')
xlim([1948 2007])
printname=['paperfigs2/bering_total_volume_transportv2'];
print(6,'-depsc2','-r150',printname)

figure(7)
hold on
aa=bering_volume_total_mom_0_25(267:326)-coef.*mean(bering_volume_total_mom_0_25(267:326));
k=4;
plot(time,aa,'color',[color(k,1) color(k,2) color(k,3)],'linewidth',lw)
aa=bering_volume_north_mri_data+bering_volume_south_mri_data - ...
   coef.*mean(bering_volume_north_mri_data+bering_volume_south_mri_data);
k=11;
plot(time,aa,'color',[color(k,1) color(k,2) color(k,3)],'linewidth',lw)
aa=bering_volume_north_mri_free(end-59:end)+bering_volume_south_mri_free(end-59:end) - ...
   coef.*mean(bering_volume_north_mri_free(end-59:end)+bering_volume_south_mri_free(end-59:end));
k=10;
plot(time,aa,'color',[color(k,1) color(k,2) color(k,3)],'linewidth',lw)
aa=bering_volume_north_ncar(end-59:end)+bering_volume_south_ncar(end-59:end) - ...
   coef.*mean(bering_volume_north_ncar(end-59:end)+bering_volume_south_ncar(end-59:end));
k=1;
plot(time,aa,'color',[color(k,1) color(k,2) color(k,3)],'linewidth',lw)
aa=bering_volume_total_noc(end-57:end) - coef.*mean(bering_volume_total_noc(end-57:end));
k=8;
plot(time(1:end-2),aa,'color',[color(k,1) color(k,2) color(k,3)],'linewidth',lw)
ylim([-0.5 0.5])
ax=legend('MOM0.25','MRI-A','MRI-F','NCAR','NOC','location','Eastoutside');
ylabel('Anomaly of total volume transport [Sv]')
xlabel('time [years]')
set(gca,'Box','on')
set(gcf, 'units', 'centimeters', 'pos', [0 0 22.5 10])
set(gca, 'units', 'centimeters', 'pos', [2 1.2 15 8])
set(gcf, 'PaperPositionMode','auto')
aa=bering_volume_north_ncar(end-59:end)+bering_volume_south_ncar(end-59:end) - ...
   coef.*mean(bering_volume_north_ncar(end-59:end)+bering_volume_south_ncar(end-59:end));
plot(time,aa*0,'k')
xlim([1948 2007])
printname=['paperfigs2/bering_total_volume_transportv3'];
print(7,'-depsc2','-r150',printname)


coef=0;
a1=bering_volume_north_fesom(end-59:end)+bering_volume_south_fesom(end-59:end) - ...
   coef.*mean(bering_volume_north_fesom(end-59:end)+bering_volume_south_fesom(end-59:end));
a2=bering_volume_north_noresm(end-59:end)+bering_volume_south_noresm(end-59:end) - ...
   coef.*mean(bering_volume_north_noresm(end-59:end)+bering_volume_south_noresm(end-59:end));
a3=bering_volume_north_cerfacs(end-59:end)+bering_volume_south_cerfacs(end-59:end) - ...
   coef.*mean(bering_volume_north_cerfacs(end-59:end)+bering_volume_south_cerfacs(end-59:end));
a4=bering_volume_north_cmcc(end-59:end)+bering_volume_south_cmcc(end-59:end) - ...
   coef.*mean(bering_volume_north_cmcc(end-59:end)+bering_volume_south_cmcc(end-59:end));
a5=bering_volume_north_cnrm(end-59:end)+bering_volume_south_cnrm(end-59:end) - ...
   coef.*mean(bering_volume_north_cnrm(end-59:end)+bering_volume_south_cnrm(end-59:end));
a6=bering_volume_north_hycom(end-59:end)+bering_volume_south_hycom(end-59:end) - ...
   coef.*mean(bering_volume_north_hycom(end-59:end)+bering_volume_south_hycom(end-59:end));
a7=bering_volume_north_hycom2(end-59:end)+bering_volume_south_hycom2(end-59:end) - ...
   coef*mean(bering_volume_north_hycom2(end-59:end)+bering_volume_south_hycom2(end-59:end));
a8=bering_volume_total_gold(end-59:end) - ...
   coef.*mean(bering_volume_total_gold(end-59:end));
a9=bering_volume_total_mom(end-59:end) - ...
   coef.*mean(bering_volume_total_mom(end-59:end));
a10=bering_volume_north_geomar(end-59:end)+bering_volume_south_geomar(end-59:end) - ...
   coef.*mean(bering_volume_north_geomar(end-59:end)+bering_volume_south_geomar(end-59:end));
a11=bering_volume_total_mom_0_25(267:326)-coef.*mean(bering_volume_total_mom_0_25(267:326));
a12=bering_volume_north_mri_free(end-59:end)+bering_volume_south_mri_free(end-59:end) - ...
   coef.*mean(bering_volume_north_mri_free(end-59:end)+bering_volume_south_mri_free(end-59:end));
a13=bering_volume_north_mri_data+bering_volume_south_mri_data - ...
   coef.*mean(bering_volume_north_mri_data+bering_volume_south_mri_data);
a14=bering_volume_north_ncar(end-59:end)+bering_volume_south_ncar(end-59:end) - ...
   coef.*mean(bering_volume_north_ncar(end-59:end)+bering_volume_south_ncar(end-59:end));
a15=bering_volume_total_noc(end-57:end)-coef.*mean(bering_volume_total_noc(end-57:end));
a15(end+1)=a15(end);
a15(end+1)=a15(end);

aT=[a1;a2;a3;a4;a5;a6;a7;a8;a9;a10;a11;a12;a14;a15];
aTmean=nanmean(aT,1);
aTstd=nanstd(aT,1);

figure(1)
coef=1;
a1=bering_volume_north_fesom(end-59:end)+bering_volume_south_fesom(end-59:end) - ...
   coef.*mean(bering_volume_north_fesom(end-59:end)+bering_volume_south_fesom(end-59:end));
a2=bering_volume_north_noresm(end-59:end)+bering_volume_south_noresm(end-59:end) - ...
   coef.*mean(bering_volume_north_noresm(end-59:end)+bering_volume_south_noresm(end-59:end));
a3=bering_volume_north_cerfacs(end-59:end)+bering_volume_south_cerfacs(end-59:end) - ...
   coef.*mean(bering_volume_north_cerfacs(end-59:end)+bering_volume_south_cerfacs(end-59:end));
a4=bering_volume_north_cmcc(end-59:end)+bering_volume_south_cmcc(end-59:end) - ...
   coef.*mean(bering_volume_north_cmcc(end-59:end)+bering_volume_south_cmcc(end-59:end));
a5=bering_volume_north_cnrm(end-59:end)+bering_volume_south_cnrm(end-59:end) - ...
   coef.*mean(bering_volume_north_cnrm(end-59:end)+bering_volume_south_cnrm(end-59:end));
a6=bering_volume_north_hycom(end-59:end)+bering_volume_south_hycom(end-59:end) - ...
   coef.*mean(bering_volume_north_hycom(end-59:end)+bering_volume_south_hycom(end-59:end));
a7=bering_volume_north_hycom2(end-59:end)+bering_volume_south_hycom2(end-59:end) - ...
   coef*mean(bering_volume_north_hycom2(end-59:end)+bering_volume_south_hycom2(end-59:end));
a8=bering_volume_total_gold(end-59:end) - ...
   coef.*mean(bering_volume_total_gold(end-59:end));
a9=bering_volume_total_mom(end-59:end) - ...
   coef.*mean(bering_volume_total_mom(end-59:end));
a10=bering_volume_north_geomar(end-59:end)+bering_volume_south_geomar(end-59:end) - ...
   coef.*mean(bering_volume_north_geomar(end-59:end)+bering_volume_south_geomar(end-59:end));
a11=bering_volume_total_mom_0_25(267:326)-coef.*mean(bering_volume_total_mom_0_25(267:326));
a12=bering_volume_north_mri_free(end-59:end)+bering_volume_south_mri_free(end-59:end) - ...
   coef.*mean(bering_volume_north_mri_free(end-59:end)+bering_volume_south_mri_free(end-59:end));
a13=bering_volume_north_mri_data+bering_volume_south_mri_data - ...
   coef.*mean(bering_volume_north_mri_data+bering_volume_south_mri_data);
a14=bering_volume_north_ncar(end-59:end)+bering_volume_south_ncar(end-59:end) - ...
   coef.*mean(bering_volume_north_ncar(end-59:end)+bering_volume_south_ncar(end-59:end));
a15=bering_volume_total_noc(end-57:end)-coef.*mean(bering_volume_total_noc(end-57:end));

