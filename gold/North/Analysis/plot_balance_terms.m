clear all
C2K=273.15;
rcp=0;

if rcp==1
% RCP8.5 case
  load matfiles/ESM2G_rcp8_5
  load matfiles/ESM2G_rcp8_5_heatflux
  load matfiles/ESM2G_rcp8_5_saltflux
else
% pi-control case
  load matfiles/ESM2G_pi_control
  load matfiles/ESM2G_pi_control_heatflux
  load matfiles/ESM2G_pi_control_saltflux
end

% Mass balance case: Transport at the section is balanced by transport CAA, Be, EC and Fresh water;
% section transport
TrSec=squeeze(nansum(trsec,3));TrSec=squeeze(nansum(TrSec,2));
TrCAA=squeeze(nansum(trCAA,3));TrCAA=squeeze(nansum(TrCAA,2));
TrBe=squeeze(nansum(trBe,3));TrBe=squeeze(nansum(TrBe,2));
TrEC=squeeze(nansum(trEC,3));TrEC=squeeze(nansum(TrEC,2));

figure(1)
plot(TrSec)
hold on
plot(Fwt'+(TrBe+TrCAA+TrEC),'r')
plot(TrSec+Fwt'+(TrBe+TrCAA+TrEC),'k')

% heat balance
dnm1=squeeze(nansum(trsec.*(tempsec+C2K),3));dnm1=squeeze(nansum(dnm1,2));     
dnm2=squeeze(nansum(trCAA.*(tempCAA+C2K),3));dnm2=squeeze(nansum(dnm2,2));      
dnm3=squeeze(nansum(trBe.*(tempBe+C2K),3));dnm3=squeeze(nansum(dnm3,2));      
dnm4=squeeze(nansum(trEC.*(tempEC+C2K),3));dnm4=squeeze(nansum(dnm4,2));      

HTrSec=dnm1;
HTrCAA=dnm2;
HTrBe=dnm3;
HTrEC=dnm4;

figure(2)
plot(HTrSec)
hold on
plot(Qf'-(HTrCAA+HTrBe+HTrEC),'r')
%There is a a very small offset but if you remove the mean they are on top of each other
rhs=Qf'-(HTrCAA+HTrBe+HTrEC);

figure(3)
plot(HTrSec-mean(HTrSec))
hold on
plot(rhs-mean(rhs),'r')

% salt balance
dnm1=squeeze(nansum(trsec.*saltsec,3));dnm1=squeeze(nansum(dnm1,2));
dnm2=squeeze(nansum(trCAA.*saltCAA,3));dnm2=squeeze(nansum(dnm2,2));
dnm3=squeeze(nansum(trBe.*saltBe,3));dnm3=squeeze(nansum(dnm3,2));
dnm4=squeeze(nansum(trEC.*saltEC,3));dnm4=squeeze(nansum(dnm4,2));      

STrSec=dnm1;
STrCAA=dnm2;
STrBe=dnm3;
STrEC=dnm4;

figure(4)
plot(STrSec)
hold on
plot(Sft'-(STrCAA+STrBe+STrEC),'r')
%There is an offsett of -10 but if you remove the mean they are on top of each other
rhs2=Sft'-(STrCAA+STrBe+STrEC);

figure(5)
plot(STrSec-mean(STrSec))
hold on
plot(rhs2-mean(rhs2),'r')





