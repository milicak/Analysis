function [MOC_mean MOC_eddy lat depth]=general_diagnostics_amoc_mean(root_folder,expid,m2y,fyear,lyear,region)

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
    rmoc_eddy=zeros(166,70); %regional moc
    rmoc_mean=zeros(166,70); %regional moc
    for month=1:12
      sdate=sprintf('%4.4d%c%2.2d',year,datesep,month);
      disp(sdate)
      if(n==1)
        lat=ncgetvar([prefix sdate '.nc'],'lat');
        depth=ncgetvar([prefix sdate '.nc'],'depth');
      end

      dnm=ncgetvar([prefix sdate '.nc'],'mmftdd');
      rmoc_eddy=rmoc_eddy+1e-9*dnm(:,:,region).*months2days(month)/yeardays;

      dnm=ncgetvar([prefix sdate '.nc'],'mmflxd');
      rmoc_mean=rmoc_mean+1e-9*dnm(:,:,region).*months2days(month)/yeardays;
    end
    MOC_eddy(1:166,1:70,n) = rmoc_eddy;
    MOC_mean(1:166,1:70,n) = rmoc_mean;
  end
else
  for year=fyear:lyear
    n=n+1;
    sdate=sprintf('%4.4d%c%2.2d',year);
    disp(sdate)
    dnm=ncgetvar([prefix sdate '.nc'],'mmftdd');
    MOC_eddy(1:166,1:70,n)=1e-9*dnm(:,:,region);

    dnm=ncgetvar([prefix sdate '.nc'],'mmflxd');
    MOC_mean(1:166,1:70,n)=1e-9*dnm(:,:,region);
  end
end

keyboard
%save(['matfiles/' expid '_drakepassage_' num2str(fyear) '_' num2str(lyear) '.mat'],'drake')
