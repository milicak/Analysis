clear all

g=9.81;
plot(pe./pe(1))
hold on
plot(rpe./pe(1),'k')
plot(ape./pe(1),'r')
%plot(g*ke_bouss./pe(1),'g')
plot(g*ke./pe(1),'g')

ke_t_bouss=(ke_bouss(2:end)-ke_bouss(1:end-1))./(dumpfreq/(H/u_charc));
ke_t_=(ke(2:end)-ke(1:end-1))./(dumpfreq/(H/u_charc));

plot(ke_t)                
hold on
plot(-wb/g-dissp_rho,'k-')

