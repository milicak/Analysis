function [Tempglobal Saltglobal depth]=general_diagnostics_timetracer_vertical(root_folder,expid,grid_file,m2y,fyear,lyear)

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

nz=ncgetdim([prefix sdate '.nc'],'depth');
depth=ncgetvar([prefix sdate '.nc'],'depth');
area=ncgetvar(grid_file,'parea');
%remove arctic
load noresm_tnxv1_mask;
%mask_tnxv1(mask_tnxv1==8)=3;
%area(mask_tnxv1~=1)=NaN; % 3 for Pacific; 10 for Atlantic ; 8 for Indian ; 1 for Arctic ; 4 for Southern Ocean

Nz=length(depth);
area=repmat(area,[1 1 Nz]);
templvl=ncgetvar([prefix sdate '.nc'],'templvl');
area(isnan(templvl)==1)=NaN;
areaglobal=nansum(area(:));
darea1=squeeze(nansum(squeeze(nansum(area,1)),1));

n=0;
if m2y==1
  for year=fyear:lyear
    for month=1:12
      n=n+1;
      sdate=sprintf('%4.4d%c%2.2d',year,datesep,month);
      disp(sdate)
      templvl=ncgetvar([prefix sdate '.nc'],'templvl');
      salnlvl=ncgetvar([prefix sdate '.nc'],'salnlvl');
      dnm=templvl.*area;
      dd1=squeeze(nansum(squeeze(nansum(dnm,1)),1));
      Tempglobal(n,:)=dd1./darea1;
      dnm=salnlvl.*area;
      dd1=squeeze(nansum(squeeze(nansum(dnm,1)),1));
      Saltglobal(n,:)=dd1./darea1;
    end
  end
else
  for year=fyear:lyear
    sdate=sprintf('%4.4d%c%2.2d',year);
    disp(sdate)
    n=n+1;
    templvl=ncgetvar([prefix sdate '.nc'],'templvl');
    salnlvl=ncgetvar([prefix sdate '.nc'],'salnlvl');
    dnm=templvl.*area;
    dd1=squeeze(nansum(squeeze(nansum(dnm,1)),1));
    Tempglobal(n,:)=dd1./darea1;
    dnm=salnlvl.*area;
    dd1=squeeze(nansum(squeeze(nansum(dnm,1)),1));
    Saltglobal(n,:)=dd1./darea1;
  end
end

