clear all

%lon_section=-150; %-135 Pacific
lon_section=-20; %Atlantic

expid0='NOIIA_T62_tn11_sr10m60d_01';
expid1='NOIIA_T62_tn11_001';
expid2='NOIIA_T62_tn11_002';
expid3='NOIIA_T62_tn11_003';
expid4='NOIIA_T62_tn11_004';
expid5='NOIIA_T62_tn11_005';
expid6='NOIIA_T62_tn11_006';
expid7='NOIIA_T62_tn11_007';
year_ini=1;
year_end=100;

root_dir='/work/milicak/RUNS/noresm/CORE2/kepsilon/';

expfiles=[{expid0} {expid1} {expid2} {expid3} {expid5} {expid6} {expid7}];

for k=1:7
expid=char(expfiles(k))
filename=[root_dir expid '_diapycnaldiff_annual_' num2str(year_ini) '-' num2str(year_end) '.nc'];

lat=nc_varget(filename,'TLAT');
lon=nc_varget(filename,'TLON');
depth=nc_varget(filename,'depth');
difdia=nc_varget(filename,'difdia');

difdia_sect(size(difdia,1),size(difdia,2),size(difdia,3))=0;
for j=1:size(lon,1)
  ind=max(find(abs(lon(j,:)-lon_section)<=1.5));
  if(isempty(ind)==0)
    lat_section(j)=lat(j,ind);
    difdia_sect(:,:,j)=difdia(:,:,j,ind);
  else
%    ind=max(find(abs(lon(j,:)-lon_section)<=5)); %Pacific
    ind=max(find(abs(lon(j,:)-lon_section)<=15)); %Atlantic
    if(isempty(ind)==1)
      ind=91;
    end
    lat_section(j)=lat(j,ind);
    difdia_sect(:,:,j)=difdia(:,:,j,ind);
  end
end

dnm=squeeze(nanmean(difdia_sect,1));
pcolor(lat_section,-depth,dnm);shading interp;needJet2
caxis([-6 0])
xlabel('Lat');
ylabel('depth [m]')
xlim([-80 65])
%printname=['paperfigs/' expid '_Pacific_difdia.eps']
printname=['paperfigs/' expid '_Atlantic_difdia.eps']
print(printname,'-depsc2','-r150')

end

