clear all


matfile = 'matfiles/om3_core3_2_FWC_time.mat';
out1 = load(matfile);
matfile = 'matfiles/om3_core3_2_BG_pos_FWC_time.mat';
out2 = load(matfile);
matfile = 'matfiles/om3_core3_2_BG_neg_FWC_time.mat';
out3 = load(matfile);
aname = '/export/grunchfs/unibjerknes/milicak/bckup/noresm/CORE2/Arctic/DATA/gfdl-mom/grids_bathymetry/ocean.static.nc';
mname = ['/fimm/home/bjerknes/milicak/Analysis/mom/APE/Analysis/grid_spec_v6_regMask.nc'];
lon=ncread(mname,'geolon_t');
lat=ncread(mname,'geolat_t');
area = ncread(aname,'area_t');
area = repmat(area,[1 1 size(out1.FWC,3)]);

FWC = containers.Map
dnm = out1.FWC_BG.*area;
dnm = squeeze(nansum(dnm,1));
dnm = squeeze(nansum(dnm,1));
FWC('ctrl') = dnm(397:end);
dnm = out2.FWC_BG.*area;
dnm = squeeze(nansum(dnm,1));
dnm = squeeze(nansum(dnm,1));
FWC('BG_pos') = dnm(397:end);
dnm = out3.FWC_BG.*area;
dnm = squeeze(nansum(dnm,1));
dnm = squeeze(nansum(dnm,1));
FWC('BG_neg') = dnm(397:end);

savename = ['matfiles/FWC_BG_all_time.mat']
save(savename,'FWC')


figure(1)
plot((FWC('BG_pos')-FWC('ctrl'))*1e-12)
hold on
plot((FWC('BG_neg')-FWC('ctrl'))*1e-12,'r')
title('FWC BG')
ylim([-8 8])
legend('BG-pos','BG-neg','location','northwest')
printname = ['paperfigs/FWC_anomaly.png'];
print(1,'-dpng','-r300',printname)

% year 1 mean
tindex = (1980-1947)*12 +1;
dnm1 = out1.FWC(:,:,tindex:tindex+11);
dnm1 = squeeze(nanmean(dnm1,3));
dnm2 = out2.FWC(:,:,tindex:tindex+11);
dnm2 = squeeze(nanmean(dnm2,3));
dnm3 = out3.FWC(:,:,tindex:tindex+11);
dnm3 = squeeze(nanmean(dnm3,3));
figure(2)
m_projpolar
m_pcolor(lon,lat,dnm2-dnm1);shf
m_coast('patch',[.7 .7 .7])
m_grid
title('BG-pos FWC anomaly year 1')
printname = ['paperfigs/FWC_anomaly_BG_pos_year1.png'];
print(2,'-dpng','-r300',printname)


figure(3)
m_projpolar
m_pcolor(lon,lat,dnm3-dnm1);shf
m_coast('patch',[.7 .7 .7])
m_grid
title('BG-neg FWC anomaly year 1')
printname = ['paperfigs/FWC_anomaly_BG_neg_year1.png'];
print(3,'-dpng','-r300',printname)


% year 5 mean
tindex = (1985-1947)*12 +1;
dnm1 = out1.FWC(:,:,tindex:tindex+11);
dnm1 = squeeze(nanmean(dnm1,3));
dnm2 = out2.FWC(:,:,tindex:tindex+11);
dnm2 = squeeze(nanmean(dnm2,3));
dnm3 = out3.FWC(:,:,tindex:tindex+11);
dnm3 = squeeze(nanmean(dnm3,3));

figure(4)
m_projpolar
m_pcolor(lon,lat,dnm2-dnm1);shf
m_coast('patch',[.7 .7 .7])
m_grid
title('BG-pos FWC anomaly year 5')
printname = ['paperfigs/FWC_anomaly_BG_pos_year5.png'];
print(4,'-dpng','-r300',printname)


figure(5)
m_projpolar
m_pcolor(lon,lat,dnm3-dnm1);shf
m_coast('patch',[.7 .7 .7])
m_grid
title('BG-neg FWC anomaly year 5')
printname = ['paperfigs/FWC_anomaly_BG_neg_year5.png'];
print(5,'-dpng','-r300',printname)


% year 10 mean
tindex = (1990-1947)*12 +1;
dnm1 = out1.FWC(:,:,tindex:tindex+11);
dnm1 = squeeze(nanmean(dnm1,3));
dnm2 = out2.FWC(:,:,tindex:tindex+11);
dnm2 = squeeze(nanmean(dnm2,3));
dnm3 = out3.FWC(:,:,tindex:tindex+11);
dnm3 = squeeze(nanmean(dnm3,3));

figure(6)
m_projpolar
m_pcolor(lon,lat,dnm2-dnm1);shf
m_coast('patch',[.7 .7 .7])
m_grid
title('BG-pos FWC anomaly year 10')
printname = ['paperfigs/FWC_anomaly_BG_pos_year10.png'];
print(6,'-dpng','-r300',printname)


figure(7)
m_projpolar
m_pcolor(lon,lat,dnm3-dnm1);shf
m_coast('patch',[.7 .7 .7])
m_grid
title('BG-neg FWC anomaly year 10')
printname = ['paperfigs/FWC_anomaly_BG_neg_year10.png'];
print(7,'-dpng','-r300',printname)


% year 15 mean
tindex = (1995-1947)*12 +1;
dnm1 = out1.FWC(:,:,tindex:tindex+11);
dnm1 = squeeze(nanmean(dnm1,3));
dnm2 = out2.FWC(:,:,tindex:tindex+11);
dnm2 = squeeze(nanmean(dnm2,3));
dnm3 = out3.FWC(:,:,tindex:tindex+11);
dnm3 = squeeze(nanmean(dnm3,3));

figure(6)
m_projpolar
m_pcolor(lon,lat,dnm2-dnm1);shf
m_coast('patch',[.7 .7 .7])
m_grid
title('BG-pos FWC anomaly year 15')
printname = ['paperfigs/FWC_anomaly_BG_pos_year15.png'];
print(6,'-dpng','-r300',printname)


figure(7)
m_projpolar
m_pcolor(lon,lat,dnm3-dnm1);shf
m_coast('patch',[.7 .7 .7])
m_grid
title('BG-neg FWC anomaly year 15')
printname = ['paperfigs/FWC_anomaly_BG_neg_year15.png'];



print(3,'-dpng','-r300',printname)
