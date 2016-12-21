clear all
%close all
addpath('/fimm/home/bjerknes/milicak/matlab/tools/nansuite/');
format long
digits(64);

%root_name=['/hexagon/work/milicak/RUNS/mitgcm/adjustment_3d/'];
root_name=['/bcmhsm/milicak/RUNS/mitgcm/adjustment_3d/'];

project_name=['Exp01.0']
%project_name=['Exp01.1']
%project_name=['Exp01.2']
%project_name=['Exp01.3']
%project_name=['Exp01.4']
logic_diff=0; %if there was implicit diffusion in the code then turn this on

foldername=[root_name project_name '/']

g=9.81;
skip=1;
dumpfreq=10800; %1800; %from data in the run folder
deltat=200; %from data in the run folder
timeend=86400*140;

variable_name=['T']; %T for temp; S for salt

depth=rdmds([foldername 'Depth']);
xc=rdmds([foldername 'XC']);
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

volume=delta_x.*delta_y.*delta_z;
rhomax=1000-0.2*8.9+0.8*35;
rhomin=1000-0.2*13.023+0.8*35;
rhomid=0.5*(rhomin+rhomax);

%L=64e3;
Ldomain=nansum(delta_x(1:end,1,1));
Wdomain=nansum(delta_y(1,2:end-1,1));
%H=sum(volume(:))./(L*W);
Hdomain=1000;

real_ind=1;

irr_mix(Nx,Ny,Nz,1)=0;

%break

for time=0:skip*dumpfreq/deltat:timeend/deltat       %time indices
%timevec=[0 dumpfreq]
%timevec=[0 200 400 600]
%timevec=[43200]
%for time=timevec

itr=time;
temp=double(rdmds([foldername 'T'],itr));
temp(delta_z_ref==0)=NaN;
eta=rdmds([foldername 'Eta'],itr);


% This is due to zstar used in MITGCM; look at table 7.1 in mom4p1 manual
for k=1:Nz
for j=1:Ny
for i=1:Nx
delta_z(i,j,k)=delta_z_ref(i,j,k)*(1.0+0.0*eta(i,j)/depth(i,j)); %rigid lid
end
end
end

if(time>0 & logic_diff==1)
  diff=double(rdmds([foldername 'diffavg'],itr));
  %diff=double(rdmds([foldername 'diff'],itr));
  diff(delta_z_ref==0)=NaN;
  diff(:,:,end+1)=diff(:,:,end); 
   %dnm1=(diff(:,:,2:end)-diff(:,:,1:end-1))./delta_z;
  dnm1=(diff(:,:,2:end)-diff(:,:,1:end-1));
  diff=0.2*dnm1./(delta_x.*delta_y);
  clear dnm1
end

%rho=1000-0.2*temp+35.*0.8;
%rho=(1000-0.2*temp+0.8*35)-rhomid; %remove round errors
rho=(1000-0.2*temp+0.8*35)-rhomin; %remove round errors

%%%% COMPUTE POTENTIAL ENERGY = g*rho*z_rho*dz  %%%%%%%%%%%%%%%%%%%%%%%
z_w(1:Nx,1:Ny,1:Nz+1)=0; 
z_w(:,:,Nz:-1:1)=-Hdomain+cumsum(delta_z(:,:,Nz:-1:1),3);
%z_w(:,:,2:Nz+1)=-H+cumsum(delta_z,3);
z_w(:,:,Nz+1)=-Hdomain;
z_rho=0.5*(z_w(:,:,2:end)+z_w(:,:,1:end-1));
dnm=g.*z_rho.*delta_z.*rho;
dnm_pe(:,:,:,real_ind)=dnm;
pe(real_ind)=nansum(dnm(:))/((Nx-2)*Ny);

kk=1;
for k=1:Nz
for j=1:Ny
for i=1:Nx
  %if(isnan(rho(i,j,k))~=1)
  rho_not_sort_dz(kk)=delta_z(i,j,k)*delta_x(i,j,k)*delta_y(i,j,k)/(Ldomain*Wdomain);
  rho_not_sort(kk)=rho(i,j,k);
  if(time>0 & logic_diff==1)
    diff_not_sort(kk)=diff(i,j,k);
    %diff_not_sort(kk)=diff(i,j,k)/(delta_x(i,j,k)*delta_y(i,j,k));
  end
  rho_not_sort_zrho(kk)=z_rho(i,j,k);
  kk=kk+1;
  %end
end
end
end


[rho_sort I]=sort(rho_not_sort,'descend');
rho_sort_dz=rho_not_sort_dz(I);
rho_sort_zrho=rho_not_sort_zrho(I);

clear dnm layer rho_sort_z_rho rho_sort_z_w
rho_sort_z_w(2:length(rho_sort_dz)+1)=-Hdomain+nancumsum(rho_sort_dz); 
rho_sort_z_w(1)=-Hdomain;
rho_sort_z_rho=0.5*(rho_sort_z_w(1:end-1)+rho_sort_z_w(2:end));

%%%% COMPUTE BACKGROUND POTENTIAL ENERGY = g*rho*z_rhostar*dzstar  %%%%%%%%%%%%%%%%%%%%%%%
dnm=g.*rho_sort.*rho_sort_dz.*rho_sort_z_rho;
rpe(real_ind)=nansum(dnm(:));
%rho_sort_time(real_ind,:)=rho_sort;
%rho_sort_z_rho_time(real_ind,:)=rho_sort_z_rho;
%rho_sort_dz_time(real_ind,:)=rho_sort_dz;
time_days(real_ind)=time*deltat/86400;


real_ind
real_ind=real_ind+1;
rhoini=rho;

if 1
if time>0
  filename=[project_name '_ape_rpe_spatial_newfluxv4_onlyrpe.mat'];
  save(['/export/grunchfs/unibjerknes/milicak/bckup/mitgcm/adjustment_3d/matfiles/' filename],'pe','rpe','time_days')
end
end

end %time slice




