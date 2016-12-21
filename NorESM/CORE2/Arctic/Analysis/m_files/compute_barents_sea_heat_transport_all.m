clear all

%Geomar [TW]
heat_north1=ncgetvar('/work/milicak/RUNS/noresm/CORE2/Arctic/DATA/geomar/ORCA05-K3178_1m_19480101_20071231_BSO20E_transports.nc','heat_transeast');
heat_south1=ncgetvar('/work/milicak/RUNS/noresm/CORE2/Arctic/DATA/geomar/ORCA05-K3178_1m_19480101_20071231_BSO20E_transports.nc','heat_transwest');
heat_north1(end+1:720*2)=ncgetvar('/work/milicak/RUNS/noresm/CORE2/Arctic/DATA/geomar/ORCA05-K3181_1m_19480101_20071231_BSO20E_transports.nc','heat_transeast');
heat_south1(end+1:720*2)=ncgetvar('/work/milicak/RUNS/noresm/CORE2/Arctic/DATA/geomar/ORCA05-K3181_1m_19480101_20071231_BSO20E_transports.nc','heat_transwest');
heat_north1(end+1:720*3)=ncgetvar('/work/milicak/RUNS/noresm/CORE2/Arctic/DATA/geomar/ORCA05-K3183_1m_19480101_20071231_BSO20E_transports.nc','heat_transeast');
heat_south1(end+1:720*3)=ncgetvar('/work/milicak/RUNS/noresm/CORE2/Arctic/DATA/geomar/ORCA05-K3183_1m_19480101_20071231_BSO20E_transports.nc','heat_transwest');
heat_north1(end+1:720*4)=ncgetvar('/work/milicak/RUNS/noresm/CORE2/Arctic/DATA/geomar/ORCA05-K3184_1m_19480101_20071231_BSO20E_transports.nc','heat_transeast');
heat_south1(end+1:720*4)=ncgetvar('/work/milicak/RUNS/noresm/CORE2/Arctic/DATA/geomar/ORCA05-K3184_1m_19480101_20071231_BSO20E_transports.nc','heat_transwest');
heat_north1(end+1:720*5)=ncgetvar('/work/milicak/RUNS/noresm/CORE2/Arctic/DATA/geomar/ORCA05-K3186_1m_19480101_20071231_BSO20E_transports.nc','heat_transeast');
heat_south1(end+1:720*5)=ncgetvar('/work/milicak/RUNS/noresm/CORE2/Arctic/DATA/geomar/ORCA05-K3186_1m_19480101_20071231_BSO20E_transports.nc','heat_transwest');
heat_north1=reshape(heat_north1,[12 300]);
heat_south1=reshape(heat_south1,[12 300]);
barents_heat_north_geomar=nanmean(heat_north1,1);
barents_heat_south_geomar=nanmean(heat_south1,1);

%NorESM [TW]
heat_north2=ncgetvar('/work/milicak/RUNS/noresm/CORE2/Arctic/DATA/NorESM/NOIIA_T62_tn11_sr10m60d_01_heat_freshwater_layer_Barents_monthly_1-300.nc','vhflx_in')./1e12;
heat_south2=ncgetvar('/work/milicak/RUNS/noresm/CORE2/Arctic/DATA/NorESM/NOIIA_T62_tn11_sr10m60d_01_heat_freshwater_layer_Barents_monthly_1-300.nc','vhflx_out')./1e12;
heat_north2=reshape(heat_north2,[12 300]);
heat_south2=reshape(heat_south2,[12 300]);
barents_heat_north_noresm=nanmean(heat_north2,1);
barents_heat_south_noresm=nanmean(heat_south2,1);

%NCAR-POP [TW]
heat_north3=ncgetvar('/bcmhsm/milicak/RUNS/noresm/CORE2/Arctic/DATA/ncar-pop/Heat_fluxes_CESM_1_300_monthly.nc','Heat_BSO_in')./1e12;
heat_south3=ncgetvar('/bcmhsm/milicak/RUNS/noresm/CORE2/Arctic/DATA/ncar-pop/Heat_fluxes_CESM_1_300_monthly.nc','Heat_BSO_out')./1e12;
heat_north3=reshape(heat_north3,[12 300]);
heat_south3=reshape(heat_south3,[12 300]);
barents_heat_north_ncar=nanmean(heat_north3,1);
barents_heat_south_ncar=nanmean(heat_south3,1);

%MRI-DATA
heat_north4=ncgetvar('/work/milicak/RUNS/noresm/CORE2/Arctic/DATA/mir-data/Barents_heat.nc','inflow')./1e12;
heat_south4=-ncgetvar('/work/milicak/RUNS/noresm/CORE2/Arctic/DATA/mir-data/Barents_heat.nc','outflow')./1e12;
heat_north4=reshape(heat_north4,[12 60]);
heat_south4=reshape(heat_south4,[12 60]);
barents_heat_north_mri_data=nanmean(heat_north4,1);
barents_heat_south_mri_data=nanmean(heat_south4,1);

%MRI-FREE
heat_north5=ncgetvar('/work/milicak/RUNS/noresm/CORE2/Arctic/DATA/mir-free/Barents_heat.nc','inflow')./1e12;
heat_south5=-ncgetvar('/work/milicak/RUNS/noresm/CORE2/Arctic/DATA/mir-free/Barents_heat.nc','outflow')./1e12;
heat_north5=reshape(heat_north5,[12 300]);
heat_south5=reshape(heat_south5,[12 300]);
barents_heat_north_mri_free=nanmean(heat_north5,1);
barents_heat_south_mri_free=nanmean(heat_south5,1);

%NEMO-CERFACS
heat_north6=ncgetvar('/bcmhsm/milicak/RUNS/noresm/CORE2/Arctic/DATA/nemo-cerfacs/CERFACS_bso.nc','T_H_in_Cy1')./1e12;
heat_north6(end+1:720*2,1)=ncgetvar('/bcmhsm/milicak/RUNS/noresm/CORE2/Arctic/DATA/nemo-cerfacs/CERFACS_bso.nc','T_H_in_Cy2')./1e12;
heat_north6(end+1:720*3,1)=ncgetvar('/bcmhsm/milicak/RUNS/noresm/CORE2/Arctic/DATA/nemo-cerfacs/CERFACS_bso.nc','T_H_in_Cy3')./1e12;
heat_north6(end+1:720*4,1)=ncgetvar('/bcmhsm/milicak/RUNS/noresm/CORE2/Arctic/DATA/nemo-cerfacs/CERFACS_bso.nc','T_H_in_Cy4')./1e12;
heat_north6(end+1:720*5,1)=ncgetvar('/bcmhsm/milicak/RUNS/noresm/CORE2/Arctic/DATA/nemo-cerfacs/CERFACS_bso.nc','T_H_in_Cy5')./1e12;
heat_south6=ncgetvar('/bcmhsm/milicak/RUNS/noresm/CORE2/Arctic/DATA/nemo-cerfacs/CERFACS_bso.nc','T_H_out_Cy1')./1e12;
heat_south6(end+1:720*2,1)=ncgetvar('/bcmhsm/milicak/RUNS/noresm/CORE2/Arctic/DATA/nemo-cerfacs/CERFACS_bso.nc','T_H_out_Cy2')./1e12;
heat_south6(end+1:720*3,1)=ncgetvar('/bcmhsm/milicak/RUNS/noresm/CORE2/Arctic/DATA/nemo-cerfacs/CERFACS_bso.nc','T_H_out_Cy3')./1e12;
heat_south6(end+1:720*4,1)=ncgetvar('/bcmhsm/milicak/RUNS/noresm/CORE2/Arctic/DATA/nemo-cerfacs/CERFACS_bso.nc','T_H_out_Cy4')./1e12;
heat_south6(end+1:720*5,1)=ncgetvar('/bcmhsm/milicak/RUNS/noresm/CORE2/Arctic/DATA/nemo-cerfacs/CERFACS_bso.nc','T_H_out_Cy5')./1e12;
heat_north6=reshape(heat_north6,[12 300]);
heat_south6=reshape(heat_south6,[12 300]);
barents_heat_north_cerfacs=nanmean(heat_north6,1);
barents_heat_south_cerfacs=nanmean(heat_south6,1);

%NEMO-CNRM
heat_north7=ncgetvar('/work/milicak/RUNS/noresm/CORE2/Arctic/DATA/nemo-cnrm/CNRM_bso.nc','T_H_in_Cy1')./1e12;
heat_north7(end+1:720*2,1)=ncgetvar('/work/milicak/RUNS/noresm/CORE2/Arctic/DATA/nemo-cnrm/CNRM_bso.nc','T_H_in_Cy2')./1e12;
heat_north7(end+1:720*3,1)=ncgetvar('/work/milicak/RUNS/noresm/CORE2/Arctic/DATA/nemo-cnrm/CNRM_bso.nc','T_H_in_Cy3')./1e12;
heat_north7(end+1:720*4,1)=ncgetvar('/work/milicak/RUNS/noresm/CORE2/Arctic/DATA/nemo-cnrm/CNRM_bso.nc','T_H_in_Cy4')./1e12;
heat_north7(end+1:720*5,1)=ncgetvar('/work/milicak/RUNS/noresm/CORE2/Arctic/DATA/nemo-cnrm/CNRM_bso.nc','T_H_in_Cy5')./1e12;
heat_south7=ncgetvar('/work/milicak/RUNS/noresm/CORE2/Arctic/DATA/nemo-cnrm/CNRM_bso.nc','T_H_out_Cy1')./1e12;
heat_south7(end+1:720*2,1)=ncgetvar('/work/milicak/RUNS/noresm/CORE2/Arctic/DATA/nemo-cnrm/CNRM_bso.nc','T_H_out_Cy2')./1e12;
heat_south7(end+1:720*3,1)=ncgetvar('/work/milicak/RUNS/noresm/CORE2/Arctic/DATA/nemo-cnrm/CNRM_bso.nc','T_H_out_Cy3')./1e12;
heat_south7(end+1:720*4,1)=ncgetvar('/work/milicak/RUNS/noresm/CORE2/Arctic/DATA/nemo-cnrm/CNRM_bso.nc','T_H_out_Cy4')./1e12;
heat_south7(end+1:720*5,1)=ncgetvar('/work/milicak/RUNS/noresm/CORE2/Arctic/DATA/nemo-cnrm/CNRM_bso.nc','T_H_out_Cy5')./1e12;
heat_north7=reshape(heat_north7,[12 300]);
heat_south7=reshape(heat_south7,[12 300]);
barents_heat_north_cnrm=nanmean(heat_north7,1);
barents_heat_south_cnrm=nanmean(heat_south7,1);

%FSU-HYCOM
heat_north8=ncgetvar('/work/milicak/RUNS/noresm/CORE2/Arctic/DATA/fsu-hycom/BSO_vol_heat_fresh_tr_cyc1-5_glb1x3.nc','heat_trp');
heat_south8=ncgetvar('/work/milicak/RUNS/noresm/CORE2/Arctic/DATA/fsu-hycom/BSO_vol_heat_fresh_tr_cyc1-5_glb1x3.nc','heat_trn');
heat_north8=reshape(heat_north8,[12 300]);
heat_south8=reshape(heat_south8,[12 300]);
barents_heat_north_hycom=nanmean(heat_north8,1);
barents_heat_south_hycom=nanmean(heat_south8,1);


%GFDL-GOLD [TW]
out=load('matfiles/gold_barents_transports.mat');
barents_heat_north_gold=out.barents_heat_inflow*1e-12;
barents_heat_south_gold=out.barents_heat_outflow*1e-12;

%GFDL-MOM [TW]
out=load('matfiles/mom_barents_transports.mat');
barents_heat_outflow=reshape(out.barents_heat_outflow,[12 300]);
barents_heat_inflow=reshape(out.barents_heat_inflow,[12 300]);
barents_heat_north_mom=nanmean(barents_heat_inflow,1)*1e-12;
barents_heat_south_mom=nanmean(barents_heat_outflow,1)*1e-12;

%FESOM [TW]
%heat_south9=ncgetvar('/work/milicak/RUNS/noresm/CORE2/Arctic/DATA/fesom/FESOM_Barents_Kara.nc','Q_flux_in');
%heat_north9=ncgetvar('/work/milicak/RUNS/noresm/CORE2/Arctic/DATA/fesom/FESOM_Barents_Kara.nc','Q_flux_out');
heat_north9=-ncgetvar('/bcmhsm/milicak/RUNS/noresm/CORE2/Arctic/DATA/fesom/FESOM_BSO.nc','Q_flux_in');
heat_south9=-ncgetvar('/bcmhsm/milicak/RUNS/noresm/CORE2/Arctic/DATA/fesom/FESOM_BSO.nc','Q_flux_out');
heat_north9=reshape(heat_north9,[12 300]);
heat_south9=reshape(heat_south9,[12 300]);
barents_heat_north_fesom=nanmean(heat_north9,1);
barents_heat_south_fesom=nanmean(heat_south9,1);

%NOC [TW]
aa=textread('/bcmhsm/milicak/RUNS/noresm/CORE2/Arctic/DATA/noc/1to5_heat_vol_fw_liquid_transorts/barents_1948to2007_pass1to5_CORE_ORCA1_monthly');
%heat_north10=aa();
%heat_south10=aa();
%heat_north10=reshape(heat_north9,[12 300]);
%heat_south10=reshape(heat_south9,[12 300]);
heat_total10=aa(:,16)*1000;
heat_total10=reshape(heat_total10,[12 300]);
barents_heat_total_noc=nanmean(heat_total10,1);
%barents_heat_north_noc=nanmean(heat_north10,1);
%barents_heat_south_noc=nanmean(heat_south10,1);

break

% CMCC [Tw]
heat_total11=nc_varget('/bcmhsm/milicak/RUNS/noresm/CORE2/Arctic/DATA/cmcc/CMCC_1m_HT_flux.nc','HT_BSO');
heat_total11=reshape(heat_total11,[12 300]);
barents_heat_total_cmcc=nanmean(heat_total11,1);


% MOM0.25
heat_total11=nc_varget('/bcmhsm/milicak/RUNS/noresm/CORE2/Arctic/DATA/mom0.25/heat_transport_choke_points.nc','HEAT_TRANS_BARENTS');
heat_total11=reshape(heat_total11,[12 360]);
barents_heat_total_mom_0_25=nanmean(heat_total11,1);
barents_heat_total_mom_0_25=barents_heat_total_mom_0_25*1e-12; %[TW]

% FSU-HYCOM
heat_north12=ncgetvar('/bcmhsm/milicak/RUNS/noresm/CORE2/Arctic/DATA/fsu-hycom2/BSO_vol_heat_fresh_tr_cyc1-5_fsu-hycom2.nc','heat_trp');
heat_south12=ncgetvar('/bcmhsm/milicak/RUNS/noresm/CORE2/Arctic/DATA/fsu-hycom2/BSO_vol_heat_fresh_tr_cyc1-5_fsu-hycom2.nc','heat_trn');
heat_north12=reshape(heat_north12,[12 300]);
heat_south12=reshape(heat_south12,[12 300]);
barents_heat_north_hycom2=nanmean(heat_north12,1);
barents_heat_south_hycom2=nanmean(heat_south12,1);



save('matfiles/barents_heat_transports','barents_heat_north_cerfacs','barents_heat_north_cnrm','barents_heat_north_geomar','barents_heat_north_gold', ...
                                     'barents_heat_north_hycom','barents_heat_north_mom','barents_heat_north_mri_data','barents_heat_north_mri_free', ...
                                     'barents_heat_north_ncar','barents_heat_north_noresm',...
                                     'barents_heat_south_cerfacs','barents_heat_south_cnrm','barents_heat_south_geomar','barents_heat_south_gold', ...
                                     'barents_heat_south_hycom','barents_heat_south_mom','barents_heat_south_mri_data','barents_heat_south_mri_free', ...
                                     'barents_heat_south_ncar','barents_heat_south_noresm','barents_heat_north_fesom','barents_heat_south_fesom', ...
                                     'barents_heat_total_noc','barents_heat_total_cmcc','barents_heat_total_mom_0_25', 'barents_heat_north_hycom2', ...
                                     'barents_heat_south_hycom2')




