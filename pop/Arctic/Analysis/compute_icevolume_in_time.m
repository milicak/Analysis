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
folder_icename = [root_name project_name '/ice/hist/'];


grid_file='/bcmhsm/milicak/RUNS/noresm/CORE2/Arctic/DATA/ncar-pop/areacello_fx_CCSM4_piControl_r0i0p0.nc';
area=ncgetvar(grid_file,'areacello');
ice_cr = 0.15;

datesep = '-';
fyear = 1;
lyear = 250;
daysweights = [31 28 31 30 31 30 31 31 30 31 30 31]./365;

nitr = 1;
for year=fyear:lyear
  iceSH = 0;
  iceNH = 0;
  for month=1:12
     
     sdate=sprintf('%4.4d%c%2.2d',year,datesep,month);
     disp(sdate)
     filename = [folder_name project_name '.pop.h.' sdate '.nc'];
     filenameice = [folder_icename project_name '.cice.h.' sdate '.nc'];
     tmp = ncgetvar(filename,'IFRAC');
     tmp2 = ncgetvar(filenameice,'hi');
     tmp(tmp<ice_cr) = NaN;
     tmp = tmp.*tmp2;
     % Northern hemisphere 
     dnm = tmp(:,201:end).*area(:,201:end); %NH seaice area
     iceNH = iceNH+nansum(dnm(:))*daysweights(month);
     % Southern hemisphere 
     dnm = tmp(:,1:200).*area(:,1:200); %SH seaice area
     iceSH = iceSH+nansum(dnm(:))*daysweights(month);
     if(month==3)
       % Northern hemisphere 
       dnm = tmp(:,201:end).*area(:,201:end); %NH seaice area
       iceNHMarch = nansum(dnm(:));
       % Southern hemisphere 
       dnm = tmp(:,1:200).*area(:,1:200); %SH seaice area
       iceSHMarch = nansum(dnm(:));       
     end
     if(month==9)
       % Northern hemisphere 
       dnm = tmp(:,201:end).*area(:,201:end); %NH seaice area
       iceNHSeptember = nansum(dnm(:));
       % Southern hemisphere 
       dnm = tmp(:,1:200).*area(:,1:200); %SH seaice area
       iceSHSeptember = nansum(dnm(:));       
     end
  end
     ICESHmean(nitr) = iceSH;
     ICENHmean(nitr) = iceNH;
     ICENHMarch(nitr) = iceNHMarch;
     ICESHMarch(nitr) = iceSHMarch;
     ICENHSeptember(nitr) = iceNHSeptember;
     ICESHSeptember(nitr) = iceSHSeptember;
     nitr = nitr+1;
end


save(['matfiles/' project_name '_icevolume_' num2str(fyear) '_' num2str(lyear) '.mat'],'ICESHmean','ICENHmean','ICENHMarch','ICESHMarch','ICENHSeptember','ICESHSeptember')
