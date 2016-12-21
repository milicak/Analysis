function [sshrms]=general_diagnostics_sshrms(root_folder,expid,m2y,fyear,lyear,grid_file)

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
      n=n+1;
      sdate=sprintf('%4.4d%c%2.2d',year,datesep,month);
      disp(sdate)
      dnm=ncgetvar([prefix sdate '.nc'],'sealv').*mask;
      ssh=ssh+dnm;      
    end
  end
else
  for year=fyear:lyear
    n=n+1;
    sdate=sprintf('%4.4d%c%2.2d',year);
    disp(sdate)
    dnm=ncgetvar([prefix sdate '.nc'],'sealv').*mask;
    ssh=ssh+dnm;      
  end
end

sshmean=(ssh./n);

n=0;
ssh=zeros(nx,ny);
if m2y==1
  for year=fyear:lyear
    for month=1:12
      n=n+1;
      sdate=sprintf('%4.4d%c%2.2d',year,datesep,month);
      disp(sdate)
      dnm=ncgetvar([prefix sdate '.nc'],'sealv').*mask;
      ssh=ssh+(dnm-sshmean).^2;   
    end
  end
else
  for year=fyear:lyear
    n=n+1;
    sdate=sprintf('%4.4d%c%2.2d',year);
    disp(sdate)
    dnm=ncgetvar([prefix sdate '.nc'],'sealv').*mask;
    ssh=ssh+(dnm-sshmean).^2;   
  end
end

sshrms=sqrt(ssh./n);
keyboard


save(['matfiles/' expid '_sshrms_' num2str(fyear) '_' num2str(lyear) '.mat'],'sshrms')
