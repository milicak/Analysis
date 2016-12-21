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

pathnameurho=[pathname 'output1/NCC/' modelname '/' project_name '/mon/ocean/OmonOnRho/' version '/latest/umo'];
pathnamevrho=[pathname 'output1/NCC/' modelname '/' project_name '/mon/ocean/OmonOnRho/' version '/latest/vmo'];
pathnametrho=[pathname 'output1/NCC/' modelname '/' project_name '/mon/ocean/OmonOnRho/' version '/latest/thetao'];
pathnamesrho=[pathname 'output1/NCC/' modelname '/' project_name '/mon/ocean/OmonOnRho/' version '/latest/so'];
pathnamedzrho=[pathname 'output1/NCC/' modelname '/' project_name '/mon/ocean/OmonOnRho/' version '/latest/thkcello'];

yearsini=2006:4:2098;
yearsend=2009:4:2100;yearsend(end+1)=2100;

[BSO CAA DS EC IFS FS]=sections_noresm_bipolar;

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
     temp=nc_varget(filenametrho,'thetao',[month-1 0 0 0],[1 -1 -1 -1])-K2C;
     salt=nc_varget(filenamesrho,'so',[month-1 0 0 0],[1 -1 -1 -1]);
     dzrho=nc_varget(filenamedzrho,'thkcello',[month-1 0 0 0],[1 -1 -1 -1]);
     % salt has dimensions of Nz, Ny Nx
% compute Atlantic Water and IFS overflow temperature, salinity and transport    
     i1=1;clear tempsect saltsect transsect transsectu transsectv dzsect
     for i=1:length(IFS)
       tempsect(:,i1)=temp(:,IFS(i,2),IFS(i,1));
       saltsect(:,i1)=salt(:,IFS(i,2),IFS(i,1));
       dzsect(:,i1)=dzrho(:,IFS(i,2),IFS(i,1));
       transsect(:,i1)=(utr(:,IFS(i,2),IFS(i,1)).*IFS(i,3)+vtr(:,IFS(i,2),IFS(i,1)).*IFS(i,4))*1e-9;
       %transsectu(:,i1)=(utr(:,IFS(i,2),IFS(i,1)).*IFS(i,3))*1e-9;
       %transsectv(:,i1)=(vtr(:,IFS(i,2),IFS(i,1)).*IFS(i,4))*1e-9;
       i1=i1+1;
     end
     for i=1:size(tempsect,2)
       % Assumption that Atlantic water will be larger than 4 degrees C
       kind(i)=max(find(tempsect(:,i)>=TAW_cri));
       aa=1-isnan(tempsect(1:kind(i),i));
       dnm=tempsect(1:kind(i),i).*(aa.*dzsect(1:kind(i),i));
       tempAW(i)=nansum(dnm)./nansum(aa.*dzsect(1:kind(i),i));
       dnm=saltsect(1:kind(i),i).*(aa.*dzsect(1:kind(i),i));
       saltAW(i)=nansum(dnm)./nansum(aa.*dzsect(1:kind(i),i));
       dnm=transsect(1:kind(i),i);
       trAW(i)=nansum(dnm);
       
       aa=1-isnan(tempsect(kind(i)+1:end,i));
       dnm=tempsect(kind(i)+1:end,i).*(aa.*dzsect(kind(i)+1,i));
       tempOW1(i)=nansum(dnm)./nansum(aa.*dzsect(kind(i)+1,i));
       dnm=saltsect(kind(i)+1:end,i).*(aa.*dzsect(kind(i)+1,i));
       saltOW1(i)=nansum(dnm)./nansum(aa.*dzsect(kind(i)+1,i));
       dnm=transsect(kind(i)+1:end,i);
       trOW1(i)=nansum(dnm);
     end

     TAW(timeind)=nanmean(tempAW);
     SAW(timeind)=nanmean(saltAW);
     TrAW(timeind)=nansum(trAW(:));
     TOW1(timeind)=nanmean(tempOW1);
     SOW1(timeind)=nanmean(saltOW1);
     TrOW1(timeind)=nansum(trOW1(:));

% compute Denmark Strait overflow, East-Greenland Current temperature, salinity and transport    
     i1=1;clear tempsect saltsect transsect transsectu transsectv dzsect
     for i=1:length(DS)
       tempsect(:,i1)=temp(:,DS(i,2),DS(i,1));
       saltsect(:,i1)=salt(:,DS(i,2),DS(i,1));
       dzsect(:,i1)=dzrho(:,DS(i,2),DS(i,1));
       transsect(:,i1)=(utr(:,DS(i,2),DS(i,1)).*DS(i,3)+vtr(:,DS(i,2),DS(i,1)).*DS(i,4))*1e-9;
       i1=i1+1;
     end

     for i=1:size(tempsect,2)
       clear kind kstr ktop
       ktop=[];
       % Assumption that EGC will be fresher than 34 psu
%       ind=max(find(saltsect(:,i)<=SEG_cri));
       ind1=min(min(find(saltsect(:,i)<=SEG_cri)),ow_layer-1); %34th layer
       ind2=min(max(find(saltsect(:,i)<=SEG_cri)),ow_layer-1); %34th layer
       if(isempty(ind1)==0)
         kstr=ind1;
         kend=ind2;
         kind=kstr:kend;
         if(kstr>1)
           ktop=1:kstr-1;
         end
         if(isempty(find(tempsect(ktop,i)<0.5)) ==0)
           dnm=find(tempsect(ktop,i)<0.5);
           kind=[dnm' kind];
           ktop=dnm(end)+1:kstr-1;
         end
         aa=1-isnan(tempsect(kind,i));
         dnm=tempsect(kind,i).*(aa.*dzsect(kind,i));
         tempEG(i)=nansum(dnm)./nansum(aa.*dzsect(kind,i));
         dnm=saltsect(kind,i).*(aa.*dzsect(kind,i));
         saltEG(i)=nansum(dnm)./nansum(aa.*dzsect(kind,i));
         dnm=transsect(kind,i);
         trEG(i)=nansum(dnm);
       else
         tempEG(i)=NaN;
         saltEG(i)=NaN;
         trEG(i)=0;
         kind=0;
         kstr=0;
         kend=0;
       end

       ind1=max(min(find(saltsect(:,i)>SEG_cri)),kind(end)+1);
       ind2=min(max(find(saltsect(:,i)>SEG_cri)),ow_layer-1);
       if(isempty(ind1)==0 & ind1<ind2)
         kstr=ind1;
         kend=ind2;
         if(isempty(kstr)==0)
           kind=[ktop kstr:kend];
         else
           kind=kstr:kend;
         end
         aa=1-isnan(tempsect(kind,i));
         dnm=tempsect(kind,i).*(aa.*dzsect(kind,i));
         tempAW2(i)=nansum(dnm)./nansum(aa.*dzsect(kind,i));
         dnm=saltsect(kind,i).*(aa.*dzsect(kind,i));
         saltAW2(i)=nansum(dnm)./nansum(aa.*dzsect(kind,i));
         dnm=transsect(kind,i);
         trAW2(i)=nansum(dnm);
       else
         tempAW2(i)=NaN;
         saltAW2(i)=NaN;
         trAW2(i)=0;
       end

       kstr=min(ow_layer,kind(end)+1);
       kind=kstr:Nz;
       aa=1-isnan(tempsect(kind,i));
       dnm=tempsect(kind,i).*(aa.*dzsect(kind,i));
       tempOW2(i)=nansum(dnm)./nansum(aa.*dzsect(kind,i));
       dnm=saltsect(kind,i).*(aa.*dzsect(kind,i));
       saltOW2(i)=nansum(dnm)./nansum(aa.*dzsect(kind,i));
       dnm=transsect(kind,i);
       trOW2(i)=nansum(dnm);
     end

     TAW2(timeind)=nanmean(tempAW2);
     SAW2(timeind)=nanmean(saltAW2);
     TrAW2(timeind)=nansum(trAW2(:));
     TEGC(timeind)=nanmean(tempEG);
     SEGC(timeind)=nanmean(saltEG);
     TrEGC(timeind)=nansum(trEG(:));
     TOW2(timeind)=nanmean(tempOW2);
     SOW2(timeind)=nanmean(saltOW2);
     TrOW2(timeind)=nansum(trOW2(:));

     savename=['matfiles/' modelname '_' project_name '_' version '_' num2str(yearsini(1)) '_' num2str(yearsend(end)) '_tempsalttransports']
     save(savename,'TAW','TAW2','SAW','SAW2','TrAW','TrAW2','TEGC','SEGC','TrEGC','TOW1','TOW2','SOW1','SOW2','TrOW1','TrOW2')

     timeind=timeind+1
   end %month
end %time


