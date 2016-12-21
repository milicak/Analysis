clear all
%close all

format long

%root_name=['/lustre/fs/scratch/Mehmet.Ilicak/RUNS/mitgcm/mix_eff/'];

root_name=['/vftmp/Mehmet.Ilicak/RUNS/mitgcm/mix_eff/'];

project_name=['Exp01.3']

foldername=[root_name project_name '/']

nondimensional=false;
H=0.2; %meter
L=H*8;
W=H*0.5;
visc=1e-6;
g=9.81;
rho0=1e3;
skip=1;
dumpfreq=10;   %10; %from data in the run folder
deltat=0.02; %from data in the run folder
timeend=166*(dumpfreq/deltat);

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


temp=double(rdmds([foldername 'T'],0));
temp(delta_z_ref==0)=NaN;
rho=(rho0-0.2*temp);
delta_rho=max(rho(:))-min(rho(:));
u_charc=sqrt(0.5*H*g*delta_rho/rho0);


time=15*dumpfreq/deltat       %time indices
itr=time;

eta=rdmds([foldername 'Eta'],itr);
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

u_rho = u_rho./u_charc;
v_rho = v_rho./u_charc;
w_rho = w_rho./u_charc;

%%%% COMPUTE KINETIC ENERGY = 0.5*(u^2+v^2+w^2)*dx*dy*dz %%%%%%%%%%%%%%%%%%%%%%%
KE=0.5*(u_rho.^2+v_rho.^2+w_rho.^2).*delta_z.*delta_y.*delta_x;
KE2=0.5*(u_rho.^2+v_rho.^2+w_rho.^2);


dx=L/H/Nx;
dy=W/H/Ny;
dz=H/H/Nz;

dnm=squeeze(KE(600,end/2,:));

%dnm=squeeze(KE(end/2,end/2,:));
%dnm=squeeze(KE(:,end/2,end/4));

dummy=dnm;
%dummy=dnm-mean(dnm);

Fs=1/dz;
nfft=256;
novlp=nfft-1;wind=nfft;
[p,f]=spectrum(dummy,nfft,novlp,wind,1/dz);
[Pxx,k_wave]=pwelch(dummy,wind,novlp,nfft,Fs);
loglog(f,p(:,1),'r-');
hold on
loglog(k_wave,Pxx)


%[Pxx k_wave]=pwelch(dummy,[],[],nfft,Fs);
%l_wave=(k_wave).^-1;







