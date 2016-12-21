clear all

grdname2=['/archive/m1i/gold/global/Exp01.0/RESTART/ocean_geometry.nc']
Nz=50;
area=(nc_varget(grdname2,'Ah')); 
area(isnan(area))=0;
H=(nc_varget(grdname2,'D'));
wet=(nc_varget(grdname2,'wet'));
wet=repmat(wet,[1 1 Nz]);
wet=permute(wet,[3 1 2]);
H(isnan(H))=0;
msk=0*H; msk(H>0)=1; area=area.*msk;

%%root_dir=['/net2/Robert.Hallberg/CM2G/Kd_sens/']
%root_dir=['/net2/Robert.Hallberg/CM2G/Kd_add/']
root_dir=['/net2/rwh/CM2G/Kd_add/']

%project_name='CM2G_LM3_1990_G0_KDadd5'
project_name0='CM2G_LM3_1860_KDadd0'
project_name1='CM2G_LM3_1860_KDadd1'
project_name2='CM2G_LM3_1860_KDadd2'
project_name4='CM2G_LM3_1860_KDadd4'
project_name6='CM2G_LM3_1860_KDadd6'
project_name8='CM2G_LM3_1860_KDadd8'

%filepath=['/pp/ocean/av/annual_20yr/'];
filepath=['/pp/ocean_annual_z/av/annual_100yr/'];

%filename=['ocean_annual_z.2000-2019.ann.nc'];
filename=['ocean_annual_z.2501-2600.ann.nc'];

flname0=[root_dir project_name0 filepath filename];
flname1=[root_dir project_name1 filepath filename];
flname2=[root_dir project_name2 filepath filename];
flname4=[root_dir project_name4 filepath filename];
flname6=[root_dir project_name6 filepath filename];
flname8=[root_dir project_name8 filepath filename];
zt=nc_varget(flname0,'zt');
zw=nc_varget(flname0,'zw');
dz=zw(2:end)-zw(1:end-1);
lon=nc_varget(flname0,'xh');
lat=nc_varget(flname0,'yh');
dz=repmat(dz,[1 size(lat,1) size(lon,1)]);


temp(1,:,:,:)=nc_varget(flname0,'temp');
salt(1,:,:,:)=nc_varget(flname0,'salt');
temp(2,:,:,:)=nc_varget(flname1,'temp');
salt(2,:,:,:)=nc_varget(flname1,'salt');
temp(3,:,:,:)=nc_varget(flname2,'temp');
salt(3,:,:,:)=nc_varget(flname2,'salt');
temp(4,:,:,:)=nc_varget(flname4,'temp');
salt(4,:,:,:)=nc_varget(flname4,'salt');
temp(5,:,:,:)=nc_varget(flname6,'temp');
salt(5,:,:,:)=nc_varget(flname6,'salt');
temp(6,:,:,:)=nc_varget(flname8,'temp');
salt(6,:,:,:)=nc_varget(flname8,'salt');


BPE=[];
PBPE=[];
HPE=[];


for n=1:6;
%dimensions should be Nz,Ny,Nx
T=squeeze(temp(n,:,:,:));
S=squeeze(salt(n,:,:,:));

T(wet==0)=NaN;
S(wet==0)=NaN;
dz(isnan(dz))=0;
%eta=-H+squeeze(sum(dz));
eta=zeros(size(T,2),size(T,3));
[nk nj ni]=size(dz);
Vol=0*dz; Pb=zeros(nj,ni); %Zc=0*dz; zi=eta; Zi=zeros(nk+1,nj,ni);
grav=9.8;

if n==1
 [h_sorted, vol_sorted] = sort_topog_eta(-H,eta,area);
else
 h_sorted(end)=sum(eta(:).*area(:))./sum(area(:));
end
[BPE(end+1) PE(end+1)]=bpe_calc2(T,S,dz,area,H,h_sorted,vol_sorted,grav);
fprintf('bpe_mom: timings, %f s, %f s, %f s. BPE=%g J/m^2\n',tim1,tim2,tim3,BPE(end))
n
savename=['matfiles/rpe_pe_ape.mat']
save(savename,'BPE','PE')
end % n


break



