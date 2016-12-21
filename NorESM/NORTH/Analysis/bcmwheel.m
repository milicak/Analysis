clear all;

alpha_T=0.2; %kgm-3
beta_S=0.8;  %kgm-3

load matfiles/watermasses_tor;

load matfiles/atm_forcing_tor;

load matfiles/GSR_Heat_Salt_transport; n0 = 101; 
load matfiles/mean_ann_AM_s_t
load matfiles/asiv_yr_Q01;

nwac_st = nwac_st(n0:end); nwac_ht = nwac_ht(n0:end);
egc_st = egc_st(n0:end); egc_ht = egc_ht(n0:end);
overflow_st = overflow_st(n0:end); overflow_ht = overflow_ht(n0:end);

load matfiles/transports_AM;

% water masses
vtAW = -nwac'; vtPW = -egc'; vtOW = -overflow'; 
stAW = -nwac_st'; stPW = -egc_st'; stOW = -overflow_st';
htAW = -nwac_ht'; htPW = -egc_ht'; htOW = -overflow_ht';

% gateways DS=Denmark Strait; IS=Iceland-Scotland; FS=Fram Strait; BC=British Channel; BS=Barents Sea; CA=Canadian Archipelago
% vt=volume transport; st=salt transport; ft=freshwater transport; ht=heat transport
vtDS = -ds_vol; vtIS = icf_vol; vtFS = fs_vol; vtBC = bc_vol; vtBS = bs_vol; vtCA = -ca_vol;
stDS = -ds_sal; stIS = icf_sal; stFS = fs_sal; stBC = bc_sal; stBS = bs_sal; stCA = -ca_sal;
ftDS = -ds_fw; ftIS = icf_fw; ftFS = fs_fw; ftBC = bc_fw; ftBS = bs_fw; ftCA = -ca_fw;
htDS = -1e3*ds_heat; htIS = 1e3*icf_heat; htFS = 1e3*fs_heat; htBC = 1e3*bc_heat; htBS = 1e3*bs_heat; htCA = -1e3*ca_heat;

% total greenland-scotland-ridge (gsr)
vtgsr = vtDS + vtIS + vtFS;
stgsr = stDS + stIS + stFS;
ftgsr = ftDS + ftIS + ftFS;
htgsr = htDS + htIS + htFS;

vtnet = vtgsr + vtBC + vtBS + vtCA;
stnet = stgsr + stBC + stBS + stCA;
ftnet = ftgsr + ftBC + ftBS + ftCA;
htnet = htgsr + htBC + htBS + htCA;

gr = .4*[1 1 1];

facTW = 4.1;
facFW = 0.029;
fackT = 0.97;

time = 0:599; N = size(time,2);
timec = time +.5;

U1bcm = vtAW;
%U1bcm = vtAW+vtBC;
U2bcm = vtPW;
%U2bcm = vtCA+vtPW;
U3bcm = vtOW;
%U1bcm = vtnet-(U2bcm+U3bcm);

sal1bcm = fackT*stAW;
%sal1bcm = fackT*(stAW+stBC);
sal2bcm = fackT*stPW;
%sal2bcm = fackT*(stCA+stPW);
sal3bcm = fackT*stOW;
%sal1bcm = fackT*stnet-(sal2bcm+sal3bcm);

heat1bcm = htAW/facTW;
%heat1bcm = (htAW+htBC)/facTW;
heat2bcm = htPW/facTW;
%heat2bcm = (htPW+htCA)/facTW;
heat3bcm = htOW/facTW;
%heat1bcm = htnet/facTW-(heat2bcm+heat3bcm);

% transport-weighted hydrographies
S1 = sal1bcm./U1bcm;
S2 = sal2bcm./U2bcm;
S3 = sal3bcm./U3bcm;

%
T1 = heat1bcm./U1bcm;
T2 = heat2bcm./U2bcm;
T3 = heat3bcm./U3bcm;

Sref =34.9;

% storage
Vam = 1.7523e16;

Sam = salt;
Tam = temp;

oneyear = 365*24*3600;

dheat = 0*Tam;
dheat(2:end-1) = (facTW/1e6)*Vam*(Tam(3:end)-Tam(1:end-2))/(2*oneyear);
dsalt = 0*Sam;
dsalt(2:end-1) = Vam*(Sam(3:end)-Sam(1:end-2))/(2*oneyear)/1e6;


Vice = asiv_yr(n0:end);
dice = 0*Vice;
dice(1:end-1) = 1e3*(asiv_yr(n0+1:end)-asiv_yr(n0-1:end-2))/(2*365*24*3600);

% defining model forcing

netsink = 0; % ref
storage = 0; % ref
%netsink = 1;
%storage = 1;

F = am_fw; Q = am_h*1e3;

corF = mean((fackT*stnet-Sref*vtnet)*facFW-F);
corQ = mean(htnet-Q);

F = F + corF; Q = Q + corQ; 

if netsink == 1
  qS = fackT*stnet-Sref*vtnet;
  qT = htnet/facTW;
elseif storage == 1 % storage as the variability around the mean forcing
  qS = fackT*stnet-Sref*vtnet-F/facFW; 
  qT = (htnet-Q)/facTW;
  %qS = dsalt - mean(dsalt);
  %qT = dheat - mean(dheat);
else
  qS = F/facFW; 
  qT = Q/facTW;
end

% filter
fil = 'tri'; % ref
dn = 20; % ref

S1_dn = my_nanfilter(S1,dn,fil)';
S2_dn = my_nanfilter(S2,dn,fil)';
S3_dn = my_nanfilter(S3,dn,fil)';

T1_dn = my_nanfilter(T1,dn,fil)';
T2_dn = my_nanfilter(T2,dn,fil)';
T3_dn = my_nanfilter(T3,dn,fil)';

qS_dn = my_nanfilter(qS,dn,fil)';
qT_dn = my_nanfilter(qT,dn,fil)';

U1bcm_dn = my_nanfilter(U1bcm,dn,fil)';
U2bcm_dn = my_nanfilter(U2bcm,dn,fil)';
U3bcm_dn = my_nanfilter(U3bcm,dn,fil)';

% spin the climate wheel
% A*U = q  where A=[1 1 1; S1 S2 S3; T1 T2 T3], U=[U1;U2;U3], q=[0;qS;qT] 
% inv(A)=1/Delta*[S2T3-S3T2 T2-T3 S3-S2; S3T1-S1T3 T3-T1 S1-S3; S1T2-S2T1 T1-T2 S2-S2];
% Delta=[(S1 - S2).*(T1 - T3)-(S1 - S3).*(T1 - T2)]=[(S2T3-S3T2)-(S1T3-S3T1)+(S1T2-S2T1)]

hydrtri = (S1 - S2).*(T1 - T3)-(S1 - S3).*(T1 - T2);
hydrtri_dn = (S1_dn - S2_dn).*(T1_dn - T3_dn)-(S1_dn - S3_dn).*(T1_dn - T2_dn);

U1 = ( (T2 - T3).*qS - ((S2 - S3).*qT) )./hydrtri;
U2 = ( (T3 - T1).*qS - ((S3 - S1).*qT) )./hydrtri;
U3 =  - ( U1 + U2 );

U1_dn = ( (T2_dn - T3_dn).*qS_dn - ((S2_dn - S3_dn).*qT_dn) )./hydrtri_dn;
U2_dn = ( (T3_dn - T1_dn).*qS_dn - ((S3_dn - S1_dn).*qT_dn) )./hydrtri_dn;
U3_dn =  - ( U1_dn + U2_dn );

U1S_dn =  (T2_dn - T3_dn)./hydrtri_dn*facFW;
U1T_dn = -(S2_dn - S3_dn)./hydrtri_dn/facTW;
U2S_dn =  (T3_dn - T1_dn)./hydrtri_dn*facFW;
U2T_dn = -(S3_dn - S1_dn)./hydrtri_dn/facTW;
U3S_dn =  - ( U1S_dn + U2S_dn );
U3T_dn =  - ( U1T_dn + U2T_dn );

%U1_dn = my_nanrunmean(U1,dn)';
%U2_dn = my_nanrunmean(U2,dn)'; 
%U3_dn = my_nanrunmean(U3,dn)';

r1 = my_nancorr(U1bcm_dn,U1_dn,'l');
r2 = my_nancorr(U2bcm_dn,U2_dn,'l');
r3 = my_nancorr(U3bcm_dn,U3_dn,'l');

% compute overflow and Atlantic water transports using hydraulic theory
delta_rho1=0.5*(-alpha_T*(T3_dn-T1_dn)+beta_S*(S3_dn-S1_dn));
delta_rho2=0.5*(-alpha_T*(my_nanfilter(temOW,dn,fil)'-my_nanfilter(temAW,dn,fil)')+beta_S*(my_nanfilter(salOW,dn,fil)'-my_nanfilter(salAW,dn,fil)'));
% U2bcm_dn is the EGC current from BCM model
% U2_dn is the Eldevik's prediction
[QO1 QAW1] = compute_hydraulic_transports(delta_rho1,U2bcm_dn);
[QO2 QAW2] = compute_hydraulic_transports(delta_rho2,U2bcm_dn);

%rho_EGC1=

break

