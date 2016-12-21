function [Tempglobal Tglobal TempNH TempSH Sglobal SaltNH SaltSH]=general_diagnostics_timetracer(root_folder,expid,grid_file,m2y,fyear,lyear)

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
Nz=length(depth);
area=repmat(area,[1 1 Nz]);
templvl=ncgetvar([prefix sdate '.nc'],'templvl');
area(isnan(templvl)==1)=NaN;
areaglobal=nansum(area(:));
areaSH=nansum(nansum(nansum(squeeze(area(:,1:188,:)))));
areaNH=nansum(nansum(nansum(squeeze(area(:,189:end,:)))));
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
      dnm=squeeze(templvl(:,:,:)).*squeeze(area(:,:,:));
      dd1=squeeze(nansum(squeeze(nansum(dnm,1)),1));
      Tempglobal(n,:)=dd1./darea1;
      %dnmNH=squeeze(templvl(:,189:end,:)).*squeeze(area(:,189:end,:));
      %dnmSH=squeeze(templvl(:,1:188,:)).*squeeze(area(:,1:188,:));
      dnmNH=squeeze(dnm(:,189:end,:));
      dnmSH=squeeze(dnm(:,1:188,:));
      Tglobal(n)=nansum(dnm(:))/areaglobal;
      TempNH(n)=nansum(dnmNH(:))/areaNH;
      TempSH(n)=nansum(dnmSH(:))/areaSH;
      dnm=squeeze(salnlvl(:,:,:)).*squeeze(area(:,:,:));
      dnmNH=squeeze(dnm(:,189:end,:));
      dnmSH=squeeze(dnm(:,1:188,:));
      Sglobal(n)=nansum(dnm(:))/areaglobal;
      SaltNH(n)=nansum(dnmNH(:))/areaNH;
      SaltSH(n)=nansum(dnmSH(:))/areaSH;
    end
  end
else
  for year=fyear:lyear
    sdate=sprintf('%4.4d%c%2.2d',year);
    disp(sdate)
    templvl=ncgetvar([prefix sdate '.nc'],'templvl');
    salnlvl=ncgetvar([prefix sdate '.nc'],'salnlvl');
    dnm=squeeze(templvl(:,:,:)).*squeeze(area(:,:,:));
    %dnmNH=squeeze(templvl(:,189:end,:)).*squeeze(area(:,189:end,:));
    %dnmSH=squeeze(templvl(:,1:188,:)).*squeeze(area(:,1:188,:));
    dnmNH=squeeze(dnm(:,189:end,:));
    dnmSH=squeeze(dnm(:,1:188,:));
    Tglobal(n)=nansum(dnm(:))/areaglobal;
    TempNH(n)=nansum(dnmNH(:))/areaNH;
    TempSH(n)=nansum(dnmSH(:))/areaSH;
    dnm=squeeze(salnlvl(:,:,:)).*squeeze(area(:,:,:));
    dnmNH=squeeze(dnm(:,189:end,:));
    dnmSH=squeeze(dnm(:,1:188,:));
    Sglobal(n)=nansum(dnm(:))/areaglobal;
    SaltNH(n)=nansum(dnmNH(:))/areaNH;
    SaltSH(n)=nansum(dnmSH(:))/areaSH;
  end
end

