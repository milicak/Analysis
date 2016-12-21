clear all

%Geomar [TW]
volume_north1=ncgetvar('/bcmhsm/milicak/RUNS/noresm/CORE2/Arctic/DATA/geomar/ORCA05-K3178_1m_19480101_20071231_DAVIS_transports.nc','transnorth');
volume_south1=ncgetvar('/bcmhsm/milicak/RUNS/noresm/CORE2/Arctic/DATA/geomar/ORCA05-K3178_1m_19480101_20071231_DAVIS_transports.nc','transsouth');
volume_north1(end+1:720*2)=ncgetvar('/bcmhsm/milicak/RUNS/noresm/CORE2/Arctic/DATA/geomar/ORCA05-K3181_1m_19480101_20071231_DAVIS_transports.nc','TRANSNORTH');
volume_south1(end+1:720*2)=ncgetvar('/bcmhsm/milicak/RUNS/noresm/CORE2/Arctic/DATA/geomar/ORCA05-K3181_1m_19480101_20071231_DAVIS_transports.nc','TRANSSOUTH');
volume_north1(end+1:720*3)=ncgetvar('/bcmhsm/milicak/RUNS/noresm/CORE2/Arctic/DATA/geomar/ORCA05-K3183_1m_19480101_20071231_DAVIS_transports.nc','TRANSNORTH');
volume_south1(end+1:720*3)=ncgetvar('/bcmhsm/milicak/RUNS/noresm/CORE2/Arctic/DATA/geomar/ORCA05-K3183_1m_19480101_20071231_DAVIS_transports.nc','TRANSSOUTH');
volume_north1(end+1:720*4)=ncgetvar('/bcmhsm/milicak/RUNS/noresm/CORE2/Arctic/DATA/geomar/ORCA05-K3184_1m_19480101_20071231_DAVIS_transports.nc','TRANSNORTH');
volume_south1(end+1:720*4)=ncgetvar('/bcmhsm/milicak/RUNS/noresm/CORE2/Arctic/DATA/geomar/ORCA05-K3184_1m_19480101_20071231_DAVIS_transports.nc','TRANSSOUTH');
volume_north1(end+1:720*5)=ncgetvar('/bcmhsm/milicak/RUNS/noresm/CORE2/Arctic/DATA/geomar/ORCA05-K3186_1m_19480101_20071231_DAVIS_transports.nc','TRANSNORTH');
volume_south1(end+1:720*5)=ncgetvar('/bcmhsm/milicak/RUNS/noresm/CORE2/Arctic/DATA/geomar/ORCA05-K3186_1m_19480101_20071231_DAVIS_transports.nc','TRANSSOUTH');
volume_north1=reshape(volume_north1,[12 300]);
volume_south1=reshape(volume_south1,[12 300]);
davis_volume_north_geomar=nanmean(volume_north1,1);
davis_volume_south_geomar=nanmean(volume_south1,1);

%NorESM [TW]
volume_north2=ncgetvar('/bcmhsm/milicak/RUNS/noresm/CORE2/Arctic/DATA/NorESM/NOIIA_T62_tn11_sr10m60d_01_heat_freshwater_layer_Davis_monthly_1-300.nc','Massflx_in')./1e9;
volume_south2=ncgetvar('/bcmhsm/milicak/RUNS/noresm/CORE2/Arctic/DATA/NorESM/NOIIA_T62_tn11_sr10m60d_01_heat_freshwater_layer_Davis_monthly_1-300.nc','Massflx_out')./1e9;
volume_north2=reshape(volume_north2,[12 300]);
volume_south2=reshape(volume_south2,[12 300]);
davis_volume_north_noresm=nanmean(volume_north2,1);
davis_volume_south_noresm=nanmean(volume_south2,1);

%NCAR-POP [TW]
volume_north3=ncgetvar('/bcmhsm/milicak/RUNS/noresm/CORE2/Arctic/DATA/ncar-pop/Volume_fluxes_CESM_1_300_monthly.nc','incoming_vol_flux_Davis');
volume_south3=ncgetvar('/bcmhsm/milicak/RUNS/noresm/CORE2/Arctic/DATA/ncar-pop/Volume_fluxes_CESM_1_300_monthly.nc','outgoing_vol_flux_Davis');
volume_north3=reshape(volume_north3,[12 300]);
volume_south3=reshape(volume_south3,[12 300]);
davis_volume_north_ncar=nanmean(volume_north3,1);
davis_volume_south_ncar=nanmean(volume_south3,1);

%MRI-DATA
volume_north4=ncgetvar('/bcmhsm/milicak/RUNS/noresm/CORE2/Arctic/DATA/mir-data/Davis_volume.nc','inflow')./1e6;
volume_south4=-ncgetvar('/bcmhsm/milicak/RUNS/noresm/CORE2/Arctic/DATA/mir-data/Davis_volume.nc','outflow')./1e6;
volume_north4=reshape(volume_north4,[12 60]);
volume_south4=reshape(volume_south4,[12 60]);
davis_volume_north_mri_data=nanmean(volume_north4,1);
davis_volume_south_mri_data=nanmean(volume_south4,1);

%MRI-FREE
volume_north5=ncgetvar('/bcmhsm/milicak/RUNS/noresm/CORE2/Arctic/DATA/mir-free/Davis_volume.nc','inflow')./1e6;
volume_south5=-ncgetvar('/bcmhsm/milicak/RUNS/noresm/CORE2/Arctic/DATA/mir-free/Davis_volume.nc','outflow')./1e6;
dnm1=ncgetvar('/bcmhsm/milicak/RUNS/noresm/CORE2/Arctic/DATA/mir-free/Davis_volume.nc','total')./1e6;
volume_north5=reshape(volume_north5,[12 300]);
volume_south5=reshape(volume_south5,[12 300]);
dnm1=reshape(dnm1,[12 300]);
davis_volume_north_mri_free=nanmean(volume_north5,1);
davis_volume_south_mri_free=nanmean(volume_south5,1);
dnm1=squeeze(nanmean(dnm1,1));

%NEMO-CERFACS
volume_north6=ncgetvar('/bcmhsm/milicak/RUNS/noresm/CORE2/Arctic/DATA/nemo-cerfacs/CERFACS_davis.nc','T_in_Cy1')./1e6;
volume_north6(end+1:720*2,1)=ncgetvar('/bcmhsm/milicak/RUNS/noresm/CORE2/Arctic/DATA/nemo-cerfacs/CERFACS_davis.nc','T_in_Cy2')./1e6;
volume_north6(end+1:720*3,1)=ncgetvar('/bcmhsm/milicak/RUNS/noresm/CORE2/Arctic/DATA/nemo-cerfacs/CERFACS_davis.nc','T_in_Cy3')./1e6;
volume_north6(end+1:720*4,1)=ncgetvar('/bcmhsm/milicak/RUNS/noresm/CORE2/Arctic/DATA/nemo-cerfacs/CERFACS_davis.nc','T_in_Cy4')./1e6;
volume_north6(end+1:720*5,1)=ncgetvar('/bcmhsm/milicak/RUNS/noresm/CORE2/Arctic/DATA/nemo-cerfacs/CERFACS_davis.nc','T_in_Cy5')./1e6;
volume_south6=ncgetvar('/bcmhsm/milicak/RUNS/noresm/CORE2/Arctic/DATA/nemo-cerfacs/CERFACS_davis.nc','T_out_Cy1')./1e6;
volume_south6(end+1:720*2,1)=ncgetvar('/bcmhsm/milicak/RUNS/noresm/CORE2/Arctic/DATA/nemo-cerfacs/CERFACS_davis.nc','T_out_Cy2')./1e6;
volume_south6(end+1:720*3,1)=ncgetvar('/bcmhsm/milicak/RUNS/noresm/CORE2/Arctic/DATA/nemo-cerfacs/CERFACS_davis.nc','T_out_Cy3')./1e6;
volume_south6(end+1:720*4,1)=ncgetvar('/bcmhsm/milicak/RUNS/noresm/CORE2/Arctic/DATA/nemo-cerfacs/CERFACS_davis.nc','T_out_Cy4')./1e6;
volume_south6(end+1:720*5,1)=ncgetvar('/bcmhsm/milicak/RUNS/noresm/CORE2/Arctic/DATA/nemo-cerfacs/CERFACS_davis.nc','T_out_Cy5')./1e6;
volume_north6=reshape(volume_north6,[12 300]);
volume_south6=reshape(volume_south6,[12 300]);
davis_volume_north_cerfacs=nanmean(volume_north6,1);
davis_volume_south_cerfacs=nanmean(volume_south6,1);

%NEMO-CNRM
volume_north7=ncgetvar('/bcmhsm/milicak/RUNS/noresm/CORE2/Arctic/DATA/nemo-cnrm/CNRM_davis.nc','T_in_Cy1')./1e6;
volume_north7(end+1:720*2,1)=ncgetvar('/bcmhsm/milicak/RUNS/noresm/CORE2/Arctic/DATA/nemo-cnrm/CNRM_davis.nc','T_in_Cy2')./1e6;
volume_north7(end+1:720*3,1)=ncgetvar('/bcmhsm/milicak/RUNS/noresm/CORE2/Arctic/DATA/nemo-cnrm/CNRM_davis.nc','T_in_Cy3')./1e6;
volume_north7(end+1:720*4,1)=ncgetvar('/bcmhsm/milicak/RUNS/noresm/CORE2/Arctic/DATA/nemo-cnrm/CNRM_davis.nc','T_in_Cy4')./1e6;
volume_north7(end+1:720*5,1)=ncgetvar('/bcmhsm/milicak/RUNS/noresm/CORE2/Arctic/DATA/nemo-cnrm/CNRM_davis.nc','T_in_Cy5')./1e6;
volume_south7=ncgetvar('/bcmhsm/milicak/RUNS/noresm/CORE2/Arctic/DATA/nemo-cnrm/CNRM_davis.nc','T_out_Cy1')./1e6;
volume_south7(end+1:720*2,1)=ncgetvar('/bcmhsm/milicak/RUNS/noresm/CORE2/Arctic/DATA/nemo-cnrm/CNRM_davis.nc','T_out_Cy2')./1e6;
volume_south7(end+1:720*3,1)=ncgetvar('/bcmhsm/milicak/RUNS/noresm/CORE2/Arctic/DATA/nemo-cnrm/CNRM_davis.nc','T_out_Cy3')./1e6;
volume_south7(end+1:720*4,1)=ncgetvar('/bcmhsm/milicak/RUNS/noresm/CORE2/Arctic/DATA/nemo-cnrm/CNRM_davis.nc','T_out_Cy4')./1e6;
volume_south7(end+1:720*5,1)=ncgetvar('/bcmhsm/milicak/RUNS/noresm/CORE2/Arctic/DATA/nemo-cnrm/CNRM_davis.nc','T_out_Cy5')./1e6;
volume_north7=reshape(volume_north7,[12 300]);
volume_south7=reshape(volume_south7,[12 300]);
davis_volume_north_cnrm=nanmean(volume_north7,1);
davis_volume_south_cnrm=nanmean(volume_south7,1);

%FSU-HYCOM
volume_north8=ncgetvar('/bcmhsm/milicak/RUNS/noresm/CORE2/Arctic/DATA/fsu-hycom/Davis_vol_heat_fresh_tr_cyc1-5_glb1x3.nc','vol_trp');
volume_south8=ncgetvar('/bcmhsm/milicak/RUNS/noresm/CORE2/Arctic/DATA/fsu-hycom/Davis_vol_heat_fresh_tr_cyc1-5_glb1x3.nc','vol_trn');
volume_north8=reshape(volume_north8,[12 300]);
volume_south8=reshape(volume_south8,[12 300]);
davis_volume_north_hycom=nanmean(volume_north8,1);
davis_volume_south_hycom=nanmean(volume_south8,1);


%GFDL-GOLD [TW]
aa=ncgetvar('/bcmhsm/milicak/RUNS/noresm/CORE2/Arctic/DATA/gfdl-gold/monthly_heat_water_ocean_transports/seawater_transport_choke_points.nc','SEAWATER_TRANS_DAVIS');
davis_volume_total_gold=nanmean(reshape(aa,[12 300])*1e-9,1);

%GFDL-MOM [TW]

aa=ncgetvar('/bcmhsm/milicak/RUNS/noresm/CORE2/Arctic/DATA/gfdl-mom/monthly_heat_water_ocean_transports/seawater_transport_choke_points.nc','SEAWATER_TRANS_DAVIS');
davis_volume_total_mom=nanmean(reshape(aa,[12 300])*1e-9,1);

%FESOM [Sv]
volume_north9=ncgetvar('/bcmhsm/milicak/RUNS/noresm/CORE2/Arctic/DATA/fesom/FESOM_Davis.nc','V_flux_in');
volume_south9=ncgetvar('/bcmhsm/milicak/RUNS/noresm/CORE2/Arctic/DATA/fesom/FESOM_Davis.nc','V_flux_out');
volume_north9=reshape(volume_north9,[12 300]);
volume_south9=reshape(volume_south9,[12 300]);
davis_volume_north_fesom=nanmean(volume_north9,1);
davis_volume_south_fesom=nanmean(volume_south9,1);

% NOC [Sv]
aa=textread('/bcmhsm/milicak/RUNS/noresm/CORE2/Arctic/DATA/noc/1to5_heat_vol_fw_liquid_transorts/davis_1948to2007_pass1to5_CORE_ORCA1_monthly');
volume_total10=aa(:,14);
volume_total10=reshape(volume_total10,[12 290]);
davis_volume_total_noc=nanmean(volume_total10,1);

% CMCC [Sv]
volume_north10=nc_varget('/bcmhsm/milicak/RUNS/noresm/CORE2/Arctic/DATA/cmcc/CMCC_1m_Vol_flux.nc','Volp_Da');
volume_south10=nc_varget('/bcmhsm/milicak/RUNS/noresm/CORE2/Arctic/DATA/cmcc/CMCC_1m_Vol_flux.nc','Voln_Da');
volume_north10=reshape(volume_north10,[12 300]);
volume_south10=reshape(volume_south10,[12 300]);
davis_volume_north_cmcc=nanmean(volume_north10,1);
davis_volume_south_cmcc=nanmean(volume_south10,1);


% MOM0.25
volume_total11=nc_varget('/bcmhsm/milicak/RUNS/noresm/CORE2/Arctic/DATA/mom0.25/seawater_transport_choke_points.nc','SEAWATER_TRANS_DAVIS');
volume_total11=reshape(volume_total11,[12 360]);
davis_volume_total_mom_0_25=nanmean(volume_total11,1);
davis_volume_total_mom_0_25=davis_volume_total_mom_0_25*1e-9; %[Sv]

%FSU-HYCOMv2
volume_north12=ncgetvar('/bcmhsm/milicak/RUNS/noresm/CORE2/Arctic/DATA/fsu-hycom2/Davis_vol_heat_fresh_tr_cyc1-5_fsu-hycom2.nc','vol_trp');
volume_south12=ncgetvar('/bcmhsm/milicak/RUNS/noresm/CORE2/Arctic/DATA/fsu-hycom2/Davis_vol_heat_fresh_tr_cyc1-5_fsu-hycom2.nc','vol_trn');
volume_north12=reshape(volume_north12,[12 300]);
volume_south12=reshape(volume_south12,[12 300]);
davis_volume_north_hycom2=nanmean(volume_north12,1);
davis_volume_south_hycom2=nanmean(volume_south12,1);

davis_volume_north_cerfacs(isnan(davis_volume_north_cerfacs))=0;
davis_volume_north_cnrm(isnan(davis_volume_north_cnrm))=0;
davis_volume_north_geomar(isnan(davis_volume_north_geomar))=0;
davis_volume_total_gold(isnan(davis_volume_total_gold))=0;
davis_volume_north_hycom(isnan(davis_volume_north_hycom))=0;
davis_volume_total_mom(isnan(davis_volume_total_mom))=0;
davis_volume_north_mri_data(isnan(davis_volume_north_mri_data))=0;
davis_volume_north_mri_free(isnan(davis_volume_north_mri_free))=0;
davis_volume_north_ncar(isnan(davis_volume_north_ncar))=0;
davis_volume_north_noresm(isnan(davis_volume_north_noresm))=0;

davis_volume_south_cerfacs(isnan(davis_volume_south_cerfacs))=0;
davis_volume_south_cnrm(isnan(davis_volume_south_cnrm))=0;
davis_volume_south_geomar(isnan(davis_volume_south_geomar))=0;
davis_volume_total_gold(isnan(davis_volume_total_gold))=0;
davis_volume_south_hycom(isnan(davis_volume_south_hycom))=0;
davis_volume_total_mom(isnan(davis_volume_total_mom))=0;
davis_volume_south_mri_data(isnan(davis_volume_south_mri_data))=0;
davis_volume_south_mri_free(isnan(davis_volume_south_mri_free))=0;
davis_volume_south_ncar(isnan(davis_volume_south_ncar))=0;
davis_volume_south_noresm(isnan(davis_volume_south_noresm))=0;
davis_volume_north_fesom(isnan(davis_volume_north_fesom))=0;
davis_volume_south_fesom(isnan(davis_volume_south_fesom))=0;
davis_volume_north_cmcc(isnan(davis_volume_north_cmcc))=0;
davis_volume_south_cmcc(isnan(davis_volume_south_cmcc))=0;
davis_volume_north_hycom2(isnan(davis_volume_north_hycom2))=0;
davis_volume_south_hycom2(isnan(davis_volume_south_hycom2))=0;
davis_volume_total_noc(isnan(davis_volume_total_noc))=0;
davis_volume_total_mom_0_25(isnan(davis_volume_total_mom_0_25))=0;

save('matfiles/davis_volume_transports','davis_volume_north_cerfacs','davis_volume_north_cnrm','davis_volume_north_geomar','davis_volume_total_gold', ...
                                     'davis_volume_north_hycom','davis_volume_total_mom','davis_volume_north_mri_data','davis_volume_north_mri_free', ...
                                     'davis_volume_north_ncar','davis_volume_north_noresm',...
                                     'davis_volume_south_cerfacs','davis_volume_south_cnrm','davis_volume_south_geomar','davis_volume_total_gold', ...
                                     'davis_volume_south_hycom','davis_volume_total_mom','davis_volume_south_mri_data','davis_volume_south_mri_free', ...
                                     'davis_volume_south_ncar','davis_volume_south_noresm','davis_volume_north_fesom','davis_volume_south_fesom', ...
                                     'davis_volume_total_noc','davis_volume_north_cmcc','davis_volume_south_cmcc','davis_volume_total_mom_0_25', ...
                                     'davis_volume_north_hycom2','davis_volume_south_hycom2')


