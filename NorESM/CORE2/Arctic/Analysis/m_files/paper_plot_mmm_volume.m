clear all
load matfiles/fram_volume_transports.mat
lw=2; %linewidth
time=1948:2007;
coef1=59;

a1=fram_volume_north_ncar(end-coef1:end)+fram_volume_south_ncar(end-coef1:end);
a2=fram_volume_north_mom(end-coef1:end)+fram_volume_south_mom(end-coef1:end);
a3=fram_volume_north_mri_free(end-coef1:end)+fram_volume_south_mri_free(end-coef1:end);
a4=fram_volume_north_mri_data(end-coef1:end)+fram_volume_south_mri_data(end-coef1:end);
a5=fram_volume_north_hycom(end-coef1:end)+fram_volume_south_hycom(end-coef1:end);
a6=fram_volume_north_hycom2(end-coef1:end)+fram_volume_south_hycom2(end-coef1:end);
a7=fram_volume_north_noresm(end-coef1:end)+fram_volume_south_noresm(end-coef1:end);
a8=fram_volume_north_cnrm(end-coef1:end)+fram_volume_south_cnrm(end-coef1:end);
a9=fram_volume_north_gold(end-coef1:end)+fram_volume_south_gold(end-coef1:end);
a10=fram_volume_north_cerfacs(end-coef1:end)+fram_volume_south_cerfacs(end-coef1:end);
a11=fram_volume_north_fesom(end-coef1:end)+fram_volume_south_fesom(end-coef1:end);
a12=fram_volume_north_geomar(end-coef1:end)+fram_volume_south_geomar(end-coef1:end);
a13=fram_volume_north_cmcc(end-coef1:end)+fram_volume_south_cmcc(end-coef1:end);
a14=fram_volume_total_noc(end-coef1+2:end);
dnm(1:length(a14))=a14;
dnm(end+1)=a14(end);dnm(end+1)=a14(end);
a14=dnm;
a15=fram_volume_total_mom_0_25(268:327);

AL=[a1' a2' a3' a5' ...
   a6' a7' a8' a9' a10' ... 
   a11' a12' a13' a14' a15']; 
   
mmm_vol_fram=nanmean(AL,2);

load matfiles/barents_volume_transports.mat

a1=barents_volume_north_ncar(end-coef1:end)+barents_volume_south_ncar(end-coef1:end);
a2=barents_volume_north_mom(end-coef1:end)+barents_volume_south_mom(end-coef1:end);
a3=barents_volume_north_mri_free(end-coef1:end)+barents_volume_south_mri_free(end-coef1:end);
a4=barents_volume_north_mri_data(end-coef1:end)+barents_volume_south_mri_data(end-coef1:end);
a5=barents_volume_north_hycom(end-coef1:end)+barents_volume_south_hycom(end-coef1:end);
a6=barents_volume_north_hycom2(end-coef1:end)+barents_volume_south_hycom2(end-coef1:end);
a7=barents_volume_north_noresm(end-coef1:end)+barents_volume_south_noresm(end-coef1:end);
a8=barents_volume_north_cnrm(end-coef1:end)+barents_volume_south_cnrm(end-coef1:end);
a9=barents_volume_north_gold(end-coef1:end)+barents_volume_south_gold(end-coef1:end);
a10=barents_volume_north_cerfacs(end-coef1:end)+barents_volume_south_cerfacs(end-coef1:end);
a11=barents_volume_north_fesom(end-coef1:end)+barents_volume_south_fesom(end-coef1:end);
a12=barents_volume_north_geomar(end-coef1:end)+barents_volume_south_geomar(end-coef1:end);
a13=barents_volume_north_cmcc(end-coef1:end)+barents_volume_south_cmcc(end-coef1:end);
a14=barents_volume_total_noc(end-coef1+2:end);
clear dnm
dnm(1:length(a14))=a14;
dnm(end+1)=a14(end);dnm(end+1)=a14(end);
a14=dnm;
a15=barents_volume_total_mom_0_25(268:327);

AL=[a1' a2' a3' a5' ...
   a6' a7' a8' a9' a10' ... 
   a11' a12' a13' a14' a15']; 
   
mmm_vol_barents=nanmean(AL,2);

load matfiles/davis_volume_transports.mat

a1=davis_volume_north_ncar(end-coef1:end)+davis_volume_south_ncar(end-coef1:end);
a2=davis_volume_total_mom(end-coef1:end);
a3=davis_volume_north_mri_free(end-coef1:end)+davis_volume_south_mri_free(end-coef1:end);
a4=davis_volume_north_mri_data(end-coef1:end)+davis_volume_south_mri_data(end-coef1:end);
a5=davis_volume_north_hycom(end-coef1:end)+davis_volume_south_hycom(end-coef1:end);
a6=davis_volume_north_hycom2(end-coef1:end)+davis_volume_south_hycom2(end-coef1:end);
a7=davis_volume_north_noresm(end-coef1:end)+davis_volume_south_noresm(end-coef1:end);
a8=davis_volume_north_cnrm(end-coef1:end)+davis_volume_south_cnrm(end-coef1:end);
a9=davis_volume_total_gold(end-coef1:end);
a10=davis_volume_north_cerfacs(end-coef1:end)+davis_volume_south_cerfacs(end-coef1:end);
a11=davis_volume_north_fesom(end-coef1:end)+davis_volume_south_fesom(end-coef1:end);
a12=davis_volume_north_geomar(end-coef1:end)+davis_volume_south_geomar(end-coef1:end);
a13=davis_volume_north_cmcc(end-coef1:end)+davis_volume_south_cmcc(end-coef1:end);
a14=davis_volume_total_noc(end-coef1+2:end);
clear dnm
dnm(1:length(a14))=a14;
dnm(end+1)=a14(end);dnm(end+1)=a14(end);
a14=dnm;
a15=davis_volume_total_mom_0_25(268:327);

AL=[a1' a2' a3' a5' ...
   a6' a7' a8' a9' a10' ... 
   a11' a12' a13' a14' a15']; 
   
mmm_vol_davis=nanmean(AL,2);

load matfiles/bering_volume_transports.mat

a1=bering_volume_north_ncar(end-coef1:end)+bering_volume_south_ncar(end-coef1:end);
a2=bering_volume_total_mom(end-coef1:end);
a3=bering_volume_north_mri_free(end-coef1:end)+bering_volume_south_mri_free(end-coef1:end);
a4=bering_volume_north_mri_data(end-coef1:end)+bering_volume_south_mri_data(end-coef1:end);
a5=bering_volume_north_hycom(end-coef1:end)+bering_volume_south_hycom(end-coef1:end);
a6=bering_volume_north_hycom2(end-coef1:end)+bering_volume_south_hycom2(end-coef1:end);
a7=bering_volume_north_noresm(end-coef1:end)+bering_volume_south_noresm(end-coef1:end);
a8=bering_volume_north_cnrm(end-coef1:end)+bering_volume_south_cnrm(end-coef1:end);
a9=bering_volume_total_gold(end-coef1:end);
a10=bering_volume_north_cerfacs(end-coef1:end)+bering_volume_south_cerfacs(end-coef1:end);
a11=bering_volume_north_fesom(end-coef1:end)+bering_volume_south_fesom(end-coef1:end);
a12=bering_volume_north_geomar(end-coef1:end)+bering_volume_south_geomar(end-coef1:end);
a13=bering_volume_north_cmcc(end-coef1:end)+bering_volume_south_cmcc(end-coef1:end);
a14=bering_volume_total_noc(end-coef1+2:end);
clear dnm
dnm(1:length(a14))=a14;
dnm(end+1)=a14(end);dnm(end+1)=a14(end);
a14=dnm;
a15=bering_volume_total_mom_0_25(268:327);

AL=[a1' a2' a3' a5' ...
   a6' a7' a8' a9' a10' ... 
   a11' a12' a13' a14' a15']; 
   
mmm_vol_bering=nanmean(AL,2);

figure(1)
plot(time,mmm_vol_bering-mean(mmm_vol_bering),'k','linewidth',lw)
hold on
plot(time,mmm_vol_fram-mean(mmm_vol_fram),'b','linewidth',lw)
plot(time,mmm_vol_barents-mean(mmm_vol_barents),'r','linewidth',lw)
plot(time,mmm_vol_davis-mean(mmm_vol_davis),'g','linewidth',lw)
ax=legend('Bering','Fram','BSO','Davis','location','Eastoutside');
ylabel('MMM total volume transport [Sv]')
xlabel('time [years]')
set(gca,'Box','on')
set(gcf, 'units', 'centimeters', 'pos', [0 0 22.5 10])
set(gca, 'units', 'centimeters', 'pos', [2 1.2 15 8])
set(gcf, 'PaperPositionMode','auto')
plot(time,a15*0,'k')
xlim([1948 2007])
ylim([-1.5 1.5])
printname=['paperfigs2/mmm_total_volume_transport'];
print(1,'-depsc2','-r150',printname)





