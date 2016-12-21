clear all
% sshfs -o uid=1000 -o gid=1000 milicak@login.norstore.uio.no:/projects/NS2345K/noresm/cases/ /fimm/work/milicak/mnt2/
warning off
pathname='/fimm/work/milicak/mnt2/';
project_name='NRCP85AERCN_f19_g16_01'
%project_name='NAER1850CNOC_f19_g16_06'


%project_name='NOIIA_T62_tn11_ctrl'
%project_name='NOIIA_T62_tn11_sr10m60d_01'

yearsini=2006 %700; %2006;
yearsend=2100 %1200; %2100;

Nz=53; %number of layers
Cp=3985; %specific heat ratio
rho0=1027; %
TAW_cri=4;  %critical temperature for the Atlantic water
SEG_cri=34.5; %critical salinity for the East Greenland current
ow_layer=35; %overflow layer and below
area=nc_varget('grid_NorESM_bipolargrid.nc','parea');

pathnameurho=[pathname project_name '/ocn/hist/'];
pathnamevrho=[pathname project_name '/ocn/hist/'];
pathnametrho=[pathname project_name '/ocn/hist/'];
pathnamesrho=[pathname project_name '/ocn/hist/'];
pathnamedzrho=[pathname project_name '/ocn/hist/'];


[BSO CAA DS EC IFS FS BS]=sections_noresm_bipolar;
NSS=[DS;IFS]; % total Nordic Sea Section
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
     filenametrho=[pathnameurho project_name '.micom.hm.' sdate '.nc'];
     filenamesrho=[pathnameurho project_name '.micom.hm.' sdate '.nc'];
     filenamedzrho=[pathnameurho project_name '.micom.hm.' sdate '.nc'];
     filenameuhflxrho=[pathnameurho project_name '.micom.hm.' sdate '.nc'];
     filenamevhflxrho=[pathnameurho project_name '.micom.hm.' sdate '.nc'];
     utr=nc_varget(filenameurho,'uflx',[0 0 0 0],[1 -1 -1 -1]);
     vtr=nc_varget(filenamevrho,'vflx',[0 0 0 0],[1 -1 -1 -1]);
     uhflx=nc_varget(filenameurho,'uhflx',[0 0 0 0],[1 -1 -1 -1]);
     vhflx=nc_varget(filenamevrho,'vhflx',[0 0 0 0],[1 -1 -1 -1]);
     usflx=nc_varget(filenameurho,'usflx',[0 0 0 0],[1 -1 -1 -1]);
     vsflx=nc_varget(filenamevrho,'vsflx',[0 0 0 0],[1 -1 -1 -1]);
     utr(isnan(utr))=0;
     vtr(isnan(vtr))=0;
     uhflx(isnan(uhflx))=0;
     vhflx(isnan(vhflx))=0;
     usflx(isnan(usflx))=0;
     vsflx(isnan(vsflx))=0;
     temp=nc_varget(filenametrho,'temp',[0 0 0 0],[1 -1 -1 -1]);
     salt=nc_varget(filenamesrho,'saln',[0 0 0 0],[1 -1 -1 -1]);
     dzrho=nc_varget(filenamedzrho,'dz',[0 0 0 0],[1 -1 -1 -1]);
     utr(dzrho==0)=0;
     vtr(dzrho==0)=0;
     uhflx(dzrho==0)=0;
     vhflx(dzrho==0)=0;
     usflx(dzrho==0)=0;
     vsflx(dzrho==0)=0;
     % salt has dimensions of Nz, Ny Nx
% compute Atlantic Water, EGC, IFS, DS overflow temperature, salinity and transport    
     i1=1;clear tempsect saltsect transsect heattranssect salttranssect dzsect
     for i=1:size(NSS,1)
       tempsect(:,i1)=temp(:,NSS(i,2),NSS(i,1));
       saltsect(:,i1)=salt(:,NSS(i,2),NSS(i,1));
       dzsect(:,i1)=dzrho(:,NSS(i,2),NSS(i,1));
       transsect(:,i1)=(utr(:,NSS(i,2),NSS(i,1)).*NSS(i,3)+vtr(:,NSS(i,2),NSS(i,1)).*NSS(i,4))*1e-9;
       % for NAER1850CNOC_f19_g16_04-06 NRCP85AERCN_f19_g16_* type of models since heattrans is in Watts only
       heattranssect(:,i1)=(uhflx(:,NSS(i,2),NSS(i,1)).*NSS(i,3)+vhflx(:,NSS(i,2),NSS(i,1)).*NSS(i,4));
       % for NAER1850CNOC_f19_g16_03 type of models since heattrans is in Watts/m2 
       %heattranssect(:,i1)=(uhflx(:,NSS(i,2),NSS(i,1)).*NSS(i,3)+vhflx(:,NSS(i,2),NSS(i,1)).*NSS(i,4)).*areasect(:,i)/(Cp*rho0);
       salttranssect(:,i1)=(usflx(:,NSS(i,2),NSS(i,1)).*NSS(i,3)+vsflx(:,NSS(i,2),NSS(i,1)).*NSS(i,4));
       i1=i1+1;
     end
   end %month
end %time
