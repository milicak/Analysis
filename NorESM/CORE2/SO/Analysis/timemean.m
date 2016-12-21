
clear all

%expid='NOIIA_T62_tn11_bblsr10m30d_01';
expid='N1850_f19_tn11_003';
datesep='-';
fyear=101;
lyear=120;

prefix=['/hexagon/work/milicak/archive/' expid '/ocn/hist/' expid '.micom.hm.'];
%prefix=['/work/matsbn/archive/' expid '/ocn/hist/' expid '.micom.hm.'];

sdate=sprintf('%4.4d%c%2.2d',fyear,datesep,1);
nx=ncgetdim([prefix sdate '.nc'],'x');
ny=ncgetdim([prefix sdate '.nc'],'y');
nz=ncgetdim([prefix sdate '.nc'],'depth');
depth=ncgetvar([prefix sdate '.nc'],'depth');

n=0;
templvl=zeros(nx,ny,nz);
salnlvl=zeros(nx,ny,nz);
idlagelvl=zeros(nx,ny,nz);
for year=fyear:lyear
  for month=1:12
    n=n+1;
    sdate=sprintf('%4.4d%c%2.2d',year,datesep,month);
    disp(sdate)
    templvl=templvl+ncgetvar([prefix sdate '.nc'],'templvl');
    salnlvl=salnlvl+ncgetvar([prefix sdate '.nc'],'salnlvl');
    idlagelvl=idlagelvl+ncgetvar([prefix sdate '.nc'],'idlagelvl');
  end
end
templvl=templvl/n;
salnlvl=salnlvl/n;
idlagelvl=idlagelvl/n;

save([expid '_timemean_' num2str(fyear) '_' num2str(lyear) '.mat'],'nx','ny','nz','depth','templvl','salnlvl','idlagelvl')
