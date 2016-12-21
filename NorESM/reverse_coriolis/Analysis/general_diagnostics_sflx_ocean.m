function [totalheatflx]=general_diagnostics_sflx_ocean(root_folder,expid,fyear,lyear)

datesep='-';
prefix=[root_folder expid '/atm/hist/' expid '.cam.h0.'];

% Get dimensions and time attributes
%if m2y==1
%  sdate=sprintf('%4.4d%c%2.2d',fyear,datesep,1);
%else
  sdate=sprintf('%4.4d%c%2.2d',fyear);
%end

months2days=[31  28  31  30  31   30   31  31   30 31   30 31]./365;
yeardays=sum(months2days);

nx = 144;
ny = 96;


n=0;
for year=fyear:lyear
  lhf = zeros(nx,ny);
  shf = zeros(nx,ny);
  lwsfc = zeros(nx,ny);
  swsfc = zeros(nx,ny);
  for month=1:12
   % n=n+months2days(month);
    sdate=sprintf('%4.4d%c%2.2d',year,datesep,month);
    disp(sdate)
    filename=[prefix sdate '.nc'];
    if(n==0)
      lat = ncgetvar(filename,'lat');
      rearth = 6.373E6;     % Radius of Earth (m)
    end
    tmp = ncgetvar(filename,'LHF'); %W/m2 # latent heat flux (evaporation)
    lhf = lhf + tmp.*months2days(month);
    tmp = ncgetvar(filename,'SHF'); %W/m2 # sensible heat flux
    shf = shf + tmp.*months2days(month);
    tmp = ncgetvar(filename,'LWsfc'); %W/m2 # net longwave radiation at surface
    lwsfc = lwsfc + tmp.*months2days(month);
    tmp = -ncgetvar(filename,'SWsfc'); %W/m2 # net shortwave radiation at surface
    swsfc = swsfc + tmp.*months2days(month);
  end
  n=n+1;
  dnm = lhf+shf+lwsfc+swsfc;
  ohflx_cesm_zon = mean(dnm,1);
  heat =  ohflx_cesm_zon;  % net heat flux into ocean
  dnm=1e-15*2*pi*rearth*rearth.*cumtrapz(lat'*pi/180,cos(lat*pi/180).*heat');
  totalheatflx(n)=dnm(end);
end

  keyboard 
