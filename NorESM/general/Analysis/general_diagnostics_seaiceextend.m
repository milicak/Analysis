function [areaiceNH areaiceSH areaiceNH_mar areaiceSH_mar areaiceNH_sep areaiceSH_sep]=general_diagnostics_seaiceextend(root_folder,expid,m2y,fyear,lyear,grid_file)

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
ssh=zeros(nx,ny);
ice_cr = 0.15;
ind = int16(ny/2);

if m2y==1
  for year=fyear:lyear
    dnm=zeros(nx,ny);
    dnmmar=zeros(nx,ny);
    dnmsep=zeros(nx,ny);
    for month=1:12
      sdate=sprintf('%4.4d%c%2.2d',year,datesep,month);
      disp(sdate)
      dnm2 = ncgetvar([prefix sdate '.nc'],'fice')./100;
      dnm2(dnm2<ice_cr)=0;
      dnm = dnm + dnm2.*area.*mask.*mw(month);
    end
    sdate=sprintf('%4.4d%c%2.2d',year,datesep,3);
    dnm2 = ncgetvar([prefix sdate '.nc'],'fice')./100;
    dnm2(dnm2<ice_cr)=0;
    dnmmar = dnmmar + dnm2.*area.*mask;
    sdate=sprintf('%4.4d%c%2.2d',year,datesep,9);
    dnm2 = ncgetvar([prefix sdate '.nc'],'fice')./100;
    dnm2(dnm2<ice_cr)=0;
    dnmsep = dnmsep + dnm2.*area.*mask;
    areaiceSH(n) = nansum(nansum(dnm(:,1:ind)));
    areaiceNH(n) = nansum(nansum(dnm(:,ind:end)));
    areaiceSH_mar(n) = nansum(nansum(dnmmar(:,1:ind)));
    areaiceNH_mar(n) = nansum(nansum(dnmmar(:,ind:end)));
    areaiceSH_sep(n) = nansum(nansum(dnmsep(:,1:ind)));
    areaiceNH_sep(n) = nansum(nansum(dnmsep(:,ind:end)));
    n = n+1;
  end
else
  for year=fyear:lyear
    sdate=sprintf('%4.4d%c%2.2d',year);
    disp(sdate)
    dnm = ncgetvar([prefix sdate '.nc'],'fice')./100;
    dnm(dnm<ice_cr)=0;
    dnm = dnm.*area.*mask;
    areaiceSH(n) = nansum(nansum(dnm(:,1:ind)));
    areaiceNH(n) = nansum(nansum(dnm(:,ind:end)));
    n=n+1;
  end
end

