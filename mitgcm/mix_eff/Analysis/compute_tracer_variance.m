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
deltat=0.02; %0.01 0.0025; %0.008; %0.02; %from data in the run folder
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

drhodx(2:Nx,:,:)=(rho(2:end,:,:)-rho(1:end-1,:,:))./delta_x(2:end,:,:);
drhody(:,2:Ny,:)=(rho(:,2:end,:)-rho(:,1:end-1,:))./delta_y(:,2:end,:);
drhodz(:,:,2:Nz)=(rho(:,:,2:end)-rho(:,:,1:end-1))./(0.5*(delta_z(:,:,2:end)+delta_z(:,:,1:end-1)));
%drhodz(:,:,2:Nz)=(rho(:,:,1:end-1)-rho(:,:,2:end))./(0.5*(delta_z(:,:,2:end)+delta_z(:,:,1:end-1)));

%%%% COMPUTE TRACER VARIANCE  %%%%%%%%%%%%%%%%%%%%%%%
grad_b=drhody+drhody+drhodz;
%dnm=kappa.*(grad_b.^2).*delta_x.*delta_y.*delta_z;
dnm=kappa.*(drhodx.^2+drhody.^2+drhodz.^2).*delta_x.*delta_y.*delta_z;
variance_total(real_ind)=nansum(dnm(:));

dnm=0.5.*(rho.^2);%.*delta_x.*delta_y.*delta_z;
rhosq_total(real_ind)=nansum(dnm(:));

time_days(real_ind)=time*deltat/86400;
real_ind
real_ind=real_ind+1;

%%%% Save into a mat file %%%%%%%%
if(nondimensional)
filename=[project_name '_variance.mat']
save(['matfiles/' filename],'time_days','delta_rho','T_buoy','u_charc','Re','variance_total','rhosq_total')
else
filename=[project_name '_variance_dimensional.mat']
save(['matfiles/' filename],'time_days','delta_rho','T_buoy','u_charc','visc','variance_total','rhosq_total')
end
display('matfile saved')
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

end %time slice

%break




