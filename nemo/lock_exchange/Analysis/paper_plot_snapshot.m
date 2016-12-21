clear all
%close all

format long

root_name = ['/export/grunchfs/unibjerknes/milicak/bckup/nemo/lock_exchange/'];

%No-slip cases
project_name=['FCT4-flux-cen2']
%project_name=['FCT4-flux-ubs']
%project_name=['FCT4-vect-eenH']
%project_name=['FCT2-flux-cen2']
%project_name=['FCT2-flux-ubs']
%project_name=['FCT2-vect-eenH']

%project_name=['FCT4-flux-cen2']
%project_name=['FCT4-flux-ubs']
%project_name=['FCT4-vect-een']
%project_name=['FCT4-vect-eenH']
%project_name=['FCT4-vect-ene']
%project_name=['FCT4-vect-ens']

%filename=[root_name project_name '/NOTlin-' project_name '_30mi_00010101_00010101_grid_T.nc'];
filename=[root_name project_name '/NOTlin-' project_name '-fs_30mi_00010101_00010102_grid_T.nc'];

Nx=128;
Nz=20;
Ny=1;
H=20.0; %meter
depth_2d=H*ones(Nx,Nz);
L=64e3;
W=0.5e3;
g=9.81;
rho0=1000;
alpha_T=0.2; %alpha
beta_S=0.8; %beta
dx=500; %meter
delta_x=dx*ones(Nx,Nz);
delta_y=500; %meter

%volume=delta_x.*delta_y.*delta_z;
x=nc_read(filename,'nav_lon');
y=nc_read(filename,'nav_lat');

for time=[34]      %time indices

real_ind=time;
itr=time;
%temp=nc_read(filename,'thetao',itr);
%dz=nc_read(filename,'e3tinst',itr);
temp=nc_read(filename,'thetao2',itr);
dz=nc_read(filename,'e3t',itr);
eta=nc_read(filename,'zos',itr);
%temp(delta_z_ref==0)=NaN;

% walls are removed;
temp=squeeze(temp(2:end-1,2,1:end-1));
delta_z=squeeze(dz(2:end-1,2,1:end-1));
eta=squeeze(eta(2:end-1,2));


% This is due to zstar used in MITGCM; look at table 7.1 in mom4p1 manual
%corr=(1.0+eta./depth);
%corr=repmat(corr,[1 1 Nz]); 
%delta_z=delta_z_ref.*corr;

% compute rho using linear EOS
% No effect of salt
rho=(rho0-alpha_T*(temp)+beta_S*35.0)-0.*1020.0;   %+0.8.*salt;
%keyboard

%%%% COMPUTE POTENTIAL ENERGY = g*rho*z_rho*dz  %%%%%%%%%%%%%%%%%%%%%%%
clear z_w
z_w(1:Nx,1:Nz+1)=0; 
%z_w(:,:,Nz+1:-1:2)=cumsum(delta_z,3);
z_w(:,2:Nz+1)=cumsum(delta_z,2);
z_rho=0.5*(z_w(:,2:end)+z_w(:,1:end-1));
z_rho=depth_2d-z_rho;


xx=x(2:end-1,2);
xx=repmat(xx,[1 20]);

pcolor(xx,z_rho,rho);shf
xlabel('x [km]')
ylabel('Depth [m]')
set(gcf, 'units', 'centimeters', 'pos', [2 1.20 42.5 10])
set(gca, 'units', 'centimeters', 'pos', [2 1.2 37 8])
set(gcf, 'PaperPositionMode','auto')

timereal=time*0.5; %every half an hour
title(project_name)
%printname=['paperfigs/snapshotrho_time_' num2str(timereal) '_hours']
%print(1,'-dpng',printname)
%print(1,'-depsc2',printname)

%time_days(real_ind)=time*deltat/86400;
real_ind

%if (time==34)
%keyboard
%end

end %time slice





