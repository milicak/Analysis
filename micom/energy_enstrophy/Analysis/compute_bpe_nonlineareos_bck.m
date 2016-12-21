clear all

grav=9.81;
%Nz=200; %jet
Nz=5; %philips model
rho0=1028;
dz_cri=1e-3; %1mm
Href=2000.0;
z0=-Href;

%root_name=['/mnt/hexwork/RUNS/micom/dam_breaking/run/'];
root_name=['/hexagon/work/milicak/RUNS/micom/energy_enstrophy/'];
%root_name=['/hexagon/work/milicak/shared/'];
%root_name=['/work/milicak/RUNS/shared/'];
%root_name=['/bcmhsm/milicak/RUNS/micom/dam_breaking/run/'];
%root_name=['/work/milicak/RUNS/micom/dam_breaking/run/'];

project_name=['exp04.3']
%project_name=['Exp003']
foldername=[root_name project_name '/'];
grdname2=[foldername 'grid.nc'];

%time=nc_varget(filename,'time',[0],[2]);
dt=1*86400; %(time(2)-time(1))*86400; %seconds output frequency

area=(nc_varget(grdname2,'parea'));
area(isnan(area))=0;
Ny=size(area,1);Nx=size(area,2);
dx=(nc_varget(grdname2,'pdx'));
dy=(nc_varget(grdname2,'pdy'));
H=(nc_varget(grdname2,'pdepth'));

L=sum(dx(1,:));W=sum(dy(:,1));
dx3d=repmat(dx,[1 1 Nz]);
dy3d=repmat(dy,[1 1 Nz]);
dx3d=permute(dx3d,[3 1 2]);
dy3d=permute(dy3d,[3 1 2]);
if(Nz==1)
  dx3d=squeeze(dx3d);
  dy3d=squeeze(dy3d);
end

wet=(nc_varget(grdname2,'pmask'));
area=area.*wet;
wet=repmat(wet,[1 1 Nz]);
wet=permute(wet,[3 1 2]);
area3d=area;
area3d=repmat(area3d,[1 1 Nz]);
area3d=permute(area3d,[3 1 2]);
H(isnan(H))=0;
msk=0*H; msk(H>0)=1;

LW=nansum(area(:));

PE=[];
PE2=[];
BPE=[];
APE=[];
KE=[];
KE1=[];
KE2=[];
KE3=[];
KE4=[];
TPV=[];
TEN=[];
TMO=[];
dPE_dt=[];
dBPE_dt=[];
PE2KE=[];
dE=[];
dE2=[];
dE3=[];
dE4=[];
phi_i_v=[];

for years=1989:1999
for months=1:12
no = num2str(months,'%.2d');
filename=[foldername 'Exp04_3_hm_' num2str(years) '.' no '.nc']
if(exist(filename)~=0)
for n=1:30

T=nc_varget(filename,'temp',[n-1 0 0 0],[1 -1 -1 -1]);
S=nc_varget(filename,'saln',[n-1 0 0 0],[1 -1 -1 -1]);
dz=nc_varget(filename,'dz',[n-1 0 0 0],[1 -1 -1 -1]);
dp=nc_varget(filename,'dp',[n-1 0 0 0],[1 -1 -1 -1]);
kappa=nc_varget(filename,'difdia',[n-1 0 0 0],[1 -1 -1 -1]);
uvel=nc_varget(filename,'uvel',[n-1 0 0 0],[1 -1 -1 -1]);
vvel=nc_varget(filename,'vvel',[n-1 0 0 0],[1 -1 -1 -1]);
uflx=nc_varget(filename,'uflx',[n-1 0 0 0],[1 -1 -1 -1]);
vflx=nc_varget(filename,'vflx',[n-1 0 0 0],[1 -1 -1 -1]);
wflx=nc_varget(filename,'wflx',[n-1 0 0 0],[1 -1 -1 -1]);
PV=nc_varget(filename,'pv',[n-1 0 0 0],[1 -1 -1 -1]);

T(wet==0)=NaN;
S(wet==0)=NaN;
uvel(wet==0)=NaN;
vvel(wet==0)=NaN;
%T(dz==0)=NaN;T(T>100)=NaN;
%S(dz==0)=NaN;S(S>100)=NaN;
uvel(dz==0)=NaN;uvel(uvel>100)=NaN;
vvel(dz==0)=NaN;vvel(uvel>100)=NaN;
dz(isnan(dz))=0;
PV(isnan(dp))=0;
dp(isnan(dp))=0;
dz(dz<dz_cri)=0;
dp(dp<dz_cri*grav*rho0)=0;
uflx(isnan(uflx))=0;
vflx(isnan(vflx))=0;
wflx(isnan(wflx))=0;
T(isnan(T))=0;
S(isnan(S))=0;
kappa(isnan(kappa))=0;

press(2:Nz+1,:,:)=cumsum(dp,1);
pres=0.5*(press(1:end-1,:,:)+press(2:end,:,:));
zw(2:Nz+1,:,:)=cumsum(dz,1);
zr=0.5*(zw(1:end-1,:,:)+zw(2:end,:,:));

%compute density
%sigma-2
rho_sigma2=rho(2000.0,T,S);
if(Nz==1)
 pres=squeeze(pres);
end
rho_insitu=rho(pres./1e4,T,S);

% compute gamma defined by Hogh et al. 13 gamma=drho/dp*dp(z)/dz
drho_dp=eosben07_rho_p(pres./1e4,T,S);
gamma=-drho_dp.*(dp./1e4)./dz;
%aa(2:Nz,:,:)=(dp(2:end,:,:)-dp(1:end-1,:,:))./(0.5*(dz(2:end,:,:)+dz(1:end-1,:,:)))./1e4;
%gamma=drho_dp.*aa; clear aa

%compute PE
% Obtain the upper height limit.
dnm=0;
q1=0;q2=0;
%z0=-Href; %negative way 
z0=0; %positive way
for k=Nz:-1:1
if(Nz==1)
  p1=squeeze(press(k,:,:));
  p0=squeeze(press(k+1,:,:));
  th=T(:,:);
  salt=S(:,:);
else
  p1=press(k,:,:);
  p0=press(k+1,:,:);
  th=T(k,:,:);
  salt=S(k,:,:);
end
z1=z0-p_alpha(p1,p0,th,salt)/grav; %negative way
%PE1=-z1.*p1+z0.*p0-p_alphap(p1,p0,th,salt)./grav;
PE1=squeeze(-z1.*p1).*area+squeeze(z0.*p0).*area-squeeze(p_alphap(p1,p0,th,salt)./grav).*area;
dnm=dnm+nansum(PE1(:));
q1=q1+area.*squeeze(press(1,:,:)).*squeeze(p_alpha(p1,p0,th,salt)/grav);
q2=q2+area.*squeeze(p_alphap(p1,p0,th,salt)/grav);
z0=z1;
end
keyboard
PE(end+1)=dnm;

%sorting
rho_notsort=rho_sigma2(:);
rho_notsort(isnan(rho_notsort)==1)=[];
[rho_s I]=sort(rho_notsort(:));
%I3d=reshape(I,[Nz Ny Nx]);

%compute BPE with new PE
dp_notsort=dp(:);
dz_notsort=dz(:);
dp_s=dp_notsort(I).*dx3d(I).*dy3d(I)./(LW);
dz_s=dz_notsort(I).*dx3d(I).*dy3d(I)./(LW);
th_s=T(I);
salt_s=S(I);
dnm=0;
%z0=-Href; %negative way 
z0=0; %positive way
press_s(2:length(dp_s)+1)=cumsum(dp_s);
for k=length(dp_s):-1:1
p1=press_s(k);
p0=press_s(k+1);
z1=z0-p_alpha(p1,p0,th_s(k),salt_s(k))/grav;
PE1=-z1.*p1+z0.*p0-p_alphap(p1,p0,th_s(k),salt_s(k))./grav;
%PE1=squeeze(-z1.*p1).*area+squeeze(z0.*p0).*area-squeeze(p_alphap(p1,p0,th,salt)./grav).*area;
dnm=dnm+nansum(PE1(:));
z0=z1;
end
BPE(end+1)=LW*nansum(dnm(:));

%compute KE
dnm=0.5*(uvel.*uvel+vvel.*vvel).*dp.*dx3d.*dy3d./grav;
KE(end+1)=nansum(dnm(:));
dnm=0.5*(uvel.*uvel+vvel.*vvel);
KE1(end+1)=nansum(dnm(:));
dnm=0.5*(uvel.*uvel+vvel.*vvel).*dz.*dx3d.*dy3d;
KE2(end+1)=nansum(dnm(:));
% compute KE using uflx and vflx.  KE=0.5*g*[ (uflx^2)dx/(dp*dy) + (vflx^2)dy/(dp*dx)]
dp1=dp;
dp1(dp<1)=NaN;
dnm=0.5*grav*(((uflx.^2).*dx3d./(dp1.*dy3d))+((vflx.^2).*dy3d./(dp1.*dx3d)));
KE3(end+1)=nansum(dnm(:));
dnm    = -0.5*(grav./dp1).*...
             ((uflx.^2).*(dx3d./dy3d) + (vflx.^2).*(dy3d./dx3d));  
KE4(end+1) = nansum(dnm(:));
%clear dp

%Compute PE2KE
dnm=grav.*wflx.*dz;
PE2KE(end+1)=nansum(dnm(:));

% compute total PV
%dnm=PV.*dx3d.*dy3d.*dz;
dnm=PV.*dx3d.*dy3d;
TPV(end+1) = nansum(dnm(:));

% compute total momentum
dnm=(uvel+vvel).*dx3d.*dy3d.*dz;
TMO(end+1) = nansum(dnm(:));

% compute total enstrophy
%dnm=0.5*dz.*dz.*PV.*PV.*dx3d.*dy3d;
dnm=0.5*PV.*PV.*dx3d.*dy3d;
TEN(end+1) = nansum(dnm(:));

if(n>2)
dPE_dt(end+1)=(PE(n)-PE(n-1))/dt;
dBPE_dt(end+1)=(BPE(n)-BPE(n-1))/dt;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if 0
%compute kappa*rho*N2*dz*dx*dy = kappa*dP*drho/dz*dx*dy/rho0
drho_dz(1:Nz+1,1:Ny,1:Nx)=0;
drho_dz(2:Nz,:,:)=(rho(press(2:end-1,:,:)./1e4,T(1:end-1,:,:),S(1:end-1,:,:))-rho(press(2:end-1,:,:)./1e4,T(2:end,:,:),S(2:end,:,:)))./ ...
        (0.5*(dz(1:end-1,:,:)+dz(2:end,:,:)));
drho_dz(isnan(drho_dz))=0;
dnm=(kappa.*(-0.5*(drho_dz(2:end,:,:)+drho_dz(1:end-1,:,:))+gamma).*dp.*dx3d.*dy3d)./rho_insitu;
%dnm=(kappa.*(0.5*(drho_dz(2:end,:,:)+drho_dz(1:end-1,:,:))).*dp.*dx3d.*dy3d)./rho0;
dnm(isinf(dnm))=0;
dE(end+1)=nansum(dnm(:));

dnm=-(grav.*kappa.*(0.5*(drho_dz(2:end,:,:)+drho_dz(1:end-1,:,:))-gamma)).*dz.*dx3d.*dy3d;
dnm(isinf(dnm))=0;
dE2(end+1)=nansum(dnm(:));

%drho_ds and drho_dth
drho_ds=eosben07_rho_s(pres./1e4,T,S);
drho_dth=eosben07_rho_th(pres./1e4,T,S);
dS_dz(2:Nz,:,:)=(S(1:end-1,:,:)-S(2:end,:,:))./(0.5*(dz(1:end-1,:,:)+dz(2:end,:,:)));
dT_dz(2:Nz,:,:)=(T(1:end-1,:,:)-T(2:end,:,:))./(0.5*(dz(1:end-1,:,:)+dz(2:end,:,:)));
dnm=-(grav.*kappa.*(drho_dth.*dT_dz+drho_ds.*dS_dz)).*dz.*dx3d.*dy3d;
dnm(isinf(dnm))=0;
dE3(end+1)=nansum(dnm(:));

%drho_ds_dz and drho_dth_dz
drho_ds_dz(2:Nz,:,:)=(drho_ds(1:end-1,:,:)-drho_ds(2:end,:,:))./(0.5*(dz(1:end-1,:,:)+dz(2:end,:,:)));
drho_dth_dz(2:Nz,:,:)=(drho_dth(1:end-1,:,:)-drho_dth(2:end,:,:))./(0.5*(dz(1:end-1,:,:)+dz(2:end,:,:)));
dnm=-(grav.*(zr).*kappa.*(drho_dth_dz.*dT_dz+0.*drho_ds_dz.*dS_dz)).*dz.*dx3d.*dy3d;
dnm(isinf(dnm))=0;
dE4(end+1)=nansum(dnm(:));

%compute eq. 14 in supplemantal of Hogg 2013 paper
%dnm=kappa.*(drho_dth.*dT_dz+drho_ds.*dS_dz);
dnm=kappa.*(0.5*(drho_dz(2:end,:,:)+drho_dz(1:end-1,:,:))-gamma);
dnm_z(2:Nz,:,:)=(dnm(1:end-1,:,:)-dnm(2:end,:,:))./(0.5*(dz(1:end-1,:,:)+dz(2:end,:,:)));
dnm_z=dnm_z(:);
dnm_z=dnm_z(I);
zws(2:Nx*Ny*Nz+1)=cumsum(dz_s);
zrs=0.5*(zws(2:end)+zws(1:end-1));
press_r=0.5*(press_s(2:end)+press_s(1:end-1));
%dnm=grav.*(zrs)'.*dnm_z.*dz_s.*dx3d(:).*dy3d(:);
dnm=fliplr(press_r)'.*dnm_z.*dp_s.*dx3d(:).*dy3d(:)./(grav.*rho_s).^2;
dnm(isinf(dnm))=0;
phi_i_v(end+1)=nansum(dnm(:));
clear dnm_z
end  %if 0
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%





%compute Available Potential Energy
APE(end+1)=PE(end)-BPE(end);
n
timereal(n)=dt*n; %sec


savename=['matfiles/' project_name '_energetics_noresm.mat']
save(savename,'PE','BPE','APE','dPE_dt','dBPE_dt','KE','KE1','KE2','KE3','KE4','timereal','area','TEN','TPV','TMO')

end % n
end % exist

end % months
end % years



