clear all
%close all

format long

%root_name=['/lustre/fs/scratch/Mehmet.Ilicak/RUNS/mitgcm/mix_eff/'];
root_name=['/hexagon/work/milicak/RUNS/mitgcm/mix_eff/'];
%root_name=['/home/fimm/bjerknes/milicak/mnt/vilje/RUNS/mitgcm/mix_eff/'];
%root_name=['/vftmp/Mehmet.Ilicak/RUNS/mitgcm/mix_eff/'];

project_name=['Exp01.6']

foldername=[root_name project_name '/']

nondimensional=true
H=0.2; %meter
L=H*8;
W=H*0.5;
visc=1e-6;
kappa=1e-7;
Pr=visc/kappa;
g=9.81;
rho0=1e3;
skip=1;
timeini=0;

real_ind=1;
if(nondimensional)
depth=H;
L=L/H;
W=W/H;
if(project_name=='Exp01.0')
  dumpfreq=120; %1;   %10; %from data in the run folder
  deltat=0.02; %0.0025; %0.008; %0.02; %from data in the run folder
  Nx=1152;Ny=72;Nz=144;
  load matfiles/Exp01.0_energetics.mat
  %timeini=438000;
  timeini=672000+6000;
elseif(project_name=='Exp01.1')
  dumpfreq=120; %1;   %10; %from data in the run folder
  deltat=0.02; %0.0025; %0.008; %0.02; %from data in the run folder
  Nx=1152;Ny=72;Nz=144;
  load matfiles/Exp01.1_energetics.mat
  %timeini=378000;
  timeini=618000+6000;
elseif(project_name=='Exp01.2')
  dumpfreq=100; %1;   %10; %from data in the run folder
  deltat=0.02; %0.0025; %0.008; %0.02; %from data in the run folder
  Nx=1152;Ny=72;Nz=144;
  load matfiles/Exp01.2_energetics.mat
  %timeini=435000;
  timeini=680000+5000;
elseif(project_name=='Exp01.3')
  dumpfreq=50; %1;   %10; %from data in the run folder
  deltat=0.02; %0.0025; %0.008; %0.02; %from data in the run folder
  Nx=2304;Ny=144;Nz=288;
  load matfiles/Exp01.3_energetics.mat
  timeini=80000;
elseif(project_name=='Exp01.6')
  dumpfreq=10; %1;   %10; %from data in the run folder
  deltat=0.01; %0.0025; %0.008; %0.02; %from data in the run folder
  Nx=2304;Ny=144;Nz=288;
  load matfiles/Exp01.6_energetics.mat
  %timeini=48000;
  timeini=247000+1000;
end
real_ind=size(rpe,2)+1;
depth_3d=1;
delta_x=L/Nx;
delta_y=W/Ny;
delta_z=1/Nz;
delta_z_ref=delta_z;
end

%break
%%%% clear variables %%%%
clear hfacc xc yc dxc dyc
%%%%%%%%%%%%%%%%%%%%%%%%%

timeend=1218*(dumpfreq/deltat);

for time=timeini:skip*dumpfreq/deltat:timeend       %time indices

itr=time;
temp=double(rdmds([foldername 'T'],itr));
temp(temp==0)=NaN;
% No effect of salt
%salt=double(rdmds([foldername 'S'],itr));
%salt(delta_z_ref==0)=NaN;
eta=rdmds([foldername 'Eta'],itr);
%u=rdmds([foldername 'U'],itr);
%v=rdmds([foldername 'V'],itr);
%w=rdmds([foldername 'W'],itr);

% This is due to zstar used in MITGCM; look at table 7.1 in mom4p1 manual
corr=(1.0+eta./depth);
corr=repmat(corr,[1 1 Nz]); 
delta_z=delta_z_ref.*corr;
clear corr eta

% compute rho using linear EOS
rho=(rho0-0.2*temp);   %+0.8.*salt;
clear temp
if(time==0)
rho_min=min(rho(:));
delta_rho=max(rho(:))-min(rho(:));
N_infnty=sqrt(g*delta_rho/((rho0)*H));
T_buoy=2*pi/N_infnty;
u_charc=sqrt(0.5*H*g*delta_rho/rho0);
if(nondimensional)
Re=u_charc*H/visc;
visc=1/Re;
kappa=1/(Re*Pr);
end
elseif(time~=0 & time==timeini)
rho1=(rho0-0.2*20);   %+0.8.*salt;
rho_max=min(rho1(:));
clear rho1
Re=u_charc*H/visc;
visc=1/Re;
kappa=1/(Re*Pr);
end

if(nondimensional)
% non-dimensionalize density
rho=1-((rho_max-rho)./delta_rho);   %+0.8.*salt;
end

% remove rho_min for accuracy
%rho=rho-rho_min+0.5;

rho_not_sort=rho(:);
aa=rho_not_sort;
rho_not_sort_dz=delta_z(:).*delta_x(:).*delta_y(:)./(L*W);
rho_not_sort_dz(isnan(rho_not_sort)==1)=[];
rho_not_sort(isnan(rho_not_sort)==1)=[];

[rho_sort I]=sort(rho_not_sort,'descend');
rho_sort_dz=rho_not_sort_dz(I);

clear dnm layer rho_sort_z_rho rho_sort_z_w rho_not_sort rho_not_sort_dz
rho_sort_z_w(2:length(rho_sort_dz)+1)=cumsum(rho_sort_dz); 
rho_sort_z_rho=0.5*(rho_sort_z_w(1:end-1)+rho_sort_z_w(2:end));

%%%% COMPUTE RERENCE POTENTIAL ENERGY = g*rho_sort*z_rho_sort*dz  %%%%%%%%%%%%%%%%%%%%%%%
dnm=rho_sort.*rho_sort_dz.*rho_sort_z_rho'.*L*W;
rpe(real_ind)=g*nansum(dnm(:));
clear dnm rho_sort_z_w 

%%%% COMPUTE RERENCE POTENTIAL ENERGY DISSIPATION = g*rho_sort*z_rho_sort*dz  %%%%%%%%%%%%%%%%%%%%%%%
drhodx(2:Nx,:,:)=(rho(2:end,:,:)-rho(1:end-1,:,:))./(delta_x);
drhody(:,2:Ny,:)=(rho(:,2:end,:)-rho(:,1:end-1,:))./(delta_y);
drhodz(:,:,2:Nz)=(rho(:,:,2:end)-rho(:,:,1:end-1))./(0.5*(delta_z(:,:,2:end)+delta_z(:,:,1:end-1)));
dzstardrho(2:length(rho_sort))=(rho_sort_z_rho(2:end)-rho_sort_z_rho(1:end-1))'./(rho_sort(2:end)-rho_sort(1:end-1));
dzstardrho(isinf(dzstardrho))=NaN;
dnm=(drhodx.^2+drhodx.^2+drhodz.^2).*delta_x.*delta_y.*delta_z;
dnm=dnm(:);
dnm(isnan(aa)==1)=[];
dnm2=dnm(I);
dnm=kappa*dnm2'.*dzstardrho;
phi_dissp(real_ind)=g*nansum(dnm(:));

%%%% clear variables %%%% 
clear dnm dnm2 dzstardrho drhodx drhody rho_sort_z_rho rho_sort aa rho_sort_dz I
%%%%%%%%%%%%%%%%%%%%%%%%%

%%%% COMPUTE POTENTIAL ENERGY = g*rho*z_rho*dz  %%%%%%%%%%%%%%%%%%%%%%%
clear z_w
z_w(1:Nx,1:Ny,1:Nz+1)=0; 
%z_w(:,:,Nz+1:-1:2)=cumsum(delta_z,3);
z_w(:,:,2:Nz+1)=cumsum(delta_z,3);
z_rho=0.5*(z_w(:,:,2:end)+z_w(:,:,1:end-1));
z_rho=depth_3d-z_rho;
dnm=z_rho.*delta_x.*delta_y.*delta_z.*rho;
pe(real_ind)=g*nansum(dnm(:));
clear dnm z_w z_rho

%%%% COMPUTE AVAILABLE POTENTIAL ENERGY = pe-rpe  %%%%%%%%%%%%%%%%%%%%%%%
ape(real_ind)=pe(real_ind)-rpe(real_ind);

%%%% COMPUTE MOLECULAR MIXING = kappa*g*(drhodz)*dz*dx*dy  %%%%%%%%%%%%%%%%%%%%%%%
dnm=kappa*delta_x.*delta_y.*delta_z.*drhodz;
psi(real_ind)=g*nansum(dnm(:));
rho_top=rho(:,:,1);
rho_bottom=rho(:,:,end);
rho_top=nanmean(rho_top(:));
rho_bottom=nanmean(rho_bottom(:));
psi2(real_ind)=g*kappa*(rho_bottom-rho_top)*(L*W);

%%%% clear variables %%%%
clear dnm  drhodz
%%%%%%%%%%%%%%%%%%%%%%%%%

u=rdmds([foldername 'U'],itr);
v=rdmds([foldername 'V'],itr);
w=rdmds([foldername 'W'],itr);

% for periodic and/or closed boundries in MITgcm
u(end+1,:,:)=u(1,:,:);
v(:,end+1,:)=v(:,1,:);
w(:,:,end+1)=0;
if(nondimensional)
% non-dimensionalize velocities
u = u./u_charc;
v = v./u_charc;
w = w./u_charc;
end
u_rho=0.5*(u(1:end-1,:,:)+u(2:end,:,:));
v_rho=0.5*(v(:,1:end-1,:)+v(:,2:end,:));
w_rho=0.5*(w(:,:,2:end)+w(:,:,1:end-1));

%%%% COMPUTE KINETIC ENERGY  = 0.5*rho*(u^2+v^2+w^2)*dz %%%%%%%%%%%%%%%%%%%%%%%
dnm=0.5*rho.*(u_rho.^2+v_rho.^2+w_rho.^2).*delta_z.*delta_y.*delta_x;
ke(real_ind)=nansum(dnm(:));

%%%% COMPUTE KINETIC ENERGY using rho0 = 0.5*rho0*(u^2+v^2)*dz %%%%%%%%%%%%%%%%%%%%%%%
dnm=0.5*(u_rho.^2+v_rho.^2+w_rho.^2).*delta_z.*delta_y.*delta_x;
ke_bouss(real_ind)=nansum(dnm(:));

clear dnm
%%%% COMPUTE DISSIPATION  = nu*(grad(u))^2 %%%%%%%%%%%%%%%%%%%%%%%
[epsilon epsilon_rho]=compute_dissipation_fromrestart(rho,u,v,w,u_rho,v_rho,w_rho,visc,delta_x,delta_y,delta_z,Nx,Ny,Nz);
dissp(real_ind)=nansum(epsilon(:));
dissp_rho(real_ind)=nansum(epsilon_rho(:));

%%%% clear variables %%%%
clear dnm u v w u_rho v_rho epsilon epsilon_rho
%%%%%%%%%%%%%%%%%%%%%%%%%

%%%% COMPUTE WB conversion wb=w*g*(rho-rho0)dz %%%%%%%%%%%%%%%%%%%%%%%
dnm=w_rho.*(rho).*delta_x.*delta_y.*delta_z;
%dnm=w_rho.*(rho-0.0*rho0).*delta_x.*delta_y.*delta_z;
wb(real_ind)=g*nansum(dnm(:));

%%%% clear variables %%%%
clear dnm w_rho rho
%%%%%%%%%%%%%%%%%%%%%%%%%

time_days(real_ind)=time*deltat/86400;
real_ind
real_ind=real_ind+1;

%%%% Save into a mat file %%%%%%%%
if(nondimensional)
filename=[project_name '_energetics.mat']
save(['matfiles/' filename],'rpe','pe','ape','ke','ke_bouss','dissp','dissp_rho', 'wb','time_days','delta_rho','T_buoy','u_charc','Re','psi','psi2','phi_dissp')
else
filename=[project_name '_energetics_dimensional.mat']
save(['matfiles/' filename],'rpe','pe','ape','ke','ke_bouss','dissp','dissp_rho', 'wb','time_days','delta_rho','T_buoy','u_charc','visc','psi','psi2','phi_dissp')
end
display('matfile saved')
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

end %time slice

%break




