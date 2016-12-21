clear all

pathname='/fimm/work/milicak/mnt/';
modelname='NorESM1-M'
project_name='rcp85'
version='r1i1p1'

K2C=273.15;
pathnameu=[pathname 'output2/NCC/' modelname '/' project_name '/mon/ocean/Omon/' version '/latest/umo'];
pathnamev=[pathname 'output2/NCC/' modelname '/' project_name '/mon/ocean/Omon/' version '/latest/vmo'];
pathnamet=[pathname 'output1/NCC/' modelname '/' project_name '/mon/ocean/Omon/' version '/latest/thetao'];
pathnames=[pathname 'output1/NCC/' modelname '/' project_name '/mon/ocean/Omon/' version '/latest/so'];

yearsini=2006:4:2098;
yearsend=2009:4:2100;yearsend(end+1)=2100;

[BSO CAA DS EC IFS FS]=sections_noresm_bipolar;

timeind=1;
for time=1:length(yearsini)
   sdate=sprintf('%4.4d%2.2d%c%4.4d%2.2d',yearsini(time),1,'-',yearsend(time),12);
   %netcdf files
   filenameu=[pathnameu '/umo_Omon_' modelname '_' project_name '_' version '_'  sdate '.nc'];
   filenamev=[pathnamev '/vmo_Omon_' modelname '_' project_name '_' version '_'  sdate '.nc'];
   filenamet=[pathnamet '/thetao_Omon_' modelname '_' project_name '_' version '_'  sdate '.nc'];
   filenames=[pathnames '/so_Omon_' modelname '_' project_name '_' version '_'  sdate '.nc'];
  
   for month=1:48
     utr=nc_varget(filenameu,'umo',[month-1 0 0 0],[1 -1 -1 -1]);
     vtr=nc_varget(filenamev,'vmo',[month-1 0 0 0],[1 -1 -1 -1]);
     utr(isnan(utr))=0;
     vtr(isnan(vtr))=0;
     if(timeind == 1)
       zt=nc_varget(filenamet,'lev');
       ztb=nc_varget(filenamet,'lev_bnds');
       dzt=ztb(:,2)-ztb(:,1);
     end
     temp=nc_varget(filenamet,'thetao',[month-1 0 0 0],[1 -1 -1 -1])-K2C;
     salt=nc_varget(filenames,'so',[month-1 0 0 0],[1 -1 -1 -1]);

% compute Atlantic Water temperature, salinity and transport    
     i1=1;clear tempsect saltsect transsect transsectu transsectv
     for i=1:length(IFS)
       tempsect(:,i1)=temp(:,IFS(i,2),IFS(i,1));
       saltsect(:,i1)=salt(:,IFS(i,2),IFS(i,1));
       transsect(:,i1)=(utr(:,IFS(i,2),IFS(i,1)).*IFS(i,3)+vtr(:,IFS(i,2),IFS(i,1)).*IFS(i,4))*1e-9;
       transsectu(:,i1)=(utr(:,IFS(i,2),IFS(i,1)).*IFS(i,3))*1e-9;
       transsectv(:,i1)=(vtr(:,IFS(i,2),IFS(i,1)).*IFS(i,4))*1e-9;
       i1=i1+1;
     end
%     tempsectdz=diff(tempsect,1,1);
     for i=1:size(tempsect,2)
%       kind(i)=max(find(tempsectdz(:,i)>=0));       
       % Assumption that Atlantic water will be larger than 4 degrees C
       kind(i)=max(find(tempsect(:,i)>=4));
       aa=1-isnan(tempsect(1:kind(i),i));
       dnm=tempsect(1:kind(i),i).*(aa.*dzt(1:kind(i)));
       tempAW(i)=nansum(dnm)./nansum(aa.*dzt(1:kind(i)));
       dnm=saltsect(1:kind(i),i).*(aa.*dzt(1:kind(i)));
       saltAW(i)=nansum(dnm)./nansum(aa.*dzt(1:kind(i)));
       dnm=transsect(1:kind(i),i);
       trAW(i)=nansum(dnm);
       
       aa=1-isnan(tempsect(kind(i)+1:end,i));
       dnm=tempsect(kind(i)+1:end,i).*(aa.*dzt(kind(i)+1));
       tempOW1(i)=nansum(dnm)./nansum(aa.*dzt(kind(i)+1));
       dnm=saltsect(kind(i)+1:end,i).*(aa.*dzt(kind(i)+1));
       saltOW1(i)=nansum(dnm)./nansum(aa.*dzt(kind(i)+1));
       dnm=transsect(kind(i)+1:end,i);
       trOW1(i)=nansum(dnm);
     end

     TAW(timeind)=nanmean(tempAW);
     SAW(timeind)=nanmean(saltAW);
     TrAW(timeind)=nansum(trAW(:));
     TOW1(timeind)=nanmean(tempOW1);
     SOW1(timeind)=nanmean(saltOW1);
     TrOW1(timeind)=nansum(trOW1(:));
     timeind=timeind+1
   end %month
end %time

