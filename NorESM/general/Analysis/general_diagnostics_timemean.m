function [templvl salnlvl difdialvl]=general_diagnostics_timemean(root_folder,expid,m2y,fyear,lyear,grid_file)

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
templvl=zeros(nx,ny,nz);
salnlvl=zeros(nx,ny,nz);
uvellvl=zeros(nx,ny,nz);
vvellvl=zeros(nx,ny,nz);
idlagelvl=zeros(nx,ny,nz);
difisolvl=zeros(nx,ny,nz);
difdialvl=zeros(nx,ny,nz);
mask=repmat(mask,[1 1 nz]);

if m2y==1
  for year=fyear:lyear
    for month=1:12
      n=n+months2days(month);
      sdate=sprintf('%4.4d%c%2.2d',year,datesep,month);
      disp(sdate)
      templvl=templvl+ncgetvar([prefix sdate '.nc'],'templvl').*mask.*months2days(month);
      salnlvl=salnlvl+ncgetvar([prefix sdate '.nc'],'salnlvl').*mask.*months2days(month);
      uvellvl=uvellvl+ncgetvar([prefix sdate '.nc'],'uvellvl').*mask.*months2days(month);
      vvellvl=vvellvl+ncgetvar([prefix sdate '.nc'],'vvellvl').*mask.*months2days(month);
      idlagelvl=idlagelvl+ncgetvar([prefix sdate '.nc'],'idlagelvl').*mask.*months2days(month);
      difisolvl=difisolvl+10.^ncgetvar([prefix sdate '.nc'],'difisolvl').*mask.*months2days(month);
      difdialvl=difdialvl+10.^ncgetvar([prefix sdate '.nc'],'difdialvl').*mask.*months2days(month);
    end
  end
else
  for year=fyear:lyear
    n=n+1;
    sdate=sprintf('%4.4d%c%2.2d',year);
    disp(sdate)
    templvl=templvl+ncgetvar([prefix sdate '.nc'],'templvl').*mask;
    salnlvl=salnlvl+ncgetvar([prefix sdate '.nc'],'salnlvl').*mask;
    uvellvl=uvellvl+ncgetvar([prefix sdate '.nc'],'uvellvl').*mask;
    vvellvl=vvellvl+ncgetvar([prefix sdate '.nc'],'vvellvl').*mask;
    idlagelvl=idlagelvl+ncgetvar([prefix sdate '.nc'],'idlagelvl').*mask;
    difisolvl=difisolvl+10.^ncgetvar([prefix sdate '.nc'],'difintlvl').*mask;
    difdialvl=difdialvl+10.^ncgetvar([prefix sdate '.nc'],'difdialvl').*mask;
  end
end

templvl=templvl/n;
salnlvl=salnlvl/n;
uvellvl=uvellvl/n;
vvellvl=vvellvl/n;
idlagelvl=idlagelvl/n;
%difisolvl=difisolvl/n;
%difdialvl=difdialvl/n;


save(['matfiles/' expid '_timemean_' num2str(fyear) '_' num2str(lyear) '.mat'],'nx','ny','nz','depth','templvl','salnlvl','difdialvl','difisolvl','uvellvl','vvellvl')
