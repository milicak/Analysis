clear all

%Geomar [TW]
heat_north1=ncgetvar('/work/milicak/RUNS/noresm/CORE2/Arctic/DATA/geomar/ORCA05-K3178_1m_19480101_20071231_FS_transports.nc','heat_transnorth');
heat_south1=ncgetvar('/work/milicak/RUNS/noresm/CORE2/Arctic/DATA/geomar/ORCA05-K3178_1m_19480101_20071231_FS_transports.nc','heat_transsouth');
heat_north1(1,end+1:720*2)=ncgetvar('/work/milicak/RUNS/noresm/CORE2/Arctic/DATA/geomar/ORCA05-K3181_1m_19480101_20071231_FS_transports.nc','heat_transnorth');
heat_south1(1,end+1:720*2)=ncgetvar('/work/milicak/RUNS/noresm/CORE2/Arctic/DATA/geomar/ORCA05-K3181_1m_19480101_20071231_FS_transports.nc','heat_transsouth');
heat_north1(1,end+1:720*3)=ncgetvar('/work/milicak/RUNS/noresm/CORE2/Arctic/DATA/geomar/ORCA05-K3183_1m_19480101_20071231_FS_transports.nc','heat_transnorth');
heat_south1(1,end+1:720*3)=ncgetvar('/work/milicak/RUNS/noresm/CORE2/Arctic/DATA/geomar/ORCA05-K3183_1m_19480101_20071231_FS_transports.nc','heat_transsouth');
heat_north1(1,end+1:720*4)=ncgetvar('/work/milicak/RUNS/noresm/CORE2/Arctic/DATA/geomar/ORCA05-K3184_1m_19480101_20071231_FS_transports.nc','heat_transnorth');
heat_south1(1,end+1:720*4)=ncgetvar('/work/milicak/RUNS/noresm/CORE2/Arctic/DATA/geomar/ORCA05-K3184_1m_19480101_20071231_FS_transports.nc','heat_transsouth');
heat_north1(1,end+1:720*5)=ncgetvar('/work/milicak/RUNS/noresm/CORE2/Arctic/DATA/geomar/ORCA05-K3186_1m_19480101_20071231_FS_transports.nc','heat_transnorth');
heat_south1(1,end+1:720*5)=ncgetvar('/work/milicak/RUNS/noresm/CORE2/Arctic/DATA/geomar/ORCA05-K3186_1m_19480101_20071231_FS_transports.nc','heat_transsouth');
heat_north1=reshape(heat_north1,[12 300]);
heat_south1=reshape(heat_south1,[12 300]);
fram_heat_north_geomar=nanmean(heat_north1,1);
fram_heat_south_geomar=nanmean(heat_south1,1);

%NorESM [TW]
heat_north2=ncgetvar('/work/milicak/RUNS/noresm/CORE2/Arctic/DATA/NorESM/NOIIA_T62_tn11_sr10m60d_01_heat_freshwater_layer_Fram_monthly_1-300.nc','vhflx_in')./1e12;
heat_south2=ncgetvar('/work/milicak/RUNS/noresm/CORE2/Arctic/DATA/NorESM/NOIIA_T62_tn11_sr10m60d_01_heat_freshwater_layer_Fram_monthly_1-300.nc','vhflx_out')./1e12;
heat_north2=reshape(heat_north2,[12 300]);
heat_south2=reshape(heat_south2,[12 300]);
fram_heat_north_noresm=nanmean(heat_north2,1);
fram_heat_south_noresm=nanmean(heat_south2,1);

%NCAR-POP [TW]
heat_north3=ncgetvar('/work/milicak/RUNS/noresm/CORE2/Arctic/DATA/ncar-pop/Heat_fluxes_CESM_1_300_monthly.nc','Heat_Fram_in')./1e12;
heat_south3=ncgetvar('/work/milicak/RUNS/noresm/CORE2/Arctic/DATA/ncar-pop/Heat_fluxes_CESM_1_300_monthly.nc','Heat_Fram_out')./1e12;
heat_north3=reshape(heat_north3,[12 300]);
heat_south3=reshape(heat_south3,[12 300]);
fram_heat_north_ncar=nanmean(heat_north3,1);
fram_heat_south_ncar=nanmean(heat_south3,1);

%MRI-DATA
heat_north4=ncgetvar('/work/milicak/RUNS/noresm/CORE2/Arctic/DATA/mir-data/Fram_heat.nc','inflow')./1e12;
heat_south4=-ncgetvar('/work/milicak/RUNS/noresm/CORE2/Arctic/DATA/mir-data/Fram_heat.nc','outflow')./1e12;
heat_north4=reshape(heat_north4,[12 60]);
heat_south4=reshape(heat_south4,[12 60]);
fram_heat_north_mri_data=nanmean(heat_north4,1);
fram_heat_south_mri_data=nanmean(heat_south4,1);

%MRI-FREE
heat_north5=ncgetvar('/work/milicak/RUNS/noresm/CORE2/Arctic/DATA/mir-free/Fram_heat.nc','inflow')./1e12;
heat_south5=-ncgetvar('/work/milicak/RUNS/noresm/CORE2/Arctic/DATA/mir-free/Fram_heat.nc','outflow')./1e12;
dnm1=ncgetvar('/work/milicak/RUNS/noresm/CORE2/Arctic/DATA/mir-free/Fram_heat.nc','total')./1e12;
heat_north5=reshape(heat_north5,[12 300]);
heat_south5=reshape(heat_south5,[12 300]);
dnm1=reshape(dnm1,[12 300]);
fram_heat_north_mri_free=nanmean(heat_north5,1);
fram_heat_south_mri_free=nanmean(heat_south5,1);
dnm1=squeeze(nanmean(dnm1,1));

%NEMO-CERFACS
heat_north6=ncgetvar('/work/milicak/RUNS/noresm/CORE2/Arctic/DATA/nemo-cerfacs/CERFACS_fram.nc','T_H_in_Cy1')./1e12;
heat_north6(end+1:720*2,1)=ncgetvar('/work/milicak/RUNS/noresm/CORE2/Arctic/DATA/nemo-cerfacs/CERFACS_fram.nc','T_H_in_Cy2')./1e12;
heat_north6(end+1:720*3,1)=ncgetvar('/work/milicak/RUNS/noresm/CORE2/Arctic/DATA/nemo-cerfacs/CERFACS_fram.nc','T_H_in_Cy3')./1e12;
heat_north6(end+1:720*4,1)=ncgetvar('/work/milicak/RUNS/noresm/CORE2/Arctic/DATA/nemo-cerfacs/CERFACS_fram.nc','T_H_in_Cy4')./1e12;
heat_north6(end+1:720*5,1)=ncgetvar('/work/milicak/RUNS/noresm/CORE2/Arctic/DATA/nemo-cerfacs/CERFACS_fram.nc','T_H_in_Cy5')./1e12;
heat_south6=ncgetvar('/work/milicak/RUNS/noresm/CORE2/Arctic/DATA/nemo-cerfacs/CERFACS_fram.nc','T_H_out_Cy1')./1e12;
heat_south6(end+1:720*2,1)=ncgetvar('/work/milicak/RUNS/noresm/CORE2/Arctic/DATA/nemo-cerfacs/CERFACS_fram.nc','T_H_out_Cy2')./1e12;
heat_south6(end+1:720*3,1)=ncgetvar('/work/milicak/RUNS/noresm/CORE2/Arctic/DATA/nemo-cerfacs/CERFACS_fram.nc','T_H_out_Cy3')./1e12;
heat_south6(end+1:720*4,1)=ncgetvar('/work/milicak/RUNS/noresm/CORE2/Arctic/DATA/nemo-cerfacs/CERFACS_fram.nc','T_H_out_Cy4')./1e12;
heat_south6(end+1:720*5,1)=ncgetvar('/work/milicak/RUNS/noresm/CORE2/Arctic/DATA/nemo-cerfacs/CERFACS_fram.nc','T_H_out_Cy5')./1e12;
heat_north6=reshape(heat_north6,[12 300]);
heat_south6=reshape(heat_south6,[12 300]);
fram_heat_north_cerfacs=nanmean(heat_north6,1);
fram_heat_south_cerfacs=nanmean(heat_south6,1);

%NEMO-CNRM
heat_north7=ncgetvar('/work/milicak/RUNS/noresm/CORE2/Arctic/DATA/nemo-cnrm/CNRM_fram.nc','T_H_in_Cy1')./1e12;
heat_north7(end+1:720*2,1)=ncgetvar('/work/milicak/RUNS/noresm/CORE2/Arctic/DATA/nemo-cnrm/CNRM_fram.nc','T_H_in_Cy2')./1e12;
heat_north7(end+1:720*3,1)=ncgetvar('/work/milicak/RUNS/noresm/CORE2/Arctic/DATA/nemo-cnrm/CNRM_fram.nc','T_H_in_Cy3')./1e12;
heat_north7(end+1:720*4,1)=ncgetvar('/work/milicak/RUNS/noresm/CORE2/Arctic/DATA/nemo-cnrm/CNRM_fram.nc','T_H_in_Cy4')./1e12;
heat_north7(end+1:720*5,1)=ncgetvar('/work/milicak/RUNS/noresm/CORE2/Arctic/DATA/nemo-cnrm/CNRM_fram.nc','T_H_in_Cy5')./1e12;
heat_south7=ncgetvar('/work/milicak/RUNS/noresm/CORE2/Arctic/DATA/nemo-cnrm/CNRM_fram.nc','T_H_out_Cy1')./1e12;
heat_south7(end+1:720*2,1)=ncgetvar('/work/milicak/RUNS/noresm/CORE2/Arctic/DATA/nemo-cnrm/CNRM_fram.nc','T_H_out_Cy2')./1e12;
heat_south7(end+1:720*3,1)=ncgetvar('/work/milicak/RUNS/noresm/CORE2/Arctic/DATA/nemo-cnrm/CNRM_fram.nc','T_H_out_Cy3')./1e12;
heat_south7(end+1:720*4,1)=ncgetvar('/work/milicak/RUNS/noresm/CORE2/Arctic/DATA/nemo-cnrm/CNRM_fram.nc','T_H_out_Cy4')./1e12;
heat_south7(end+1:720*5,1)=ncgetvar('/work/milicak/RUNS/noresm/CORE2/Arctic/DATA/nemo-cnrm/CNRM_fram.nc','T_H_out_Cy5')./1e12;
heat_north7=reshape(heat_north7,[12 300]);
heat_south7=reshape(heat_south7,[12 300]);
fram_heat_north_cnrm=nanmean(heat_north7,1);
fram_heat_south_cnrm=nanmean(heat_south7,1);

%FSU-HYCOM
heat_north8=ncgetvar('/work/milicak/RUNS/noresm/CORE2/Arctic/DATA/fsu-hycom/Fram_vol_heat_fresh_tr_cyc1-5_glb1x3.nc','heat_trp');
heat_south8=ncgetvar('/work/milicak/RUNS/noresm/CORE2/Arctic/DATA/fsu-hycom/Fram_vol_heat_fresh_tr_cyc1-5_glb1x3.nc','heat_trn');
heat_north8=reshape(heat_north8,[12 300]);
heat_south8=reshape(heat_south8,[12 300]);
fram_heat_north_hycom=nanmean(heat_north8,1);
fram_heat_south_hycom=nanmean(heat_south8,1);


%GFDL-GOLD [TW]
out=load('matfiles/gold_fram_transports.mat');
fram_heat_north_gold=out.fram_heat_inflow*1e-12;
fram_heat_south_gold=out.fram_heat_outflow*1e-12;

%GFDL-MOM [TW]
out=load('matfiles/mom_fram_transports.mat');
fram_heat_outflow=reshape(out.fram_heat_outflow,[12 300]);
fram_heat_inflow=reshape(out.fram_heat_inflow,[12 300]);
fram_heat_north_mom=nanmean(fram_heat_inflow,1)*1e-12;
fram_heat_south_mom=nanmean(fram_heat_outflow,1)*1e-12;

%FESOM [Sv]
heat_north9=ncgetvar('/work/milicak/RUNS/noresm/CORE2/Arctic/DATA/fesom/FESOM_Fram.nc','Q_flux_in');
heat_south9=ncgetvar('/work/milicak/RUNS/noresm/CORE2/Arctic/DATA/fesom/FESOM_Fram.nc','Q_flux_out');
heat_north9=reshape(heat_north9,[12 300]);
heat_south9=reshape(heat_south9,[12 300]);
fram_heat_north_fesom=nanmean(heat_north9,1);
fram_heat_south_fesom=nanmean(heat_south9,1);

%NOC [TW]
aa=textread('/bcmhsm/milicak/RUNS/noresm/CORE2/Arctic/DATA/noc/1to5_heat_vol_fw_liquid_transorts/fram_1948to2007_pass1to5_CORE_ORCA1_monthly');
%heat_north10=aa();
%heat_south10=aa();
%heat_north10=reshape(heat_north9,[12 300]);
%heat_south10=reshape(heat_south9,[12 300]);
heat_total10=aa(:,16)*1000;
heat_total10=reshape(heat_total10,[12 290]);
fram_heat_total_noc=nanmean(heat_total10,1);

% CMCC [Tw]
heat_total10=nc_varget('/bcmhsm/milicak/RUNS/noresm/CORE2/Arctic/DATA/cmcc/CMCC_1m_HT_flux.nc','HT_Fram');
heat_total10=reshape(heat_total10,[12 300]);
fram_heat_total_cmcc=nanmean(heat_total10,1);

% MOM0.25
heat_total11=nc_varget('/bcmhsm/milicak/RUNS/noresm/CORE2/Arctic/DATA/mom0.25/heat_transport_choke_points.nc','HEAT_TRANS_FRAM');
heat_total11=reshape(heat_total11,[12 360]);
fram_heat_total_mom_0_25=nanmean(heat_total11,1);
fram_heat_total_mom_0_25=fram_heat_total_mom_0_25*1e-12; %[TW]

%FSU-HYCOM
heat_north12=ncgetvar('/bcmhsm/milicak/RUNS/noresm/CORE2/Arctic/DATA/fsu-hycom2/Fram_vol_heat_fresh_tr_cyc1-5_fsu-hycom2.nc','heat_trp');
heat_south12=ncgetvar('/bcmhsm/milicak/RUNS/noresm/CORE2/Arctic/DATA/fsu-hycom2/Fram_vol_heat_fresh_tr_cyc1-5_fsu-hycom2.nc','heat_trn');
heat_north12=reshape(heat_north12,[12 300]);
heat_south12=reshape(heat_south12,[12 300]);
fram_heat_north_hycom2=nanmean(heat_north12,1);
fram_heat_south_hycom2=nanmean(heat_south12,1);

save('matfiles/fram_heat_transports','fram_heat_north_cerfacs','fram_heat_north_cnrm','fram_heat_north_geomar','fram_heat_north_gold', ...
                                     'fram_heat_north_hycom','fram_heat_north_mom','fram_heat_north_mri_data','fram_heat_north_mri_free', ...
                                     'fram_heat_north_ncar','fram_heat_north_noresm',...
                                     'fram_heat_south_cerfacs','fram_heat_south_cnrm','fram_heat_south_geomar','fram_heat_south_gold', ...
                                     'fram_heat_south_hycom','fram_heat_south_mom','fram_heat_south_mri_data','fram_heat_south_mri_free', ...
                                     'fram_heat_south_ncar','fram_heat_south_noresm','fram_heat_north_fesom','fram_heat_south_fesom', ...
                                     'fram_heat_total_noc','fram_heat_total_cmcc','fram_heat_total_mom_0_25','fram_heat_north_hycom2', ...
                                     'fram_heat_south_hycom2')


