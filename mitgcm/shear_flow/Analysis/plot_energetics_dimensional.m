clear all
load matfiles/Exp01.1_energetics_dimensional.mat

dt=(time_days(2:end)-time_days(1:end-1))*86400;

% time derivative
rpe_t=(rpe(2:end)-rpe(1:end-1))./(dt);
pe_t=(pe(2:end)-pe(1:end-1))./(dt);
ape_t=(ape(2:end)-ape(1:end-1))./(dt);
ke_t=(ke(2:end)-ke(1:end-1))./(dt);
dissp_t=0.5*(dissp(1:end-1)+dissp(2:end));
keb_t=(ke_bouss(2:end)-ke_bouss(1:end-1))./(dt);
dissp_rho_t=0.5*(dissp_rho(1:end-1)+dissp_rho(2:end));

%nondimensional Time dividec by delta_vort/U0
Time=time_days.*86400/(0.02/0.1);
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
plot(Time_t,ke_t)
hold on
plot(Time,-wb-dissp_rho,'k-')

plot(Time_t,rpe_t./(rpe_t+dissp_rho_t),'k')
hold on
plot(Time_t,cumsum(rpe_t)./(cumsum(rpe_t)+cumsum(dissp_rho_t)),'k--')
dnm=rpe_t.*dt;
dnm2=dissp_rho_t.*dt;
plot(Time_t,cumsum(dnm)./(cumsum(dnm)+cumsum(dnm2)),'r--*')

