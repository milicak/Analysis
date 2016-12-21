clear all

grid_file='/fimm/home/bjerknes/milicak/Analysis/NorESM/climatology/Analysis/grid.nc';
plon=ncgetvar(grid_file,'plon');
plat=ncgetvar(grid_file,'plat');
parea=ncgetvar(grid_file,'parea');
plon=plon(:,1:end-1);
plat=plat(:,1:end-1);
parea=parea(:,1:end-1);

Qnet=ncgetvar('/bcmhsm/milicak/RUNS/noresm/CORE2/Upwelling/NOIIA_T62_tn11_sr10m60d_01_Q_net_swa_nsf_monthly_1-100.nc','Q_net');
Qswa=ncgetvar('/bcmhsm/milicak/RUNS/noresm/CORE2/Upwelling/NOIIA_T62_tn11_sr10m60d_01_Q_net_swa_nsf_monthly_1-100.nc','Q_swa');
Qnsf=ncgetvar('/bcmhsm/milicak/RUNS/noresm/CORE2/Upwelling/NOIIA_T62_tn11_sr10m60d_01_Q_net_swa_nsf_monthly_1-100.nc','Q_nsf');

% new one up to 42N
xx=[243.6613
  241.9747
  240.5411
  239.1075
  237.8848
  236.5355
  235.3549
  234.8489
  234.3008
  233.7105
  233.2888
  233.1623
  233.0358
  232.9937
  231.9817
  233.9213
  237.3366
  240.2881
  243.6613];

yy=[33.1694
   32.8586
   32.8586
   32.8240
   33.0313
   33.5839
   34.2401
   35.0000
   35.8635
   36.7960
   38.0394
   39.0065
   40.0772
   40.9407
   42.0460
   42.7022
   42.7022
   41.1825
   33.1694];

in=insphpoly(plon,plat,xx,yy,0,90);
in=double(in');
in(in==0)=NaN;

for time=1:size(Qnet,3)
   dnm=squeeze(Qnet(:,:,time)).*parea.*in';
   dnm2=parea.*in';
   Qnet_Cal(time)=nansum(dnm(:))./nansum(dnm2(:));   
   dnm=squeeze(Qnsf(:,:,time)).*parea.*in';
   Qnsf_Cal(time)=nansum(dnm(:))./nansum(dnm2(:));   
   dnm=squeeze(Qswa(:,:,time)).*parea.*in';
   Qswa_Cal(time)=nansum(dnm(:))./nansum(dnm2(:));   
end

months2days=[31  28  31  30  31   30   31  31   30 31   30 31];
yeardays=sum(months2days);
months2days=months2days./yeardays;
m2days=repmat(months2days,[100 1]);
Qnet_Cal_year=reshape(Qnet_Cal,[12 100]).*m2days';
Qnet_Cal_year=nansum(Qnet_Cal_year,1);
Qnsf_Cal_year=reshape(Qnsf_Cal,[12 100]).*m2days';
Qnsf_Cal_year=nansum(Qnsf_Cal_year,1);
Qswa_Cal_year=reshape(Qswa_Cal,[12 100]).*m2days';
Qswa_Cal_year=nansum(Qswa_Cal_year,1);






