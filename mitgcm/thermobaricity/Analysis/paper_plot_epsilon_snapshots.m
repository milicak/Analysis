clear all
%close all

visc=2e-4;
kappa=1.8e-4;
Pr=visc/kappa; 
alpha_T=2; %alpha
beta_S=8; %beta
g=9.81;
rho0=1027;

root_name=['/export/grunchfs/unibjerknes/milicak/bckup/mitgcm/thermobaricity/'];
%project_name=['Exp01.0']
%project_name=['Exp01.1']
%project_name=['Exp01.2']
project_name=['Exp01.3']
itrnames = [{'31680'} {'52560'} {'288000'} {'86400'}]; % for Exp01.0 ; Exp01.1 ; Exp01.2 ; Exp01.3
%timeind=[31680];
%timeind=[52560];
%timeind=[288000];
timeind=[86400];

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

itr=timeind;

salt=double(rdmds([foldername 'S'],itr));
salt(salt==0)=NaN;
temp=double(rdmds([foldername 'T'],itr));
temp(temp==0)=NaN;
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
lat = ncread('n-ice2015_ship-ctd.nc','LATITUDE');
pr = sw_pres(Z,mean(lat));
pr = pr(1:end-1);
pr = repmat(pr,[1 1 4096]);
pr = permute(pr,[3 2 1]);
rho = densmdjwf(salt,temp,pr);
%rho=(rho0-alpha_T*(-2)+beta_S*salt);   %+0.8.*salt;

% add a second layer in Ny
Ny = 2;
rho(:,2,:) = rho(:,1,:);
u_rho(:,2,:) = u_rho(:,1,:);
v_rho(:,2,:) = v_rho(:,1,:);
w_rho(:,2,:) = w_rho(:,1,:);
u(:,2,:) = u(:,1,:);
v(:,3,:) = v(:,1,:);
w(:,2,:) = w(:,1,:);
delta_x(:,2,:) = delta_x(:,1,:);
delta_y(:,2,:) = delta_y(:,1,:);
delta_z(:,2,:) = delta_z(:,1,:);

[epsilon epsilon_rho]=compute_dissipation(rho,u,v,w,u_rho,v_rho,w_rho,visc,delta_x,delta_y,delta_z,Nx,Ny,Nz);

figure(1)
pcolor(x,-Z(2:end),log10(squeeze(epsilon_rho(:,1,:)))');shading interp;colorbar
shfn
caxis([-7 -3])
set(gca,'PlotBoxAspectRatio',[1 1 1])
xlabel('x [m]'); ylabel('Depth [m]');
no=num2str(timeind,'%.4d');
if(length(project_name)==7)
  printname=['paperfigs/verticalxz_epsilon_section' project_name(1:5) '_' project_name(7) '_' no];
else
  printname=['paperfigs/verticalxz_epsilon_section' project_name(1:5) '_' project_name(7:8) '_' no];
end
print(1,'-depsc2','-r300',printname)

