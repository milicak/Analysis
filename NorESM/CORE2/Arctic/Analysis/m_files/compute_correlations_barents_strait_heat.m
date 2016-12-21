clear all
load matfiles/barents_heat_transports.mat

a1=barents_heat_north_ncar(end-49:end)+barents_heat_south_ncar(end-49:end);
a2=barents_heat_north_mom(end-49:end)+barents_heat_south_mom(end-49:end);
a3=barents_heat_north_mri_free(end-49:end)+barents_heat_south_mri_free(end-49:end);
a4=barents_heat_north_mri_data(end-49:end)+barents_heat_south_mri_data(end-49:end);
a5=barents_heat_north_hycom(end-49:end)+barents_heat_south_hycom(end-49:end);
a6=barents_heat_north_hycom2(end-49:end)+barents_heat_south_hycom2(end-49:end);
a7=barents_heat_north_noresm(end-49:end)+barents_heat_south_noresm(end-49:end);
a8=barents_heat_north_cnrm(end-49:end)+barents_heat_south_cnrm(end-49:end);
a9=barents_heat_north_gold(end-49:end)+barents_heat_south_gold(end-49:end);
a10=barents_heat_north_cerfacs(end-49:end)+barents_heat_south_cerfacs(end-49:end);
a11=-(barents_heat_north_fesom(end-49:end)+barents_heat_south_fesom(end-49:end));
a12=barents_heat_north_geomar(end-49:end)+barents_heat_south_geomar(end-49:end);
a13=barents_heat_total_cmcc(end-49:end);
a14=barents_heat_total_noc(end-47:end);
dnm(1:length(a14))=a14;
dnm(end+1)=a14(end);dnm(end+1)=a14(end);
a14=dnm;
%a15=barents_heat_total_mom_0_25(end-49:end);
a15=barents_heat_total_mom_0_25(278:327);


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

%A=[detrend(a1','constant') detrend(a2','constant') detrend(a3','constant') detrend(a4','constant') detrend(a5','constant') ...
%   detrend(a6','constant') detrend(a7','constant') detrend(a8','constant') detrend(a9','constant') detrend(a10','constant') ... 
%   detrend(a11','constant') detrend(a12','constant') detrend(a13','constant') detrend(a14','constant') detrend(a15','constant')];
   
AL=[detrend(a11L','constant') detrend(a7L','constant') detrend(a10L','constant') detrend(a13L','constant') detrend(a8L','constant') ...
   detrend(a5L','constant') detrend(a6L','constant') detrend(a9L','constant') detrend(a2L','constant') detrend(a12L','constant') ... 
   detrend(a15L','constant') detrend(a4L','constant') detrend(a3L','constant') detrend(a1L','constant') detrend(a14L','constant')];

AH=[detrend(a11H','constant') detrend(a7H','constant') detrend(a10H','constant') detrend(a13H','constant') detrend(a8H','constant') ...
   detrend(a5H','constant') detrend(a6H','constant') detrend(a9H','constant') detrend(a2H','constant') detrend(a12H','constant') ... 
   detrend(a15H','constant') detrend(a4H','constant') detrend(a3H','constant') detrend(a1H','constant') detrend(a14H','constant')];
   
barents_heat_corr=corr(A);
barents_heat_corr_LP=corr(AL);
barents_heat_corr_HP=corr(AH);
for k=1:15
  barents_heat_corr(k,k+1:end)=NaN;
  barents_heat_corr_LP(k,k+1:end)=NaN;
  barents_heat_corr_HP(k,k+1:end)=NaN;
end


keyboard
figure(1)
imagescwithnan(flipud(barents_heat_corr),jet,[.7 .7 .7])
set(gca,'yticklabel',{'14' '12' '10' '8' '6' '4' '2'})
%text(10,11,{'NCAR','GFDL-MOM','MRI-F','MRI-A','FSU-HYCOM','FSU-HYCOMv2','BERGEN','CNRM','GFDL-GOLD','CERFACS','AWI-FESOM','Kiel-ORCA05','CMCC-ORCA','NOC-ORCA','MOM-0.25'},'fontsize',14)
text(10,11,{'AWI-FESOM','Bergen','CERFACS','CMCC','CNRM', ...
       'FSU-HYCOM','FSU-HYCOMv2','GFDL-GOLD', 'GFDL-MOM','Kiel-ORCA05', ...
       'MOM0.25','MRI-A','MRI-F','NCAR','NOC',},'fontsize',14)

figure(2)
imagescwithnan(flipud(barents_heat_corr_LP),jet,[.7 .7 .7])
set(gca,'yticklabel',{'14' '12' '10' '8' '6' '4' '2'})
%hh=text(11,10.5,{'1:NCAR','2:GFDL-MOM','3:MRI-F','4:MRI-A','5:FSU-HYCOM','6:FSU-HYCOMv2','7:BERGEN','8:CNRM','9:GFDL-GOLD','10:CERFACS','11:AWI-FESOM','12:Kiel-ORCA05','13:CMCC-ORCA','14:NOC-ORCA','15:MOM-0.25'},'fontsize',13);
%set(hh,'BackgroundColor','w')
%caxis([0.38 1])
printname=['paperfigs2/barents_heat_corr_low']
print(2,'-depsc2',printname)

figure(3)
imagescwithnan(flipud(barents_heat_corr_HP),jet,[.7 .7 .7])
set(gca,'yticklabel',{'14' '12' '10' '8' '6' '4' '2'})
%caxis([0.38 1])
printname=['paperfigs2/barents_heat_corr_high']
print(3,'-depsc2',printname)

% white in the middle
myColorMap(32,:)=[1 1 1];   
myColorMap(33,:)=[1 1 1];
colormap(myColorMap)

close all
set(gca,'yticklabel',{'2' '4' '6' '8' '10' '12' '14'})
set(gca,'ytick',[2.5:2:16])                           
set(gca,'xtick',[2.5:2:16])
set(gca,'xticklabel',{'2' '4' '6' '8' '10' '12' '14'})
printname=['paperfigs2/barents_heat_corr_low_v2']
print(1,'-depsc2','-r300',printname)

