clear all

%root_name = '/fimm/work/milicak/mnt/viljework/archive/';
root_name = '/fimm/work/milicak/mnt/norstore/NS2345K/noresm/cases/';
%project_name = 'B1850CN_f19_tn11_kdsens';
%project_name = 'B1850CN_f19_tn11_kdsens01';
%project_name = 'B1850CN_f19_tn11_kdsens02';
%project_name = 'B1850CN_f19_tn11_kdsens03';
%project_name = 'B1850CN_f19_tn11_kdsens04';
%project_name = 'B1850CN_f19_tn11_kdsens05';
%project_name = 'B1850CN_f19_tn11_kdsens06';

folder_name = [root_name project_name '/ocn/hist/'];


grid_file='/bcmhsm/milicak/RUNS/noresm/CORE2/Arctic/DATA/ncar-pop/areacello_fx_CCSM4_piControl_r0i0p0.nc';
area=ncgetvar(grid_file,'areacello');

datesep = '-';
fyear = 1;
lyear = 250;
daysweights = [31 28 31 30 31 30 31 31 30 31 30 31]./365;

itr = 1;
for year=fyear:lyear
  temp = 0;
  for month=1:12
     sdate=sprintf('%4.4d%c%2.2d',year,datesep,month);
     disp(sdate)
     filename = [folder_name project_name '.pop.h.' sdate '.nc'];
     temp = temp + ncgetvar(filename,'TEMP').*daysweights(month);
     temp(temp==0) = NaN;
     if(itr==1)
       lon = ncgetvar(filename,'TLONG');
       lat = ncgetvar(filename,'TLAT');
       south1 = 0; %0 North
       north1 = 60; %60 North
       west1 = -80+360; %80 West
       east1 = 360; %00 East

       [nx ny]=size(lon);
       % North Atlantic mask
       mask=zeros(nx,ny);
       for ii=1:nx; for jj=1:ny
          if(lat(ii,jj) >= south1 & lat(ii,jj) <= north1)
          if(lon(ii,jj) >= west1 & lon(ii,jj) <= east1)
             mask(ii,jj) = 1;
          end;end
       end;end
     end %itr
  end
  sst = squeeze(temp(:,:,1));
  dnm = sq(sst.*mask.*area); 
  dnm2 = sq(mask.*area); 
  SSTNA(itr) = nansum(dnm(:))./nansum(dnm2(:));
  dnm = sq(sst.*area); 
  dnm2 = sq(area); 
  SST(itr) = nansum(dnm(:))./nansum(dnm2(:));
  itr = itr+1;
end
save(['matfiles/' project_name '_ssttime_' num2str(fyear) '_' num2str(lyear) '.mat'],'SSTNA','SST')

exit
