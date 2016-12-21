clear all

%pathname='/fimm/work/milicak/mnt2/';
pathname='/work-common/shared/bjerknes/milicak/mnt/norstore/NS2345K/noresm/cases/';
modelname='NorESM1-M'
%project_name='NRCP85AERCN_f19_g16_01'
project_name='NAER1850CNOC_f19_g16_06'
pathnameurho=[pathname project_name '/ocn/hist/'];
yearsini=700; %2006;
yearsend=1200; %2100;

Nz=53; %number of layers
Cp=3985; %specific heat ratio
rho0=1027; %

area=nc_varget('/fimm/home/bjerknes/milicak/Analysis/NorESM/NORTH/Analysis/grid_NorESM_bipolargrid.nc','parea');
lon=nc_varget('/fimm/home/bjerknes/milicak/Analysis/NorESM/NORTH/Analysis/grid_NorESM_bipolargrid.nc','plon');
lat=nc_varget('/fimm/home/bjerknes/milicak/Analysis/NorESM/NORTH/Analysis/grid_NorESM_bipolargrid.nc','plat');
mask=nc_varget('/fimm/home/bjerknes/milicak/Analysis/NorESM/NORTH/Analysis/grid_NorESM_bipolargrid.nc','pmask');

x=[ 31.432140612600524
  42.190442170359859
  43.721323201424831
  45.828040216651857
  36.600619689957490
  33.960201030872952];
y=[27.328730520796874
  11.999698769076225
  12.252028509845292
  17.193485933239465
  29.557643230923606
  29.221203576564854];

y(end+1)=y(1);
x(end+1)=x(1);

in=insphpoly(lon,lat,x,y,0,90);
in=double(in);
in=in.*mask;
in(234,75)=0;
in(in==0)=NaN;

timeind=1;
for time=yearsini:yearsend
   for month=1:12
     sdate=sprintf('%4.4d%c%2.2d',time,'-',month);
     filenamehf=[pathnameurho project_name '.micom.hm.' sdate '.nc'];
%netcdf files
     sfs=nc_varget(filenamehf,'sflx',[0 0 0],[1 -1 -1]);
     sss=nc_varget(filenamehf,'sss',[0 0 0],[1 -1 -1]);
     %fice=nc_varget(filenamehf,'fice',[0 0 0],[1 -1 -1]);
     %eva=nc_varget(filenamehf,'eva',[0 0 0],[1 -1 -1]);
     %lip=nc_varget(filenamehf,'lip',[0 0 0],[1 -1 -1]);
     %sop=nc_varget(filenamehf,'sop',[0 0 0],[1 -1 -1]);
     %sfl=nc_varget(filenamehf,'sfl',[0 0 0],[1 -1 -1]);
     %rnf=nc_varget(filenamehf,'rnf',[0 0 0],[1 -1 -1]);
     %rfi=nc_varget(filenamehf,'rfi',[0 0 0],[1 -1 -1]);
     %fmltfz=nc_varget(filenamehf,'fmltfz',[0 0 0],[1 -1 -1]);
     %ifrac=(100-fice)/100; % icefree fraction of grid cell

     %dnm=sfs.*in.*area.*sss/(1e3); %kg/s
     dnm=sfs.*in.*area; %kg/s
     Sft(timeind)=nansum(dnm(:))*1e-6; % Total salt flux
     dnm=sfs.*in.*area./(sss.*1e-3); %kg/s
     Fwt(timeind)=nansum(dnm(:))*1e-6; %Fresh water total
     %dnm=in.*area.*(eva+lip+sop+rnf+rfi+fmltfz);
     %vftsfl=-sss.*dnm*1e-3;
     %Fwr(timeind)=nansum(dnm(:))*1e-6; %Fresh water runoff and E-P

     savename=['matfiles/' modelname '_' project_name '_'  num2str(yearsini) '_' num2str(yearsend) '_saltflux'];
     save(savename,'Fwt','Sft')

     timeind=timeind+1
   end %month
end %time


