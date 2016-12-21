clear all
%close all

format long


%root_name=['/bcmhsm/milicak/RUNS/mitgcm/shear_flow/'];
%root_name=['/work/milicak/RUNS/mitgcm/shear_flow/'];
root_name=['/hexagon/work/milicak/RUNS/mitgcm/RB_convection/'];
%root_name=['/work/milicak/RUNS/mitgcm/shear_flow/hexagon/work/milicak/RUNS/mitgcm/shear_flow/'];

project_name=['Exp01.0']
alpha_T=0.2; %alpha 0.2 for Exp1.0, 1.1.,1.2 ; 2 for Exp 1.3
nondimensional=true
hdim='hdmn'

foldername=[root_name project_name '/']

H=0.4; %meter
L=H*1;
W=H*0.5;
visc=1e-6;
kappa=1e-7;
Pr=visc/kappa; 
g=9.81;
rho0=1e3;
skip=1;
dumpfreq=1.0; %0.5; %0.025;   % %from data in the run folder
deltat=0.0025; %0.001;  %0.0005; %from data in the run folder
timeini=000;  %4000; for Exp1.0
timeend=3000*(dumpfreq/deltat);

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
if(hdim=='hdmn')
depth_3d=depth_3d./H;
delta_z_ref=delta_z_ref./H;
delta_x=delta_x./H;
delta_y=delta_y./H;
delta_z=delta_z./H;
L=L/H;
W=W/H;
elseif(hdim=='hvrt')
depth_3d=depth_3d./delta_vort;
delta_z_ref=delta_z_ref./delta_vort;
delta_x=delta_x./delta_vort;
delta_y=delta_y./delta_vort;
delta_z=delta_z./delta_vort;
L=L/delta_vort;
W=W/delta_vort;
end
end
%volume=delta_x.*delta_y.*delta_z;

real_ind=1;

%break
dnm=timeini:skip*dumpfreq/deltat:timeend;
time_vec=[dnm];
%time_vec=[0 dnm];

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

% for periodic and/or closed boundries in MITgcm
u(end+1,:,:)=u(1,:,:);
v(:,end+1,:)=v(:,1,:);
w(:,:,end+1)=0;
u_rho=0.5*(u(1:end-1,:,:)+u(2:end,:,:));
v_rho=0.5*(v(:,1:end-1,:)+v(:,2:end,:));
w_rho=0.5*(w(:,:,2:end)+w(:,:,1:end-1));

% compute rho using linear EOS
rho=(rho0-alpha_T*temp);   %+0.8.*salt;

if(real_ind==1)
u_charc=H/kappa;
temp1=double(rdmds([foldername 'T'],0));
temp1(delta_z_ref==0)=NaN;
rho1=(rho0-alpha_T*temp1);   %+0.8.*salt;
rho_min=min(rho1(:));
delta_rho=max(rho1(:))-min(rho1(:));
N_infnty=sqrt(g*delta_rho/((rho0)*H));
T_buoy=2*pi/N_infnty;
if(nondimensional)
Ra=(g*delta_rho*H*H*H/rho0)/(visc*kappa);
visc=Pr;
kappa=1.0;
end
end

if(nondimensional)
% non-dimensionalize density
rho=(rho-rho_min)./delta_rho;   %+0.8.*salt;
% non-dimensionalize velocities
u_rho = u_rho./(u_charc);
v_rho = v_rho./(u_charc);
w_rho = w_rho./(u_charc);
end

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
aa=rho_sort_z_rho';
dnm=rho_sort.*rho_sort_dz.*aa.*L*W;
rpe(real_ind)=g*nansum(dnm(:));

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
pe(real_ind)=g*nansum(dnm(:));

%%%% COMPUTE AVAILABLE POTENTIAL ENERGY = pe-rpe  %%%%%%%%%%%%%%%%%%%%%%%
ape(real_ind)=pe(real_ind)-rpe(real_ind);

%%%% COMPUTE MOLECULAR MIXING = kappa*g*(drhodz)*dz*dx*dy  %%%%%%%%%%%%%%%%%%%%%%%
drhodz(:,:,2:Nz)=(rho(:,:,2:end)-rho(:,:,1:end-1))./(0.5*(delta_z(:,:,2:end)+delta_z(:,:,1:end-1)));
dnm=kappa*delta_x.*delta_y.*delta_z.*drhodz;
psi(real_ind)=g*nansum(dnm(:));

%%%% COMPUTE KINETIC ENERGY  = 0.5*rho*(u^2+v^2+w^2)*dz %%%%%%%%%%%%%%%%%%%%%%%
dnm=0.5*rho.*(u_rho.^2+v_rho.^2+w_rho.^2).*delta_z.*delta_y.*delta_x;
ke(real_ind)=nansum(dnm(:));

%%%% COMPUTE KINETIC ENERGY using rho0 = 0.5*rho0*(u^2+v^2)*dz %%%%%%%%%%%%%%%%%%%%%%%
dnm=0.5*(u_rho.^2+v_rho.^2+w_rho.^2).*delta_z.*delta_y.*delta_x;
ke_bouss(real_ind)=nansum(dnm(:));

%%%% COMPUTE DISSIPATION  = nu*(grad(u))^2 %%%%%%%%%%%%%%%%%%%%%%%
[epsilon epsilon_rho]=compute_dissipation(rho,u,v,w,u_rho,v_rho,w_rho,visc,delta_x,delta_y,delta_z,Nx,Ny,Nz);
dissp(real_ind)=nansum(epsilon(:));
dissp_rho(real_ind)=nansum(epsilon_rho(:));

%%%% COMPUTE WB conversion wb=w*g*(rho-rho0)dz %%%%%%%%%%%%%%%%%%%%%%%
dnm=w_rho.*(rho).*delta_x.*delta_y.*delta_z;
%dnm=w_rho.*(rho-0.0*rho0).*delta_x.*delta_y.*delta_z;
wb(real_ind)=g*nansum(dnm(:));

time_days(real_ind)=time*deltat/86400;
time
real_ind
real_ind=real_ind+1;

%%%% Save into a mat file %%%%%%%%
if(nondimensional)
filename=[project_name '_energetics.mat']
save(['matfiles/' filename],'rpe','pe','ape','ke','ke_bouss','dissp','dissp_rho', 'wb','time_days','delta_rho','T_buoy','u_charc','Ra','Pr','psi')
else
filename=[project_name '_energetics_dimensional.mat']
save(['matfiles/' filename],'rpe','pe','ape','ke','ke_bouss','dissp','dissp_rho', 'wb','time_days','delta_rho','T_buoy','u_charc','visc','psi','delta_vort')
end
display('matfile saved')
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

end %time slice

%break




