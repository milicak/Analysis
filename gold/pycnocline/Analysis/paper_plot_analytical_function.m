clear all
% Ehlert and Leverman 2014;
% Mechanism for potential strengthening of Atlantic overturning prior to collapse
% temperature evolution equations
% for git hub
tempevl = false;
FWforce = false;
nthousand = 2; % number of thousand years
%diffusivity = 'N2 dependent'; % 'constant diff' ; 'constant energy' ; 'N2 dependent'
%diffusivity = 'constant diff'; % 'constant diff' ; 'constant energy' ; 'N2 dependent'
%diffusivity = 'constant energy'; % 'constant diff' ; 'constant energy' ; 'N2 dependent'
% Table 1
C1 = 0.1; %nondimensional coeff for MOC transport
m3s2Sv = 1e-6; 
grav = 9.81; %m2/s

bathy = 5000; %in m ; Average depth of Atlantic Ocean basin
B = 1e7; % in m ; Average width of Atlantic Ocean
LN = 3.34*1e6; %in m ; Meridional extend of the northen box
LU = 8.9*1e6;  %in m ; Meridional extend of the tropical box
LS = 3.34*1e6; %in m ; Meridional extend of the southern box
LyN = 1.5*1e6; % Meridional extend of the northen outcropping

rho0 = 1027; %kgm-3
S0 = 35; % psu ; Average salinity of Atlantic Ocean
alpha_T = 2.1e-4; % 1/C thermal coefficient
alphaT = alpha_T*rho0;
beta_S = 8e-4; % 1/psu haline coefficient
betaS = beta_S*rho0;
f0 = 7.5e-5; %1/s
fbeta = 2e-11; % 1/s

kappa_GM = 1000; %m2/s GM thickness diffusivity
kappa_cnst = 8.2e-5; %m2/s Background vertical diffusivity
epsilon = 1e-4; % kg s-3 constant dissipation energy in the ocean per area
N0 = 8e-3; % 1/s used in N2 dependent diffusivity 
a0 = 1e-5; % m2/s constant diffusivity used in N2 dependent diffusivity
tau = 0.1-0.02*1.0; %Nm-2 = kgm-1s-2
Cgm = (1-exp(-tau/0.02)); % it can be 1 for simplicity
FN = 0.2*1e6; % Sv ; Northern meridional freshwater transport
FNd = 0;
FNFW = 0; %initial freshwater into nordic seas
FNFW_cap = 2e6; % cap of freshwater 
FS = 0.2*1e6; %Sv ; Southern meridional freshwater transport
gammau = 1/(5*365*86400); % 5 years
gamman = 1/(5*365*86400); % 5 years
gammas = 1/(5*365*86400); % 5 years
TUrelax = 30;
TNrelax = 4;
TSrelax = 3;

SN=35; % Nortern Atlantic water
SU=35; % Upper pycnocline water
SS=35; % Southern Ocean water
SD=35; % Deep thermocline water
SA=35; % Antarctic Bottom Water
TN = 4;
TS = 3;
TU = 30.5; %12.5;
TD = 7; 
TA = 2; 

H_pyc = 100; % initial conditions
H_AADW = 2000;
H_deep = bathy-H_pyc-H_AADW;
VU = LU*B*H_pyc;
VN = LN*B*bathy;
VS = LS*B*bathy;
VD = LU*B*H_deep;
VA = LU*B*H_AADW;
	
yearinsec = 360*86400; % 1 year in sec
deltat = 15*86400; %30 days to sec
time = 0;
iind = 1;

filename='workspace1.mat'
save(filename)

moc=[];

[TrN,TrW,TrU,TrE1,TrE2,TrAADW,TrITU,SUtime,SNtime,SStime,SDtime,SAtime] ...
 = compute_analytic_solution(filename);
moc(end+1)=TrN(end)*1e-6;


%TrU=TrU(end)*1e-6;
%TrE1=TrE1(end)*1e-6;
%TrE2=TrE2(end)*1e-6;
%TrAADW=TrAADW(end)*1e-6;
%TrITU=TrITU(end)*1e-6;
%SNtime=SNtime(end);
%SAtime=SAtime(end);
%SStime=SStime(end);
%SDtime=SDtime(end);
%SUtime=SUtime(end);

