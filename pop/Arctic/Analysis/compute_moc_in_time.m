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

datesep = '-';
fyear = 1;
lyear = 250; %250;
daysweights = [31 28 31 30 31 30 31 31 30 31 30 31]./365;

nitr = 1;
for year=fyear:lyear
  moc = 0;
  amoc = 0;
  amoc26 = 0;
  dnm1 = zeros(79,61);
  dnm2 = zeros(79,61);
  dnm3 = zeros(1,61);
  for month=1:12
     
     sdate=sprintf('%4.4d%c%2.2d',year,datesep,month);
     disp(sdate)
     filename = [folder_name project_name '.pop.h.' sdate '.nc'];
     tmp = ncgetvar(filename,'MOC');

     if(nitr==1)
        lat = ncgetvar(filename,'lat_aux_grid');
        moc_z = ncgetvar(filename,'moc_z');
        ii=find(lat<60 & lat>20);
        ii2=max(find(lat<26.5));
     end
     dnm = tmp(ii,:,1,1); %global moc
     dnm1 = dnm1 + dnm.*daysweights(month);
     dnm = tmp(ii,:,1,2); % AMOC
     dnm2 = dnm2 + dnm.*daysweights(month);
     dnm = tmp(ii2,:,1,2); % AMOC
     dnm3 = dnm3 + dnm.*daysweights(month);
  end
     moc = max(dnm1(:));
     amoc = max(dnm2(:));
     amoc26 = max(dnm3(:));
     MOC(nitr) = moc;
     AMOC(nitr) = amoc;
     AMOC26(nitr) = amoc26;
     nitr = nitr+1;
end

%keyboard
save(['matfiles/' project_name '_moc_' num2str(fyear) '_' num2str(lyear) '.mat'],'MOC','AMOC','AMOC26')
