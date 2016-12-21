clear all

%root_name = '/fimm/work/milicak/mnt/viljework/archive/';
root_name = '/fimm/work/milicak/mnt/norstore/NS2345K/noresm/cases/';

%project_name = 'N20TRAERCN_f19_g16_01';
project_name = 'NRCP85AERCN_f19_g16_01'

folder_name = [root_name project_name '/atm/hist/'];


grid_file='/bcmhsm/milicak/RUNS/noresm/CORE2/Arctic/DATA/ncar-pop/areacello_fx_CCSM4_piControl_r0i0p0.nc';
area=ncgetvar(grid_file,'areacello');
nx = 144;
ny = 96;

datesep = '-';
%fyear = 1980;
%lyear = 2000;
fyear = 2080;
lyear = 2100;
daysweights = [31 28 31 30 31 30 31 31 30 31 30 31]./365;

nitr = 1;
for year=fyear:lyear
  airmean = zeros(nx,ny);
  airTrefmean = zeros(nx,ny);
  for month=1:12 % 3 for March, 9 for September
     sdate=sprintf('%4.4d%c%2.2d',year,datesep,month);
     disp(sdate)
     filename = [folder_name project_name '.cam2.h0.' sdate '.nc'];
     tmp = ncgetvar(filename,'TS');
     airmean = airmean + tmp.*daysweights(month); 
     tmp = ncgetvar(filename,'TREFHT');
     airTrefmean = airTrefmean+tmp.*daysweights(month);
  end
     AIRTEMPmean(nitr,:,:) = airmean;
     AIRTEMPTrefmean(nitr,:,:) = airTrefmean;
  if(nitr==1)
    lon = nc_read(filename,'lon');
    lat = nc_read(filename,'lat');
  end
     nitr = nitr+1;
end

save(['matfiles/' project_name '_airtemp_mean_' num2str(fyear) '_' num2str(lyear) '.mat'],'AIRTEMPmean','AIRTEMPTrefmean','lon','lat')

%exit
