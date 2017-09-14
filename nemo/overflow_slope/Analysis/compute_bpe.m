clear all
grav = 9.81;

root_dir = '/export/grunchfs/unibjerknes/milicak/bckup/nemo/overflow_slope/'

% file names for temperature and dzt
%tfname = [root_dir 'OVF_sco_FCT2_fluxcen_lapahm1000_grid_T.nc'];
%dzfname = [root_dir 'OVF_sco_FCT2_fluxcen_lapahm1000_grid_T.nc'];
%sshfname = [root_dir 'OVF_sco_FCT2_fluxcen_lapahm1000_grid_T.nc'];
tfname = [root_dir 'OVF_sco_FCT4_fluxcen_lapahm1000_grid_T.nc'];
dzfname = [root_dir 'OVF_sco_FCT4_fluxcen_lapahm1000_grid_T.nc'];
sshfname = [root_dir 'OVF_sco_FCT4_fluxcen_lapahm1000_grid_T.nc'];
grdfile = [root_dir 'mesh_mask_OVF_zps.nc'];

dx = ncread(grdfile,'e1t');
dy = ncread(grdfile,'e2t');
depth = ncread(grdfile,'mbathy');
%%%% IMPORTANT To get the bathymetry
depth = depth*20; 
%%%%
area = dx.*dy;
temp = ncread(tfname,'thetao_inst');
time = ncread(tfname,'time_instant');
dzt = ncread(dzfname,'e3t_inst');
ssh = ncread(sshfname,'ssh_inst');
% remove the closed boundary areas j=1, j=end, i=1, i=end
%temp = squeeze(temp(2:end-1,2:end-1,1:end-1,:));
%dzt = squeeze(dzt(2:end-1,2:end-1,1:end-1,:));
%ssh = squeeze(ssh(2:end-1,2:end-1,1:end-1,:));
%area = squeeze(area(2:end-1,2:end-1,1:end-1,:));
%depth = squeeze(depth(2:end-1,2:end-1,:,:));

BPE = [];
FBPE = [];
HPE = [];
real_ind = 1;
for timeind = 1:length(time)
  Time(real_ind) = time(timeind);
  T = temp(:,:,:,timeind);
  % there is no salt in this run so we will take is as constant
  S = 35.0*ones(size(T,1),size(T,2),size(T,3));
  %S=salt(:,:,:,timeind);
  dzts = dzt(:,:,:,timeind);
  eta = ssh(:,:,timeind);
  %eta = -H+squeeze(sum(dzts,3));


  if real_ind == 1
   [h_sorted, vol_sorted] = sort_topog_eta(-depth,eta,area);
  else
    h_sorted(end) = sum(eta(:).*area(:))./sum(area(:));
  end
  % manual mask, we need better than this for nemo
  S(T==0) = NaN;
  dzts(T==0) = NaN;
  T(T==0) = NaN;
 [BPE(end+1) FBPE(end+1) HPE(end+1)] = bpe_calc2(T,S,dzts,area,depth,h_sorted,vol_sorted,grav);
  %fprintf('bpe_mom: timings, %f s, %f s, %f s. BPE=%g J/m^2\n',tim1,tim2,tim3,BPE(end))
  real_ind=real_ind+1

end %timeind

timeind = 20;
zr = squeeze(dzt(:,2,:,timeind));
zr = cumsum(zr,2);
T1 = squeeze(temp(:,2,:,timeind));
lon = ncread(grdfile,'nav_lon');
lon = lon(:,2);
lon = repmat(lon,[1 size(T1,2)]);
figure
pcolor(lon,-zr,T1);shading flat;colorbar
