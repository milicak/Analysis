clear all; %close all;

tau0 = 0.2 ; %Pa=N/m2
rho0 = 1e3; %kg/m3

N = sqrt(6e-6);
H = 1e3;
L = 200e3;

x = [-200e3:1e3:200e3];
z = [0:10:H];

a = 50; %layer thickness under the effect of winds

r=[1:100];


k = 2*pi/L ;

f = 1.45e-4;
Tf = 2*pi/f; %inertial period
T = 0.5*Tf; %take half of intertial period as forcing period

time=0:T/10:10*T;
tavg=time;
tavg(tavg>T)=T;

[x2d,z2d] = meshgrid(x,z);
[X,Z,R] = meshgrid(x,z,r);
%[~,~,~,tavg] = meshgrid(x,z,r,tavg);

windX = tau0/rho0.*cos(k.*x2d);
%windX = tau0/rho0.*sin(k.*x2d);
%windX = tau0/rho0;
Z0 = 1/H;
Zr = 2*sin(R*pi*a/H)./(R*pi*a);

phi0 = 1;
phiR = cos(R.*pi.*Z./H);
lambda = R.* pi./ N ./ H;
sr = f.*sqrt(1 + k.^2./f^2./lambda.^2);

vIz = f.^2./sr.^3.*Zr.*phiR;
vIzt = sum(vIz,3);
vItot = windX.*vIzt;
vGz = (1 - f.^2./sr.^2).*Zr.*phiR;
vGzt = sum(vGz,3);
vGtot = T.*windX.*(Z0.*phi0 + vGzt);

%vItot = sum(vI,3);
%vGtot = sum(vG,3);

vItot=vItot*1e2;
vGtot=vGtot*1e2;
vtot = vItot + vGtot;

figure
pcolor(X(:,:,1),-Z(:,:,1),vItot); shading interp; colorbar;
title(['Inertial velocity, r = ',num2str(length(r))]);

figure
pcolor(X(:,:,1),-Z(:,:,1),vGtot); shading interp; colorbar;
title(['Geostrophic velocity, r = ',num2str(length(r))]);

figure
pcolor(X(:,:,1),-Z(:,:,1),vtot); shading interp; colorbar;
title(['Inertial + Geostrophic velocity, r = ',num2str(length(r))]);

