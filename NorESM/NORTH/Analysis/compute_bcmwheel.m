clear all
dn=10;
met='tri';
lw=2;
alpha_T=0.2; %kgm-3
beta_S=0.8;  %kgm-3
grav=9.81; %m/s2
f=1.31e-4; %1/s coriolis for Denmark Strait
rho0=1027; %kg/m3

%load('matfiles/NAER1850CNOC_f19_g16_03_1_299_tempsalttransports.mat');
%load('matfiles/NorESM1-M_NAER1850CNOC_f19_g16_03_1_299_Bering_transports.mat')
%load('matfiles/NorESM1-M_NAER1850CNOC_f19_g16_03_1_299_CAA_transports.mat')
%load('matfiles/NorESM1-M_NAER1850CNOC_f19_g16_03_1_299_heatflux.mat')
%load('matfiles/NorESM1-M_NAER1850CNOC_f19_g16_03_1_299_saltflux.mat')

load('matfiles/NAER1850CNOC_f19_g16_05_600_699_tempsalttransports.mat');
load('matfiles/NorESM1-M_NAER1850CNOC_f19_g16_05_600_699_Bering_transports.mat')
load('matfiles/NorESM1-M_NAER1850CNOC_f19_g16_05_600_699_CAA_transports.mat')
load('matfiles/NorESM1-M_NAER1850CNOC_f19_g16_05_600_699_heatflux.mat')
load('matfiles/NorESM1-M_NAER1850CNOC_f19_g16_05_600_699_saltflux.mat')

%out=load('matfiles/NAER1850CNOC_f19_g16_04_300_599_tempsalttransports.mat');
out=load('matfiles/NAER1850CNOC_f19_g16_06_700_1200_tempsalttransports.mat');
TEGC(end+1:end+1+length(out.TEGC)-1)=out.TEGC;
TAW(end+1:end+1+length(out.TEGC)-1)=out.TAW;
TOW(end+1:end+1+length(out.TEGC)-1)=out.TOW;
SEGC(end+1:end+1+length(out.TEGC)-1)=out.SEGC;
SAW(end+1:end+1+length(out.TEGC)-1)=out.SAW;
SOW(end+1:end+1+length(out.TEGC)-1)=out.SOW;
TrEGC(end+1:end+1+length(out.TEGC)-1)=out.TrEGC;
TrAW(end+1:end+1+length(out.TEGC)-1)=out.TrAW;
TrOW(end+1:end+1+length(out.TEGC)-1)=out.TrOW;
HTrEGC(end+1:end+1+length(out.TEGC)-1)=out.HTrEGC;
HTrAW(end+1:end+1+length(out.TEGC)-1)=out.HTrAW;
HTrOW(end+1:end+1+length(out.TEGC)-1)=out.HTrOW;
STrEGC(end+1:end+1+length(out.TEGC)-1)=out.STrEGC;
STrAW(end+1:end+1+length(out.TEGC)-1)=out.STrAW;
STrOW(end+1:end+1+length(out.TEGC)-1)=out.STrOW;

%out=load('matfiles/NorESM1-M_NAER1850CNOC_f19_g16_04_300_599_Bering_transports.mat');
out=load('matfiles/NorESM1-M_NAER1850CNOC_f19_g16_06_700_1200_Bering_transports.mat');
TrBS(end+1:end+1+length(out.TrBS)-1)=out.TrBS;
HTrBS(end+1:end+1+length(out.TrBS)-1)=out.HTrBS;
STrBS(end+1:end+1+length(out.TrBS)-1)=out.STrBS;
%out=load('matfiles/NorESM1-M_NAER1850CNOC_f19_g16_04_300_599_CAA_transports.mat');
out=load('matfiles/NorESM1-M_NAER1850CNOC_f19_g16_06_700_1200_CAA_transports.mat');
TrCAA(end+1:end+1+length(out.TrCAA)-1)=out.TrCAA;
HTrCAA(end+1:end+1+length(out.TrCAA)-1)=out.HTrCAA;
STrCAA(end+1:end+1+length(out.TrCAA)-1)=out.STrCAA;

out=load('matfiles/NorESM1-M_NAER1850CNOC_f19_g16_06_700_1200_EC_transports.mat');
TrEC(1:1200)=0;
HTrEC(1:1200)=0;
STrEC(1:1200)=0;
TrEC(end+1:end+1+length(out.TrEC)-1)=out.TrEC;
HTrEC(end+1:end+1+length(out.TrEC)-1)=out.HTrEC;
STrEC(end+1:end+1+length(out.TrEC)-1)=out.STrEC;
%out=load('matfiles/NorESM1-M_NAER1850CNOC_f19_g16_04_300_599_heatflux.mat');
out=load('matfiles/NorESM1-M_NAER1850CNOC_f19_g16_06_700_1200_heatflux.mat');
Qf(end+1:end+1+length(out.Qf)-1)=out.Qf;
QTW(end+1:end+1+length(out.Qf)-1)=out.QTW;
%out=load('matfiles/NorESM1-M_NAER1850CNOC_f19_g16_04_300_599_saltflux.mat');
out=load('matfiles/NorESM1-M_NAER1850CNOC_f19_g16_06_700_1200_saltflux.mat');
Sft(end+1:end+1+length(out.Sft)-1)=out.Sft;
Fwt(end+1:end+1+length(out.Sft)-1)=out.Fwt;

% remove first 100 years since it is spinup in this case
if 0
kind=1200;
coeff=1e-3;
else
kind=0;
kind=1200;
coeff=1;
end

% yearly avearage
% convert them into proper units
Fwt=year_mean(Fwt(kind+1:end))*1e-3;
Sft=year_mean(Sft(kind+1:end));
Qf=year_mean(Qf(kind+1:end));
QTW=year_mean(QTW(kind+1:end));
TAW=year_mean(TAW(kind+1:end));
SAW=year_mean(SAW(kind+1:end));
TrAW=year_mean(TrAW(kind+1:end));
HTrAW=year_mean(HTrAW(kind+1:end));
STrAW=year_mean(STrAW(kind+1:end))*coeff;

TOW=year_mean(TOW(kind+1:end));
SOW=year_mean(SOW(kind+1:end));
TrOW=year_mean(TrOW(kind+1:end));
HTrOW=year_mean(HTrOW(kind+1:end));
STrOW=year_mean(STrOW(kind+1:end))*coeff;

TEGC=year_mean(TEGC(kind+1:end));
SEGC=year_mean(SEGC(kind+1:end));
TrEGC=year_mean(TrEGC(kind+1:end));
HTrEGC=year_mean(HTrEGC(kind+1:end));
STrEGC=year_mean(STrEGC(kind+1:end))*coeff;

TrCAA=year_mean(TrCAA(kind+1:end));
HTrCAA=year_mean(HTrCAA(kind+1:end));
STrCAA=year_mean(STrCAA(kind+1:end))*coeff;
TrEC=year_mean(TrEC(kind+1:end));
HTrEC=year_mean(HTrEC(kind+1:end));
STrEC=year_mean(STrEC(kind+1:end))*coeff;
TrBS=year_mean(TrBS(kind+1:end));
HTrBS=year_mean(HTrBS(kind+1:end));
STrBS=year_mean(STrBS(kind+1:end))*coeff;
% yearly avearage finished

load('matfiles/NAER1850CNOC_f19_g16_06_700_1200_tempsalt_yearly.mat')

% filter the data
TrEGC_dn=my_nanfilter(TrEGC,dn,met);
TrOW_dn=my_nanfilter(TrOW,dn,met);
TrAW_dn=my_nanfilter(TrAW,dn,met);
HTrAW_dn=my_nanfilter(HTrAW,dn,met);
STrAW_dn=my_nanfilter(STrAW,dn,met);
TEGC_dn=my_nanfilter(TEGC,dn,met);
TOW_dn=my_nanfilter(TOW,dn,met);
TAW_dn=my_nanfilter(TAW,dn,met);
SEGC_dn=my_nanfilter(SEGC,dn,met);
SOW_dn=my_nanfilter(SOW,dn,met);
SAW_dn=my_nanfilter(SAW,dn,met);
HTrOW_dn=my_nanfilter(HTrOW,dn,met);
STrOW_dn=my_nanfilter(STrOW,dn,met);
HTrEGC_dn=my_nanfilter(HTrEGC,dn,met);
STrEGC_dn=my_nanfilter(STrEGC,dn,met);

Fwt_dn=my_nanfilter(Fwt,dn,met);
Qf_dn=my_nanfilter(Qf,dn,met);
Sft_dn=my_nanfilter(Sft,dn,met);
TrBS_dn=my_nanfilter(TrBS,dn,met);
STrBS_dn=my_nanfilter(STrBS,dn,met);
HTrBS_dn=my_nanfilter(HTrBS,dn,met);
TrEC_dn=my_nanfilter(TrEC,dn,met);
STrEC_dn=my_nanfilter(STrEC,dn,met);
HTrEC_dn=my_nanfilter(HTrEC,dn,met);


%%%%% New version %%%%
if 1
TAW_dn=HTrAW_dn./TrAW_dn;
SAW_dn=STrAW_dn./TrAW_dn;
TOW_dn=HTrOW_dn./TrOW_dn;
SOW_dn=STrOW_dn./TrOW_dn;
TEGC_dn=HTrEGC_dn./TrEGC_dn;
SEGC_dn=STrEGC_dn./TrEGC_dn;
end

break

%plot transports and rhs=Fwt-(TrCAA+TrBS)
figure(1)
plot(my_nanfilter(TrAW+TrOW+TrEGC,dn,met),'linewidth',lw)
hold on
plot(my_nanfilter(Fwt,dn,met),'k','linewidth',lw)
plot(my_nanfilter(TrCAA+TrBS,dn,met),'m','linewidth',lw)
plot(my_nanfilter(Fwt-(TrCAA+TrBS),dn,met),'r','linewidth',lw)
plot(my_nanfilter(TrAW+TrOW+TrEGC-(Fwt-(TrCAA+TrBS)),dn,met),'g','linewidth',lw)
ylim([-0.75 1.25])
legend('TrAW+TrOW+TrEGC','E-P','TrCAA+TrBS','rhs','residual','location','northeast')

%plot heat transports and rhs=Qf-(HTrCAA+HTrBS)
figure(2)
%plot(my_nanfilter(HTrAW+HTrOW+HTrEGC,dn,met),'linewidth',lw)
hold on
%plot(my_nanfilter(TAW.*TrAW+TOW.*TrOW+TEGC.*TrEGC,dn,met),'b-','linewidth',lw)
plot((TAW_dn.*TrAW_dn+TOW_dn.*TrOW_dn+TEGC_dn.*TrEGC_dn),'b-','linewidth',lw)
plot(my_nanfilter(-Qf,dn,met),'k','linewidth',lw)
plot(my_nanfilter(HTrCAA+HTrBS,dn,met),'m','linewidth',lw)
plot(my_nanfilter((-Qf-(HTrCAA+HTrBS)),dn,met),'r','linewidth',lw)
plot(my_nanfilter((HTrAW+HTrEGC+HTrOW),dn,met),'c','linewidth',lw)
%plot(my_nanfilter(TAW.*TrAW+TOW.*TrOW+TEGC.*TrEGC+(HTrCAA+HTrBS)+(+Qf),dn,met),'g','linewidth',lw)
ylim([-10 100])
legend('\Sigma T_i*Tr_i','Fq','HTrCAA+HTrBS','rhs','\Sigma HTr','location','east')

%plot salt transports and rhs=Sft-(STrCAA+STrBS)
figure(3)
%plot(my_nanfilter(STrAW+STrOW+STrEGC,dn,met),'linewidth',lw)
plot(STrAW_dn+STrOW_dn+STrEGC_dn,'linewidth',lw)
hold on
%plot(my_nanfilter(SAW.*TrAW+SOW.*TrOW+SEGC.*TrEGC,dn,met),'c','linewidth',lw)
plot((SAW_dn.*TrAW_dn+SOW_dn.*TrOW_dn+SEGC_dn.*TrEGC_dn),'c','linewidth',lw)
plot(my_nanfilter(Sft,dn,met),'k','linewidth',lw)
plot(my_nanfilter(STrCAA+STrBS,dn,met),'m','linewidth',lw)
plot(my_nanfilter(Sft-(STrCAA+STrBS),dn,met),'r','linewidth',lw)
plot(my_nanfilter(SAW.*TrAW+SOW.*TrOW+SEGC.*TrEGC-(Sft-(STrCAA+STrBS)),dn,met),'g','linewidth',lw)
ylim([-25 40])
legend('STrAW+STrOW+STrEGC','SAW*TrAW+SOW*TrOW+SEGC*TrEGC','Fs','STrCAA+STrBS','rhs','residual','location','northeast')



delta_rho1=0.5*(-alpha_T*(TOW_dn-TAW_dn)+beta_S*(SOW_dn-SAW_dn));
delta_rho2=(-alpha_T*(TEGC_dn-TAW_dn)+beta_S*(SEGC_dn+0.8-SAW_dn));
%hydraulic theory 
s=0.05;
QEGC=-grav*s*delta_rho2./(2*rho0*f);
%rhs=TrEGC_dn-(Fwt_dn-(TrCAA_dn+TrBS_dn));
rhs=(Fwt_dn-(TrCAA_dn+TrBS_dn))-QEGC;
[QOW,QAW] = compute_hydraulic_transports(delta_rho1,rhs); QOW=-QOW;


%compute rhs of the eqs.
rhs1=(Fwt_dn-(TrCAA_dn+TrBS_dn));
rhs2=Sft_dn-(STrCAA_dn+STrBS_dn);
rhs3=-Qf_dn-(HTrCAA_dn+HTrBS_dn);
hydrtri_dn = (SAW_dn - SEGC_dn).*(TAW_dn - TOW_dn)-(SAW_dn - SOW_dn).*(TAW_dn - TEGC_dn);

%bcmwheel results
TrAW_bcm_dn=( ((SEGC_dn.*TOW_dn-SOW_dn.*TEGC_dn).*rhs1) + ((TEGC_dn - TOW_dn).*rhs2) - ((SEGC_dn - SOW_dn).*rhs3) )./hydrtri_dn;
TrEGC_bcm_dn=( ((SOW_dn.*TAW_dn-SAW_dn.*TOW_dn).*rhs1) + ((TOW_dn - TAW_dn).*rhs2) - ((SOW_dn - SAW_dn).*rhs3) )./hydrtri_dn;
TrOW_bcm_dn=( ((SAW_dn.*TEGC_dn-SEGC_dn.*TAW_dn).*rhs1) + ((TAW_dn - TEGC_dn).*rhs2) - ((SAW_dn - SEGC_dn).*rhs3) )./hydrtri_dn;








