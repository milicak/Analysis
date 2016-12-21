clear all
load matfiles/Exp01.1_energetics.mat

Ri=0.0165; %0.0165 for Exp1.1 ; 0.00165 for Exp1.3 ; 0.165 for Exp1.5
g=9.81;
H=0.02; %delta_vort
dt=(time_days(2:end)-time_days(1:end-1))*86400;
pe=pe./g;
rpe=rpe./g;
ape=ape./g;
wb=wb./g;

%nondimensional time divided by delta_vort/U0
dtbar=(dt/(H/u_charc));

pe=pe.*Ri;
rpe=rpe.*Ri;
ape=ape.*Ri;
wb=wb.*Ri;

rpe_t=(rpe(2:end)-rpe(1:end-1))./dtbar;
pe_t=(pe(2:end)-pe(1:end-1))./dtbar;
ape_t=(ape(2:end)-ape(1:end-1))./dtbar;
ke_t=(ke(2:end)-ke(1:end-1))./dtbar;
keb_t=(ke_bouss(2:end)-ke_bouss(1:end-1))./dtbar;

dissp_t=0.5*(dissp(1:end-1)+dissp(2:end));
wb_t=0.5*(wb(1:end-1)+wb(2:end));
dissp_rho_t=0.5*(dissp_rho(1:end-1)+dissp_rho(2:end));

Time=time_days.*86400/(H/u_charc);
Time_t=0.5*(Time(1:end-1)+Time(2:end));

te=pe+ke;
figure
plot(Time,pe./te(1))
hold on
plot(Time,rpe./te(1),'k')
plot(Time,ape./te(1),'r')
plot(Time,ke./te(1),'g')

figure
plot(Time_t,ke_t,'b-')
hold on
plot(Time,-wb-dissp_rho,'k-')


figure
plot(Time_t,rpe_t./(rpe_t+dissp_t),'k')
hold on
plot(Time_t,cumsum(rpe_t)./(cumsum(rpe_t)+cumsum(dissp_t)),'k--')
dnm=rpe_t.*dt;
dnm2=dissp_t.*dt;
plot(Time_t,cumsum(dnm)./(cumsum(dnm)+cumsum(dnm2)),'r--*')

