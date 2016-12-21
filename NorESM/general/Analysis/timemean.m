clear all
m2y=1; % if it is monthly then m2y=1; if it is yearly data then m2y=0;

if m2y==1
  %expid='NOIIA_T62_tn11_sr10m60d_02';
  %expid='NOIIA_T62_tn11_020';
  expid='N1850_f19_tn11_007';
else
%  expid='NOIIA_T62_tn025_001';
  %expid='NOIIA_T62_tn025_003';
  expid='N1850_f19_tn11_01_default';
  %expid='N1850_f19_tn11_01_2D';
end

datesep='-';
%fyear=61;
%lyear=120;
fyear=100;
lyear=120;

if m2y==1
  %prefix=['/hexagon/work/matsbn/archive/' expid '/ocn/hist/' expid '.micom.hm.'];
  prefix=['/hexagon/work/milicak/archive/' expid '/ocn/hist/' expid '.micom.hm.'];
  %prefix=['/export/grunchfs/green/matsbn/archive/' expid '/ocn/hist/' expid '.micom.hm.'];
else
  prefix=['/hexagon/work/milicak/archive/' expid '/ocn/hist/' expid '.micom.hy.'];
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
templvl=zeros(nx,ny,nz);
salnlvl=zeros(nx,ny,nz);
idlagelvl=zeros(nx,ny,nz);
difisolvl=zeros(nx,ny,nz);
difdialvl=zeros(nx,ny,nz);
if m2y==1
  for year=fyear:lyear
    for month=1:12
      n=n+months2days(month);
      sdate=sprintf('%4.4d%c%2.2d',year,datesep,month);
      disp(sdate)
      templvl=templvl+ncgetvar([prefix sdate '.nc'],'templvl').*months2days(month);
      salnlvl=salnlvl+ncgetvar([prefix sdate '.nc'],'salnlvl').*months2days(month);
      idlagelvl=idlagelvl+ncgetvar([prefix sdate '.nc'],'idlagelvl').*months2days(month);
      difisolvl=difisolvl+ncgetvar([prefix sdate '.nc'],'difisolvl').*months2days(month);
      difdialvl=difdialvl+10.^ncgetvar([prefix sdate '.nc'],'difdialvl').*months2days(month);
    end
  end
else
  for year=fyear:lyear
    n=n+1;
    sdate=sprintf('%4.4d%c%2.2d',year);
    disp(sdate)
    templvl=templvl+ncgetvar([prefix sdate '.nc'],'templvl');
    salnlvl=salnlvl+ncgetvar([prefix sdate '.nc'],'salnlvl');
    idlagelvl=idlagelvl+ncgetvar([prefix sdate '.nc'],'idlagelvl');
    difisolvl=difisolvl+ncgetvar([prefix sdate '.nc'],'difisolvl');
    difdialvl=difdialvl+10.^ncgetvar([prefix sdate '.nc'],'difdialvl');
  end
end

templvl=templvl/n;
salnlvl=salnlvl/n;
idlagelvl=idlagelvl/n;
difisolvl=difisolvl/n;
difdialvl=difdialvl/n;
save(['matfiles/' expid '_timemean_' num2str(fyear) '_' num2str(lyear) '.mat'],'nx','ny','nz','depth','templvl','salnlvl','difdialvl','difisolvl')
