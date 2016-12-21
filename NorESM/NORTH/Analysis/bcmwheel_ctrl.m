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

D = [U1bcm_dn-mean(U1bcm_dn),U1_dn-mean(U1_dn)];
[U,S,V1] = svd(D,'econ');
b1 = V1(2,1)/V1(1,1); % slope of major axis
stdmax1 = S(1,1)*std(U(:,1)); % std along major axis
stdmin1 = S(2,2)*std(U(:,2)); % std along minor axis

D = [U2bcm_dn-mean(U2bcm_dn),U2_dn-mean(U2_dn)];
[U,S,V2] = svd(D,'econ');
b2 = V2(2,1)/V2(1,1); % slope of major axis
stdmax2 = S(1,1)*std(U(:,1)); % std along major axis
stdmin2 = S(2,2)*std(U(:,2)); % std along minor axis

D = [U3bcm_dn-mean(U3bcm_dn),U3_dn-mean(U3_dn)];
[U,S,V3] = svd(D,'econ');
b3 = V3(2,1)/V3(1,1); % slope of major axis
stdmax3 = S(1,1)*std(U(:,1)); % std along major axis
stdmin3 = S(2,2)*std(U(:,2)); % std along minor axis

if 0

figure(1);clf
subplot(2,1,1),
plot(time,T1_dn,'r','linewidth',1.5)
grid on
hold on
plot(time,T2_dn,'b','linewidth',1.5)
plot(time,T3_dn,'k','linewidth',1.5)
hold off
xlabel('Time [yr]')
ylabel('Pot. temp [\circC]')

subplot(2,1,2),
plot(time,S1_dn,'r','linewidth',1.5)
grid on
hold on
plot(time,S2_dn,'b','linewidth',1.5)
plot(time,S3_dn,'k','linewidth',1.5)
hold off
xlabel('Time [yr]')
ylabel('Salinity')

end

mS1 = mean(S1);
mT1 = mean(T1);
mS2 = mean(S2);
mT2 = mean(T2);
mS3 = mean(S3);
mT3 = mean(T3);

delta_rho1=0.5*(-alpha_T*(T3_dn-T1_dn)+beta_S*(S3_dn-S1_dn));
delta_rho2=0.5*(-alpha_T*(my_nanfilter(temOW,dn,fil)'-my_nanfilter(temAW,dn,fil)')+beta_S*(my_nanfilter(salOW,dn,fil)'-my_nanfilter(salAW,dn,fil)'));
[QO1 QAW1] = compute_hydraulic_transports(delta_rho1,U2bcm_dn);
[QO2 QAW2] = compute_hydraulic_transports(delta_rho2,U2bcm_dn);

%rho_EGC1=

break

figure(1);clf
plot(S1,T1,'.','color',gr)
grid on
hold on
plot(S2,T2,'.','color',gr)
plot(S3,T3,'.','color',gr)
plot([mS1 mS2 mS3 mS1],[mT1 mT2 mT3 mT1],'w','linewidth',3)
plot([mS2 mS3],[mT2 mT3],'r','linewidth',2)
plot([mS1 mS3],[mT1 mT3],'b','linewidth',2)
plot([mS1 mS2],[mT1 mT2],'k','linewidth',2)
plot([mS1 mS1-fackT*mean(stnet-34.9*vtnet)/mean(U1bcm)],[mT1 mT1-mean(htnet)/facTW/mean(U1bcm)],'k--','linewidth',2)
plot(mS1,mT1,'ro','markersize',8,'linewidth',3,'markerfacecolor','w')
plot(mS2,mT2,'bo','markersize',8,'linewidth',3,'markerfacecolor','w')
plot(mS3,mT3,'ko','markersize',8,'linewidth',3,'markerfacecolor','w')
hold off
xlabel('Salinity')
ylabel('Potential temperature [\circC]')

figure(2)
plot(time,my_nanfilter(F,dn,fil),'b','linewidth',1.5)
grid on
hold on
%plot(time,my_nanfilter(dsalt,dn,fil)*facFW,'b--','linewidth',1.5)
plot(time,fackT*(my_nanfilter(stnet-Sref*vtnet,dn,fil))*facFW,'r','linewidth',1.5)
plot(time,fackT*(my_nanfilter(stnet-Sref*vtnet,dn,fil))*facFW-my_nanfilter(F,dn,fil),'b--','linewidth',1.5)
hold off
legend('input','advective','storage')
xlabel('Time [yr]')
ylabel('Freshwater input [Sv]')

figure(3)
plot(time,my_nanfilter(Q,dn,fil),'b','linewidth',1.5)
grid on
hold on
%plot(time,my_nanfilter(dheat,dn,fil),'b--','linewidth',1.5)
plot(time,my_nanfilter(htnet,dn,fil),'r','linewidth',1.5)
plot(time,my_nanfilter(htnet-Q,dn,fil),'b--','linewidth',1.5)
hold off
legend('loss','advective','storage')
xlabel('Time [yr]')
ylabel('Heat loss [Sv]')

figure(4);clf
subplot(1,3,1),plot([-10 10],[-10 10],'k--','linewidth',1)
hold on
grid on
plot(U1bcm_dn,U1_dn,'r.','markersize',8)
plot(3*stdmax1*[-V1(1,1) V1(1,1)]+mean(U1bcm_dn),3*stdmax1*[-V1(2,1) V1(2,1)]+mean(U1_dn),'w','linewidth',4)
plot(3*stdmax1*[-V1(1,1) V1(1,1)]+mean(U1bcm_dn),3*stdmax1*[-V1(2,1) V1(2,1)]+mean(U1_dn),'r','linewidth',2)
plot(mean(U1bcm_dn),mean(U1_dn),'o','color','w','markersize',12,'markerfacecolor','w')
plot(mean(U1bcm_dn),mean(U1_dn),'o','color','r','markersize',8,'linewidth',2,'markerfacecolor','w')
text(6.25,9.5,sprintf('r=%0.2g',r1),'color','r','fontsize',10)
text(6.22,9,sprintf('b=%0.2g',b1),'color','r','fontsize',10)
hold off
set(gca,'fontsize',8)
set(gca,'xtick',6:.5:10)
set(gca,'ytick',6:.5:10)
set(gca,'xticklabel',{'6','','7','','8','','9','','10'})
set(gca,'yticklabel',{'6','','7','','8','','9','','10'})
xlabel('BCM Atlantic inflow [Sv]')
ylabel('Diagnosed Atlantic inflow [Sv]')
axis([6 10 6 10])
set(gca,'dataaspectratio',[1 1 1])

subplot(1,3,2), plot([-10 10],[-10 10],'k--','linewidth',1)
hold on
grid on
plot(U2bcm_dn,U2_dn,'b.','markersize',8)
plot(3*stdmax2*[-V2(1,1) V2(1,1)]+mean(U2bcm_dn),3*stdmax2*[-V2(2,1) V2(2,1)]+mean(U2_dn),'w','linewidth',4)
plot(3*stdmax2*[-V2(1,1) V2(1,1)]+mean(U2bcm_dn),3*stdmax2*[-V2(2,1) V2(2,1)]+mean(U2_dn),'b','linewidth',2)
plot(mean(U2bcm_dn),mean(U2_dn),'o','color','w','markersize',12,'markerfacecolor','w')
plot(mean(U2bcm_dn),mean(U2_dn),'o','color','b','markersize',8,'linewidth',2,'markerfacecolor','w')
text(-4.75,-1.5,sprintf('r=%0.2g',r2),'color','b','fontsize',10)
text(-4.75,-2,sprintf('b=%0.2g',b2),'color','b','fontsize',10)
hold off
set(gca,'fontsize',8)
set(gca,'xtick',-5:.5:-1)
set(gca,'ytick',-5:.5:-1)
set(gca,'xticklabel',{'-5','','-4','','-3','','-2','','-1'})
set(gca,'yticklabel',{'-5','','-4','','-3','','-2','','-1'})
xlabel('BCM polar outflow [Sv]')
ylabel('Diagnosed polar outflow [Sv]')
%axis([-3 -1 -5 -1])
axis([-5 -1 -5 -1])
set(gca,'dataaspectratio',[.5 .5 .5])

subplot(1,3,3), plot([-10 10],[-10 10],'k--','linewidth',1)
hold on
grid on
plot(U3bcm_dn,U3_dn,'k.','markersize',8)
plot(3*stdmax3*[-V3(1,1) V3(1,1)]+mean(U3bcm_dn),3*stdmax3*[-V3(2,1) V3(2,1)]+mean(U3_dn),'w','linewidth',4)
plot(3*stdmax3*[-V3(1,1) V3(1,1)]+mean(U3bcm_dn),3*stdmax3*[-V3(2,1) V3(2,1)]+mean(U3_dn),'k','linewidth',2)
plot(mean(U3bcm_dn),mean(U3_dn),'o','color','w','markersize',12,'markerfacecolor','w')
plot(mean(U3bcm_dn),mean(U3_dn),'o','color','k','markersize',8,'linewidth',2,'markerfacecolor','w')
text(-6.75,-3.5,sprintf('r=%0.2g',r3),'color','k','fontsize',10)
text(-6.75,-4.,sprintf('b=%0.2g',b3),'color','k','fontsize',10)
hold off
set(gca,'fontsize',8)
set(gca,'xtick',-7:.5:-3)
set(gca,'ytick',-7:.5:-3)
xlabel('BCM overflow [Sv]')
set(gca,'xticklabel',{'-7','','-6','','-5','','-4','','-3'})
set(gca,'yticklabel',{'-7','','-6','','-5','','-4','','-3'})
ylabel('Diagnosed overflow [Sv]')
axis([-7 -3 -7 -3])
set(gca,'dataaspectratio',[1 1 1])

figure(5); clf
plot(timec,(U1bcm_dn-mean(U1bcm_dn))/std(U1bcm_dn),'color',gr,'linewidth',1.5)
grid on
hold on
plot(timec,(U1_dn-mean(U1_dn))/std(U1_dn),'r','linewidth',1.5)
plot(timec,-7-(U2bcm_dn-mean(U2bcm_dn))/std(U2bcm_dn),'color',gr,'linewidth',1.5)
plot(timec,-7-(U2_dn-mean(U2_dn))/std(U2_dn),'b','linewidth',1.5)
%plot(timec,-7+(dsalt_dn-mean(dsalt_dn))/std(dsalt_dn),'r','linewidth',1.5)
%plot(timec,-7+(Sam_dn-mean(Sam_dn))/std(Sam_dn),'r','linewidth',1.5)
plot(timec,-14-(U3bcm_dn-mean(U3bcm_dn))/std(U3bcm_dn),'color',gr,'linewidth',1.5)
plot(timec,-14-(U3_dn-mean(U3_dn))/std(U3_dn),'k','linewidth',1.5)
set(gca,'fontsize',10)
xlabel('Time [yr]')
%ylabel('standardized volume transport')
%ylabel('Diagnosed volume transport anomaly [Sv]')
ylabel('Diagnosed volume transport [Sv]')
axis([0 600 -18 4])
set(gca,'xtick',0:50:600)
set(gca,'ytick',[-16:-12 -9:-5 -2:2])
if netsink == 1
  set(gca,'yticklabel',[{'-6.2','','-6.6','','-7.0'} {'-1.0','','-1.7','','-2.4'} {'7.5','','8.3','','9.1'}]);
  text(10,3.25,'Atlantic inflow, {\it r}^2= 92%','color','r','fontsize',12)
  text(10,-7+3.25,'Polar outflow, {\it r}^2= 70%','color','b','fontsize',12)
  text(10,-14+3.25,'Overflow, {\it r}^2= 46%','color','k','fontsize',12)
elseif storage == 1
  set(gca,'yticklabel',[{'0.7','','0','','-0.7'} {'0.7','','0','','-0.7'} {'-0.6','','0','','0.6'}]);
  text(10,3.25,'Atlantic inflow, ({\it r}^2= 4%)','color','r','fontsize',12)
  text(10,-7+3.25,'Polar outflow, {\it r}^2= 26%','color','b','fontsize',12)
  text(10,-14+3.25,'Overflow, {\it r}^2= 35%','color','k','fontsize',12)
else
  set(gca,'yticklabel',[{'-5.7','','-6.6','','-7.5'} {'-1.0','','-1.7','','-2.4'} {'7.5','','8.3','','9.1'}]);
  text(10,3.25,'Atlantic inflow, {\it r}^2= 65%','color','r','fontsize',12)
  text(10,-7+3.25,'Polar outflow, {\it r}^2= 12%','color','b','fontsize',12)
  text(10,-14+3.25,'Overflow, {\it r}^2= 52%','color','k','fontsize',12)
end
text(605,-16,'-5.4','color',gr','fontsize',10)
text(605,-14,'-5.7','color',gr','fontsize',10)
text(605,-12,'-6.0','color',gr','fontsize',10)
text(605,-9,'-1.6','color',gr','fontsize',10)
text(605,-7,'-2.1','color',gr','fontsize',10)
text(605,-5,'-2.6','color',gr','fontsize',10)
text(605,-2,' 6.6','color',gr','fontsize',10)
text(605,-0,' 7.4','color',gr','fontsize',10)
text(605, 2,' 8.2','color',gr','fontsize',10)
text(645,-12.375,'BCM volume transport [Sv]','color',gr','fontsize',10,'rotation',90)
set(gca,'dataaspectratio',[15 1 1])

figure(6); clf
plot(timec,-7-(U2bcm_dn-mean(U2bcm_dn))/std(U2bcm_dn),'color',gr,'linewidth',1.5)
grid on
hold on
plot(timec,-7-(U2_dn-mean(U2_dn))/std(U2_dn),'b','linewidth',1.5)
plot(timec,-14-(U3bcm_dn-mean(U3bcm_dn))/std(U3bcm_dn),'color',gr,'linewidth',1.5)
plot(timec,-14-(U3_dn-mean(U3_dn))/std(U3_dn),'k','linewidth',1.5)
set(gca,'fontsize',10)
xlabel('Time [yr]')
%ylabel('Diagnosed volume transport [Sv]')
ylabel('Diagnosed anomaly [Sv]')
axis([0 600 -17 -3])
set(gca,'xtick',0:50:600)
set(gca,'ytick',[-16:-12 -9:-5])
if netsink == 1
  set(gca,'yticklabel',[{'-6.2','','-6.6','','-7.0'} {'-1.0','','-1.7','','-2.4'}]);
  text(10,-7+3.25,'Polar outflow, {\it r}^2= 70%','color','b','fontsize',12)
  text(10,-14+3.25,'Overflow, {\it r}^2= 46%','color','k','fontsize',12)
  text(605,-16,'-5.4','color',gr','fontsize',10)
  text(605,-14,'-5.7','color',gr','fontsize',10)
  text(605,-12,'-6.0','color',gr','fontsize',10)
  text(605,-9,'-1.6','color',gr','fontsize',10)
  text(605,-7,'-2.1','color',gr','fontsize',10)
  text(605,-5,'-2.6','color',gr','fontsize',10)
elseif storage == 1
  set(gca,'yticklabel',[{'0.7','','0','','-0.7'} {'0.7','','0','','-0.7'}]);
  text(10,-7+3.25,'Polar outflow, {\it r}^2= 26%','color','b','fontsize',12)
  text(10,-14+3.25,'Overflow, {\it r}^2= 35%','color','k','fontsize',12)
  text(605,-16,'-5.4','color',gr','fontsize',10)
  text(605,-14,'-5.7','color',gr','fontsize',10)
  text(605,-12,'-6.0','color',gr','fontsize',10)
  text(605,-9,'-1.6','color',gr','fontsize',10)
  text(605,-7,'-2.1','color',gr','fontsize',10)
  text(605,-5,'-2.6','color',gr','fontsize',10)
%  text(605,-16,'-0.3','color',gr','fontsize',10)
%  text(605,-14,'  0','color',gr','fontsize',10)
%  text(605,-12,'  0.3','color',gr','fontsize',10)
%  text(605,-9,'  0.5','color',gr','fontsize',10)
%  text(605,-7,'  0','color',gr','fontsize',10)
%  text(605,-5,'-0.5','color',gr','fontsize',10)
else
  set(gca,'yticklabel',[{'-1.0','','-1.7','','-2.4'}]);
  text(10,-7+3.25,'Polar outflow, {\it r}^2= 12%','color','b','fontsize',12)
end
text(645,-15.75,'BCM volume transport [Sv]','color',gr','fontsize',10,'rotation',90)
%text(645,-14.,'BCM anomaly [Sv]','color',gr','fontsize',10,'rotation',90)
hold off
set(gca,'dataaspectratio',[15 1 1])

