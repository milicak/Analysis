clear all
%close all

format long

root_name=['/work/milicak/RUNS/mitgcm/dam_breaking/'];
%root_name=['/net/m1i/models/MITgcm/Projects/overflow_slope/'];

project_name=['Exp01.0']

%foldername=['/net/m1i/models/MITgcm/Projects/dambreaking/run/'];
%foldername=['/net/m1i/models/MITgcm/Projects/overflow_slope/run/'];
foldername=[root_name project_name '/']

g=9.81;
skip=1;
dumpfreq=1800; %from data in the run folder
deltat=1; %from data in the run folder
timeend=86400*5;

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

%L=64e3;
L=nansum(delta_x(2:end-1,1,1));
W=4e3;
%H=sum(volume(:))./(L*W);
H=20;

real_ind=1;

%break

%for time=0:skip*dumpfreq/deltat:timeend       %time indices
timevec=[0 dumpfreq]
for time=timevec

itr=time;
temp=double(rdmds([foldername 'T'],itr));
temp(delta_z_ref==0)=NaN;
uvel=double(rdmds([foldername 'U'],itr));
uvel(delta_z_ref==0)=NaN;
wvel=double(rdmds([foldername 'W'],itr));
wvel(delta_z_ref==0)=NaN;
eta=rdmds([foldername 'Eta'],itr);

% This is due to zstar used in MITGCM; look at table 7.1 in mom4p1 manual
for k=1:Nz
for j=1:Ny
for i=1:Nx
delta_z(i,j,k)=delta_z_ref(i,j,k)*(1.0+0.0*eta(i,j)/depth(i,j)); %rigid lid
end
end
end

rho=1000-0.2*temp+35.*0.8;
if time==0
rhoini=rho;
dx=delta_x(2,2,2);
elseif time==dumpfreq
rho=rhoini;
rho(65,:,Nz)=1027;
rho(64,:,1)=1022;
%compute fluxes through F_i+1/2=F_i-1/2-dx/dt*(rho_i(t)-rho_i(t-1))
flx=zeros(Nx+1,Ny,Nz);
u2=zeros(Nx+1,Ny,Nz);
for i=2:Nx-1;for j=1:Ny;for k=1:Nz
  flx(i+1,j,k)=flx(i,j,k)-(dx/dumpfreq)*(rho(i,j,k)-rhoini(i,j,k));
  if isnan(flx(i+1,j,k))==1
    flx(i+1,j,k)=0;
  end
  %u2(i+1,j,k)=2*flx(i+1,j,k)/(rhoini(i,j,k)+rhoini(i+1,j,k));
  u2(i+1,j,k)=-((rho(i,j,k)-rhoini(i,j,k))/dumpfreq)/((rhoini(i,j,k)-rhoini(i-1,j,k))/dx);
end;end;end
u2=zeros(Nx+1,Ny,Nz);
u2(65,:,Nz)=0.279965;
u2(64,:,1)=-0.279965;

end



%%%% COMPUTE POTENTIAL ENERGY = g*rho*z_rho*dz  %%%%%%%%%%%%%%%%%%%%%%%
z_w(1:Nx,1:Ny,1:Nz+1)=0; 
z_w(:,:,Nz:-1:1)=-H+cumsum(delta_z(:,:,Nz:-1:1),3);
%z_w(:,:,2:Nz+1)=-H+cumsum(delta_z,3);
z_w(:,:,Nz+1)=-H;
z_rho=0.5*(z_w(:,:,2:end)+z_w(:,:,1:end-1));
dnm=g.*z_rho.*delta_z.*rho;
dnm_pe(:,:,:,real_ind)=dnm;
pe(real_ind)=nansum(dnm(:))/((Nx-2)*Ny);

kk=1;
for k=1:Nz
for j=1:Ny
for i=1:Nx
  %if(isnan(rho(i,j,k))~=1)
  rho_not_sort_dz(kk)=delta_z(i,j,k)*delta_x(i,j,k)*delta_y(i,j,k)/(L*W);
  rho_not_sort(kk)=rho(i,j,k);
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
rho_sort_z_w(2:length(rho_sort_dz)+1)=-H+nancumsum(rho_sort_dz); 
rho_sort_z_w(1)=-H;
rho_sort_z_rho=0.5*(rho_sort_z_w(1:end-1)+rho_sort_z_w(2:end));

%%%% COMPUTE BACKGROUND POTENTIAL ENERGY = g*rho*z_rhostar*dzstar  %%%%%%%%%%%%%%%%%%%%%%%
dnm=g.*rho_sort.*rho_sort_dz.*rho_sort_z_rho;
rpe(real_ind)=nansum(dnm(:));
%rho_sort_time(real_ind,:)=rho_sort;
%rho_sort_z_rho_time(real_ind,:)=rho_sort_z_rho;
%rho_sort_dz_time(real_ind,:)=rho_sort_dz;

%%%% COMPUTE AVAILABLE POTENTIAL ENERGY DENSITY %%%%%%%%%%%%%%%%%%%%%%%
%tau1=(z-zstar)*rho
for k=1:length(rho_not_sort)
   aa=find(I==k);
   tau1(k)=((rho_not_sort_zrho(k))-(rho_sort_z_rho(aa))).*rho_not_sort(k);
   tau3(k)=(rho_sort_z_rho(aa)).*rho_not_sort(k);
end
for k=1:length(rho_not_sort)
   aa=find(I==k);
   if(isnan(rho_sort_z_rho(aa))==0 & isnan(rho_not_sort_zrho(k))==0)
     if(rho_sort_z_rho(aa)<=rho_not_sort_zrho(k))
       ind=find(rho_sort_z_rho<=rho_not_sort_zrho(k) & rho_sort_z_rho>=rho_sort_z_rho(aa));
       dnm=rho_sort(ind).*rho_sort_dz(ind);
       %tau2(k)=nansum(dnm).*(rho_not_sort_zrho(k)-rho_sort_z_rho(aa));
       tau2(k)=nansum(dnm);
     else   
       ind=find(rho_sort_z_rho>rho_not_sort_zrho(k) & rho_sort_z_rho<=rho_sort_z_rho(aa));
       dnm=rho_sort(ind).*rho_sort_dz(ind);
       tau2(k)=-nansum(dnm);
     end
   else
     tau2(k)=NaN;
   end
end
%APE=g*(nansum(tau1-tau2))/((Nx-2)*Ny) \sim pe-rpe
dnm_rpe(:,:,:,real_ind)=dnm_pe(:,:,:,real_ind)-g*(reshape(tau1,[Nx Ny Nz])-reshape(tau2,[Nx Ny Nz]));
dnm_rpe2(:,:,:,real_ind)=g*(reshape(tau3,[Nx Ny Nz])+reshape(tau2,[Nx Ny Nz]));
dnm=squeeze(dnm_rpe(:,:,:,real_ind));
rpe_new(real_ind)=nansum(dnm(:))/((Nx-2)*Ny);

time_days(real_ind)=time*deltat/86400;
TAU1(real_ind,:)=tau1;
TAU2(real_ind,:)=tau2;
TAU3(real_ind,:)=tau3;
dnm=tau1-tau2;
dnm=g.*reshape(dnm,[Nx Ny Nz]);
dnm_ape(:,:,:,real_ind)=dnm;
ape_new(real_ind)=nansum(dnm(:))/((Nx-2)*Ny);

ape(real_ind)=pe(real_ind)-rpe(real_ind);

%APE=g*(nansum(TAU1-TAU2,2))/((Nx-2)*Ny);
%RPE=g*(nansum(TAU3+TAU2,2))/((Nx-2)*Ny);

real_ind
real_ind=real_ind+1;

if time==dumpfreq

flxBPE=zeros(Nx+1,Ny,Nz);
for i=1:Nx-1;for j=1:Ny;for k=1:Nz
  %flxBPE(i,j,k)=u2(i,j,k)*0.5*(dnm_ape(i,j,k,1)+dnm_ape(i-1,j,k,1));
  flxBPE(i+1,j,k)=u2(i+1,j,k)*0.5*(dnm_rpe(i,j,k,1)+dnm_rpe(i+1,j,k,1));
  %flxBPE(i,j,k)=u2(i,j,k)*0.5*(rhoini(i,j,k)+rhoini(i-1,j,k));
  %flxBPE(i,j,k)=u2(i,j,k)*0.5*(rhoini(i,j,k)+rhoini(i+1,j,k));
end;end;end

end

end %time slice

break

filename=[project_name '_ape_rpe_inspace.mat']
save(['matfiles/' filename],'TAU1','TAU2','TAU3','pe','rpe','time_days')


break


dnm1=reshape(tau1,[Nx Ny Nz]);
dnm2=reshape(tau2,[Nx Ny Nz]);
dnm3=reshape(tau3,[Nx Ny Nz]);




