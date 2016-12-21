function [EKE]=general_diagnostics_EKE(root_folder,expid,m2y,fyear,lyear,grid_file)

mask=ncgetvar(grid_file,'pmask');

datesep='-';

if m2y==1
  prefix=[root_folder expid '/ocn/hist/' expid '.micom.hm.'];
  %prefix=[root_folder '/' expid '.micom.hm.'];
else
  prefix=[root_folder expid '/ocn/hist/' expid '.micom.hy.'];
end

% Get dimensions and time attributes
if m2y==1
  sdate=sprintf('%4.4d%c%2.2d',fyear,datesep,1);
else
  sdate=sprintf('%4.4d%c%2.2d',fyear);
end

months2days=[31  28  31  30  31   30   31  31   30 31   30 31];
yeardays=sum(months2days);

nx=ncgetdim([prefix sdate '.nc'],'x');
ny=ncgetdim([prefix sdate '.nc'],'y');
nz=ncgetdim([prefix sdate '.nc'],'depth');
depth=ncgetvar([prefix sdate '.nc'],'depth');

n=0;
uvellvl=zeros(nx,ny);
vvellvl=zeros(nx,ny);
mask=repmat(mask,[1 1 nz]);

timeind=1;
if m2y==1
  for year=fyear:lyear
    for month=1:12
      n=n+months2days(month);
      sdate=sprintf('%4.4d%c%2.2d',year,datesep,month);
      disp(sdate)

      dnm=ncgetvar([prefix sdate '.nc'],'uvellvl').*mask;
      uvel1(:,:,timeind)=squeeze(dnm(:,:,1));
      dnm=ncgetvar([prefix sdate '.nc'],'uvellvl').*mask.*months2days(month);
      uvellvl=uvellvl+squeeze(dnm(:,:,1));

      dnm=ncgetvar([prefix sdate '.nc'],'vvellvl').*mask;
      vvel1(:,:,timeind)=squeeze(dnm(:,:,1));
      dnm=ncgetvar([prefix sdate '.nc'],'vvellvl').*mask.*months2days(month);
      vvellvl=vvellvl+squeeze(dnm(:,:,1));

      timeind=timeind+1;
    end
  end
else
  for year=fyear:lyear
    n=n+1;
    sdate=sprintf('%4.4d%c%2.2d',year);
    disp(sdate)
    dnm=ncgetvar([prefix sdate '.nc'],'uvellvl').*mask;
    uvel1(:,:,timeind)=squeeze(dnm(:,:,1));
    uvellvl=uvellvl+squeeze(dnm(:,:,1));
    dnm=ncgetvar([prefix sdate '.nc'],'vvellvl').*mask;
    vvel1(:,:,timeind)=squeeze(dnm(:,:,1));
    vvellvl=vvellvl+squeeze(dnm(:,:,1));
    timeind=timeind+1;
  end
end

% mean velocities
uvellvl=uvellvl/n;
vvellvl=vvellvl/n;

% real velocities

uvel1mean=repmat(uvellvl,[1 1 timeind-1]);
vvel1mean=repmat(vvellvl,[1 1 timeind-1]);

u1eddy=uvel1-uvel1mean;
v1eddy=vvel1-vvel1mean;

v1eddy(end+1,:,:)=v1eddy(1,:,:);
u1eddy(:,end+1,:)=u1eddy(:,end,:);
dnm=0.5*(v1eddy(1:end-1,:,:)+v1eddy(2:end,:,:));
v1eddy=dnm;
dnm=0.5*(u1eddy(:,1:end-1,:)+u1eddy(:,2:end,:));
u1eddy=dnm;

%KE=0.5*(uvel1.^2+vvel1.^2);
%MKE=0.5*(uvel1mean.^2+vvel1mean.^2);
EKE=0.5*(u1eddy.^2+v1eddy.^2);

save(['matfiles/' expid '_EKE_' num2str(fyear) '_' num2str(lyear) '.mat'],'EKE')

