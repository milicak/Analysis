clear all

nondimension=true
grav=9.8;
Nz=25;
Href=1000.0;
u_front=2.5; %5m/s!!

%root_name=['/mnt/hexwork/RUNS/micom/dam_breaking/run/'];
root_name=['/hexagon/work/milicak/RUNS/micom/dam_breaking/run/'];
%root_name=['/bcmhsm/milicak/RUNS/micom/dam_breaking/run/'];

project_name=['Exp02.3']
foldername=[root_name project_name '/'];
%filename=[foldername project_name '_hm_1989.12.nc']; 
filename=[foldername 'Exp02_0_hm_1989.12.nc']; 
grdname2=[foldername 'grid.nc'];


area=(nc_varget(grdname2,'parea'));
area(isnan(area))=0;
Ny=size(area,1);Nx=size(area,2);
dx=(nc_varget(grdname2,'pdx'));
dy=(nc_varget(grdname2,'pdy'));
H=(nc_varget(grdname2,'pdepth'));
%Nondimensionalize
if(nondimension)
dx=dx./Href;
dy=dy./Href;
end

L=sum(dx(1,:));W=sum(dy(:,1));
dx3d=repmat(dx,[1 1 Nz]);
dy3d=repmat(dy,[1 1 Nz]);
dx3d=permute(dx3d,[3 1 2]);
dy3d=permute(dy3d,[3 1 2]);
%Nondimensionalize
if(nondimension)
H=H./Href;
end

wet=(nc_varget(grdname2,'pmask'));
area=area.*wet;
wet=repmat(wet,[1 1 Nz]);
wet=permute(wet,[3 1 2]);
H(isnan(H))=0;
msk=0*H; msk(H>0)=1;
LW=nansum(area(:));
%Nondimensionalize
if(nondimension)
LW=LW./(Href*Href);
end


BPE=[];
PE=[];
KE=[];
KE2=[];

%Time=nc_varget(filename,'time');
%for n=1:length(Time)-1;
for n=1:4000
%n=4000;

T=nc_varget(filename,'temp',[n-1 0 0 0],[1 -1 -1 -1]);
S=nc_varget(filename,'saln',[n-1 0 0 0],[1 -1 -1 -1]);
dz=nc_varget(filename,'dz',[n-1 0 0 0],[1 -1 -1 -1]);
dp=nc_varget(filename,'dp',[n-1 0 0 0],[1 -1 -1 -1]);
uvel=nc_varget(filename,'uvel',[n-1 0 0 0],[1 -1 -1 -1]);
vvel=nc_varget(filename,'vvel',[n-1 0 0 0],[1 -1 -1 -1]);
%Nondimensionalize
if(nondimension)
uvel=uvel./u_front;
vvel=vvel./u_front;
%Nondimensionalize
T=(T-6.04166)./(25.83333-6.04166);
end

T(wet==0)=NaN;
S(wet==0)=NaN;
uvel(wet==0)=NaN;
vvel(wet==0)=NaN;
T(dz==0)=NaN;T(T>100)=NaN;
S(dz==0)=NaN;S(S>100)=NaN;
uvel(dz==0)=NaN;uvel(uvel>100)=NaN;
vvel(dz==0)=NaN;vvel(uvel>100)=NaN;
dz(isnan(dz))=0;
dp(isnan(dp))=0;
%Nondimensionalize
if(nondimension)
dz=dz./Href;
end

%compute density
%Nondimensionalize
if(nondimension)
rho=1.0-T;
rho_sigma2=1.0-T;
else
%sigma-2
rho_sigma2=rho(2000.0,T,S);
rho=rho(2000.0,T,S);
end

%compute z_rho
z_w(2:Nz+1,1:Ny,1:Nx)=cumsum(dz,1);
z_rho=0.5*(z_w(1:end-1,:,:)+z_w(2:end,:,:));

%compute PE
if(nondimension)
%Nondimensionalize
z_rho=1.0-z_rho; %bottom has to be zero
else
z_rho=Href-z_rho;
end
dnm=grav.*rho.*z_rho.*dz.*dx3d.*dy3d;
PE(end+1)=nansum(dnm(:));

%sorting
dV_notsort=dz(:).*dx3d(:).*dy3d(:);
rho_notsort=rho_sigma2(:);
dV_notsort(isnan(rho_notsort)==1)=[];
rho_notsort(isnan(rho_notsort)==1)=[];
[rho_s I]=sort(rho_notsort(:));
dz_s=dV_notsort(I)./(LW);
z_w_s(2:(length(dz_s)+1),1)=cumsum(dz_s);
z_rho_s=0.5*(z_w_s(2:end)+z_w_s(1:end-1));

%compute BPE
if(nondimension)
%Nondimensionalize
z_rho_s=1.0-z_rho_s; %bottom has to be zero
else
z_rho_s=Href-z_rho_s;
end
dnm=grav.*rho_s.*z_rho_s.*dz_s*LW;
BPE(end+1)=nansum(dnm(:));

%compute KE
dnm=0.5*(uvel.*uvel+vvel.*vvel).*rho.*dz.*dx3d.*dy3d;
KE(end+1)=nansum(dnm(:));
dnm=0.5*(uvel.*uvel+vvel.*vvel).*dz.*dx3d.*dy3d;
KE2(end+1)=nansum(dnm(:));

clear z_rho_s dz_s z_w_s rho
n
end % n

%time_days=1:n;
%dt=86400;
%real_bpe=(BPE(2:end)-BPE(1:end-1))./dt;
%aa=real_bpe.*sum(area(:))/1e9;
%plot(aa)

%break

