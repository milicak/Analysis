clear all
%close all

format long

root_name = ['/export/grunchfs/unibjerknes/milicak/bckup/nemo/lock_exchange/'];

%No-slip cases
%project_name=['FCT4-flux-cen2']
%project_name=['FCT4-flux-ubs']
%project_name=['FCT4-vect-eenH']
%project_name=['FCT2-flux-cen2']
project_name=['FCT2-flux-ubs']
%project_name=['FCT2-flux-ubs-fs-exp']
%project_name=['FCT2-vect-eenH']

%project_name=['FCT4-flux-cen2']
%project_name=['FCT4-flux-ubs']
%project_name=['FCT4-vect-een']
%project_name=['FCT4-vect-eenH']
%project_name=['FCT4-vect-ene']
%project_name=['FCT4-vect-ens']

%filename=[root_name project_name '/NOTlin-' project_name '_30mi_00010101_00010101_grid_T.nc'];

%filename=[root_name project_name '/NOTlin-' project_name '_30mi_00010101_00010102_grid_T.nc'];
%filenameu=[root_name project_name '/NOTlin-' project_name '_30mi_00010101_00010102_grid_U.nc'];
%filenamev=[root_name project_name '/NOTlin-' project_name '_30mi_00010101_00010102_grid_V.nc'];
filename=[root_name project_name '/NOTlin-' project_name '-fs_30mi_00010101_00010102_grid_T.nc'];
filenameu=[root_name project_name '/NOTlin-' project_name '-fs_30mi_00010101_00010102_grid_U.nc'];
filenamev=[root_name project_name '/NOTlin-' project_name '-fs_30mi_00010101_00010102_grid_V.nc'];

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

for time=1:68       %time indices

real_ind=time;
itr=time;
%temp=nc_read(filename,'thetao',itr);
%dz=nc_read(filename,'e3tinst',itr);
temp=nc_read(filename,'thetao2',itr);
dz=nc_read(filename,'e3t',itr);
eta=nc_read(filename,'zos',itr);
%temp(delta_z_ref==0)=NaN;
uvel=nc_read(filenameu,'uo',itr);
vvel=nc_read(filenamev,'vo',itr);

% walls are removed;
temp=squeeze(temp(2:end-1,2,1:end-1));
delta_z=squeeze(dz(2:end-1,2,1:end-1));
eta=squeeze(eta(2:end-1,2));
uvel=squeeze(uvel(2:end-1,2,1:end-1));
vvel=squeeze(vvel(2:end-1,2,1:end-1));
% no slip on the left wall


% This is due to zstar used in MITGCM; look at table 7.1 in mom4p1 manual
%corr=(1.0+eta./depth);
%corr=repmat(corr,[1 1 Nz]); 
%delta_z=delta_z_ref.*corr;

% compute rho using linear EOS
% No effect of salt
rho=(rho0-alpha_T*(temp)+beta_S*35.0)-0.*1020.0;   %+0.8.*salt;
%keyboard

rho_not_sort=rho(:);
rho_not_sort_dz=delta_z(:).*delta_x(:).*delta_y(:)./(L*W);
rho_not_sort_dz(isnan(rho_not_sort)==1)=[];
rho_not_sort(isnan(rho_not_sort)==1)=[];

[rho_sort I]=sort(rho_not_sort,'descend');
rho_sort_dz=rho_not_sort_dz(I);

clear dnm layer rho_sort_z_rho rho_sort_z_w
rho_sort_z_w(2:length(rho_sort_dz)+1)=cumsum(rho_sort_dz); 
rho_sort_z_rho=0.5*(rho_sort_z_w(1:end-1)+rho_sort_z_w(2:end));

%%%% COMPUTE RERENCE POTENTIAL ENERGY = g*rho_sort*z_rho_sort*dz  %%%%%%%%%%%%%%%%%%%%%%%
dnm=rho_sort.*rho_sort_dz.*rho_sort_z_rho'.*L*W;
rpe(real_ind)=g*nansum(dnm(:));

%rho_sort_time(real_ind,:)=rho_sort;
%rho_sort_z_rho_time(real_ind,:)=rho_sort_z_rho;
%rho_sort_dz_time(real_ind,:)=rho_sort_dz;

%%%% COMPUTE POTENTIAL ENERGY = g*rho*z_rho*dz  %%%%%%%%%%%%%%%%%%%%%%%
clear z_w
z_w(1:Nx,1:Nz+1)=0; 
%z_w(:,:,Nz+1:-1:2)=cumsum(delta_z,3);
z_w(:,2:Nz+1)=cumsum(delta_z,2);
z_rho=0.5*(z_w(:,2:end)+z_w(:,1:end-1));
z_rho=depth_2d-z_rho;
dnm=z_rho.*delta_x.*delta_y.*delta_z.*rho;
pe(real_ind)=g*nansum(dnm(:));

%%%% COMPUTE AVAILABLE POTENTIAL ENERGY = pe-rpe  %%%%%%%%%%%%%%%%%%%%%%%
ape(real_ind)=pe(real_ind)-rpe(real_ind);

%%%% COMPUTE MOLECULAR MIXING = kappa*g*(drhodz)*dz*dx*dy  %%%%%%%%%%%%%%%%%%%%%%%
%drhodz(:,:,2:Nz)=(rho(:,:,2:end)-rho(:,:,1:end-1))./(0.5*(delta_z(:,:,2:end)+delta_z(:,:,1:end-1)));
%dnm=kappa*delta_x.*delta_y.*delta_z.*drhodz;
%psi(real_ind)=g*nansum(dnm(:));

%%%% COMPUTE KINETIC ENERGY  = 0.5*rho*(u^2+v^2+w^2)*dz %%%%%%%%%%%%%%%%%%%%%%%
%dnm=0.5*rho.*(u_rho.^2+v_rho.^2).*delta_z.*delta_y.*delta_x;
%ke(real_ind)=nansum(dnm(:));

%%%% COMPUTE KINETIC ENERGY using rho0 = 0.5*rho0*(u^2+v^2)*dz %%%%%%%%%%%%%%%%%%%%%%%
dnm=0.5*(uvel.^2+vvel.^2).*delta_z.*delta_y.*delta_x;
ke_bouss(real_ind)=nansum(dnm(:));

%%%% COMPUTE DISSIPATION  = nu*(grad(u))^2 %%%%%%%%%%%%%%%%%%%%%%%
%[epsilon epsilon_rho]=compute_dissipation(rho,u,v,w,u_rho,v_rho,w_rho,visc,delta_x,delta_y,delta_z,Nx,Ny,Nz);
%dissp(real_ind)=nansum(epsilon(:));
%dissp_rho(real_ind)=nansum(epsilon_rho(:));

%%%% COMPUTE WB conversion wb=w*g*(rho-rho0)dz %%%%%%%%%%%%%%%%%%%%%%%
%dnm=w_rho.*(rho).*delta_x.*delta_y.*delta_z;
%%dnm=w_rho.*(rho-0.0*rho0).*delta_x.*delta_y.*delta_z;
%wb(real_ind)=g*nansum(dnm(:));

%time_days(real_ind)=time*deltat/86400;
real_ind

%%%% Save into a mat file %%%%%%%%
%save([filename],'rpe','pe','ape','ke','ke_bouss','dissp','dissp_rho', 'wb','time_days','delta_rho','T_buoy','u_charc','visc','psi')
%display('matfile saved')
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

end %time slice





