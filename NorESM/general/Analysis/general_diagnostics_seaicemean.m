function [icemean]=general_diagnostics_seaicemean(root_folder,expid,m2y,fyear,lyear,grid_file)

mask=ncgetvar(grid_file,'pmask');
area=ncgetvar(grid_file,'parea');

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

mw=[31  28  31  30  31   30   31  31   30 31   30 31]./365.0;

nx=ncgetdim([prefix sdate '.nc'],'x');
ny=ncgetdim([prefix sdate '.nc'],'y');
nz=ncgetdim([prefix sdate '.nc'],'depth');
depth=ncgetvar([prefix sdate '.nc'],'depth');

n=1;
icemean = [];
ice_cr = 0.15;

if m2y==1
  for year=fyear:lyear
    dnm=zeros(nx,ny);
    for month=1:12
      sdate=sprintf('%4.4d%c%2.2d',year,datesep,month);
      disp(sdate)
      dnm = dnm+(ncgetvar([prefix sdate '.nc'],'fice')./100).*mask.*mw(month);
    end
    icemean(:,:,n) = dnm;
    n = n+1;
  end
else
  for year=fyear:lyear
    sdate=sprintf('%4.4d%c%2.2d',year);
    disp(sdate)
    dnm = ncgetvar([prefix sdate '.nc'],'fice')./100;
    icemean(:,:,n) = dnm;
    n=n+1;
  end
end

icemean = squeeze(nanmean(icemean,3));
