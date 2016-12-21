clear all

root_folder='/bcmhsm/milicak/RUNS/obs/LF_newTP_dataset/data_mat/'

month=1; %1 to 12
months2days=[31  28  31  30  31   30   31  31   30 31   30 31];
yeardays=sum(months2days);

monthnames=[{'Jan'} {'Feb'} {'Mar'} {'Apr'} {'May'} {'Jun'} {'Jul'} {'Aug'} {'Sep'} {'Oct'} {'Nov'} {'Dec'}]

years=2002:2011;
%years=2011;

for year=years   
  tmp=zeros(1792,1216);
  %for month=[1 2 3 4 11 12]
  %for month=[11 12] % for 2002
  %for month=[1 2 3 4] % for 2011
  if(year==2002)
    months=[11 12];
  elseif(year==2011)
    months=[1 2 3 4];
  else
    months=[1 2 3 4 11 12];
  end
  for month=months
     dnm=zeros(1792,1216);
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
       sdate=sprintf('%4.4d%2.2d%2.2d',year,month,days)
       filename=[root_folder 'LF_newTP_' sdate '.mat'];
       load(filename)    
       dnm=dnm+LF_corr;        
     end
     dnm=dnm./(months2days(month)-daystr+1);
     savename1=['matfiles/LF_' sprintf('%4.4d',year) '_' sprintf('%2.2d',month) '.mat']
     LF_month=dnm;
     save(savename1,'LF_month');
     tmp=tmp+dnm;
  end
  %tmp=tmp./6;
  %tmp=tmp./2; %for 2002
  tmp=tmp./4; %for 2011
  savename2=['matfiles/LF_' sprintf('%4.4d',year) '_annual.mat']
  LF_annual=tmp;
  save(savename2,'LF_annual');
end
