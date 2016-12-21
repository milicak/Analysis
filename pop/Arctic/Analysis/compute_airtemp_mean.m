clear all

root_name = '/fimm/work/milicak/mnt/viljework/archive/';
%root_name = '/fimm/work/milicak/mnt/norstore/NS2345K/noresm/cases/';

%project_name = 'B1850CN_f19_tn11_kdsens';
%project_name = 'B1850CN_f19_tn11_kdsens01';
%project_name = 'B1850CN_f19_tn11_kdsens02';
%project_name = 'B1850CN_f19_tn11_kdsens03';
%project_name = 'B1850CN_f19_tn11_kdsens04';
%project_name = 'B1850CN_f19_tn11_kdsens05'
project_name = 'B1850CN_f19_tn11_kdsens06'

folder_name = [root_name project_name '/atm/hist/'];


grid_file='/bcmhsm/milicak/RUNS/noresm/CORE2/Arctic/DATA/ncar-pop/areacello_fx_CCSM4_piControl_r0i0p0.nc';
area=ncgetvar(grid_file,'areacello');
ice_cr = 0.05;
nx = 144;
ny = 96;

datesep = '-';
fyear = 1;
lyear = 250;
daysweights = [31 28 31 30 31 30 31 31 30 31 30 31]./365;
daysweightsDJF = [31 28 0 0 0 0 0 0 0 0 0 31]./90;

nitr = 1;
for year=fyear:lyear
  airmean = zeros(nx,ny);
  airWinter = zeros(nx,ny);
  airTrefmean = zeros(nx,ny);
  airTrefWinter = zeros(nx,ny);
  for month=1:12 % 3 for March, 9 for September
     
     sdate=sprintf('%4.4d%c%2.2d',year,datesep,month);
     disp(sdate)
     filename = [folder_name project_name '.cam.h0.' sdate '.nc'];
     tmp = ncgetvar(filename,'TS');
     airmean = airmean + tmp.*daysweights(month); 
     airWinter = airWinter+tmp.*daysweightsDJF(month);
     tmp = ncgetvar(filename,'TREFHT');
     airTrefmean = airTrefmean + tmp.*daysweights(month); 
     airTrefWinter = airTrefWinter+tmp.*daysweightsDJF(month);
  end
     AIRTEMPmean(nitr,:,:) = airmean;
     AIRTEMPwinter(nitr,:,:) = airWinter;
     AIRTEMPTrefmean(nitr,:,:) = airTrefmean;
     AIRTEMPTrefwinter(nitr,:,:) = airTrefWinter;
  if(nitr==1)
    lon = nc_read(filename,'lon');
    lat = nc_read(filename,'lat');
  end
     nitr = nitr+1;
end

save(['matfiles/' project_name '_airtemp_mean_' num2str(fyear) '_' num2str(lyear) '.mat'],'AIRTEMPmean','AIRTEMPwinter','AIRTEMPTrefmean','AIRTEMPTrefwinter','lon','lat')

exit
