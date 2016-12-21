clear all

root_folder='/bcmhsm/milicak/RUNS/obs/LF_newTP_dataset/data_mat/'

load pixarea6km

month=1; %1 to 12
months2days=[31  28  31  30  31   30   31  31   30 31   30 31];
yeardays=sum(months2days);

monthnames=[{'Jan'} {'Feb'} {'Mar'} {'Apr'} {'May'} {'Jun'} {'Jul'} {'Aug'} {'Sep'} {'Oct'} {'Nov'} {'Dec'}]
pdfs=[0 10 20 30 40 50 60 70 80 90 100];

years=[2002:1:2011];
years=[2003:1:2011];
%years=2011; %2002 2011

load lonlat.mat 

% region
load('matfiles/region3.mat');
in=insphpoly(lon,lat,lon3,lat3,0,90);
in=double(in);
in(in==0)=NaN;

in(:,:)=1;

%years=2003;

for year=years   
  %tmp=zeros(1792,1216);
  if(year==2002)
    months=[11 12];
  elseif(year==2011)
    months=[1 2 3 4];
  else
    months=[1 2 3 4 11 12];
  end
months=3
  for month=months
  %for month=[1 2 3 4 11 12]
  %for month=[11 12] % for 2002
  %for month=[1 2 3 4] % for 2011
     %dnm=zeros(1792,1216);
     LF_pdf(1:10)=0;
     LF_pdf_dim(1:10)=0;
     if(year ~=2003)
       daystr=1;
     else
       if(month==11)
         daystr=6;
       else
         daystr=1;
       end
     end
     for days=daystr:months2days(month)
       LF_pdf_d(1:10)=0;
       sdate=sprintf('%4.4d%2.2d%2.2d',year,month,days)
       filename=[root_folder 'LF_newTP_' sdate '.mat'];
       load(filename) 
       LF_corr=LF_corr.*in;
       LF_corr(LF_corr>100)=NaN;
       for i=1:1792;for j=1:1216
         if(isnan(LF_corr(i,j))==0)
           for k=1:10
             if(LF_corr(i,j)>pdfs(k) & LF_corr(i,j) <= pdfs(k+1))
               LF_pdf_d(k)=LF_pdf_d(k)+(LF_corr(i,j)/100)*pixarea(i,j)*1e6; %in meter 2
               %LF_pdf_d(k)=LF_pdf_d(k)+(LF_corr(i,j)/100);
               %LF_pdf_d(k)=LF_pdf_d(k)+1;
             end
           end %pdfs
         end 
       end;end
       if(nansum(LF_pdf_d(:))~=0)
         LF_pdf=LF_pdf+LF_pdf_d./nansum(LF_pdf_d(:));        
       end
       LF_pdf_dim=LF_pdf_dim+LF_pdf_d;        
     end
     LF_pdf=LF_pdf./(months2days(month)-daystr+1);
     LF_pdf_dim=LF_pdf_dim./(months2days(month)-daystr+1);
keyboard
     %savename1=['matfiles/region3_LF_pdf_' sprintf('%4.4d',year) '_' sprintf('%2.2d',month) '.mat']
     savename1=['matfiles/Arctic_LF_pdf_' sprintf('%4.4d',year) '_' sprintf('%2.2d',month) '.mat']
     save(savename1,'LF_pdf','LF_pdf_dim');
  end
  %tmp=tmp./6;
  %tmp=tmp./2; %for 2002
  %tmp=tmp./4; %for 2011
  %savename2=['matfiles/LF_' sprintf('%4.4d',year) '_annual.mat']
  %LF_annual=tmp;
  %save(savename2,'LF_annual');
end
