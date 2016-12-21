clear all
Cp = 1000; %Joules/(K*kg)
rho0 = 1 %kg/m3
rho_w = 1000.    % density of water (kg / m**3)
Lhvap = 2.5E6;    % Latent heat of vaporization (J / kg)
Lhsub = 2.834E6;   % Latent heat of sublimation (J / kg)
Lhfus = Lhsub - Lhvap;  % Latent heat of fusion (J / kg)
rearth = 6.373E6      % Radius of Earth (m)

root_name = '/fimm/work/milicak/mnt/viljework/archive/';
%root_name = '/fimm/work/milicak/mnt/norstore/NS2345K/noresm/cases/';
%project_name = 'B1850CN_f19_tn11_kdsens';
%project_name = 'B1850CN_f19_tn11_kdsens01';
%project_name = 'B1850CN_f19_tn11_kdsens02';
%project_name = 'B1850CN_f19_tn11_kdsens03';
%project_name = 'B1850CN_f19_tn11_kdsens04';
%project_name = 'B1850CN_f19_tn11_kdsens05';
project_name = 'B1850CN_f19_tn11_kdsens06';

folder_name = [root_name project_name '/atm/hist/'];


grid_file='/bcmhsm/milicak/RUNS/noresm/CORE2/Arctic/DATA/ncar-pop/areacello_fx_CCSM4_piControl_r0i0p0.nc';
area=ncgetvar(grid_file,'areacello');
if 1
resolution1=2.5; %1; %0.5;
resolution2=1.875; %1; %0.5;
nx=360*1/resolution1;
ny=180*1/resolution2;
deg2rad=pi/180;
%grid_center_lat=ones(nx,1)*(-89.5:resolution:89.5);
%grid_center_lon=(0.5:resolution:359.5)'*ones(1,ny);
grid_center_lat=ones(nx,1)*(-90+resolution2*0.5:resolution2:90-resolution2*0.5);
grid_center_lon=(0+resolution1*0.5:resolution1:360-resolution1*0.5)'*ones(1,ny);
grid_corner_lat=zeros(4,nx,ny);
grid_corner_lon=zeros(4,nx,ny);
grid_corner_lat(1,:,:)=grid_center_lat-0.5*resolution2;
grid_corner_lat(2,:,:)=grid_center_lat-0.5*resolution2;
grid_corner_lat(3,:,:)=grid_center_lat+0.5*resolution2;
grid_corner_lat(4,:,:)=grid_center_lat+0.5*resolution2;
grid_corner_lon(1,:,:)=grid_center_lon-0.5*resolution1;
grid_corner_lon(2,:,:)=grid_center_lon+0.5*resolution1;
grid_corner_lon(3,:,:)=grid_center_lon+0.5*resolution1;
grid_corner_lon(4,:,:)=grid_center_lon-0.5*resolution1;
grid_area=2*(sin(grid_corner_lat(4,1,:)*deg2rad) ...
            -sin(grid_corner_lat(1,1,:)*deg2rad))*pi/nx;
grid_area=ones(nx,1)*reshape(grid_area,1,[]);
m2rad=distdim(1,'m','rad');
%convert rad2 area to m2
grid_area=grid_area./(m2rad.*m2rad);

end

nx = 144;
ny = 96;
nz = 26;

datesep = '-';
fyear = 1;
lyear = 250;
daysweights = [31 28 31 30 31 30 31 31 30 31 30 31]./365;
daysweightsDJF = [31 28 0 0 0 0 0 0 0 0 0 31]./90;

nitr = 1;
for year=fyear:lyear
  heatmean = zeros(nx,ny,nz);
  fsnt = zeros(nx,ny);
  flnt = zeros(nx,ny);
  lhflx = zeros(nx,ny);
  shflx = zeros(nx,ny);
  lwsfc = zeros(nx,ny);
  swsfc = zeros(nx,ny);
  precsc = zeros(nx,ny);
  precsl = zeros(nx,ny);
  evap = zeros(nx,ny);
  precip = zeros(nx,ny);
  for month=1:12 % 3 for March, 9 for September
     
     sdate=sprintf('%4.4d%c%2.2d',year,datesep,month);
     disp(sdate)
     filename = [folder_name project_name '.cam.h0.' sdate '.nc'];
     %tmp = ncgetvar(filename,'VT'); %Km/s
     %heatmean = heatmean + tmp.*daysweights(month).*deg2km(1)*1e3; 
     tmp = ncgetvar(filename,'FSNT'); %W/m2
     fsnt = fsnt + tmp.*daysweights(month); 
     tmp = ncgetvar(filename,'FLNT'); %W/m2
     flnt = flnt + tmp.*daysweights(month); 
     tmp = ncgetvar(filename,'LHFLX'); %W/m2
     lhflx = lhflx + tmp.*daysweights(month); 
     tmp = ncgetvar(filename,'SHFLX'); %W/m2
     shflx = shflx + tmp.*daysweights(month); 
     tmp = ncgetvar(filename,'FLNS'); %W/m2
     lwsfc = lwsfc + tmp.*daysweights(month); 
     tmp = ncgetvar(filename,'FSNS'); %W/m2
     swsfc = swsfc + tmp.*daysweights(month); 
     tmp = ncgetvar(filename,'PRECSC'); %m/s
     precsc = precsc + tmp.*daysweights(month); 
     tmp = ncgetvar(filename,'PRECSL'); %m/s
     precsl = precsl + tmp.*daysweights(month); 
     tmp = ncgetvar(filename,'QFLX'); % kg/m2/s or mm/s
     evap = evap + tmp.*daysweights(month); 
     tmp = ncgetvar(filename,'PRECC'); % kg/m2/s or mm/s
     tmp2 = ncgetvar(filename,'PRECL'); % kg/m2/s or mm/s
     precip = precip + (tmp+tmp2).*daysweights(month); 
  end
  asr_cesm_zon = mean(fsnt,1);
  olr_cesm_zon = mean(flnt,1);
  LHF = mean(lhflx,1);  % latent heat flux (evaporation)
  SHF = mean(shflx,1);  % sensible heat flux
  LWsfc = mean(lwsfc,1);  % net longwave radiation at surface
  SWsfc = -mean(swsfc,1);  % net shortwave radiation at surface
  SnowFlux = (mean(precsc,1)+mean(precsl,1))*rho_w*Lhfus;  % energy flux due to snowfall
  if(nitr==1)
    lon = nc_read(filename,'lon');
    lat = nc_read(filename,'lat');
  end
  Evap = mean(evap,1); 
  Precip = mean(precip,1)*rho_w; 
  EminusP = Evap - Precip;  % kg/m2/s or mm/s

  SurfaceRadiation = LWsfc + SWsfc;  % net upward radiation from surface
  SurfaceHeatFlux = SurfaceRadiation + LHF + SHF + SnowFlux;  % net upward surface heat flux
  Rtoa = asr_cesm_zon - olr_cesm_zon;  % net downwelling radiation
  
  heat =  Rtoa + SurfaceHeatFlux;  % net heat flux in to atmosphere
  atmheattransport(nitr,:) = 1e-15*2*pi*rearth*rearth.*cumtrapz(lat'*pi/180,cos(lat*pi/180).*heat');
  heat =  - SurfaceHeatFlux;  % net heat flux of ocean
  oceanheattransport(nitr,:) = 1e-15*2*pi*rearth*rearth.*cumtrapz(lat'*pi/180,cos(lat*pi/180).*heat');
  heat =  Rtoa;  % net heat flux in to atmosphere
  totalheattransport(nitr,:) = 1e-15*2*pi*rearth*rearth.*cumtrapz(lat'*pi/180,cos(lat*pi/180).*heat');
  heat =  EminusP*Lhvap;  % net heat flux in to atmosphere
  atmlatentheattransport(nitr,:) = 1e-15*2*pi*rearth*rearth.*cumtrapz(lat'*pi/180,cos(lat*pi/180).*heat');
 
  atmdryheattransport(nitr,:) =  atmheattransport(nitr,:)-atmlatentheattransport(nitr,:);
  nitr = nitr+1;
end

save(['matfiles/' project_name '_airheattransport_mean_' num2str(fyear) '_' num2str(lyear) '.mat'],'atmheattransport','oceanheattransport','totalheattransport','atmlatentheattransport','atmdryheattransport','lon','lat')

exit
