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
       dz = ncgetvar(filename,'dz');
       area3d = repmat(area,[1 1 size(temp,3)]);
       h3d = repmat(dz,[1 size(temp,1) size(temp,2)]);
       h3d = permute(h3d,[2 3 1]);
     end
  end
  dnm = temp.*area3d.*h3d;
  dnm2 = area3d.*h3d;
  T(itr) = nansum(dnm(:))./nansum(dnm2(:));
  dnm = temp(:,1:200,:).*area3d(:,1:200,:).*h3d(:,1:200,:);
  dnm2 = area3d(:,1:200,:).*h3d(:,1:200,:);
  TSH(itr) = nansum(dnm(:))./nansum(dnm2(:));
  dnm = temp(:,201:end,:).*area3d(:,201:end,:).*h3d(:,201:end,:);
  dnm2 = area3d(:,201:end,:).*h3d(:,201:end,:);
  TNH(itr) = nansum(dnm(:))./nansum(dnm2(:));
  itr = itr+1;
end
Tempglobal = T;
TempSH = TSH;
TempNH = TNH;

save(['matfiles/' project_name '_globaltemp_' num2str(fyear) '_' num2str(lyear) '.mat'],'Tempglobal','TempNH','TempSH')

exit
