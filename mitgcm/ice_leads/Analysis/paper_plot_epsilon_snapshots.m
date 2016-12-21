clear all
%close all

H=128; %meter
L=H*1;
W=H*1;
visc=2e-5;
kappa=1.4e-5;
Pr=visc/kappa; 
alpha_T=2; %alpha
beta_S=8; %beta
g=9.81;
rho0=1027;

%root_name=['/bcmhsm/milicak/RUNS/mitgcm/ice_leads/'];
root_name=['/export/grunchfs/unibjerknes/milicak/bckup/mitgcm/ice_leads/'];
%root_name=['/work-common/shared/bjerknes/milicak/mnt/viljework/RUNS/mitgcm/ice_leads/']
project_name=['Exp01.11']

foldername=[root_name project_name '/']

depth=rdmds([foldername 'Depth']);
xc=rdmds([foldername 'XC']);
yc=rdmds([foldername 'YC']);
dxc=rdmds([foldername 'DXC']);
dyc=rdmds([foldername 'DYC']);
drc=rdmds([foldername 'DRC']);
drf=rdmds([foldername 'DRF']);
x=squeeze(xc(:,1));
y=squeeze(yc(1,:));
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

timeind=[900*14];
itr=timeind;
section=size(xc,2)/2;  %middle section

salt=double(rdmds([foldername 'S'],itr));
salt(salt==0)=NaN;
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

% compute rho using linear EOS
rho=(rho0-alpha_T*(-2)+beta_S*salt);   %+0.8.*salt;

[epsilon epsilon_rho]=compute_dissipation(rho,u,v,w,u_rho,v_rho,w_rho,visc,delta_x,delta_y,delta_z,Nx,Ny,Nz);

figure(1)
pcolor(x,-Z,log10(squeeze(epsilon_rho(:,section,:)))');shading interp;colorbar
caxis([-10 -6])
set(gca,'PlotBoxAspectRatio',[1 1 1])
xlabel('x'); ylabel('z');
no=num2str(timeind,'%.4d');
if(length(project_name)==7)
  printname=['paperfigs/verticalxz_epsilon_section' project_name(1:5) '_' project_name(7) '_' no];
else
  printname=['paperfigs/verticalxz_epsilon_section' project_name(1:5) '_' project_name(7:8) '_' no];
end
print(1,'-depsc2','-r300',printname)

figure(2)
pcolor(y,-Z,log10(squeeze(epsilon_rho(section,:,:)))');shading interp;colorbar
caxis([-10 -6])
set(gca,'PlotBoxAspectRatio',[1 1 1])
xlabel('y'); ylabel('z');
no=num2str(timeind,'%.4d');
if(length(project_name)==7)
  printname=['paperfigs/verticalyz_epsilon_section' project_name(1:5) '_' project_name(7) '_' no];
else
  printname=['paperfigs/verticalyz_epsilon_section' project_name(1:5) '_' project_name(7:8) '_' no];
end
print(2,'-depsc2','-r300',printname)
