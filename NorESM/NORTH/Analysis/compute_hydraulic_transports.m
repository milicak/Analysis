function [QO,Q_AW] = compute_hydraulic_transports(delta_rho,U2bcm_dn)
% U2bcm_dn = Eastern Greenland Current transport [Sv]
% delta_rho is to compute gprime to be used in hydraulic theory
% computes total overflow transport (QO) which is sum of Denmark Strait, IFR, FB, and WTR overflows
% using the hydraulic control theory
% compute Atlantic Water transport which is sum of QO + Q_EGC

sill_DS=600; %m
sill_WTR=600; %m Wyville-Thomson Ridge
sill_IFR=500; %m Iceland-Faroe Ridge
sill_FB=850; %m

%delta_rho=0.5*(-0.2*(T3_dn-T1_dn)+0.8*(S3_dn-S1_dn)); %kgm-3
grav=9.81; %m/s2
f=1.31e-4; %1/s coriolis for Denmark Strait
rho0=1027; %kg/m3
alpha=5.8e-6;  %1/m from Borenas and Lundberg 98 paper
gprime=grav*delta_rho/rho0;
Q_EGC=U2bcm_dn; % Eastern Greenland Current transport [Sv]
r=(f^2)./(gprime*alpha); %from Borenas and Lundberg 98 paper BECAREFUL WILKENSKJELD and QUADFASEL paper definition is wrong
%r=alpha*f^2/gprime;

depth=1200; %m upstream depth

x0=1200*1e3; %[m]
d0=335;%393; %mean interface height 350m is very nice with NAER1850NOC_f19_g16_03/4/5/6

for itr=1:length(delta_rho);

h_DS=sill_DS-d0; % interface height
h_WTR=sill_WTR-d0; % interface height
h_IFR=sill_IFR-d0; % interface height
h_FB=sill_FB-d0; % interface height
if h_DS<=0; h_DS=0; end
if h_WTR<=0; h_WTR=0; end
if h_IFR<=0; h_IFR=0; end
if h_FB<=0; h_FB=0; end

for itr2=1:50

%Denmark Strait Transport Q=h^2*g'/2f
Q_DS(itr)=(0.5*gprime(itr)./f)*h_DS^2;
Q_DS(itr)=Q_DS(itr)*1e-6; %convert to Sv

%IFR Transport Q=h^2*g'/2f
Q_IFR(itr)=(0.5*gprime(itr)/f)*h_IFR^2;
Q_IFR(itr)=Q_IFR(itr)*1e-6; %convert to Sv

%WTR Transport Q=h^2*g'/2f
Q_WTR(itr)=(0.5*gprime(itr)/f)*h_WTR^2;
Q_WTR(itr)=Q_WTR(itr)*1e-6; %convert to Sv

%FB Transport Q=(h^2/(2+r))*sqrt(3g'/2alpha)
Q_FB(itr)=(h_FB^2/(2+r(itr)))*sqrt(1.5*gprime(itr)/alpha);
%Q_FB(itr)=(h_FB^2/(2+r))*sqrt(1.5*f^2/r);
Q_FB(itr)=Q_FB(itr)*1e-6; %convert to Sv

%compute total overflow transport
QO(itr)=Q_DS(itr)+Q_IFR(itr)+Q_WTR(itr)+Q_FB(itr);

%compute Atlantic Water transport
Q_AW(itr)=QO(itr)+abs(Q_EGC(itr));

% compute upper and lower velocities from geostrophy
v_upper=Q_AW(itr)*1e6/(x0*d0);
v_lower=QO(itr)*1e6/(x0*(depth-d0));
% compute upper and lower interface height
ksi=x0*v_upper*f/grav;
eta=x0*(v_lower-v_upper)*f/gprime(itr);

h_east=d0+0.5*(ksi+eta);h_west=d0-0.5*(ksi+eta);

d1=0.5*(h_east+0e3*(h_west-h_east)./x0 + h_east+200e3*(h_west-h_east)./x0); % DS avg from 0 to 200km
d2=0.5*(h_east+200e3*(h_west-h_east)./x0 + h_east+800e3*(h_west-h_east)./x0); % IFR avg from 200km to 800km
d3=0.5*(h_east+800e3*(h_west-h_east)./x0 + h_east+900e3*(h_west-h_east)./x0); % FB avg from 800km to 900km
d4=0.5*(h_east+900e3*(h_west-h_east)./x0 + h_east+1100e3*(h_west-h_east)./x0); % WTR avg from 200km to 800km

h_DS=sill_DS-d1; % interface height
h_WTR=sill_WTR-d2; % interface height
h_IFR=sill_IFR-d3; % interface height
h_FB=sill_FB-d4; % interface height
if h_DS<=0; h_DS=0; end
if h_WTR<=0; h_WTR=0; end
if h_IFR<=0; h_IFR=0; end
if h_FB<=0; h_FB=0; end

end %itr2

end %itr




