clear all
ssh=rdmds('/bcmhsm/milicak/RUNS/mitgcm/mitgcm_sose/SSHdaily',60);
load /bcmhsm/milicak/RUNS/mitgcm/mitgcm_sose/grid.mat
grav=9.81;
fcor=coriolis(YC);
ssh=sq(ssh);

for time=1:size(ssh,3)
  %dhdy
  dhdy=zeros(size(ssh,1),size(ssh,2));
  dhdy(:,2:end)=(ssh(:,2:end,time)-ssh(:,1:end-1,time))./(0.5*(DYC(:,2:end)+DYC(:,1:end-1)));
  %dhdx
  dhdx=zeros(size(ssh,1),size(ssh,2));
  dhdx(2:end,:)=(ssh(2:end,:,time)-ssh(1:end-1,:,time))./(0.5*(DXC(2:end,:)+DXC(1:end-1,:)));
  ug(:,:,time)=(-grav./fcor).*dhdy;
  vg(:,:,time)=(grav./fcor).*dhdx;
end %time

%compute mean ug and vg
ugmean=nanmean(ug,3);
vgmean=nanmean(vg,3);
ugmean=repmat(ugmean,[1 1 size(ssh,3)]);
vgmean=repmat(vgmean,[1 1 size(ssh,3)]);

%compute prime
uprime=ug-ugmean;
vprime=vg-vgmean;

%compute EKE
EKE=0.5*(uprime.^2+vprime.^2);

