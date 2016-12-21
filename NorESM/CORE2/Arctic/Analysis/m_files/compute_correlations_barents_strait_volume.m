clear all
load matfiles/barents_volume_transports.mat
coef1=49;

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
dnm(1:length(a14))=a14;
dnm(end+1)=a14(end);dnm(end+1)=a14(end);
a14=dnm;
%a15=barents_volume_total_mom_0_25(end-coef1:end);
a15=barents_volume_total_mom_0_25(278:327);


T1 = 1; % delta T is 1 year
f1 = 1/T1; % frequency;
fN = 1/2*f1; %Nyquist frequency;
cutoff = 7; % years in curoff
fC = 1/cutoff; %
N = 4; %Nth order lowpass digital
[b a] = butter(N,fC/fN,'low');
a1L = filtfilt(b, a, a1); a2L = filtfilt(b, a, a2); a3L = filtfilt(b, a, a3); a4L = filtfilt(b, a, a4); a5L = filtfilt(b, a, a5);
a6L = filtfilt(b, a, a6); a7L = filtfilt(b, a, a7); a8L = filtfilt(b, a, a8); a9L = filtfilt(b, a, a9); a10L = filtfilt(b, a, a10);
a11L = filtfilt(b, a, a11); a12L = filtfilt(b, a, a12); a13L = filtfilt(b, a, a13); a14L = filtfilt(b, a, a14); a15L = filtfilt(b, a, a15);

[b a] = butter(N,fC/fN,'high');
a1H = filtfilt(b, a, a1); a2H = filtfilt(b, a, a2); a3H = filtfilt(b, a, a3); a4H = filtfilt(b, a, a4); a5H = filtfilt(b, a, a5);
a6H = filtfilt(b, a, a6); a7H = filtfilt(b, a, a7); a8H = filtfilt(b, a, a8); a9H = filtfilt(b, a, a9); a10H = filtfilt(b, a, a10);
a11H = filtfilt(b, a, a11); a12H = filtfilt(b, a, a12); a13H = filtfilt(b, a, a13); a14H = filtfilt(b, a, a14); a15H = filtfilt(b, a, a15);
	
A=[detrend(a11','constant') detrend(a7','constant') detrend(a10','constant') detrend(a13','constant') detrend(a8','constant') ...
   detrend(a5','constant') detrend(a6','constant') detrend(a9','constant') detrend(a2','constant') detrend(a12','constant') ...
   detrend(a15','constant') detrend(a4','constant') detrend(a3','constant') detrend(a1','constant') detrend(a14','constant')];

AL=[detrend(a11L','constant') detrend(a7L','constant') detrend(a10L','constant') detrend(a13L','constant') detrend(a8L','constant') ...
   detrend(a5L','constant') detrend(a6L','constant') detrend(a9L','constant') detrend(a2L','constant') detrend(a12L','constant') ...
   detrend(a15L','constant') detrend(a4L','constant') detrend(a3L','constant') detrend(a1L','constant') detrend(a14L','constant')];

AH=[detrend(a11H','constant') detrend(a7H','constant') detrend(a10H','constant') detrend(a13H','constant') detrend(a8H','constant') ...
   detrend(a5H','constant') detrend(a6H','constant') detrend(a9H','constant') detrend(a2H','constant') detrend(a12H','constant') ...
   detrend(a15H','constant') detrend(a4H','constant') detrend(a3H','constant') detrend(a1H','constant') detrend(a14H','constant')];

AL2=[a1L' a2L' a3L' a4L' a5L' ...
   a6L' a7L' a8L' a9L' a10L' ... 
   a11L' a12L' a13L' a14L' a15L'];

   
barents_volume_corr=corr(A);
barents_volume_corr_LP=corr(AL);
barents_volume_corr_LP2=corr(AL2);
barents_volume_corr_HP=corr(AH);
for k=1:15
  barents_volume_corr(k,k+1:end)=NaN;
  barents_volume_corr_LP(k,k+1:end)=NaN;
  barents_volume_corr_LP2(k,k+1:end)=NaN;
  barents_volume_corr_HP(k,k+1:end)=NaN;
end

keyboard
figure(1)
imagescwithnan(flipud(barents_volume_corr),jet,[.7 .7 .7])
set(gca,'yticklabel',{'14' '12' '10' '8' '6' '4' '2'})
hh=text(11,10.5,{'1:NCAR','2:GFDL-MOM','3:MRI-F','4:MRI-A','5:FSU-HYCOM','6:FSU-HYCOMv2','7:BERGEN','8:CNRM','9:GFDL-GOLD','10:CERFACS','11:AWI-FESOM','12:Kiel-ORCA05','13:CMCC-ORCA','14:NOC-ORCA','15:MOM-0.25'},'fontsize',13);
set(hh,'BackgroundColor','w')

figure(2)
imagescwithnan(flipud(barents_volume_corr_LP),jet,[.7 .7 .7])
set(gca,'yticklabel',{'14' '12' '10' '8' '6' '4' '2'})
%hh=text(11,10.5,{'1:NCAR','2:GFDL-MOM','3:MRI-F','4:MRI-A','5:FSU-HYCOM','6:FSU-HYCOMv2','7:BERGEN','8:CNRM','9:GFDL-GOLD','10:CERFACS','11:AWI-FESOM','12:Kiel-ORCA05','13:CMCC-ORCA','14:NOC-ORCA','15:MOM-0.25'},'fontsize',13);
%set(hh,'BackgroundColor','w')
caxis([0.38 1])
printname=['paperfigs2/barents_volume_corr_low']
print(2,'-depsc2',printname)

figure(3)
imagescwithnan(flipud(barents_volume_corr_HP),jet,[.7 .7 .7])
set(gca,'yticklabel',{'14' '12' '10' '8' '6' '4' '2'})
printname=['paperfigs2/barents_volume_corr_high']
print(3,'-depsc2',printname)

close all
marpcolor((barents_volume_corr_LP));shf
set(gca,'yticklabel',{'2' '4' '6' '8' '10' '12' '14'})
set(gca,'ytick',[2.5:2:16])                           
set(gca,'xtick',[2.5:2:16])
set(gca,'xticklabel',{'2' '4' '6' '8' '10' '12' '14'})
printname=['paperfigs2/barents_volume_corr_low_v2']
print(1,'-depsc2','-r300',printname)

