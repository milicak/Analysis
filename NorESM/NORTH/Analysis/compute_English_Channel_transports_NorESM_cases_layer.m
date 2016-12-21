clear all

pathname='/fimm/work/milicak/mnt2/';
modelname='NorESM1-M'
project_name='NRCP85AERCN_f19_g16_01'
%project_name='NAER1850CNOC_f19_g16_06'
yearsini=2006 %700; %2006;
yearsend=2100 %1200; %2100;

Nz=53; %number of layers
K2C=273.15;
Cp=3985; %specific heat ratio
rho0=1027; %
TAW_cri=4;  %critical temperature for the Atlantic water
SEG_cri=34.5; %critical salinity for the East Greenland current
ow_layer=35; %overflow layer and below
area=nc_varget('grid_NorESM_bipolargrid.nc','parea');

pathnameurho=[pathname project_name '/ocn/hist/'];
pathnamevrho=[pathname project_name '/ocn/hist/'];


[BSO CAA DS EC IFS FS BS]=sections_noresm_bipolar;
NSS=[EC]; % total EC section
for i=1:size(NSS,1)
  areasect(1:Nz,i)=area(NSS(i,2),NSS(i,1));
end
clear area

timeind=1;
for time=yearsini:yearsend
   for month=1:12
     sdate=sprintf('%4.4d%c%2.2d',time,'-',month);
     %netcdf files
     filenameurho=[pathnameurho project_name '.micom.hm.' sdate '.nc'];
     filenamevrho=[pathnameurho project_name '.micom.hm.' sdate '.nc'];
     filenameuhflxrho=[pathnameurho project_name '.micom.hm.' sdate '.nc'];
     filenamevhflxrho=[pathnameurho project_name '.micom.hm.' sdate '.nc'];
  
     utr=nc_varget(filenameurho,'uflx',[0 0 0 0],[1 -1 -1 -1]);
     vtr=nc_varget(filenamevrho,'vflx',[0 0 0 0],[1 -1 -1 -1]);
     uhflx=nc_varget(filenameurho,'uhflx',[0 0 0 0],[1 -1 -1 -1]);
     vhflx=nc_varget(filenamevrho,'vhflx',[0 0 0 0],[1 -1 -1 -1]);
     usflx=nc_varget(filenameurho,'usflx',[0 0 0 0],[1 -1 -1 -1]);
     vsflx=nc_varget(filenamevrho,'vsflx',[0 0 0 0],[1 -1 -1 -1]);
     dzrho=nc_varget(filenameurho,'dz',[0 0 0 0],[1 -1 -1 -1]);
     utr(isnan(utr))=0;
     vtr(isnan(vtr))=0;
     uhflx(isnan(uhflx))=0;
     vhflx(isnan(vhflx))=0;
     usflx(isnan(usflx))=0;
     vsflx(isnan(vsflx))=0;
     utr(dzrho==0)=0;
     vtr(dzrho==0)=0;
     uhflx(dzrho==0)=0;
     vhflx(dzrho==0)=0;
     usflx(dzrho==0)=0;
     vsflx(dzrho==0)=0;
     % salt has dimensions of Nz, Ny Nx
     i1=1;clear tempsect saltsect transsect heattranssect salttranssect dzsect
     for i=1:size(NSS,1)
       transsect(:,i1)=(utr(:,NSS(i,2),NSS(i,1)).*NSS(i,3)+vtr(:,NSS(i,2),NSS(i,1)).*NSS(i,4))*1e-9;
       % for NAER1850CNOC_f19_g16_04-06 type of models since heattrans is in Watts only
       heattranssect(:,i1)=(uhflx(:,NSS(i,2),NSS(i,1)).*NSS(i,3)+vhflx(:,NSS(i,2),NSS(i,1)).*NSS(i,4))./(Cp*rho0);
       % for N... type of models since heattrans is in Watts/m2 
       %heattranssect(:,i1)=(uhflx(:,NSS(i,2),NSS(i,1)).*NSS(i,3)+vhflx(:,NSS(i,2),NSS(i,1)).*NSS(i,4)).*areasect(:,i)/(Cp*rho0);
       salttranssect(:,i1)=(usflx(:,NSS(i,2),NSS(i,1)).*NSS(i,3)+vsflx(:,NSS(i,2),NSS(i,1)).*NSS(i,4));
       i1=i1+1;
     end
     trBS=transsect;
     TrEC(timeind)=nansum(trBS(:));
     HTrEC(timeind)=nansum(heattranssect(:))*1e-6;
     STrEC(timeind)=nansum(salttranssect(:))*1e-6;

     savename=['matfiles/' modelname '_' project_name '_' num2str(yearsini) '_' num2str(yearsend) '_EC_transports'];
     save(savename,'TrEC','HTrEC','STrEC')

     timeind=timeind+1
   end %month
end %time


