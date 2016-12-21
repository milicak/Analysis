clear all
display('first you need to run annual_mean_tempsalt_mass_weighted.m')

pathname='/bcmhsm/milicak/RUNS/noresm/NORTH/';
project_name='NRCP85AERCN_f19_g16_01'
%project_name='NAER1850CNOC_f19_g16_06'
%project_name='NOIIA_T62_tn11_ctrl'
%project_name='NOIIA_T62_tn11_sr10m60d_01'

yearsini=2006; %700; %2006;
yearsend=2100; %1200; %2100;

Nz=53; %number of layers
Cp=3985; %specific heat ratio
grav=9.81;
rho0=1027; %
TAW_cri=4;  %critical temperature for the Atlantic water
SEG_cri=34.5; %critical salinity for the East Greenland current
ow_layer=35; %overflow layer and below
area=nc_varget('grid_NorESM_bipolargrid.nc','parea');

%     sdate=sprintf('%4.4d%c%2.2d',time,'-',month);
filenametrho=[pathname project_name '_temp_salt_mass_weighted_annual_' num2str(yearsini) '-' num2str(yearsend) '.nc'];
filenamesrho=[pathname project_name '_temp_salt_mass_weighted_annual_' num2str(yearsini) '-' num2str(yearsend) '.nc'];
filenamedzrho=[pathname project_name '_temp_salt_mass_weighted_annual_' num2str(yearsini) '-' num2str(yearsend) '.nc'];

[BSO CAA DS EC IFS FS BS]=sections_noresm_bipolar;
NSS=[DS;IFS]; % total Nordic Sea Section
for i=1:size(NSS,1)
  areasect(1:Nz,i)=area(NSS(i,2),NSS(i,1));
end
clear area

timeind=1;
for time=yearsini:yearsend
     %netcdf files
     temp=nc_varget(filenametrho,'temp',[timeind-1 0 0 0],[1 -1 -1 -1]);
     salt=nc_varget(filenamesrho,'saln',[timeind-1 0 0 0],[1 -1 -1 -1]);
     dzrho=nc_varget(filenamedzrho,'dp',[timeind-1 0 0 0],[1 -1 -1 -1])./(grav*rho0);
     % salt has dimensions of Nz, Ny Nx
% compute Atlantic Water, EGC, IFS, DS overflow temperature, salinity and transport    
     i1=1;clear tempsect saltsect transsect heattranssect salttranssect dzsect
     for i=1:size(NSS,1)
       tempsect(:,i1)=temp(:,NSS(i,2),NSS(i,1));
       saltsect(:,i1)=salt(:,NSS(i,2),NSS(i,1));
       dzsect(:,i1)=dzrho(:,NSS(i,2),NSS(i,1));
       i1=i1+1;
     end
     for i=1:size(tempsect,2)
       clear kind kstr ktop
       ktop=[];
% Assumption that EGC will be fresher than 34.5 psu
       ind1=min(min(find(saltsect(:,i)<=SEG_cri)),ow_layer-1); %34th layer
       ind2=min(max(find(saltsect(:,i)<=SEG_cri)),ow_layer-1); %34th layer
       for kk=1:ind2
          if(tempsect(ind2,i)>=TAW_cri)
            ind2=ind2-1;
          end
       end
       if(isempty(ind1)==0 & ind1<ind2 & i<size(DS,1))
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
         dnm=tempsect(kind,i).*(aa.*dzsect(kind,i).*areasect(kind,i));
         tempEG(i)=nansum(dnm);
         volumeEG(i)=nansum(aa.*dzsect(kind,i).*areasect(kind,i));
         areaEG(i)=areasect(1,i);
         htempEG(i)=nansum(aa.*dzsect(kind,i));
         dnm=saltsect(kind,i).*(aa.*dzsect(kind,i).*areasect(kind,i));
         saltEG(i)=nansum(dnm);
       else
         tempEG(i)=NaN;
         saltEG(i)=NaN;
         volumeEG(i)=0;
         areaEG(i)=0;
         htempEG(i)=0;
         kind=0;
         kstr=0;
         kend=0;
       end

% Atlantic Water ==> defined as layers above 35 and saltier than SEG_cri
       if(i<=size(DS,1))
         %ind1=max(min(find(saltsect(:,i)>SEG_cri)),kind(end)+1);
         ind1=min(min(find(saltsect(:,i)>SEG_cri)),kind(end)+1);
         ind2=min(max(find(saltsect(:,i)>SEG_cri)),ow_layer-1);
       else
         ind1=max(min(find(tempsect(:,i)>=TAW_cri)),kind(end)+1);
         ind2=max(find(tempsect(:,i)>=TAW_cri));
       end
       if(isempty(ind1)==0 & ind1<ind2)
         kstr=ind1;
         kend=ind2;
         if(isempty(kstr)==0)
           kind=[ktop kstr:kend];
         else
           kind=kstr:kend;
         end
         aa=1-isnan(tempsect(kind,i));
         dnm=tempsect(kind,i).*(aa.*dzsect(kind,i).*areasect(kind,i));
         tempAW(i)=nansum(dnm);
         volumeAW(i)=nansum(aa.*dzsect(kind,i).*areasect(kind,i));
         %areaAW(i)=nansum(aa.*areasect(kind,i));
         areaAW(i)=areasect(1,i);
         htempAW(i)=nansum(aa.*dzsect(kind,i));
         dnm=saltsect(kind,i).*(aa.*dzsect(kind,i).*areasect(kind,i));
         saltAW(i)=nansum(dnm);
       else
         tempAW(i)=NaN;
         saltAW(i)=NaN;
         volumeAW(i)=0;
         areaAW(i)=0;
         htempAW(i)=0;
       end

% Overflow water ==> the rest 
       if(i<=size(DS,1))
         kstr=min(ow_layer,kind(end)+1);
       else
         kstr=min(Nz,kind(end)+1);
       end
       kind=kstr:Nz;
       aa=1-isnan(tempsect(kind,i));
       dnm=tempsect(kind,i).*(aa.*dzsect(kind,i).*areasect(kind,i));
       tempOW(i)=nansum(dnm);
       volumeOW(i)=nansum(aa.*dzsect(kind,i).*areasect(kind,i));
       %areaOW(i)=nansum(aa.*areasect(kind,i));
       areaOW(i)=areasect(1,i);
       htempOW(i)=nansum(aa.*dzsect(kind,i));
       dnm=saltsect(kind,i).*(aa.*dzsect(kind,i).*areasect(kind,i));
       saltOW(i)=nansum(dnm);
     end

     TEGC(timeind)=nansum(tempEG)/nansum(volumeEG);
     SEGC(timeind)=nansum(saltEG)/nansum(volumeEG);
     %hEGC(timeind)=nansum(volumeEG)/nansum(areaEG);
     if(nansum(htempEG)~=0)
       hEGC(timeind)=nansum(areaEG.*htempEG)/nansum(areaEG(htempEG~=0));
     else
       hEGC(timeind)=0;
     end
     TAW(timeind)=nansum(tempAW)/nansum(volumeAW);
     SAW(timeind)=nansum(saltAW)/nansum(volumeAW);
     hAW(timeind)=nansum(areaAW.*htempAW)/nansum(areaAW(htempAW~=0));
     TOW(timeind)=nansum(tempOW)/nansum(volumeOW);
     SOW(timeind)=nansum(saltOW)/nansum(volumeOW);
     hOW(timeind)=nansum(areaOW.*htempOW)/nansum(areaOW(htempOW~=0));

     savename=['matfiles/' project_name '_' num2str(yearsini) '_' num2str(yearsend) '_tempsalt_yearly'];
     save(savename,'TAW','SAW','TEGC','SEGC','TOW','SOW', ...
                   'hAW','hEGC','hOW')

     timeind=timeind+1
end %time


