
clear all

root_name=['/lustre/ltfs/scratch/Mehmet.Ilicak/RUNS/mom4p1/global/'];

project_name=['Exp01.4']
foldername=[root_name project_name '/'];
filename=[foldername 'ocean_snap.nc'];
grdname=[foldername 'INPUT/topog.nc'];

if (project_name(1:5)=='Exp01' )
grdname2=['/lustre/ltfs/scratch/Mehmet.Ilicak/RUNS/mom4p1/global/Exp01.5/ocean_prog.nc']; %if Exp01.*
else
grdname2=['/lustre/ltfs/scratch/Mehmet.Ilicak/RUNS/mom4p1/global/Exp02.0/ocean_prog.nc']; %if Exp02.*
grdname3=[foldername 'ocean.static.E01.nc'];
end

if (project_name(1:5)=='Exp01' )
area=(nc_varget(grdname2,'area_t')); 
area(isnan(area))=0;
H=nc_varget(grdname2,'ht');
else
area=double(nc_varget(grdname3,'area_t')); 
area(isnan(area))=0;
%H=nc_varget(grdname2,'ht');
H=nc_varget(grdname,'depth');
end
H(isnan(H))=0;
msk=0*H; msk(H>0)=1; area=area.*msk;

BPE=[];
FBPE=[];
HPE=[];

Time=nc_varget(filename,'Time');

for n=1:90 %length(Time);

tic;
T=double(nc_varget(filename,'temp',[n-1 0 0 0],[1 -1 -1 -1]));
T(T==T(1))=NaN;
S=double(nc_varget(filename,'salt',[n-1 0 0 0],[1 -1 -1 -1]));
S(S==S(1))=NaN;
dz=double(nc_varget(filename,'dzt',[n-1 0 0 0],[1 -1 -1 -1]));
dz(isnan(dz))=0;
eta=-H+squeeze(sum(dz));
[nk nj ni]=size(dz);
Vol=0*dz; Pb=zeros(nj,ni); %Zc=0*dz; zi=eta; Zi=zeros(nk+1,nj,ni);
grav=9.8;

%for k=1:nk
% Pt=Pb;
% for it=1:4
%  rho=density_wright_eos(sq(T(k,:,:)),sq(S(k,:,:)),(Pt+Pb)/2);
%  Pb=Pt+grav*squeeze(rho.*squeeze(dz(k,:,:)));
% end % it
% Rho(k,:,:)=rho;
% Sigma2(k,:,:)=density_wright_eos(sq(T(k,:,:)),sq(S(k,:,:)),2000e4);
% Vol(k,:,:)=area.*squeeze(dz(k,:,:));
% %Zc(k,:,:)=zi-squeeze(dz(k,:,:))/2;
% %zi=zi-squeeze(dz(k,:,:));
%end % k
tim1=toc;tic

if n==1
 [h_sorted, vol_sorted] = sort_topog_eta(-H,eta,area);
else
 h_sorted(end)=sum(eta(:).*area(:))./sum(area(:));
end
tim2=toc;tic
%BPE(end+1)=bpe_calc(Sigma2,dz,area,h_sorted,vol_sorted,grav);
[BPE(end+1) FBPE(end+1) HPE(end+1)]=bpe_calc2(T,S,dz,area,H,h_sorted,vol_sorted,grav);
tim3=toc;tic
fprintf('bpe_mom: timings, %f s, %f s, %f s. BPE=%g J/m^2\n',tim1,tim2,tim3,BPE(end))
n
end % n

time_days=1:n;
savename=['matfiles/' project_name '_rpe_aja.mat']
save(savename,'BPE','time_days')



