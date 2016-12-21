clear all

root_name=['/mnt/hexwork/RUNS/micom/overflow_slope/run/'];

project_name=['Exp005']
foldername=[root_name project_name '/'];
filename=[foldername project_name '_hm_1989.12.nc']; 
grdname2=[foldername 'grid.nc'];

Nz=25;

area=(nc_varget(grdname2,'parea'));
area(isnan(area))=0;
H=(nc_varget(grdname2,'pdepth'));
wet=(nc_varget(grdname2,'pmask'));
area=area.*wet;
wet=repmat(wet,[1 1 Nz]);
wet=permute(wet,[3 1 2]);
H(isnan(H))=0;
msk=0*H; msk(H>0)=1;


BPE=[];
PBPE=[];
HPE=[];

nc=netcdf(filename);

Time=nc_varget(filename,'time');

for n=1:length(Time)-1;

tic;

%T=nc_varget(filename,'temp',[n-1 0 0 0],[1 -1 -1 -1]);
%S=nc_varget(filename,'salt',[n-1 0 0 0],[1 -1 -1 -1]);
%eta=nc_varget(filename,'e',[n-1 0 0 0],[1 -1 -1 -1]);
%dz=nc_varget(filename,'h',[n-1 0 0 0],[1 -1 -1 -1]);

T=nc{'temp'}(n,:,:,:);
S=nc{'saln'}(n,:,:,:);
%eta=nc{'e'}(n,:,:,:);

dz=nc{'dz'}(n,:,:,:);

T(wet==0)=NaN;
S(wet==0)=NaN;
T(dz==0)=NaN;T(T>100)=NaN;
S(dz==0)=NaN;S(S>100)=NaN;
dz(isnan(dz))=0;

eta=-H+squeeze(sum(dz));
[nk nj ni]=size(dz);
Vol=0*dz; Pb=zeros(nj,ni); %Zc=0*dz; zi=eta; Zi=zeros(nk+1,nj,ni);
grav=9.8;

tim1=toc;tic

if n==1
 [h_sorted, vol_sorted] = sort_topog_eta(-H,eta,area);
else
 h_sorted(end)=sum(eta(:).*area(:))./sum(area(:));
end
tim2=toc;tic
%BPE(end+1)=bpe_calc(Sigma2,dz,area,h_sorted,vol_sorted,grav);
[BPE(end+1) PBPE(end+1) HPE(end+1)]=bpe_calc(T,S,dz,area,H,h_sorted,vol_sorted,grav);
tim3=toc;tic
fprintf('bpe_mom: timings, %f s, %f s, %f s. BPE=%g J/m^2\n',tim1,tim2,tim3,BPE(end))
n
end % n

time_days=1:n;
dt=86400;
real_bpe=(BPE(2:end)-BPE(1:end-1))./dt;
aa=real_bpe.*sum(area(:))/1e9;
%plot(aa)

%break
savename=['matfiles/' project_name '_rpe_aja.mat']
save(savename,'BPE','time_days','area')

