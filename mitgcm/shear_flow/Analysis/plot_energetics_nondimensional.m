
clear all
load matfiles/Exp01.2_energetics.mat
g=1;
H=1;
L=1*H;
dt=(time_days(2:end)-time_days(1:end-1));
pe=pe./g;
rpe=rpe./g;
ape=ape./g;
wb=wb./g;
rpe_t=(rpe(2:end)-rpe(1:end-1))./(dt);
pe_t=(pe(2:end)-pe(1:end-1))./(dt);
ape_t=(ape(2:end)-ape(1:end-1))./(dt);
ke_t=(ke(2:end)-ke(1:end-1))./(dt);
dissp_t=0.5*(dissp(1:end-1)+dissp(2:end));
keb_t=(ke_bouss(2:end)-ke_bouss(1:end-1))./(dt);
dissp_rho_t=0.5*(dissp_rho(1:end-1)+dissp_rho(2:end));
Time=time_days;
Time_t=0.5*(Time(1:end-1)+Time(2:end));

te=pe+ke_bouss;
figure
plot(Time,pe./te(1))
hold on
plot(Time,rpe./te(1),'k')
plot(Time,ape./te(1),'r')
plot(Time,ke./te(1),'g')
plot(Time,ke_bouss./te(1),'c')
%%% ke_bouss is wrong to use
%plot(Time,ke_bouss./pe(1),'c')
%xlim([0 5])

figure
plot(Time_t,keb_t)
hold on
plot(Time,-wb-dissp,'r-')

figure
plot(Time_t,rpe_t./(rpe_t+dissp_t),'k')
hold on
plot(Time_t,cumsum(rpe_t)./(cumsum(rpe_t)+cumsum(dissp_t)),'k--')

