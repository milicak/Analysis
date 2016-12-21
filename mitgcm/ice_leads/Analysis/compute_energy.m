clear all
%close all

format long

root_name = ['/export/grunchfs/unibjerknes/milicak/bckup/mitgcm/ice_leads/'];
%root_name = ['/bcmhsm/milicak/RUNS/mitgcm/ice_leads/'];

project_name=['Exp01.11']

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

dnm=timeini:skip*dumpfreq/deltat:timeend;
time_vec=[dnm];
%time_vec=[0 dnm];
if(nondimensional)
  filename=['matfiles/' project_name '_energetics.mat']
else
  filename=['matfiles/' project_name '_energetics_dimensional.mat']
end
if(exist(filename)~=0)
  load(filename)
end
if(exist(filename)~=0)
  real_ind=length(rpe)+1;
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
eta=rdmds([foldername 'Eta'],itr);
%if (project_name~='Exp01.0')
u=rdmds([foldername 'U'],itr);
v=rdmds([foldername 'V'],itr);
w=rdmds([foldername 'W'],itr);
%end

% This is due to zstar used in MITGCM; look at table 7.1 in mom4p1 manual
corr=(1.0+eta./depth);
corr=repmat(corr,[1 1 Nz]); 
delta_z=delta_z_ref.*corr;

% for periodic and/or closed boundries in MITgcm
%if (project_name~='Exp01.0')
u(end+1,:,:)=u(1,:,:);
v(:,end+1,:)=v(:,1,:);
w(:,:,end+1)=0;
u_rho=0.5*(u(1:end-1,:,:)+u(2:end,:,:));
v_rho=0.5*(v(:,1:end-1,:)+v(:,2:end,:));
w_rho=0.5*(w(:,:,2:end)+w(:,:,1:end-1));
%end

% compute rho using linear EOS
rho=(rho0-alpha_T*(-2)+beta_S*salt);   %+0.8.*salt;

if(real_ind==1)
%if (project_name~='Exp01.0')
u1=rdmds([foldername 'U'],0);
u_charc=max(u1(:));
clear u1
%end
temp1=double(rdmds([foldername 'S'],0));
temp1(delta_z_ref==0)=NaN;
rho1=(rho0-alpha_T*(-2)+beta_S*temp1);   %+0.8.*salt;
rho_min=min(rho1(:));
delta_rho=max(rho1(:))-min(rho1(:));
N_infnty=sqrt(g*delta_rho/((rho0)*H));
T_buoy=2*pi/N_infnty;
clear temp1 rho1
if(nondimensional)
Re=u_charc*delta_vort/visc;
visc=1/Re;
kappa=1/(Re*Pr);
end
else
rho_min=(rho0-alpha_T*(-2)+beta_S*32.0);
end

if(nondimensional)
% non-dimensionalize density
rho=(rho-rho_min)./delta_rho;   %+0.8.*salt;
% non-dimensionalize velocities
u_rho = u_rho./u_charc;
v_rho = v_rho./u_charc;
w_rho = w_rho./u_charc;
end

% remove rho_min for accuracy
%rho=rho-rho_min+0.5;

%if(project_name=='Exp01.6')
%%rho=(rho-rho_min); 
%else
rho=(rho-rho_min)./delta_rho; 
%end

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
%if (project_name~='Exp01.0')
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
%end

time_days(real_ind)=time*deltat/86400;
real_ind
real_ind=real_ind+1;

%%%% Save into a mat file %%%%%%%%
if(nondimensional)
  save([filename],'rpe','pe','ape','ke','ke_bouss','dissp','dissp_rho', 'wb','time_days','delta_rho','T_buoy','u_charc','Re','psi')
else
  %if (project_name~='Exp01.0')
     save([filename],'rpe','pe','ape','ke','ke_bouss','dissp','dissp_rho', 'wb','time_days','delta_rho','T_buoy','u_charc','visc','psi')
  %else
  %   save([filename],'rpe','pe','ape','time_days','delta_rho','T_buoy','visc','psi')
  %end
end
display('matfile saved')
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

end %time slice

%break




