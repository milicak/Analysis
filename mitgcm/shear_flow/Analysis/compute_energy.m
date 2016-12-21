clear all
%close all

format long

%root_name=['/bcmhsm/milicak/RUNS/mitgcm/shear_flow/'];
%root_name=['/work/milicak/RUNS/mitgcm/shear_flow/'];
root_name=['/hexagon/work/milicak/RUNS/mitgcm/shear_flow/'];

project_name=['Exp01.4']

foldername=[root_name project_name '/']

H=10; %nondimensional
L=H*1;
W=H*0.5;
Re=2e3; %Reynolds number
Pr=10;  %Prandtl number
Ri0=0.08; %Richardson number the gravity value in data file
kappa=1/(Re*Pr);

skip=1;

dumpfreq=1.0;   %10; %from data in the run folder
deltat=0.01; %from data in the run folder
timeini=0; %0;
timeend=4900*(dumpfreq/deltat);

depth=rdmds([foldername 'Depth']);
xc=rdmds([foldername 'XC']);
yc=rdmds([foldername 'YC']);
rc=rdmds([foldername 'RC']);
drc=rdmds([foldername 'DRC']);
drf=rdmds([foldername 'DRF']);
dxc=rdmds([foldername 'DXC']);
dyc=rdmds([foldername 'DYC']);
H_depth=-depth(:,2);
x=squeeze(xc(:,1));

Z=cumsum(sq(drc));
hfacc=rdmds([foldername 'hFacC']);         % Level thicknesses
dz=(sq(drf));
[Nx Ny Nz]=size(hfacc);
delta_z=repmat(dz,[1 Nx Ny]);
delta_z=permute(delta_z,[2 3 1]);
delta_z=delta_z.*hfacc;
delta_z_ref=delta_z;
delta_x=repmat(dxc,[1 1 Nz]);
delta_y=repmat(dyc,[1 1 Nz]);
depth_3d=repmat(depth,[1 1 Nz]);

real_ind=1;

%break

for time=timeini:skip*dumpfreq/deltat:timeend       %time indices

itr=time;
temp=double(rdmds([foldername 'T'],itr));
temp=temp+0.5; %make it between 0 and 1
temp(delta_z_ref==0)=NaN;
% No effect of salt
%salt=double(rdmds([foldername 'S'],itr));
%salt(delta_z_ref==0)=NaN;
eta=rdmds([foldername 'Eta'],itr);
%rigid-lid
%eta(:,:)=0.0;
u=rdmds([foldername 'U'],itr);
v=rdmds([foldername 'V'],itr);
w=rdmds([foldername 'W'],itr);

% This is due to zstar used in MITGCM; look at table 7.1 in mom4p1 manual
corr=(1.0+eta./depth);
corr=repmat(corr,[1 1 Nz]);
delta_z=delta_z_ref.*corr;

% for periodic and/or closed boundries in MITgcm
u(end+1,:,:)=u(1,:,:);
v(:,end+1,:)=v(:,1,:);
w(:,:,end+1)=0;
u_rho=0.5*(u(1:end-1,:,:)+u(2:end,:,:));
v_rho=0.5*(v(:,1:end-1,:)+v(:,2:end,:));
w_rho=0.5*(w(:,:,2:end)+w(:,:,1:end-1));

% density is equal to temperature
rho=(temp);
clear temp

% remove rho_min for accuracy
%rho=rho-rho_min+0.5;

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
rpe(real_ind)=Ri0*nansum(dnm(:));

%rho_sort_time(real_ind,:)=rho_sort;
%rho_sort_z_rho_time(real_ind,:)=rho_sort_z_rho;
%rho_sort_dz_time(real_ind,:)=rho_sort_dz;

%%%% COMPUTE POTENTIAL ENERGY = g*rho*z_rho*dz  %%%%%%%%%%%%%%%%%%%%%%%
clear z_w
z_w(1:Nx,1:Ny,1:Nz+1)=0;
%z_w(:,:,Nz+1:-1:2)=cumsum(delta_z,3);
z_w(:,:,2:Nz+1)=cumsum(delta_z,3);
z_rho=0.5*(z_w(:,:,2:end)+z_w(:,:,1:end-1));
z_rho=depth_3d-z_rho;
dnm=z_rho.*delta_x.*delta_y.*delta_z.*rho;
pe(real_ind)=Ri0*nansum(dnm(:));

%%%% COMPUTE AVAILABLE POTENTIAL ENERGY = pe-rpe  %%%%%%%%%%%%%%%%%%%%%%%
ape(real_ind)=pe(real_ind)-rpe(real_ind);

%%%% COMPUTE MOLECULAR MIXING = kappa*g*(drhodz)*dz*dx*dy  %%%%%%%%%%%%%%%%%%%%%%%
drhodz(:,:,2:Nz)=(rho(:,:,2:end)-rho(:,:,1:end-1))./(0.5*(delta_z(:,:,2:end)+delta_z(:,:,1:end-1)));
dnm=kappa*delta_x.*delta_y.*delta_z.*drhodz;
psi_int(real_ind)=Ri0*nansum(dnm(:));
rho_top=rho(:,:,1);
rho_bottom=rho(:,:,end);
rho_top=nanmean(rho_top(:));
rho_bottom=nanmean(rho_bottom(:));
psi(real_ind)=Ri0*(rho_bottom-rho_top)/(H*Re*Pr);


%%%% COMPUTE KINETIC ENERGY  = 0.5*rho*(u^2+v^2+w^2)*dz %%%%%%%%%%%%%%%%%%%%%%%
dnm=0.5*rho.*(u_rho.^2+v_rho.^2+w_rho.^2).*delta_z.*delta_y.*delta_x;
ke(real_ind)=nansum(dnm(:));

%%%% COMPUTE KINETIC ENERGY using rho0 = 0.5*rho0*(u^2+v^2)*dz %%%%%%%%%%%%%%%%%%%%%%%
dnm=0.5*(u_rho.^2+v_rho.^2+w_rho.^2).*delta_z.*delta_y.*delta_x;
ke_bouss(real_ind)=nansum(dnm(:));

%%%% COMPUTE DISSIPATION  = nu*(grad(u))^2 %%%%%%%%%%%%%%%%%%%%%%%
[epsilon epsilon_rho]=compute_dissipation(rho,u,v,w,u_rho,v_rho,w_rho,1/Re,delta_x,delta_y,delta_z,Nx,Ny,Nz);
dissp(real_ind)=nansum(epsilon(:));
dissp_rho(real_ind)=nansum(epsilon_rho(:));

%%%% COMPUTE WB conversion wb=w*g*(rho-rho0)dz %%%%%%%%%%%%%%%%%%%%%%%
dnm=w_rho.*(rho).*delta_x.*delta_y.*delta_z;
wb(real_ind)=Ri0*nansum(dnm(:));

time_days(real_ind)=time*deltat;
real_ind
real_ind=real_ind+1;


%%%% Save into a mat file %%%%%%%%
filename=[project_name '_energetics.mat']
save(['matfiles/' filename],'rpe','pe','ape','ke','ke_bouss','dissp','dissp_rho', 'wb','psi','psi_int','time_days','Re','Pr','Ri0')
display('matfile saved')
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

end %time slice

