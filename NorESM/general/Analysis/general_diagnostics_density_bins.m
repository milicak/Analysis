function [dens_bins]=general_diagnostics_density_bins(root_folder,expid,fyear,lyear,m2y)

datesep='-';

% Get dimensions and time attributes
if m2y==1
  sdate=sprintf('%4.4d%c%2.2d',fyear,datesep,1);
  prefix=[root_folder expid '/ocn/hist/' expid '.micom.hm.'];
else
  sdate=sprintf('%4.4d%c%2.2d',fyear);
  prefix=[root_folder expid '/ocn/hist/' expid '.micom.hy.'];
end

mw=[31  28  31  30  31   30   31  31   30 31   30 31]./365;

nx = 385;
ny = 360;
nz=53;                                                                    

CpSw = 3.996e3; % Joule/kgK
Lv = 2.5e6; % Joule/kg
rhow = 1000; %kg/m3
rearth = 6.373E6;     % Radius of Earth (m)
rhobins_w1 = 10.0;
rhobins_w2 = 30.0;
nobins = 201;
dinc = (rhobins_w2-rhobins_w1)/nobins; 
rhobins = rhobins_w1:dinc:rhobins_w2;
rhobins_c = 0.5*(rhobins(1:end-1)+rhobins(2:end));
area2d = ncread('../../climatology/Analysis/grid.nc','parea');
% global basins mask file
% 10 is Atlantic
% 3 is Pacific
% 4 is SO
% 1 is Arctic andn Nordic Seas
% 8 is Indian Ocean
mask = load('../../reverse_coriolis/Analysis/noresm_tnxv1_mask.mat');
mask.mask_tnxv1(mask.mask_tnxv1~=1)=NaN;
%north Atlantic
%mask.mask_tnxv1(:,1:200)=NaN;
mask = mask.mask_tnxv1;
mask(isnan(mask)==0)=1;
mask(isnan(mask)==1)=0;

transfrm_area(1:nobins) = 0.0;
transfrm_heat(1:nobins) = 0.0;
transfrm_salt(1:nobins) = 0.0;
nitr = 0;
for year=fyear:lyear
  for month=1:12
   % n=n+months2days(month);
    sdate=sprintf('%4.4d%c%2.2d',year,datesep,month);
    disp(sdate)
    filename=[prefix sdate '.nc'];
    %if(n==0)
    %  lat = ncgetvar(filename,'lat');
    %end
    shf = ncgetvar(filename,'hflx'); %W/m2=J/sm2 # heat flux received from ocean
    eva = ncgetvar(filename,'eva'); %kg m-2 s-1 # evaporation
    lip = ncgetvar(filename,'lip'); %kg m-2 s-1 # liquid precipitation
    sop = ncgetvar(filename,'sop'); %kg m-2 s-1 # solid precipitation
    rnf = ncgetvar(filename,'rnf'); %kg m-2 s-1 # liquid runoff
    rfi = ncgetvar(filename,'rfi'); %kg m-2 s-1 # frozen runoff
    fmltfz = ncgetvar(filename,'fmltfz'); %kg m-2 s-1 # Fresh water flux due to melting/freezing

    % ice fluxes
    sfl = ncgetvar(filename,'sfl'); %kg m-2 s-1 # salt flux
    hmltfz = ncgetvar(filename,'hmltfz'); %W/m2 # Heat flux due to melting/freezing
    %shf = shf + tmp.*mw(month)./(Lv*rhow);

    % total heat and FW fluxes
    shf_net = shf; % W/m2
    sfwf_net = eva+lip+sop+rnf+rfi+fmltfz; %kg m-2s-1
    dz = ncgetvar(filename,'dz'); % meter
    % salinity and temperature values
    salt = ncgetvar(filename,'saln'); %g/kg
    %C micom uses potential temperature.
    % It is ok to use eos routines
    temp = ncgetvar(filename,'temp'); 
    % set nan when dz=0
    temp(dz==0)=NaN;
    salt(dz==0)=NaN;

    dp = ncgetvar(filename,'dp'); % Pa
    press(:,:,2:nz+1) = cumsum(dp,3);                                           
    pres = 0.5*(press(:,:,1:end-1)+press(:,:,2:end));    
    % Pa divided by 1e4 to get dba to be used in
    pres = pres*1e-4;
    % eos routines 
    rho = eosben07_rho(pres,temp,salt);
    drhodt = eosben07_rho_th(pres,temp,salt);
    drhods = eosben07_rho_s(pres,temp,salt);
    %%%%% divide by rho
    drhodt = drhodt./rho;
    sss = squeeze(salt(:,:,1))*1e-3; % convert to kg/kg
    sst = squeeze(temp(:,:,1));
    rhos = squeeze(rho(:,:,1));
    Buoy_heat = squeeze(drhodt(:,:,1)).*shf_net/CpSw;
    Buoy_FW = -squeeze(drhods(:,:,1)).*sss.*sfwf_net; %./(1.0-sss);
    % Let's first do this 2D i.e. only surface
    % remove 1e3 from rho to improve accuracy
    rhos = rhos-1e3;
    % make rho one dimensional and remove NaNs
    rhos = rhos(:);
    area = area2d;
    area = area.*mask;
    area(isnan(rhos)) = [];
    Buoy_heat(isnan(rhos)) = [];
    Buoy_FW(isnan(rhos)) = [];
    rhos(isnan(rhos)) = [];
    for kk = 1:nobins
        ind = find(rhos>=rhobins(kk) & rhos<rhobins(kk+1));
        if(isnan(ind)==0)
            transfrm_area(kk) = transfrm_area(kk) + nansum(area(ind));
            transfrm_heat(kk) = transfrm_heat(kk) + nansum(area(ind).*Buoy_heat(ind));
            transfrm_salt(kk) = transfrm_salt(kk) + nansum(area(ind).*Buoy_FW(ind));
        else
            transfrm_area(kk) = transfrm_area(kk); 
            transfrm_heat(kk) = transfrm_heat(kk);
            transfrm_salt(kk) = transfrm_salt(kk);
        end
    end
    nitr = nitr+1;
  end
  %dnm=1e-15*2*pi*rearth*rearth.*cumtrapz(lat'*pi/180,cos(lat*pi/180).*heat');
end
keyboard
transfrm_area = transfrm_area./(nitr);
transfrm_heat = transfrm_heat./(dinc*nitr);
transfrm_salt = transfrm_salt./(dinc*nitr);

