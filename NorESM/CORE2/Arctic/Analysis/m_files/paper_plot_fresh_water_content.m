clear all

load matfiles/fwmapping_obs_forcoreiipaper.mat

m_proj('stereographic','lat',90,'long',0,'radius',20);
%m_scatter(lons,lats,250,hfw1993to2002,'.','filled');colorbar
m_scatter(lons,lats,50,hfw1993to2002,'filled');colorbar
m_coast('patch',[.7 .7 .7])
m_grid
caxis([0 30])
colorbar off
printname=['paperfigs/FWC_observations'];
print(1,'-depsc2','-r150',printname)
close

m_proj('stereographic','lat',90,'long',0,'radius',20);
%m_scatter(lons,lats,250,hfw2003to2007-hfw1993to2002,'.');colorbar
m_scatter(lons,lats,50,hfw2003to2007-hfw1993to2002,'filled');colorbar
m_coast('patch',[.7 .7 .7])
m_grid
caxis([-6 6])
needJet2
colorbar off
printname=['paperfigs/FWC_observations2'];
print(1,'-depsc2','-r150',printname)
close



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
out=load('matfiles/woa_fresh_water_content.mat');
FWC=out.FWC;

m_proj('stereographic','lat',90,'long',30,'radius',25);
m_pcolor(out.lon,out.lat,FWC);shading flat;colorbar
m_coast('patch',[.7 .7 .7]);
m_grid
caxis([0 30])
colorbar off

printname=['paperfigs/FWC_woa'];
print(1,'-depsc2','-r150',printname)
close

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
out=load('matfiles/mom_0_25_fresh_water_content.mat');
FWC=squeeze(nanmean(squeeze(out.FWC(:,:,10:11)),3));
FWC2=squeeze(nanmean(squeeze(out.FWC(:,:,12:12)),3));

m_proj('stereographic','lat',90,'long',0,'radius',20);
m_pcolor(out.lon,out.lat,FWC);shading flat;colorbar
m_coast('patch',[.7 .7 .7]);
m_grid
caxis([0 30])
colorbar off

printname=['paperfigs/FWC_mom_0_25'];
print(1,'-depsc2','-r150',printname)
close

m_proj('stereographic','lat',90,'long',0,'radius',20);
m_pcolor(out.lon,out.lat,FWC2-FWC);shading flat;colorbar
m_coast('patch',[.7 .7 .7]);
m_grid
caxis([-6 6])
needJet2
colorbar off
printname=['paperfigs/FWC_mom_0_252'];
print(1,'-depsc2','-r150',printname)
close

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
out=load('matfiles/cmcc_orca_fresh_water_content.mat');
FWC=squeeze(nanmean(squeeze(out.FWC(:,:,58:59)),3));
FWC2=squeeze(nanmean(squeeze(out.FWC(:,:,60:60)),3));

m_proj('stereographic','lat',90,'long',0,'radius',20);
m_pcolor(out.lon,out.lat,FWC);shading flat;colorbar
m_coast('patch',[.7 .7 .7]);
m_grid
caxis([0 30])
colorbar off

printname=['paperfigs/FWC_cmcc'];
print(1,'-depsc2','-r150',printname)
close

m_proj('stereographic','lat',90,'long',0,'radius',20);
m_pcolor(out.lon,out.lat,FWC2-FWC);shading flat;colorbar
m_coast('patch',[.7 .7 .7]);
m_grid
caxis([-6 6])
needJet2
colorbar off
printname=['paperfigs/FWC_cmcc2'];
print(1,'-depsc2','-r150',printname)
close


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
out=load('matfiles/noc_orca_fresh_water_content.mat');
FWC=squeeze(nanmean(squeeze(out.FWC(:,:,59:60)),3));
FWC2=squeeze(nanmean(squeeze(out.FWC(:,:,61:61)),3));

m_proj('stereographic','lat',90,'long',0,'radius',20);
m_pcolor(out.lon,out.lat,FWC);shading flat;colorbar
m_coast('patch',[.7 .7 .7]);
m_grid
caxis([0 30])
colorbar off

printname=['paperfigs/FWC_noc'];
print(1,'-depsc2','-r150',printname)
close

m_proj('stereographic','lat',90,'long',0,'radius',20);
m_pcolor(out.lon,out.lat,FWC2-FWC);shading flat;colorbar
m_coast('patch',[.7 .7 .7]);
m_grid
caxis([-6 6])
needJet2
colorbar off
printname=['paperfigs/FWC_noc2'];
print(1,'-depsc2','-r150',printname)
close
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
out=load('matfiles/fesom_fresh_water_content.mat');
FWC=squeeze(nanmean(squeeze(out.FWC(:,:,58:59)),3));
FWC2=squeeze(nanmean(squeeze(out.FWC(:,:,60:60)),3));

m_proj('stereographic','lat',90,'long',0,'radius',20);
m_pcolor(out.lon,out.lat,FWC);shading flat;colorbar
m_coast('patch',[.7 .7 .7]);
m_grid
caxis([0 30])
colorbar off

printname=['paperfigs/FWC_fesom'];
print(1,'-depsc2','-r150',printname)
close

m_proj('stereographic','lat',90,'long',0,'radius',20);
m_pcolor(out.lon,out.lat,FWC2-FWC);shading flat;colorbar
m_coast('patch',[.7 .7 .7]);
m_grid
caxis([-6 6])
needJet2
colorbar off
printname=['paperfigs/FWC_fesom2'];
print(1,'-depsc2','-r150',printname)
close
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
out=load('matfiles/mir_free_fresh_water_content.mat');
FWC=squeeze(nanmean(squeeze(out.FWC(:,:,58:59)),3));
FWC2=squeeze(nanmean(squeeze(out.FWC(:,:,60:60)),3));

m_proj('stereographic','lat',90,'long',0,'radius',20);
m_pcolor(out.lon,out.lat,FWC);shading flat;colorbar
m_coast('patch',[.7 .7 .7]);
m_grid
caxis([0 30])
colorbar off

printname=['paperfigs/FWC_mir_free'];
print(1,'-depsc2','-r150',printname)
close

m_proj('stereographic','lat',90,'long',0,'radius',20);
m_pcolor(out.lon,out.lat,FWC2-FWC);shading flat;colorbar
m_coast('patch',[.7 .7 .7]);
m_grid
caxis([-6 6])
needJet2
colorbar off
printname=['paperfigs/FWC_mir_free2'];
print(1,'-depsc2','-r150',printname)
close

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
out=load('matfiles/mir_data_fresh_water_content.mat');
FWC=squeeze(nanmean(squeeze(out.FWC(:,:,10:11)),3));
FWC2=squeeze(nanmean(squeeze(out.FWC(:,:,12:12)),3));

m_proj('stereographic','lat',90,'long',0,'radius',20);
m_pcolor(out.lon,out.lat,FWC);shading flat;colorbar
m_coast('patch',[.7 .7 .7]);
m_grid
caxis([0 30])
colorbar off

printname=['paperfigs/FWC_mir_data'];
print(1,'-depsc2','-r150',printname)
close

m_proj('stereographic','lat',90,'long',0,'radius',20);
m_pcolor(out.lon,out.lat,FWC2-FWC);shading flat;colorbar
m_coast('patch',[.7 .7 .7]);
m_grid
caxis([-6 6])
needJet2
colorbar off
printname=['paperfigs/FWC_mir_data2'];
print(1,'-depsc2','-r150',printname)
close

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
out=load('matfiles/nemo_cerfacs_fresh_water_content.mat');
FWC=squeeze(nanmean(squeeze(out.FWC(:,:,30:30)),3));

m_proj('stereographic','lat',90,'long',0,'radius',20);
m_pcolor(out.lon,out.lat,FWC);shading flat;colorbar
m_coast('patch',[.7 .7 .7]);
m_grid
caxis([0 30])
colorbar off

printname=['paperfigs/FWC_nemo_cerfacs'];
print(1,'-depsc2','-r150',printname)
close

clear FWC
FWC=ncgetvar('/bcmhsm/milicak/RUNS/noresm/CORE2/Arctic/DATA/nemo-cerfacs/CERFACS_FWdiff.nc','FWdiff');
m_proj('stereographic','lat',90,'long',0,'radius',20);
m_pcolor(out.lon,out.lat,FWC);shading flat;colorbar
m_coast('patch',[.7 .7 .7]);
m_grid
caxis([-6 6])
needJet2
colorbar off

printname=['paperfigs/FWC_nemo_cerfacs2'];
print(1,'-depsc2','-r150',printname)
close

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
out=load('matfiles/nemo_cnrm_fresh_water_content.mat');
FWC=squeeze(nanmean(squeeze(out.FWC(:,:,30:30)),3));

m_proj('stereographic','lat',90,'long',0,'radius',20);
m_pcolor(out.lon,out.lat,FWC);shading flat;colorbar
m_coast('patch',[.7 .7 .7]);
m_grid
caxis([0 30])
colorbar off

printname=['paperfigs/FWC_nemo_cnrm'];
print(1,'-depsc2','-r150',printname)
close

clear FWC
FWC=ncgetvar('/bcmhsm/milicak/RUNS/noresm/CORE2/Arctic/DATA/nemo-cnrm/CNRM_FWdiff.nc','FWdiff');
m_proj('stereographic','lat',90,'long',0,'radius',20);
m_pcolor(out.lon,out.lat,FWC);shading flat;colorbar
m_coast('patch',[.7 .7 .7]);
m_grid
caxis([-6 6])
needJet2
colorbar off

printname=['paperfigs/FWC_nemo_cnrm2'];
print(1,'-depsc2','-r150',printname)
close


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
out=load('matfiles/gfdl_mom_fresh_water_content.mat');
FWC=squeeze(nanmean(squeeze(out.FWC(:,:,286:295)),3));
FWC2=squeeze(nanmean(squeeze(out.FWC(:,:,296:300)),3));

m_proj('stereographic','lat',90,'long',0,'radius',20);
m_pcolor(out.lon,out.lat,FWC);shading flat;colorbar
m_coast('patch',[.7 .7 .7]);
m_grid
caxis([0 30])
colorbar off

printname=['paperfigs/FWC_gfdl_mom'];
print(1,'-depsc2','-r150',printname)
close

m_proj('stereographic','lat',90,'long',0,'radius',20);
m_pcolor(out.lon,out.lat,FWC2-FWC);shading flat;colorbar
m_coast('patch',[.7 .7 .7]);
m_grid
caxis([-6 6])
needJet2
colorbar off
printname=['paperfigs/FWC_gfdl_mom2'];
print(1,'-depsc2','-r150',printname)
close

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
out=load('matfiles/gfdl_gold_fresh_water_content.mat');
FWC=squeeze(nanmean(squeeze(out.FWC(:,:,286:295)),3));
FWC2=squeeze(nanmean(squeeze(out.FWC(:,:,296:300)),3));

m_proj('stereographic','lat',90,'long',0,'radius',20);
m_pcolor(out.lon,out.lat,FWC);shading flat;colorbar
m_coast('patch',[.7 .7 .7]);
m_grid
caxis([0 30])
colorbar off

printname=['paperfigs/FWC_gfdl_gold'];
print(1,'-depsc2','-r150',printname)
close

m_proj('stereographic','lat',90,'long',0,'radius',20);
m_pcolor(out.lon,out.lat,FWC2-FWC);shading flat;colorbar
m_coast('patch',[.7 .7 .7]);
m_grid
caxis([-6 6])
needJet2
colorbar off
printname=['paperfigs/FWC_gfdl_gold2'];
print(1,'-depsc2','-r150',printname)
close

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
out=load('matfiles/ncar_pop_fresh_water_content.mat');
FWC=squeeze(nanmean(squeeze(out.FWC(:,:,58:59)),3));
FWC2=squeeze(nanmean(squeeze(out.FWC(:,:,60:60)),3));

m_proj('stereographic','lat',90,'long',0,'radius',20);
m_pcolor(out.lon,out.lat,FWC);shading flat;colorbar
m_coast('patch',[.7 .7 .7]);
m_grid
caxis([0 30])
colorbar off

printname=['paperfigs/FWC_ncar_pop'];
print(1,'-depsc2','-r150',printname)
close

m_proj('stereographic','lat',90,'long',0,'radius',20);
m_pcolor(out.lon,out.lat,FWC2-FWC);shading flat;colorbar
m_coast('patch',[.7 .7 .7]);
m_grid
caxis([-6 6])
needJet2
colorbar off
printname=['paperfigs/FWC_ncar_pop2'];
print(1,'-depsc2','-r150',printname)
close

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
out=load('matfiles/geomar_orca_fresh_water_content.mat');
FWC=squeeze(nanmean(squeeze(out.FWC(:,:,58:59)),3));
FWC2=squeeze(nanmean(squeeze(out.FWC(:,:,60:60)),3));

m_proj('stereographic','lat',90,'long',0,'radius',20);
m_pcolor(out.lon,out.lat,FWC);shading flat;colorbar
m_coast('patch',[.7 .7 .7]);
m_grid
caxis([0 30])
colorbar off

printname=['paperfigs/FWC_geomar_orca'];
print(1,'-depsc2','-r150',printname)
close

m_proj('stereographic','lat',90,'long',0,'radius',20);
m_pcolor(out.lon,out.lat,FWC2-FWC);shading flat;colorbar
m_coast('patch',[.7 .7 .7]);
m_grid
caxis([-6 6])
needJet2
colorbar off
printname=['paperfigs/FWC_geomar_orca2'];
print(1,'-depsc2','-r150',printname)
close

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
out=load('matfiles/fsu_hycom_fresh_water_content.mat');
FWC=squeeze(nanmean(squeeze(out.FWC(:,:,58:59)),3));
FWC2=squeeze(nanmean(squeeze(out.FWC(:,:,60:60)),3));

m_proj('stereographic','lat',90,'long',0,'radius',20);
m_pcolor(out.lon,out.lat,FWC);shading flat;colorbar
m_coast('patch',[.7 .7 .7]);
m_grid
caxis([0 30])
colorbar off

printname=['paperfigs/FWC_fsu_hycom'];
print(1,'-depsc2','-r150',printname)
close

m_proj('stereographic','lat',90,'long',0,'radius',20);
m_pcolor(out.lon,out.lat,FWC2-FWC);shading flat;colorbar
m_coast('patch',[.7 .7 .7]);
m_grid
caxis([-6 6])
needJet2
colorbar off
printname=['paperfigs/FWC_fsu_hycom2'];
print(1,'-depsc2','-r150',printname)
close

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
out=load('matfiles/fsu_hycom2_fresh_water_content.mat');
FWC=squeeze(nanmean(squeeze(out.FWC(:,:,10:11)),3));
FWC2=squeeze(nanmean(squeeze(out.FWC(:,:,12:12)),3));

m_proj('stereographic','lat',90,'long',0,'radius',20);
m_pcolor(out.lon,out.lat,FWC);shading flat;colorbar
m_coast('patch',[.7 .7 .7]);
m_grid
caxis([0 30])
colorbar off

printname=['paperfigs2/FWC_fsu_hycom2v1'];
print(1,'-depsc2','-r150',printname)
close

m_proj('stereographic','lat',90,'long',0,'radius',20);
m_pcolor(out.lon,out.lat,FWC2-FWC);shading flat;colorbar
m_coast('patch',[.7 .7 .7]);
m_grid
caxis([-6 6])
needJet2
colorbar off
printname=['paperfigs2/FWC_fsu_hycom2v2'];
print(1,'-depsc2','-r150',printname)
close



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
out=load('matfiles/noresm_micom_fresh_water_content.mat');
FWC=squeeze(nanmean(squeeze(out.FWC(:,:,541:660)),3));
FWC2=squeeze(nanmean(squeeze(out.FWC(:,:,661:720)),3));

m_proj('stereographic','lat',90,'long',0,'radius',20);
m_pcolor(out.lon,out.lat,FWC);shading flat;colorbar
m_coast('patch',[.7 .7 .7]);
m_grid
caxis([0 30])
colorbar off

printname=['paperfigs/FWC_noresm_micom'];
print(1,'-depsc2','-r150',printname)
close

m_proj('stereographic','lat',90,'long',0,'radius',20);
m_pcolor(out.lon,out.lat,FWC2-FWC);shading flat;colorbar
m_coast('patch',[.7 .7 .7]);
m_grid
caxis([-6 6])
needJet2
colorbar off
printname=['paperfigs/FWC_noresm_micom2'];
print(1,'-depsc2','-r150',printname)
close

break


fig1=figure;
left=100; bottom=100 ; width=80 ; height=500;
pos=[left bottom width height];
axis off
colorbar([0.1 0.1  0.4  0.8]);

set(fig1,'OuterPosition',pos) 


colormap('jet');
cbar_handle = colorbar;
caxis([0 30])
set(gcf,'color','w'); 
export_fig(cbar_handle, 'colorbar_v1.eps');
close


figure
colorbar([0.1 0.1  0.4  0.8]);
caxis([-6 6])
needJet2
cbar_handle = colorbar;
set(gcf,'color','w'); 
export_fig(cbar_handle, 'colorbar_v2.eps');
close
















