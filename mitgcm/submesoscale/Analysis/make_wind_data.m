clear all

project_name = ['submesoscale']

project_name1 = ['/hexagon/work/milicak/RUNS/mitgcm/' project_name '/input_exp1.0/'];

prec = 'real*8';
ieee = 'b';

Nx = 1152;
Ny = 1152;
dx = 200; % meter
fid=fopen('/bcmhsm/milicak/RUNS/mitgcm/submesoscale/flat_setup/taux.init','r','b');
A = fread(fid,'double');
taux_ini = reshape(A,[Nx Ny]);
fclose(fid);
f0 = -1.5E-4;
%x = 0.5*dx:dx:dx*Nx;
%y = x;
%[x y] = meshgrid(x,y);
x=rdmds('/bcmhsm/milicak/RUNS/mitgcm/submesoscale/rough_topo/XC');
y=rdmds('/bcmhsm/milicak/RUNS/mitgcm/submesoscale/rough_topo/YC');
xcenter = 125e3;
ycenter = 125e3;
radius = 80e3;

tau=2.0*exp(-(((y-ycenter)./radius).^2+((x-xcenter)./radius).^2));
[TH,R] = cart2pol((x(:,:)-xcenter),(y(:,:)-ycenter));
taux = -tau.*sin(TH);
tauy = tau.*cos(TH);

Nitr=80; % 20 days travel time and every 6 hours, so N=20*4=80;

% Every 6 hours the wind will be updated and it will stay first 24 hours at the same point
% Then it will die in 4 days
for itr=1:4
%taux2d(:,:,itr) = taux_ini+taux; % 24 hours / 6 hours = 4 time steps
%tauy2d(:,:,itr) = tauy; % 24 hours / 6 hours = 4 time steps
taux2d(:,:,itr) = taux_ini-taux; % 24 hours / 6 hours = 4 time steps
tauy2d(:,:,itr) = -tauy; % 24 hours / 6 hours = 4 time steps
end
for itr=5:Nitr+1
  time=6*3600*(itr-1)-6*3600*4; %6 hours 6*3600
  %taux2d(:,:,itr) = taux_ini+taux*exp(-abs(0.08*f0)*time);
  %tauy2d(:,:,itr) = tauy*exp(-abs(0.08*f0)*time);
  taux2d(:,:,itr) = taux_ini-taux*exp(-abs(0.08*f0)*time);
  tauy2d(:,:,itr) = -tauy*exp(-abs(0.08*f0)*time);
end 


%write the wind forcing
fid=fopen([project_name1 'taux.forcing'],'w',ieee); fwrite(fid,taux2d,prec); fclose(fid);
fid=fopen([project_name1 'tauy.forcing'],'w',ieee); fwrite(fid,tauy2d,prec); fclose(fid);
