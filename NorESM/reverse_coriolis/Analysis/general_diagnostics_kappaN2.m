function [energykd energycab]=general_diagnostics_kappaN2(root_folder,expid,m2y,fyear,lyear,grid_file)

mask=ncgetvar(grid_file,'pmask');
area=ncgetvar(grid_file,'parea');
grav=9.81;rho0=1027;

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
zw=ncgetvar([prefix sdate '.nc'],'depth_bnds');
dz=(zw(2,:)-zw(1,:))';


n=0;
mask=repmat(mask,[1 1 nz]);
area=repmat(area,[1 1 nz]);
depth=zw(2,:)';
kind=min(find(depth>=1500))
depth=repmat(depth,[1 nx ny]);
depth=permute(depth,[2 3 1]);
dz=repmat(dz,[1 nx ny]);
dz=permute(dz,[2 3 1]);
zrhos=(0.5*(dz(:,:,1:end-1)+dz(:,:,2:end)));

if m2y==1
  for year=fyear:lyear
    templvl=zeros(nx,ny,nz);
    salnlvl=zeros(nx,ny,nz);
    difdialvl=zeros(nx,ny,nz);

    if 1 % layer version
    for month=1:12
      n=n+1;
      kind=3; % below mix layer
      sdate=sprintf('%4.4d%c%2.2d',year,datesep,month);
      disp(sdate)
      T=ncgetvar([prefix sdate '.nc'],'temp');
      S=ncgetvar([prefix sdate '.nc'],'saln');
      difdia=10.^ncgetvar([prefix sdate '.nc'],'difdia');
      dp=ncgetvar([prefix sdate '.nc'],'dp');
      dz=ncgetvar([prefix sdate '.nc'],'dz');
      Nz=53;
      press(:,:,2:Nz+1)=cumsum(dp,3);
      pres=0.5*(press(:,:,1:end-1)+press(:,:,2:end));
      drho_dp=eosben07_rho_p(pres./1e4,T,S);
      gamma=drho_dp.*(dp./1e4)./dz;
      rho_insitu=rho(pres./1e4,T,S);
      drho_dz(1:nx,1:ny,1:Nz+1)=0;
      drho_dz(:,:,2:Nz)=(rho(press(:,:,2:end-1)./1e4,T(:,:,1:end-1),S(:,:,1:end-1))-rho(press(:,:,2:end-1)./1e4,T(:,:,2:end),S(:,:,2:end)))./ ...
          (0.5*(dz(:,:,1:end-1)+dz(:,:,2:end)));
      drho_dz(isnan(drho_dz))=0;
      dnm=-(difdia(:,:,kind:end).*(0.5*(drho_dz(:,:,kind+1:end)+drho_dz(:,:,kind:end-1))).*dp(:,:,kind:end).*area(:,:,kind:Nz))./rho_insitu(:,:,kind:end);
      dnm(isinf(dnm))=0;
      energykd(n)=nansum(dnm(:))*1e-12 %in Watts
      dnm=-(difdia(:,:,kind:end).*(-gamma(:,:,kind:end)).*dp(:,:,kind:end).*area(:,:,kind:Nz))./rho_insitu(:,:,kind:end);
      dnm(isinf(dnm))=0;
      energycab(n)=nansum(dnm(:))*1e-12 %in Watts
    end
    end

    if 0 % level version
    n=n+1;
    for month=1:12
      sdate=sprintf('%4.4d%c%2.2d',year,datesep,month);
      disp(sdate)
      templvl=templvl+ncgetvar([prefix sdate '.nc'],'templvl').*mask.*months2days(month)./yeardays;
      salnlvl=salnlvl+ncgetvar([prefix sdate '.nc'],'salnlvl').*mask.*months2days(month)./yeardays;
      difdialvl=difdialvl+10.^ncgetvar([prefix sdate '.nc'],'difdialvl').*mask.*months2days(month)./yeardays;
    end
    rho_insitu=rho(depth,templvl,salnlvl);
    rhos_iso=(0.5*(rho_insitu(:,:,1:end-1)+rho_insitu(:,:,2:end)));
    dnm=-difdialvl(:,:,kind:end-1).*grav.*rhos_iso(:,:,kind:end).*(rho_insitu(:,:,kind:end-1)-rho_insitu(:,:,kind+1:end)).*area(:,:,kind+1:end)/rho0;
    energy(n)=nansum(dnm(:))*1e-12; %in Watts
    end
  end
else
  for year=fyear:lyear
    n=n+1;
    sdate=sprintf('%4.4d%c%2.2d',year);
    disp(sdate)
    
    if 1 % layer version
    kind=3; % below mix layer
    T=ncgetvar([prefix sdate '.nc'],'temp');
    S=ncgetvar([prefix sdate '.nc'],'saln');
    difdia=10.^ncgetvar([prefix sdate '.nc'],'difdia');
    dp=ncgetvar([prefix sdate '.nc'],'dp');
    dz=ncgetvar([prefix sdate '.nc'],'dz');
    Nz=53;
    press(:,:,2:Nz+1)=cumsum(dp,3);
    pres=0.5*(press(:,:,1:end-1)+press(:,:,2:end));
    drho_dp=eosben07_rho_p(pres./1e4,T,S);
    gamma=drho_dp.*(dp./1e4)./dz;
    rho_insitu=rho(pres./1e4,T,S);
    drho_dz(1:nx,1:ny,1:Nz+1)=0;
    drho_dz(:,:,2:Nz)=(rho(press(:,:,2:end-1)./1e4,T(:,:,1:end-1),S(:,:,1:end-1))-rho(press(:,:,2:end-1)./1e4,T(:,:,2:end),S(:,:,2:end)))./ ...
        (0.5*(dz(:,:,1:end-1)+dz(:,:,2:end)));
    drho_dz(isnan(drho_dz))=0;
    dnm=-(difdia(:,:,kind:end).*(0.5*(drho_dz(:,:,kind+1:end)+drho_dz(:,:,kind:end-1))).*dp(:,:,kind:end).*area(:,:,kind:Nz))./rho_insitu(:,:,kind:end);
    dnm(isinf(dnm))=0;
    energykd(n)=nansum(dnm(:))*1e-12; %in Watts
    dnm=-(difdia(:,:,kind:end).*(-gamma(:,:,kind:end)).*dp(:,:,kind:end).*area(:,:,kind:Nz))./rho_insitu(:,:,kind:end);
    dnm(isinf(dnm))=0;
    energycab(n)=nansum(dnm(:))*1e-12; %in Watts
    end

    if 0 %level version
    templvl=ncgetvar([prefix sdate '.nc'],'templvl').*mask;
    salnlvl=ncgetvar([prefix sdate '.nc'],'salnlvl').*mask;
    difdialvl=10.^ncgetvar([prefix sdate '.nc'],'difdialvl').*mask;
    rho_insitu=rho(depth,templvl,salnlvl);
    rhos_iso=(0.5*(rho_insitu(:,:,1:end-1)+rho_insitu(:,:,2:end)));
    dnm=-difdialvl(:,:,kind:end-1).*grav.*rhos_iso(:,:,kind:end).*(rho_insitu(:,:,kind:end-1)-rho_insitu(:,:,kind+1:end)).*area(:,:,kind+1:end)/rho0;
    energy(n)=nansum(dnm(:))*1e-12; %in Watts
    end
  end
end



%save(['matfiles/' expid '_timemean_' num2str(fyear) '_' num2str(lyear) '.mat'],'nx','ny','nz','depth','templvl','salnlvl','difdialvl','difisolvl','uvellvl','vvellvl')
