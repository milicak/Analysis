clear all

%Geomar [TW]
heat_north1=ncgetvar('/bcmhsm/milicak/RUNS/noresm/CORE2/Arctic/DATA/geomar/ORCA05-K3178_1m_19480101_20071231_BERING_transports.nc','heat_transnorth');
heat_south1=ncgetvar('/bcmhsm/milicak/RUNS/noresm/CORE2/Arctic/DATA/geomar/ORCA05-K3178_1m_19480101_20071231_BERING_transports.nc','heat_transsouth');
heat_north1(end+1:720*2)=ncgetvar('/bcmhsm/milicak/RUNS/noresm/CORE2/Arctic/DATA/geomar/ORCA05-K3181_1m_19480101_20071231_BERING_transports.nc','HEAT_TRANSNORTH');
heat_south1(end+1:720*2)=ncgetvar('/bcmhsm/milicak/RUNS/noresm/CORE2/Arctic/DATA/geomar/ORCA05-K3181_1m_19480101_20071231_BERING_transports.nc','HEAT_TRANSSOUTH');
heat_north1(end+1:720*3)=ncgetvar('/bcmhsm/milicak/RUNS/noresm/CORE2/Arctic/DATA/geomar/ORCA05-K3183_1m_19480101_20071231_BERING_transports.nc','HEAT_TRANSNORTH');
heat_south1(end+1:720*3)=ncgetvar('/bcmhsm/milicak/RUNS/noresm/CORE2/Arctic/DATA/geomar/ORCA05-K3183_1m_19480101_20071231_BERING_transports.nc','HEAT_TRANSSOUTH');
heat_north1(end+1:720*4)=ncgetvar('/bcmhsm/milicak/RUNS/noresm/CORE2/Arctic/DATA/geomar/ORCA05-K3184_1m_19480101_20071231_BERING_transports.nc','HEAT_TRANSNORTH');
heat_south1(end+1:720*4)=ncgetvar('/bcmhsm/milicak/RUNS/noresm/CORE2/Arctic/DATA/geomar/ORCA05-K3184_1m_19480101_20071231_BERING_transports.nc','HEAT_TRANSSOUTH');
heat_north1(end+1:720*5)=ncgetvar('/bcmhsm/milicak/RUNS/noresm/CORE2/Arctic/DATA/geomar/ORCA05-K3186_1m_19480101_20071231_BERING_transports.nc','HEAT_TRANSNORTH');
heat_south1(end+1:720*5)=ncgetvar('/bcmhsm/milicak/RUNS/noresm/CORE2/Arctic/DATA/geomar/ORCA05-K3186_1m_19480101_20071231_BERING_transports.nc','HEAT_TRANSSOUTH');
heat_north1=reshape(heat_north1,[12 300]);
heat_south1=reshape(heat_south1,[12 300]);
bering_heat_north_geomar=nanmean(heat_north1,1);
bering_heat_south_geomar=nanmean(heat_south1,1);

%NorESM [TW]
heat_north2=ncgetvar('/bcmhsm/milicak/RUNS/noresm/CORE2/Arctic/DATA/NorESM/NOIIA_T62_tn11_sr10m60d_01_heat_freshwater_layer_Bering_monthly_1-300.nc','vhflx_in')./1e12;
heat_south2=ncgetvar('/bcmhsm/milicak/RUNS/noresm/CORE2/Arctic/DATA/NorESM/NOIIA_T62_tn11_sr10m60d_01_heat_freshwater_layer_Bering_monthly_1-300.nc','vhflx_out')./1e12;
heat_north2=reshape(heat_north2,[12 300]);
heat_south2=reshape(heat_south2,[12 300]);
bering_heat_north_noresm=nanmean(heat_north2,1);
bering_heat_south_noresm=nanmean(heat_south2,1);

%NCAR-POP [TW]
heat_north3=ncgetvar('/bcmhsm/milicak/RUNS/noresm/CORE2/Arctic/DATA/ncar-pop/Heat_fluxes_CESM_1_300_monthly.nc','Heat_Bering_in')./1e12;
heat_south3=ncgetvar('/bcmhsm/milicak/RUNS/noresm/CORE2/Arctic/DATA/ncar-pop/Heat_fluxes_CESM_1_300_monthly.nc','Heat_Bering_out')./1e12;
heat_north3=reshape(heat_north3,[12 300]);
heat_south3=reshape(heat_south3,[12 300]);
bering_heat_north_ncar=nanmean(heat_north3,1);
bering_heat_south_ncar=nanmean(heat_south3,1);

%MRI-DATA
heat_north4=ncgetvar('/bcmhsm/milicak/RUNS/noresm/CORE2/Arctic/DATA/mir-data/Bering_heat.nc','inflow')./1e12;
heat_south4=-ncgetvar('/bcmhsm/milicak/RUNS/noresm/CORE2/Arctic/DATA/mir-data/Bering_heat.nc','outflow')./1e12;
heat_north4=reshape(heat_north4,[12 60]);
heat_south4=reshape(heat_south4,[12 60]);
bering_heat_north_mri_data=nanmean(heat_north4,1);
bering_heat_south_mri_data=nanmean(heat_south4,1);

%MRI-FREE
heat_north5=ncgetvar('/bcmhsm/milicak/RUNS/noresm/CORE2/Arctic/DATA/mir-free/Bering_heat.nc','inflow')./1e12;
heat_south5=-ncgetvar('/bcmhsm/milicak/RUNS/noresm/CORE2/Arctic/DATA/mir-free/Bering_heat.nc','outflow')./1e12;
heat_north5=reshape(heat_north5,[12 300]);
heat_south5=reshape(heat_south5,[12 300]);
bering_heat_north_mri_free=nanmean(heat_north5,1);
bering_heat_south_mri_free=nanmean(heat_south5,1);

%NEMO-CERFACS
heat_north6=ncgetvar('/bcmhsm/milicak/RUNS/noresm/CORE2/Arctic/DATA/nemo-cerfacs/CERFACS_bering.nc','T_H_in_Cy1')./1e12;
heat_north6(end+1:720*2,1)=ncgetvar('/bcmhsm/milicak/RUNS/noresm/CORE2/Arctic/DATA/nemo-cerfacs/CERFACS_bering.nc','T_H_in_Cy2')./1e12;
heat_north6(end+1:720*3,1)=ncgetvar('/bcmhsm/milicak/RUNS/noresm/CORE2/Arctic/DATA/nemo-cerfacs/CERFACS_bering.nc','T_H_in_Cy3')./1e12;
heat_north6(end+1:720*4,1)=ncgetvar('/bcmhsm/milicak/RUNS/noresm/CORE2/Arctic/DATA/nemo-cerfacs/CERFACS_bering.nc','T_H_in_Cy4')./1e12;
heat_north6(end+1:720*5,1)=ncgetvar('/bcmhsm/milicak/RUNS/noresm/CORE2/Arctic/DATA/nemo-cerfacs/CERFACS_bering.nc','T_H_in_Cy5')./1e12;
heat_south6=ncgetvar('/bcmhsm/milicak/RUNS/noresm/CORE2/Arctic/DATA/nemo-cerfacs/CERFACS_bering.nc','T_H_out_Cy1')./1e12;
heat_south6(end+1:720*2,1)=ncgetvar('/bcmhsm/milicak/RUNS/noresm/CORE2/Arctic/DATA/nemo-cerfacs/CERFACS_bering.nc','T_H_out_Cy2')./1e12;
heat_south6(end+1:720*3,1)=ncgetvar('/bcmhsm/milicak/RUNS/noresm/CORE2/Arctic/DATA/nemo-cerfacs/CERFACS_bering.nc','T_H_out_Cy3')./1e12;
heat_south6(end+1:720*4,1)=ncgetvar('/bcmhsm/milicak/RUNS/noresm/CORE2/Arctic/DATA/nemo-cerfacs/CERFACS_bering.nc','T_H_out_Cy4')./1e12;
heat_south6(end+1:720*5,1)=ncgetvar('/bcmhsm/milicak/RUNS/noresm/CORE2/Arctic/DATA/nemo-cerfacs/CERFACS_bering.nc','T_H_out_Cy5')./1e12;
heat_north6=reshape(heat_north6,[12 300]);
heat_south6=reshape(heat_south6,[12 300]);
bering_heat_north_cerfacs=nanmean(heat_north6,1);
bering_heat_south_cerfacs=nanmean(heat_south6,1);

%NEMO-CNRM
heat_north7=ncgetvar('/bcmhsm/milicak/RUNS/noresm/CORE2/Arctic/DATA/nemo-cnrm/CNRM_bering.nc','T_H_in_Cy1')./1e12;
heat_north7(end+1:720*2,1)=ncgetvar('/bcmhsm/milicak/RUNS/noresm/CORE2/Arctic/DATA/nemo-cnrm/CNRM_bering.nc','T_H_in_Cy2')./1e12;
heat_north7(end+1:720*3,1)=ncgetvar('/bcmhsm/milicak/RUNS/noresm/CORE2/Arctic/DATA/nemo-cnrm/CNRM_bering.nc','T_H_in_Cy3')./1e12;
heat_north7(end+1:720*4,1)=ncgetvar('/bcmhsm/milicak/RUNS/noresm/CORE2/Arctic/DATA/nemo-cnrm/CNRM_bering.nc','T_H_in_Cy4')./1e12;
heat_north7(end+1:720*5,1)=ncgetvar('/bcmhsm/milicak/RUNS/noresm/CORE2/Arctic/DATA/nemo-cnrm/CNRM_bering.nc','T_H_in_Cy5')./1e12;
heat_south7=ncgetvar('/bcmhsm/milicak/RUNS/noresm/CORE2/Arctic/DATA/nemo-cnrm/CNRM_bering.nc','T_H_out_Cy1')./1e12;
heat_south7(end+1:720*2,1)=ncgetvar('/bcmhsm/milicak/RUNS/noresm/CORE2/Arctic/DATA/nemo-cnrm/CNRM_bering.nc','T_H_out_Cy2')./1e12;
heat_south7(end+1:720*3,1)=ncgetvar('/bcmhsm/milicak/RUNS/noresm/CORE2/Arctic/DATA/nemo-cnrm/CNRM_bering.nc','T_H_out_Cy3')./1e12;
heat_south7(end+1:720*4,1)=ncgetvar('/bcmhsm/milicak/RUNS/noresm/CORE2/Arctic/DATA/nemo-cnrm/CNRM_bering.nc','T_H_out_Cy4')./1e12;
heat_south7(end+1:720*5,1)=ncgetvar('/bcmhsm/milicak/RUNS/noresm/CORE2/Arctic/DATA/nemo-cnrm/CNRM_bering.nc','T_H_out_Cy5')./1e12;
heat_north7=reshape(heat_north7,[12 300]);
heat_south7=reshape(heat_south7,[12 300]);
bering_heat_north_cnrm=nanmean(heat_north7,1);
bering_heat_south_cnrm=nanmean(heat_south7,1);

%FSU-HYCOM
heat_north8=ncgetvar('/bcmhsm/milicak/RUNS/noresm/CORE2/Arctic/DATA/fsu-hycom/Bering_vol_heat_fresh_tr_cyc1-5_glb1x3.nc','heat_trp');
heat_south8=ncgetvar('/bcmhsm/milicak/RUNS/noresm/CORE2/Arctic/DATA/fsu-hycom/Bering_vol_heat_fresh_tr_cyc1-5_glb1x3.nc','heat_trn');
heat_north8=reshape(heat_north8,[12 300]);
heat_south8=reshape(heat_south8,[12 300]);
bering_heat_north_hycom=nanmean(heat_north8,1);
bering_heat_south_hycom=nanmean(heat_south8,1);


%GFDL-GOLD [TW]
aa=ncgetvar('/bcmhsm/milicak/RUNS/noresm/CORE2/Arctic/DATA/gfdl-gold/monthly_heat_water_ocean_transports/heat_transport_choke_points.nc','HEAT_TRANS_BERING');
bering_heat_total_gold=nanmean(reshape(aa,[12 300])*1e-12,1);

%GFDL-MOM [TW]

aa=ncgetvar('/bcmhsm/milicak/RUNS/noresm/CORE2/Arctic/DATA/gfdl-mom/monthly_heat_water_ocean_transports/heat_transport_choke_points.nc','HEAT_TRANS_BERING');
bering_heat_total_mom=nanmean(reshape(aa,[12 300])*1e-12,1);

%FESOM [Sv]
heat_north9=ncgetvar('/bcmhsm/milicak/RUNS/noresm/CORE2/Arctic/DATA/fesom/FESOM_Bering.nc','Q_flux_in');
heat_south9=ncgetvar('/bcmhsm/milicak/RUNS/noresm/CORE2/Arctic/DATA/fesom/FESOM_Bering.nc','Q_flux_out');
heat_north9=reshape(heat_north9,[12 300]);
heat_south9=reshape(heat_south9,[12 300]);
bering_heat_north_fesom=nanmean(heat_north9,1);
bering_heat_south_fesom=nanmean(heat_south9,1);

% NOC [Sv]
aa=textread('/bcmhsm/milicak/RUNS/noresm/CORE2/Arctic/DATA/noc/1to5_heat_vol_fw_liquid_transorts/bering_1948to2007_pass1to5_CORE_ORCA1_monthly');
heat_total10=aa(:,15);
heat_total10=reshape(heat_total10,[12 290]);
bering_heat_total_noc=nanmean(heat_total10,1)*1e3;

% CMCC [Sv]
heat_total10=nc_varget('/bcmhsm/milicak/RUNS/noresm/CORE2/Arctic/DATA/cmcc/CMCC_1m_HT_flux.nc','HT_Bering');
heat_total10=reshape(heat_total10,[12 300]);
bering_heat_total_cmcc=nanmean(heat_total10,1);


% MOM0.25
heat_total11=nc_varget('/bcmhsm/milicak/RUNS/noresm/CORE2/Arctic/DATA/mom0.25/heat_transport_choke_points.nc','HEAT_TRANS_BERING');
heat_total11=reshape(heat_total11,[12 360]);
bering_heat_total_mom_0_25=nanmean(heat_total11,1);
bering_heat_total_mom_0_25=bering_heat_total_mom_0_25*1e-12; %[TW]

%FSU-HYCOMv2
heat_north12=ncgetvar('/bcmhsm/milicak/RUNS/noresm/CORE2/Arctic/DATA/fsu-hycom2/Bering_vol_heat_fresh_tr_cyc1-5_fsu-hycom2.nc','heat_trp');
heat_south12=ncgetvar('/bcmhsm/milicak/RUNS/noresm/CORE2/Arctic/DATA/fsu-hycom2/Bering_vol_heat_fresh_tr_cyc1-5_fsu-hycom2.nc','heat_trn');
heat_north12=reshape(heat_north12,[12 300]);
heat_south12=reshape(heat_south12,[12 300]);
bering_heat_north_hycom2=nanmean(heat_north12,1);
bering_heat_south_hycom2=nanmean(heat_south12,1);

bering_heat_north_cerfacs(isnan(bering_heat_north_cerfacs))=0;
bering_heat_north_cnrm(isnan(bering_heat_north_cnrm))=0;
bering_heat_north_geomar(isnan(bering_heat_north_geomar))=0;
bering_heat_total_gold(isnan(bering_heat_total_gold))=0;
bering_heat_north_hycom(isnan(bering_heat_north_hycom))=0;
bering_heat_total_mom(isnan(bering_heat_total_mom))=0;
bering_heat_north_mri_data(isnan(bering_heat_north_mri_data))=0;
bering_heat_north_mri_free(isnan(bering_heat_north_mri_free))=0;
bering_heat_north_ncar(isnan(bering_heat_north_ncar))=0;
bering_heat_north_noresm(isnan(bering_heat_north_noresm))=0;

bering_heat_south_cerfacs(isnan(bering_heat_south_cerfacs))=0;
bering_heat_south_cnrm(isnan(bering_heat_south_cnrm))=0;
bering_heat_south_geomar(isnan(bering_heat_south_geomar))=0;
bering_heat_total_gold(isnan(bering_heat_total_gold))=0;
bering_heat_south_hycom(isnan(bering_heat_south_hycom))=0;
bering_heat_total_mom(isnan(bering_heat_total_mom))=0;
bering_heat_south_mri_data(isnan(bering_heat_south_mri_data))=0;
bering_heat_south_mri_free(isnan(bering_heat_south_mri_free))=0;
bering_heat_south_ncar(isnan(bering_heat_south_ncar))=0;
bering_heat_south_noresm(isnan(bering_heat_south_noresm))=0;
bering_heat_north_fesom(isnan(bering_heat_north_fesom))=0;
bering_heat_south_fesom(isnan(bering_heat_south_fesom))=0;
bering_heat_total_cmcc(isnan(bering_heat_total_cmcc))=0;
bering_heat_north_hycom2(isnan(bering_heat_north_hycom2))=0;
bering_heat_south_hycom2(isnan(bering_heat_south_hycom2))=0;
bering_heat_total_noc(isnan(bering_heat_total_noc))=0;
bering_heat_total_mom_0_25(isnan(bering_heat_total_mom_0_25))=0;


save('matfiles/bering_heat_transports','bering_heat_north_cerfacs','bering_heat_north_cnrm','bering_heat_north_geomar','bering_heat_total_gold', ...
                                     'bering_heat_north_hycom','bering_heat_total_mom','bering_heat_north_mri_data','bering_heat_north_mri_free', ...
                                     'bering_heat_north_ncar','bering_heat_north_noresm',...
                                     'bering_heat_south_cerfacs','bering_heat_south_cnrm','bering_heat_south_geomar','bering_heat_total_gold', ...
                                     'bering_heat_south_hycom','bering_heat_total_mom','bering_heat_south_mri_data','bering_heat_south_mri_free', ...
                                     'bering_heat_south_ncar','bering_heat_south_noresm','bering_heat_north_fesom','bering_heat_south_fesom', ...
                                     'bering_heat_total_noc','bering_heat_total_cmcc','bering_heat_total_mom_0_25', ...
                                     'bering_heat_north_hycom2','bering_heat_south_hycom2')


