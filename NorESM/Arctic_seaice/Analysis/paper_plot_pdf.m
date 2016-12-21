clear all

year1=56:63;
year2=2003:2010;

fname1='matfiles/region1_LF_pdf_';
fname2='/fimm/home/bjerknes/milicak/Analysis/obs/Arctic_seaice/Analysis/matfiles/region1_LF_pdf_';
datesep='_';

for month=[1 2 3 4 11 12];

f1LF_pdf(1:10)=0;
f1LF_pdf_dim(1:10)=0;
f2LF_pdf(1:10)=0;
f2LF_pdf_dim(1:10)=0;


for ii=1:8
  sdate=sprintf('%4.4d%c%2.2d',year1(ii),datesep,month);
  filename1=[fname1 sdate '.mat']; 
  load(filename1);
  f1LF_pdf=f1LF_pdf+LF_pdf;
  f1LF_pdf_dim=f1LF_pdf_dim+LF_pdf_dim;

  sdate=sprintf('%4.4d%c%2.2d',year2(ii),datesep,month);
  filename2=[fname2 sdate '.mat']; 
  load(filename2);
nansum(LF_pdf(:))
  f2LF_pdf=f2LF_pdf+LF_pdf;
  f2LF_pdf_dim=f2LF_pdf_dim+LF_pdf_dim;
end

f1LF_pdf=f1LF_pdf./8;
f1LF_pdf_dim=f1LF_pdf_dim./8;
f2LF_pdf=f2LF_pdf./8;
f2LF_pdf_dim=f2LF_pdf_dim./8;


pdf_region=[f1LF_pdf; f2LF_pdf]';
pdf_region_dim=[f1LF_pdf_dim; f2LF_pdf_dim]';

sdate=sprintf('%c%2.2d',datesep,month);
savename1=['matfiles/decadalpdfsregion1' sdate '.mat']
save(savename1,'pdf_region','pdf_region_dim')
end % months
