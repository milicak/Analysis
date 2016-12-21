function [totalTOA]=general_diagnostics_radtoa2(root_folder,expid,fyear,lyear)

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
  fsnt = zeros(nx,ny);
  flnt = zeros(nx,ny);
  for month=1:12
   % n=n+months2days(month);
    sdate=sprintf('%4.4d%c%2.2d',year,datesep,month);
    disp(sdate)
    filename=[prefix sdate '.nc'];
    if(n==0)
      lat = ncgetvar(filename,'lat');
      rearth = 6.373E6;     % Radius of Earth (m)
    end
    tmp = ncgetvar(filename,'FSNT'); %W/m2
    fsnt = fsnt + tmp.*months2days(month);
    tmp = ncgetvar(filename,'FLNT'); %W/m2
    flnt = flnt + tmp.*months2days(month);
  end
  n=n+1;
  asr_cesm_zon = mean(fsnt,1);
  olr_cesm_zon = mean(flnt,1);
  Rtoa = asr_cesm_zon - olr_cesm_zon;
  heat =  Rtoa;  % net heat flux in to atmosphere
  dnm=1e-15*2*pi*rearth*rearth.*cumtrapz(lat'*pi/180,cos(lat*pi/180).*heat');
  totalTOA(n)=dnm(end);
end

  keyboard 
