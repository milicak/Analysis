clear all

H = 0.2; %0:0.001:0.4;  %meter
delta_rho = 0:0.000001:6; %6; %kg/m3

nu = 1e-6; %m2/s
grav = 9.81; %m/s2
rho0 = 1e3; %kg/m3
alpha = 8; %aspect ratio in x
alpha2 = 0.5; %aspect ratio in y
L = alpha*H; %meter
W = alpha2*H; %meter

gprime = grav*delta_rho./rho0;

U = sqrt(0.5*gprime*H); %m/s
U_H = sqrt(gprime*H); %m/s

Re = U.*L/nu;
Re_v = U.*H./nu;

% find # of grid points required for Re number
% alpha*N^3 = Re^(9/4)

N3 = (Re.^(9/4))./(alpha*alpha2);
n_grids = N3.^(1/3);

N3_v = (Re_v.^(9/4))./(alpha*alpha2);
n_grids_v = N3_v.^(1/3);

k = U./nu;
l_turb = 1./k;

