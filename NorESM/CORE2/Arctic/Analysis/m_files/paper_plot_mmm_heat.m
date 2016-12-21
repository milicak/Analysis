clear all
load matfiles/fram_heat_transports.mat
lw=2; %linewidth
time=1948:2007;
coef1=59;

a1=fram_heat_north_ncar(end-coef1:end)+fram_heat_south_ncar(end-coef1:end);
a2=fram_heat_north_mom(end-coef1:end)+fram_heat_south_mom(end-coef1:end);
a3=fram_heat_north_mri_free(end-coef1:end)+fram_heat_south_mri_free(end-coef1:end);
a4=fram_heat_north_mri_data(end-coef1:end)+fram_heat_south_mri_data(end-coef1:end);
a5=fram_heat_north_hycom(end-coef1:end)+fram_heat_south_hycom(end-coef1:end);
a6=fram_heat_north_hycom2(end-coef1:end)+fram_heat_south_hycom2(end-coef1:end);
a7=fram_heat_north_noresm(end-coef1:end)+fram_heat_south_noresm(end-coef1:end);
a8=fram_heat_north_cnrm(end-coef1:end)+fram_heat_south_cnrm(end-coef1:end);
a9=fram_heat_north_gold(end-coef1:end)+fram_heat_south_gold(end-coef1:end);
a10=fram_heat_north_cerfacs(end-coef1:end)+fram_heat_south_cerfacs(end-coef1:end);
a11=fram_heat_north_fesom(end-coef1:end)+fram_heat_south_fesom(end-coef1:end);
a12=fram_heat_north_geomar(end-coef1:end)+fram_heat_south_geomar(end-coef1:end);
a13=fram_heat_total_cmcc(end-coef1:end);
a14=fram_heat_total_noc(end-coef1+2:end);
dnm(1:length(a14))=a14;
dnm(end+1)=a14(end);dnm(end+1)=a14(end);
a14=dnm;
a15=fram_heat_total_mom_0_25(268:327);

AL=[a1' a2' a3' a5' ...
   a6' a7' a8' a9' a10' ... 
   a11' a12' a13' a14' a15'];

mmm_heat_fram=nanmean(AL,2);

load matfiles/barents_heat_transports.mat

a1=barents_heat_north_ncar(end-coef1:end)+barents_heat_south_ncar(end-coef1:end);
a2=barents_heat_north_mom(end-coef1:end)+barents_heat_south_mom(end-coef1:end);
a3=barents_heat_north_mri_free(end-coef1:end)+barents_heat_south_mri_free(end-coef1:end);
a4=barents_heat_north_mri_data(end-coef1:end)+barents_heat_south_mri_data(end-coef1:end);
a5=barents_heat_north_hycom(end-coef1:end)+barents_heat_south_hycom(end-coef1:end);
a6=barents_heat_north_hycom2(end-coef1:end)+barents_heat_south_hycom2(end-coef1:end);
a7=barents_heat_north_noresm(end-coef1:end)+barents_heat_south_noresm(end-coef1:end);
a8=barents_heat_north_cnrm(end-coef1:end)+barents_heat_south_cnrm(end-coef1:end);
a9=barents_heat_north_gold(end-coef1:end)+barents_heat_south_gold(end-coef1:end);
a10=barents_heat_north_cerfacs(end-coef1:end)+barents_heat_south_cerfacs(end-coef1:end);
a11=barents_heat_north_fesom(end-coef1:end)+barents_heat_south_fesom(end-coef1:end);
a12=barents_heat_north_geomar(end-coef1:end)+barents_heat_south_geomar(end-coef1:end);
a13=barents_heat_total_cmcc(end-coef1:end);
a14=barents_heat_total_noc(end-coef1+2:end);
clear dnm
dnm(1:length(a14))=a14;
dnm(end+1)=a14(end);dnm(end+1)=a14(end);
a14=dnm;
a15=barents_heat_total_mom_0_25(268:327);

AL=[a1' a2' a3' a5' ...
   a6' a7' a8' a9' a10' ... 
   a11' a12' a13' a14' a15'];

mmm_heat_barents=nanmean(AL,2);

load matfiles/davis_heat_transports.mat

a1=davis_heat_north_ncar(end-coef1:end)+davis_heat_south_ncar(end-coef1:end);
a2=davis_heat_total_mom(end-coef1:end);
a3=davis_heat_north_mri_free(end-coef1:end)+davis_heat_south_mri_free(end-coef1:end);
a4=davis_heat_north_mri_data(end-coef1:end)+davis_heat_south_mri_data(end-coef1:end);
a5=davis_heat_north_hycom(end-coef1:end)+davis_heat_south_hycom(end-coef1:end);
a6=davis_heat_north_hycom2(end-coef1:end)+davis_heat_south_hycom2(end-coef1:end);
a7=davis_heat_north_noresm(end-coef1:end)+davis_heat_south_noresm(end-coef1:end);
a8=davis_heat_north_cnrm(end-coef1:end)+davis_heat_south_cnrm(end-coef1:end);
a9=davis_heat_total_gold(end-coef1:end);
a10=davis_heat_north_cerfacs(end-coef1:end)+davis_heat_south_cerfacs(end-coef1:end);
a11=davis_heat_north_fesom(end-coef1:end)+davis_heat_south_fesom(end-coef1:end);
a12=davis_heat_north_geomar(end-coef1:end)+davis_heat_south_geomar(end-coef1:end);
a13=davis_heat_total_cmcc(end-coef1:end);
a14=davis_heat_total_noc(end-coef1+2:end);
clear dnm
dnm(1:length(a14))=a14;
dnm(end+1)=a14(end);dnm(end+1)=a14(end);
a14=dnm;
a15=davis_heat_total_mom_0_25(268:327);

AL=[a1' a2' a3' a5' ...
   a6' a7' a8' a9' a10' ... 
   a11' a12' a13' a14' a15'];

mmm_heat_davis=nanmean(AL,2);

load matfiles/bering_heat_transports.mat

a1=bering_heat_north_ncar(end-coef1:end)+bering_heat_south_ncar(end-coef1:end);
a2=bering_heat_total_mom(end-coef1:end);
a3=bering_heat_north_mri_free(end-coef1:end)+bering_heat_south_mri_free(end-coef1:end);
a4=bering_heat_north_mri_data(end-coef1:end)+bering_heat_south_mri_data(end-coef1:end);
a5=bering_heat_north_hycom(end-coef1:end)+bering_heat_south_hycom(end-coef1:end);
a6=bering_heat_north_hycom2(end-coef1:end)+bering_heat_south_hycom2(end-coef1:end);
a7=bering_heat_north_noresm(end-coef1:end)+bering_heat_south_noresm(end-coef1:end);
a8=bering_heat_north_cnrm(end-coef1:end)+bering_heat_south_cnrm(end-coef1:end);
a9=bering_heat_total_gold(end-coef1:end);
a10=bering_heat_north_cerfacs(end-coef1:end)+bering_heat_south_cerfacs(end-coef1:end);
a11=bering_heat_north_fesom(end-coef1:end)+bering_heat_south_fesom(end-coef1:end);
a12=bering_heat_north_geomar(end-coef1:end)+bering_heat_south_geomar(end-coef1:end);
a13=bering_heat_total_cmcc(end-coef1:end);
a14=bering_heat_total_noc(end-coef1+2:end);
clear dnm
dnm(1:length(a14))=a14;
dnm(end+1)=a14(end);dnm(end+1)=a14(end);
a14=dnm;
a15=bering_heat_total_mom_0_25(268:327);

AL=[a1' a2' a3' a5' ...
   a6' a7' a8' a9' a10' ... 
   a11' a12' a13' a14' a15'];

mmm_heat_bering=nanmean(AL,2);

figure(1)
plot(time,mmm_heat_bering-mean(mmm_heat_bering),'k','linewidth',lw)
hold on
plot(time,mmm_heat_fram-mean(mmm_heat_fram),'b','linewidth',lw)
plot(time,mmm_heat_barents-mean(mmm_heat_barents),'r','linewidth',lw)
plot(time,mmm_heat_davis-mean(mmm_heat_davis),'g','linewidth',lw)
ax=legend('Bering','Fram','BSO','Davis','location','Eastoutside');
ylabel('MMM total heat transport [TW]')
xlabel('time [years]')
set(gca,'Box','on')
set(gcf, 'units', 'centimeters', 'pos', [0 0 22.5 10])
set(gca, 'units', 'centimeters', 'pos', [2 1.2 15 8])
set(gcf, 'PaperPositionMode','auto')
plot(time,a15*0,'k')
xlim([1948 2007])
printname=['paperfigs2/mmm_total_heat_transport'];
print(1,'-depsc2','-r150',printname)

