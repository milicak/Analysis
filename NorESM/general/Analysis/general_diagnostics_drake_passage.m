function [drake]=general_diagnostics_drake_passage(root_folder,expid,m2y,fyear,lyear,grid_file)

section = 5;  %Drake passage transport 
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

n=0;
if m2y==1
  for year=fyear:lyear
    n=n+1;
    dnm=0;
    for month=1:12
      sdate=sprintf('%4.4d%c%2.2d',year,datesep,month);
      disp(sdate)
      voltr=ncgetvar([prefix sdate '.nc'],'voltr');
      dnm=dnm+1e-9*voltr(section).*months2days(month)/yeardays;
    end
    drake(n) = dnm;
  end
else
  for year=fyear:lyear
    n=n+1;
    sdate=sprintf('%4.4d%c%2.2d',year);
    disp(sdate)
    voltr=ncgetvar([prefix sdate '.nc'],'voltr');
    dnm=1e-9*voltr(section);
    drake(n) = dnm;
    dnm=1e-9*voltr(2);
    bering(n) = dnm;
    dnm=1e-9*voltr(3);
    caa(n) = dnm;
    dnm=1e-9*voltr(10);
    fram(n) = dnm;
  end
end

    keyboard
%save(['matfiles/' expid '_drakepassage_' num2str(fyear) '_' num2str(lyear) '.mat'],'drake')
