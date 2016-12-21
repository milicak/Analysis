clear all
%close all

format long

%root_name=['/lustre/fs/scratch/Mehmet.Ilicak/RUNS/mitgcm/mix_eff/'];
root_name=['/hexagon/work/milicak/RUNS/mitgcm/mix_eff/'];

%root_name=['/vftmp/Mehmet.Ilicak/RUNS/mitgcm/mix_eff/'];

%3000 for Exp2.0 ; 3000 for Exp2.1 ; 7500 for Exp2.2 ; 14400 for Exp1.7 ; 17600 for Exp1.5
project_name=['Exp01.5']
time_vec=[0 17600]

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
dumpfreq=10;   %10; %from data in the run folder
deltat=0.008; %0.02; %from data in the run folder
timeini=0;
timeend=1218*(dumpfreq/deltat);

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
clear hfacc
delta_z_ref=delta_z;
delta_x=repmat(dxc,[1 1 Nz]);
delta_y=repmat(dyc,[1 1 Nz]);
depth_3d=repmat(depth,[1 1 Nz]);
clear dxc dyc

if(nondimensional)
depth_3d=depth_3d./H;
delta_z_ref=delta_z_ref./H;
delta_x=delta_x./H;
delta_y=delta_y./H;
delta_z=delta_z./H;
L=L/H;
W=W/H;
end
%volume=delta_x.*delta_y.*delta_z;

real_ind=1;

%break

for time=time_vec       %time indices

itr=time;
temp=double(rdmds([foldername 'T'],itr));
temp(delta_z_ref==0)=NaN;
% No effect of salt
%salt=double(rdmds([foldername 'S'],itr));
%salt(delta_z_ref==0)=NaN;
eta=rdmds([foldername 'Eta'],itr);
u=rdmds([foldername 'U'],itr);
v=rdmds([foldername 'V'],itr);
w=rdmds([foldername 'W'],itr);

% This is due to zstar used in MITGCM; look at table 7.1 in mom4p1 manual
corr=(1.0+eta./depth);
corr=repmat(corr,[1 1 Nz]); 
delta_z=delta_z_ref.*corr;
clear corr eta

% for periodic and/or closed boundries in MITgcm
u(end+1,:,:)=u(1,:,:);
v(:,end+1,:)=v(:,1,:);
w(:,:,end+1)=0;

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
end

if(nondimensional)
% non-dimensionalize density
rho=(rho-rho_min)./delta_rho;   %+0.8.*salt;
% non-dimensionalize velocities
u = u./u_charc;
v = v./u_charc;
w = w./u_charc;
end
u_rho=0.5*(u(1:end-1,:,:)+u(2:end,:,:));
v_rho=0.5*(v(:,1:end-1,:)+v(:,2:end,:));
w_rho=0.5*(w(:,:,2:end)+w(:,:,1:end-1));

%%%% COMPUTE DISSIPATION  = nu*(grad(u))^2 %%%%%%%%%%%%%%%%%%%%%%%
if(time~=0)
[epsilon epsilon_rho]=compute_dissipation(rho,u,v,w,u_rho,v_rho,w_rho,visc,delta_x,delta_y,delta_z,Nx,Ny,Nz);
end

time_days(real_ind)=time*deltat/86400;
real_ind
real_ind=real_ind+1;


end %time slice

%break

%variable=epsilon_rho;
variable=epsilon;
section=size(variable,2)*0.5;  %section 

%for Exp2.2
if(project_name=='Exp02.2')
hhh=figure('Visible','off');
dnm=squeeze(nanmean(variable,2));
pcolor(x./abs(H),Z./H,log10(dnm'));shading interp;colorbar;needJet2;caxis([-10 -7])
xlim([min(x)/abs(H) max(x)/abs(H)])
set(gca,'PlotBoxAspectRatio',[4 1 1])
ylabel('z')
xlabel('x')
caxis([-10 -7])
needJet2
printname=['paperfigs/mitgcm_epsilon_xzsection_mix_eff_mean_' [project_name] '.eps']
print(hhh,'-depsc2','-zbuffer','-r150',printname);
end

hhh=figure('Visible','off');
pcolor(x./abs(H),Z./H,log10(squeeze(variable(:,section,:))'));shading interp;colorbar
xlim([min(x)/abs(H) max(x)/abs(H)])
set(gca,'PlotBoxAspectRatio',[4 1 1])
ylabel('z')
xlabel('x')
%caxis([-10 -7])
caxis([-11 -8])
needJet2
printname=['paperfigs/mitgcm_epsilon_xzsection_mix_eff_' [project_name] '.eps']
print(hhh,'-depsc2','-zbuffer','-r150',printname);



