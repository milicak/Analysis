clear all
%close all

format long

%root_name = ['/bcmhsm/milicak/RUNS/mitgcm/ice_leads/'];
root_name = ['/export/grunchfs/unibjerknes/milicak/bckup/mitgcm/ice_leads/'];

project_name=['Exp01.9']
filename=['matfiles/' project_name '_mean_salt.mat']
if(exist(filename)~=0)
load(filename)
end

foldername=[root_name project_name '/']

nondimensional=false
H=128; %meter
L=H*1;
W=H*1;
visc=2e-5;
kappa=1.4e-5;
Pr=visc/kappa; 
g=9.81;
rho0=1027;
skip=1;
dumpfreq=1800;   %from data in the run folder
deltat=1; %from data in the run folder
alpha_T=2; %alpha
beta_S=8; %beta
timeini=0;   %4000 for Exp01.0
timeend=300*(dumpfreq/deltat);

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
clear delta_z
%delta_x=repmat(dxc,[1 1 Nz]);
%delta_y=repmat(dyc,[1 1 Nz]);
%depth_3d=repmat(depth,[1 1 Nz]);

%volume=delta_x.*delta_y.*delta_z;


%break
dnm=timeini:skip*dumpfreq/deltat:timeend;
time_vec=[dnm];
%time_vec=[0 dnm];
if(exist(filename)~=0)
  real_ind=size(meansalt,1)+1;
  time_vec=time_vec(real_ind+1:end);
else
  real_ind=1;
end

for time=time_vec       %time indices

itr=time;
%temp=double(rdmds([foldername 'T'],itr));
%temp(delta_z_ref==0)=NaN;
% No effect of salt
salt=double(rdmds([foldername 'S'],itr));
salt(delta_z_ref==0)=NaN;
ptracer=double(rdmds([foldername 'PTRACER01'],itr));
ptracer(delta_z_ref==0)=NaN;

tracer_cr1=1e-8; %critical tracer concentration
tracer_cr2(real_ind)=0.05*max(ptracer(:)); %critical tracer concentration

if(real_ind ~= 1)
salt2=salt;
dnm=squeeze(nanmean(salt,1));
dnm=squeeze(nanmean(dnm,1));
meansalt(real_ind,:)=dnm;
salt(ptracer<=tracer_cr1)=NaN;
salt2(ptracer<=tracer_cr2(real_ind))=NaN;
dnm=squeeze(nanmean(salt,1));
dnm=squeeze(nanmean(dnm,1));
meansalt1(real_ind,:)=dnm;
dnm=squeeze(nanmean(salt2,1));
dnm=squeeze(nanmean(dnm,1));
meansalt2(real_ind,:)=dnm;
dnm=squeeze(nanmean(ptracer,1));
dnm=squeeze(nanmean(dnm,1));
meanptracer(real_ind,:)=dnm;
else
salt2=salt;
dnm=squeeze(nanmean(salt,1));
dnm=squeeze(nanmean(dnm,1));
meansalt(real_ind,:)=dnm;
real_ind
dnm=squeeze(nanmean(salt,1));
dnm=squeeze(nanmean(dnm,1));
meansalt1(real_ind,:)=dnm;
dnm=squeeze(nanmean(salt2,1));
dnm=squeeze(nanmean(dnm,1));
meansalt2(real_ind,:)=dnm;
dnm=squeeze(nanmean(ptracer,1));
dnm=squeeze(nanmean(dnm,1));
meanptracer(real_ind,:)=dnm;
end

% compute rho using linear EOS
%rho=(rho0-alpha_T*(-2)+beta_S*salt);   %+0.8.*salt;

time_days(real_ind)=time*deltat/86400;
real_ind
real_ind=real_ind+1;

%%%% Save into a mat file %%%%%%%%
save([filename],'time_days','meansalt','meansalt1','meansalt2','meanptracer','tracer_cr1','tracer_cr2')
display('matfile saved')
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

end %time slice

%break




