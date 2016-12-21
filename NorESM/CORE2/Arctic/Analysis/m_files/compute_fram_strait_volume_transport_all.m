clear all

%Geomar [TW]
volume_north1=ncgetvar('/work/milicak/RUNS/noresm/CORE2/Arctic/DATA/geomar/ORCA05-K3178_1m_19480101_20071231_FS_transports.nc','transnorth');
volume_south1=ncgetvar('/work/milicak/RUNS/noresm/CORE2/Arctic/DATA/geomar/ORCA05-K3178_1m_19480101_20071231_FS_transports.nc','transsouth');
volume_north1(1,end+1:720*2)=ncgetvar('/work/milicak/RUNS/noresm/CORE2/Arctic/DATA/geomar/ORCA05-K3181_1m_19480101_20071231_FS_transports.nc','transnorth');
volume_south1(1,end+1:720*2)=ncgetvar('/work/milicak/RUNS/noresm/CORE2/Arctic/DATA/geomar/ORCA05-K3181_1m_19480101_20071231_FS_transports.nc','transsouth');
volume_north1(1,end+1:720*3)=ncgetvar('/work/milicak/RUNS/noresm/CORE2/Arctic/DATA/geomar/ORCA05-K3183_1m_19480101_20071231_FS_transports.nc','transnorth');
volume_south1(1,end+1:720*3)=ncgetvar('/work/milicak/RUNS/noresm/CORE2/Arctic/DATA/geomar/ORCA05-K3183_1m_19480101_20071231_FS_transports.nc','transsouth');
volume_north1(1,end+1:720*4)=ncgetvar('/work/milicak/RUNS/noresm/CORE2/Arctic/DATA/geomar/ORCA05-K3184_1m_19480101_20071231_FS_transports.nc','transnorth');
volume_south1(1,end+1:720*4)=ncgetvar('/work/milicak/RUNS/noresm/CORE2/Arctic/DATA/geomar/ORCA05-K3184_1m_19480101_20071231_FS_transports.nc','transsouth');
volume_north1(1,end+1:720*5)=ncgetvar('/work/milicak/RUNS/noresm/CORE2/Arctic/DATA/geomar/ORCA05-K3186_1m_19480101_20071231_FS_transports.nc','transnorth');
volume_south1(1,end+1:720*5)=ncgetvar('/work/milicak/RUNS/noresm/CORE2/Arctic/DATA/geomar/ORCA05-K3186_1m_19480101_20071231_FS_transports.nc','transsouth');
volume_north1=reshape(volume_north1,[12 300]);
volume_south1=reshape(volume_south1,[12 300]);
fram_volume_north_geomar=nanmean(volume_north1,1);
fram_volume_south_geomar=nanmean(volume_south1,1);

%NorESM [TW]
volume_north2=ncgetvar('/work/milicak/RUNS/noresm/CORE2/Arctic/DATA/NorESM/NOIIA_T62_tn11_sr10m60d_01_heat_freshwater_layer_Fram_monthly_1-300.nc','Massflx_in')./1e9;
volume_south2=ncgetvar('/work/milicak/RUNS/noresm/CORE2/Arctic/DATA/NorESM/NOIIA_T62_tn11_sr10m60d_01_heat_freshwater_layer_Fram_monthly_1-300.nc','Massflx_out')./1e9;
volume_north2=reshape(volume_north2,[12 300]);
volume_south2=reshape(volume_south2,[12 300]);
fram_volume_north_noresm=nanmean(volume_north2,1);
fram_volume_south_noresm=nanmean(volume_south2,1);

%NCAR-POP [TW]
volume_north3=ncgetvar('/work/milicak/RUNS/noresm/CORE2/Arctic/DATA/ncar-pop/Volume_fluxes_CESM_1_300_monthly.nc','incoming_vol_flux_Fram');
volume_south3=ncgetvar('/work/milicak/RUNS/noresm/CORE2/Arctic/DATA/ncar-pop/Volume_fluxes_CESM_1_300_monthly.nc','outgoing_vol_flux_Fram');
volume_north3=reshape(volume_north3,[12 300]);
volume_south3=reshape(volume_south3,[12 300]);
fram_volume_north_ncar=nanmean(volume_north3,1);
fram_volume_south_ncar=nanmean(volume_south3,1);

%MRI-DATA
volume_north4=ncgetvar('/work/milicak/RUNS/noresm/CORE2/Arctic/DATA/mir-data/Fram_volume.nc','inflow')./1e6;
volume_south4=-ncgetvar('/work/milicak/RUNS/noresm/CORE2/Arctic/DATA/mir-data/Fram_volume.nc','outflow')./1e6;
volume_north4=reshape(volume_north4,[12 60]);
volume_south4=reshape(volume_south4,[12 60]);
fram_volume_north_mri_data=nanmean(volume_north4,1);
fram_volume_south_mri_data=nanmean(volume_south4,1);

%MRI-FREE
volume_north5=ncgetvar('/work/milicak/RUNS/noresm/CORE2/Arctic/DATA/mir-free/Fram_volume.nc','inflow')./1e6;
volume_south5=-ncgetvar('/work/milicak/RUNS/noresm/CORE2/Arctic/DATA/mir-free/Fram_volume.nc','outflow')./1e6;
dnm1=ncgetvar('/work/milicak/RUNS/noresm/CORE2/Arctic/DATA/mir-free/Fram_volume.nc','total')./1e6;
volume_north5=reshape(volume_north5,[12 300]);
volume_south5=reshape(volume_south5,[12 300]);
dnm1=reshape(dnm1,[12 300]);
fram_volume_north_mri_free=nanmean(volume_north5,1);
fram_volume_south_mri_free=nanmean(volume_south5,1);
dnm1=squeeze(nanmean(dnm1,1));

%NEMO-CERFACS
volume_north6=ncgetvar('/work/milicak/RUNS/noresm/CORE2/Arctic/DATA/nemo-cerfacs/CERFACS_fram.nc','T_in_Cy1')./1e6;
volume_north6(end+1:720*2,1)=ncgetvar('/work/milicak/RUNS/noresm/CORE2/Arctic/DATA/nemo-cerfacs/CERFACS_fram.nc','T_in_Cy2')./1e6;
volume_north6(end+1:720*3,1)=ncgetvar('/work/milicak/RUNS/noresm/CORE2/Arctic/DATA/nemo-cerfacs/CERFACS_fram.nc','T_in_Cy3')./1e6;
volume_north6(end+1:720*4,1)=ncgetvar('/work/milicak/RUNS/noresm/CORE2/Arctic/DATA/nemo-cerfacs/CERFACS_fram.nc','T_in_Cy4')./1e6;
volume_north6(end+1:720*5,1)=ncgetvar('/work/milicak/RUNS/noresm/CORE2/Arctic/DATA/nemo-cerfacs/CERFACS_fram.nc','T_in_Cy5')./1e6;
volume_south6=ncgetvar('/work/milicak/RUNS/noresm/CORE2/Arctic/DATA/nemo-cerfacs/CERFACS_fram.nc','T_out_Cy1')./1e6;
volume_south6(end+1:720*2,1)=ncgetvar('/work/milicak/RUNS/noresm/CORE2/Arctic/DATA/nemo-cerfacs/CERFACS_fram.nc','T_out_Cy2')./1e6;
volume_south6(end+1:720*3,1)=ncgetvar('/work/milicak/RUNS/noresm/CORE2/Arctic/DATA/nemo-cerfacs/CERFACS_fram.nc','T_out_Cy3')./1e6;
volume_south6(end+1:720*4,1)=ncgetvar('/work/milicak/RUNS/noresm/CORE2/Arctic/DATA/nemo-cerfacs/CERFACS_fram.nc','T_out_Cy4')./1e6;
volume_south6(end+1:720*5,1)=ncgetvar('/work/milicak/RUNS/noresm/CORE2/Arctic/DATA/nemo-cerfacs/CERFACS_fram.nc','T_out_Cy5')./1e6;
volume_north6=reshape(volume_north6,[12 300]);
volume_south6=reshape(volume_south6,[12 300]);
fram_volume_north_cerfacs=nanmean(volume_north6,1);
fram_volume_south_cerfacs=nanmean(volume_south6,1);

%NEMO-CNRM
volume_north7=ncgetvar('/work/milicak/RUNS/noresm/CORE2/Arctic/DATA/nemo-cnrm/CNRM_fram.nc','T_in_Cy1')./1e6;
volume_north7(end+1:720*2,1)=ncgetvar('/work/milicak/RUNS/noresm/CORE2/Arctic/DATA/nemo-cnrm/CNRM_fram.nc','T_in_Cy2')./1e6;
volume_north7(end+1:720*3,1)=ncgetvar('/work/milicak/RUNS/noresm/CORE2/Arctic/DATA/nemo-cnrm/CNRM_fram.nc','T_in_Cy3')./1e6;
volume_north7(end+1:720*4,1)=ncgetvar('/work/milicak/RUNS/noresm/CORE2/Arctic/DATA/nemo-cnrm/CNRM_fram.nc','T_in_Cy4')./1e6;
volume_north7(end+1:720*5,1)=ncgetvar('/work/milicak/RUNS/noresm/CORE2/Arctic/DATA/nemo-cnrm/CNRM_fram.nc','T_in_Cy5')./1e6;
volume_south7=ncgetvar('/work/milicak/RUNS/noresm/CORE2/Arctic/DATA/nemo-cnrm/CNRM_fram.nc','T_out_Cy1')./1e6;
volume_south7(end+1:720*2,1)=ncgetvar('/work/milicak/RUNS/noresm/CORE2/Arctic/DATA/nemo-cnrm/CNRM_fram.nc','T_out_Cy2')./1e6;
volume_south7(end+1:720*3,1)=ncgetvar('/work/milicak/RUNS/noresm/CORE2/Arctic/DATA/nemo-cnrm/CNRM_fram.nc','T_out_Cy3')./1e6;
volume_south7(end+1:720*4,1)=ncgetvar('/work/milicak/RUNS/noresm/CORE2/Arctic/DATA/nemo-cnrm/CNRM_fram.nc','T_out_Cy4')./1e6;
volume_south7(end+1:720*5,1)=ncgetvar('/work/milicak/RUNS/noresm/CORE2/Arctic/DATA/nemo-cnrm/CNRM_fram.nc','T_out_Cy5')./1e6;
volume_north7=reshape(volume_north7,[12 300]);
volume_south7=reshape(volume_south7,[12 300]);
fram_volume_north_cnrm=nanmean(volume_north7,1);
fram_volume_south_cnrm=nanmean(volume_south7,1);

%FSU-HYCOM
volume_north8=ncgetvar('/work/milicak/RUNS/noresm/CORE2/Arctic/DATA/fsu-hycom/Fram_vol_heat_fresh_tr_cyc1-5_glb1x3.nc','vol_trp');
volume_south8=ncgetvar('/work/milicak/RUNS/noresm/CORE2/Arctic/DATA/fsu-hycom/Fram_vol_heat_fresh_tr_cyc1-5_glb1x3.nc','vol_trn');
volume_north8=reshape(volume_north8,[12 300]);
volume_south8=reshape(volume_south8,[12 300]);
fram_volume_north_hycom=nanmean(volume_north8,1);
fram_volume_south_hycom=nanmean(volume_south8,1);


%GFDL-GOLD [TW]
out=load('matfiles/gold_fram_transports.mat');
fram_volume_north_gold=out.fram_volume_inflow*1e-9;
fram_volume_south_gold=out.fram_volume_outflow*1e-9;

%GFDL-MOM [TW]
out=load('matfiles/mom_fram_transports.mat');
fram_volume_outflow=reshape(out.fram_volume_outflow,[12 300]);
fram_volume_inflow=reshape(out.fram_volume_inflow,[12 300]);
fram_volume_north_mom=nanmean(fram_volume_inflow,1)*1e-9;
fram_volume_south_mom=nanmean(fram_volume_outflow,1)*1e-9;

%FESOM [Sv]
volume_north9=ncgetvar('/work/milicak/RUNS/noresm/CORE2/Arctic/DATA/fesom/FESOM_Fram.nc','V_flux_in');
volume_south9=ncgetvar('/work/milicak/RUNS/noresm/CORE2/Arctic/DATA/fesom/FESOM_Fram.nc','V_flux_out');
volume_north9=reshape(volume_north9,[12 300]);
volume_south9=reshape(volume_south9,[12 300]);
fram_volume_north_fesom=nanmean(volume_north9,1);
fram_volume_south_fesom=nanmean(volume_south9,1);

% NOC [Sv]
aa=textread('/bcmhsm/milicak/RUNS/noresm/CORE2/Arctic/DATA/noc/1to5_heat_vol_fw_liquid_transorts/fram_1948to2007_pass1to5_CORE_ORCA1_monthly');
volume_total10=aa(:,15);
volume_total10=reshape(volume_total10,[12 290]);
fram_volume_total_noc=nanmean(volume_total10,1);

% CMCC [Sv]
volume_north10=nc_varget('/bcmhsm/milicak/RUNS/noresm/CORE2/Arctic/DATA/cmcc/CMCC_1m_Vol_flux.nc','Volp_Fram');
volume_total10=nc_varget('/bcmhsm/milicak/RUNS/noresm/CORE2/Arctic/DATA/cmcc/CMCC_1m_Vol_flux.nc','Vol_Fram');
volume_south10=volume_total10-volume_north10;
volume_north10=reshape(volume_north10,[12 300]);
volume_south10=reshape(volume_south10,[12 300]);
fram_volume_north_cmcc=nanmean(volume_north10,1);
fram_volume_south_cmcc=nanmean(volume_south10,1);

% MOM0.25
volume_total11=nc_varget('/bcmhsm/milicak/RUNS/noresm/CORE2/Arctic/DATA/mom0.25/seawater_transport_choke_points.nc','SEAWATER_TRANS_FRAM');
volume_total11=reshape(volume_total11,[12 360]);
fram_volume_total_mom_0_25=nanmean(volume_total11,1);
fram_volume_total_mom_0_25=fram_volume_total_mom_0_25*1e-9; %[Sv]

%FSU-HYCOMv2
volume_north12=ncgetvar('/bcmhsm/milicak/RUNS/noresm/CORE2/Arctic/DATA/fsu-hycom2/Fram_vol_heat_fresh_tr_cyc1-5_fsu-hycom2.nc','vol_trp');
volume_south12=ncgetvar('/bcmhsm/milicak/RUNS/noresm/CORE2/Arctic/DATA/fsu-hycom2/Fram_vol_heat_fresh_tr_cyc1-5_fsu-hycom2.nc','vol_trn');
volume_north12=reshape(volume_north12,[12 300]);
volume_south12=reshape(volume_south12,[12 300]);
fram_volume_north_hycom2=nanmean(volume_north12,1);
fram_volume_south_hycom2=nanmean(volume_south12,1);

save('matfiles/fram_volume_transports','fram_volume_north_cerfacs','fram_volume_north_cnrm','fram_volume_north_geomar','fram_volume_north_gold', ...
                                     'fram_volume_north_hycom','fram_volume_north_mom','fram_volume_north_mri_data','fram_volume_north_mri_free', ...
                                     'fram_volume_north_ncar','fram_volume_north_noresm',...
                                     'fram_volume_south_cerfacs','fram_volume_south_cnrm','fram_volume_south_geomar','fram_volume_south_gold', ...
                                     'fram_volume_south_hycom','fram_volume_south_mom','fram_volume_south_mri_data','fram_volume_south_mri_free', ...
                                     'fram_volume_south_ncar','fram_volume_south_noresm','fram_volume_north_fesom','fram_volume_south_fesom', ...
                                     'fram_volume_total_noc','fram_volume_north_cmcc','fram_volume_south_cmcc','fram_volume_total_mom_0_25', ...
                                     'fram_volume_north_hycom2','fram_volume_south_hycom2')


