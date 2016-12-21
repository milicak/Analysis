clear all

root_name = '/fimm/work/milicak/mnt/viljework/archive/';
%root_name = '/fimm/work/milicak/mnt/norstore/NS2345K/noresm/cases/';
%project_name = 'B1850CN_f19_tn11_kdsens';
%project_name = 'B1850CN_f19_tn11_kdsens01';
%project_name = 'B1850CN_f19_tn11_kdsens02';
%project_name = 'B1850CN_f19_tn11_kdsens03';
%project_name = 'B1850CN_f19_tn11_kdsens04';
%project_name = 'B1850CN_f19_tn11_kdsens05';
project_name = 'B1850CN_f19_tn11_kdsens06';

folder_name = [root_name project_name '/ocn/hist/'];


grid_file='/bcmhsm/milicak/RUNS/noresm/CORE2/Arctic/DATA/ncar-pop/areacello_fx_CCSM4_piControl_r0i0p0.nc';
area=ncgetvar(grid_file,'areacello');
ice_cr = 0.05;
[nx ny]=size(area);

datesep = '-';
fyear = 1;
lyear = 250;
daysweights = [31 28 31 30 31 30 31 31 30 31 30 31]./365;
daysweightsDJF = [31 28 0 0 0 0 0 0 0 0 0 31]./90;

nitr = 1;
for year=fyear:lyear
  mldmean = zeros(nx,ny);
  mldWinter = zeros(nx,ny);
  for month=1:12 % 3 for March, 9 for September
     
     sdate=sprintf('%4.4d%c%2.2d',year,datesep,month);
     disp(sdate)
     filename = [folder_name project_name '.pop.h.' sdate '.nc'];
     %tmp = ncgetvar(filename,'XMXL');
     tmp = ncgetvar(filename,'HMXL');
     mldmean = mldmean + tmp.*daysweights(month); 
     mldWinter = mldWinter+tmp.*daysweightsDJF(month);
     if(month==3)
       mldMarch = tmp;
     end
     if(month==9)
       mldSeptember = tmp;
     end
  end
     MLDmean(nitr,:,:) = mldmean;
     MLDMarch(nitr,:,:) = mldMarch;
     MLDSeptember(nitr,:,:) = mldSeptember;
     MLDDJF(nitr,:,:) = mldWinter;
     nitr = nitr+1;
end

save(['matfiles/' project_name '_mld_mean_' num2str(fyear) '_' num2str(lyear) '.mat'],'MLDmean','MLDMarch','MLDSeptember','MLDDJF')

exit
