function [mld maxmld ustar]=general_diagnostics_timemean_mld(root_folder,expid,m2y,fyear,lyear,grid_file,str,skip)

mask=ncgetvar(grid_file,'pmask');

datesep='-';

if m2y==1
  prefix=[root_folder expid '/ocn/hist/' expid '.micom.hm.'];
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
mld=zeros(nx,ny);
maxmld=zeros(nx,ny);
ustar=zeros(nx,ny);
%3D mask not required
%mask=repmat(mask,[1 1 nz]);
if m2y==1
  for year=fyear:lyear
    for month=str:skip:12
      n=n+months2days(month);
      sdate=sprintf('%4.4d%c%2.2d',year,datesep,month);
      disp(sdate)
      mld=mld+ncgetvar([prefix sdate '.nc'],'mld').*mask.*months2days(month);
      maxmld=maxmld+ncgetvar([prefix sdate '.nc'],'maxmld').*mask.*months2days(month);
      ustar=ustar+ncgetvar([prefix sdate '.nc'],'ustar').*mask.*months2days(month);
    end
  end
else
  for year=fyear:lyear
    n=n+1;
    sdate=sprintf('%4.4d%c%2.2d',year);
    disp(sdate)
    mld=mld+ncgetvar([prefix sdate '.nc'],'mld').*mask;
  end
end
n
mld=mld/n;
maxmld=maxmld/n;
ustar=ustar/n;


%save(['matfiles/' expid '_timemean_mld_' num2str(fyear) '_' num2str(lyear) '.mat'],'nx','ny','mld')
