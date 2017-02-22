clear all

ice_cr=0.099; % critical ratio

root_folder='/hexagon/work/milicak/archive/';
%root_folder='/hexagon/work/matsbn/archive/';
%root_folder='/fimm/work/milicak/mnt/hexagonwork/archive/';
%root_folder='/fimm/work/milicak/mnt/norstore/NS2345K/noresm/cases/';
%root_folder='/fimm/work/milicak/mnt/viljework/archive/';

expid='NOIIANCEP_T62_tn025_default_01'

months2days=[31  28  31  30  31   30   31  31   30 31   30 31];
yeardays=sum(months2days);

monthnames=[{'Jan'} {'Feb'} {'Mar'} {'Apr'} {'May'} {'Jun'} {'Jul'} {'Aug'} {'Sep'} {'Oct'} {'Nov'} {'Dec'}]
pdfs=[0 10 20 30 40 50 60 70 80 90 100]./100;

years=[55:1:64]; %55=2002 and 64=2011
%years=2011; %2002 2011

% load lon lat of the model
lonmicom2
lon=lon(:,1:end-1);
lat=lat(:,1:end-1);

%vin, the ice volume, equal to the product of ain and the ice thickness hin.

% region
load('matfiles_leads/region1.mat');
in=insphpoly(lon,lat,lon1,lat1,0,90);
in=double(in);
in(in==0)=NaN;
datesep='-';

prefix=[root_folder expid '/ice/hist/' expid '.cice.h1.'];

years=58
nn=0;
for year=years   
  months=[1 2 3 4 11 12];
  months=1:12;
  for month=months
  %for month=[1 2 3 4 11 12]
  %for month=[11 12] % for 2002
  %for month=[1 2 3 4] % for 2011
     %dnm=zeros(1792,1216);
     LF_pdf(1:10)=0;
     LF_pdf_dim(1:10)=0;
     daystr=1;
     for days=daystr:months2days(month)
       LF_pdf_d(1:10)=0;

       sdate=sprintf('%4.4d%c%2.2d%c%2.2d',year,datesep,month,datesep,days);
       disp(sdate)
       filename=[prefix sdate '.nc'];
       LF_corr=ncgetvar(filename,'aisnap_d');
       hice=ncgetvar(filename,'hisnap_d');
       vice1=ncgetvar(filename,'vicen001_d');
       aice1=ncgetvar(filename,'aicen001_d');
       if(nn==0)
         tarea=ncgetvar(filename,'tarea');
         nn=1;
       end
       LF_corr=LF_corr.*in;
       hice=hice.*in;
       vice1=vice1.*in;
       aice1=aice1.*in./100;
       aice1=aice1./4;
       hice1=vice1./(aice1./100);
       LF_corr=1-LF_corr; %open ocean
       %aice1(vice1>0.15)=0;  %If I do this then it will not change the pdf with original version
       LF_corr=LF_corr+aice1; %include first category/4 simulates hice <0.15
       %LF_corr(hice<0.15)=0.99;
       %LF_corr(LF_corr==1)=NaN;
       LF_corr(LF_corr>=1-ice_cr)=NaN;
       for i=1:1440;for j=1:1152
         if(isnan(LF_corr(i,j))==0)
           for k=1:10
             if(LF_corr(i,j)>pdfs(k) & LF_corr(i,j) <= pdfs(k+1))
               LF_pdf_d(k)=LF_pdf_d(k)+(LF_corr(i,j))*tarea(i,j); %in meter
             end
           end %pdfs
         end 
       end;end
       LF_pdf=LF_pdf+LF_pdf_d./nansum(LF_pdf_d(:));        
       LF_pdf_dim=LF_pdf_dim+LF_pdf_d;        
     end
     LF_pdf=LF_pdf./(months2days(month)-daystr+1);
     LF_pdf_dim=LF_pdf_dim./(months2days(month)-daystr+1);
keyboard
     savename1=['matfiles_leads/region1_LF_pdf_' sprintf('%4.4d',year) '_' sprintf('%2.2d',month) '.mat']
     save(savename1,'LF_pdf','LF_pdf_dim');
     %tmp=tmp+dnm;
  end
end
