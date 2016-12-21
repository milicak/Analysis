function [ssh]=general_diagnostics_sshmean(root_folder,expid,m2y,fyear,lyear,grid_file)

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
ssh=zeros(nx,ny);

if m2y==1
  for year=fyear:lyear
    for month=1:12
      n=n+months2days(month);
      sdate=sprintf('%4.4d%c%2.2d',year,datesep,month);
      disp(sdate)
      ssh=ssh+ncgetvar([prefix sdate '.nc'],'sealv').*mask.*months2days(month);
    end
  end
else
  for year=fyear:lyear
    n=n+1;
    sdate=sprintf('%4.4d%c%2.2d',year);
    disp(sdate)
    ssh=ssh+ncgetvar([prefix sdate '.nc'],'sealv').*mask;
  end
end

ssh=ssh/n;
save(['matfiles/' expid '_sshtimemean_' num2str(fyear) '_' num2str(lyear) '.mat'],'ssh')
