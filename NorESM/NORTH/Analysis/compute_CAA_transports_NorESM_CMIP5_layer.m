clear all

pathname='/fimm/work/milicak/mnt/';
modelname='NorESM1-M'
project_name='rcp85'
version='r1i1p1'

Nz=53; %number of layers
K2C=273.15;
TAW_cri=4;  %critical temperature for the Atlantic water
SEG_cri=34.5; %critical salinity for the East Greenland current
ow_layer=35; %overflow layer and below
area=nc_varget('grid_NorESM_bipolargrid.nc','parea');

pathnameurho=[pathname 'output1/NCC/' modelname '/' project_name '/mon/ocean/OmonOnRho/' version '/latest/umo'];
pathnamevrho=[pathname 'output1/NCC/' modelname '/' project_name '/mon/ocean/OmonOnRho/' version '/latest/vmo'];
pathnametrho=[pathname 'output1/NCC/' modelname '/' project_name '/mon/ocean/OmonOnRho/' version '/latest/thetao'];
pathnamesrho=[pathname 'output1/NCC/' modelname '/' project_name '/mon/ocean/OmonOnRho/' version '/latest/so'];
pathnamedzrho=[pathname 'output1/NCC/' modelname '/' project_name '/mon/ocean/OmonOnRho/' version '/latest/thkcello'];

yearsini=2006:4:2098;
yearsend=2009:4:2100;yearsend(end+1)=2100;

[BSO CAA DS EC IFS FS BS]=sections_noresm_bipolar;
NSS=[CAA]; % total Bering Strait Section
for i=1:size(NSS,1)
  areasect(1:Nz,i)=area(NSS(i,2),NSS(i,1));
end
clear area

timeind=1;
for time=1:length(yearsini)
   sdate=sprintf('%4.4d%2.2d%c%4.4d%2.2d',yearsini(time),1,'-',yearsend(time),12);
   %netcdf files
   filenameurho=[pathnameurho '/umo_OmonOnRho_' modelname '_' project_name '_' version '_'  sdate '.nc'];
   filenamevrho=[pathnamevrho '/vmo_OmonOnRho_' modelname '_' project_name '_' version '_'  sdate '.nc'];
   filenametrho=[pathnametrho '/thetao_OmonOnRho_' modelname '_' project_name '_' version '_'  sdate '.nc'];
   filenamesrho=[pathnamesrho '/so_OmonOnRho_' modelname '_' project_name '_' version '_'  sdate '.nc'];
   filenamedzrho=[pathnamedzrho '/thkcello_OmonOnRho_' modelname '_' project_name '_' version '_'  sdate '.nc'];
  
   for month=1:48
     utr=nc_varget(filenameurho,'umo',[month-1 0 0 0],[1 -1 -1 -1]);
     vtr=nc_varget(filenamevrho,'vmo',[month-1 0 0 0],[1 -1 -1 -1]);
     utr(isnan(utr))=0;
     vtr(isnan(vtr))=0;
     dzrho=nc_varget(filenamedzrho,'thkcello',[month-1 0 0 0],[1 -1 -1 -1]);
     % salt has dimensions of Nz, Ny Nx
     i1=1;clear tempsect saltsect transsect transsectu transsectv dzsect
     for i=1:size(NSS,1)
       transsect(:,i1)=(utr(:,NSS(i,2),NSS(i,1)).*NSS(i,3)+vtr(:,NSS(i,2),NSS(i,1)).*NSS(i,4))*1e-9;
       i1=i1+1;
     end
     trCAA=transsect;
     TrCAA(timeind)=nansum(trCAA(:));

     savename=['matfiles/' modelname '_' project_name '_' version '_' num2str(yearsini(1)) '_' num2str(yearsend(end)) '_CAA_transports'];
     save(savename,'TrCAA')

     timeind=timeind+1
   end %month
end %time


