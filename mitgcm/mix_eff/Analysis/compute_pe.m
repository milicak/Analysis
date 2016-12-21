clear all
%close all

format long

%root_name=['/lustre/fs/scratch/Mehmet.Ilicak/RUNS/mitgcm/mix_eff/'];
%root_name=['/hexagon/work/milicak/RUNS/mitgcm/mix_eff/'];
root_name=['/export/grunchfs/unibjerknes/milicak/bckup/mitgcm/mix_eff/'];
%root_name=['/vftmp/Mehmet.Ilicak/RUNS/mitgcm/mix_eff/'];

project_name=['Exp02.0']

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
dumpfreq=10; %1;   %10; %from data in the run folder
deltat=0.02; %0.0025; %0.008; %0.02; %from data in the run folder
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
delta_z_ref=delta_z;
delta_x=repmat(dxc,[1 1 Nz]);
delta_y=repmat(dyc,[1 1 Nz]);
depth_3d=repmat(depth,[1 1 Nz]);

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
%%%% clear variables %%%%
clear hfacc xc yc dxc dyc
%%%%%%%%%%%%%%%%%%%%%%%%%

if(project_name=='Exp01.0')
load matfiles/Exp01.0_energetics.mat
real_ind=size(rpe,2);
timeini=real_ind*dumpfreq/deltat;
end

for time=timeini:skip*dumpfreq/deltat:timeend       %time indices

itr=time;
temp=double(rdmds([foldername 'T'],itr));
temp(delta_z_ref==0)=NaN;
eta=rdmds([foldername 'Eta'],itr);

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
temp=double(rdmds([foldername 'T'],0));
temp(delta_z_ref==0)=NaN;
rho1=(rho0-0.2*temp);   %+0.8.*salt;
rho_min=min(rho1(:));
clear rho1 temp
Re=u_charc*H/visc;
visc=1/Re;
kappa=1/(Re*Pr);
end

if(nondimensional)
% non-dimensionalize density
rho=(rho-rho_min)./delta_rho;   %+0.8.*salt;
end

% remove rho_min for accuracy
%rho=rho-rho_min+0.5;


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

time_days(real_ind)=time*deltat/86400;
real_ind
real_ind=real_ind+1;

%%%% Save into a mat file %%%%%%%%
if(nondimensional)
filename=[project_name '_pe.mat']
save(['matfiles/' filename],'pe','time_days','delta_rho','T_buoy','u_charc','Re')
else
filename=[project_name '_pe_dimensional.mat']
save(['matfiles/' filename],'pe','wb','time_days','delta_rho','T_buoy','u_charc','visc')
end
display('matfile saved')
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

end %time slice

%break




