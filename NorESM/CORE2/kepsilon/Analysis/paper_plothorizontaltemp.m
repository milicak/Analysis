clear all

depth_section=2000; %

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

woaname='/bcmhsm/milicak/RUNS/noresm/CORE2/kepsilon/t00an1.nc';
lonwoa=nc_varget(woaname,'lon');
latwoa=nc_varget(woaname,'lat');
depthwoa=nc_varget(woaname,'depth');
tempwoa=nc_varget(woaname,'t');
ind=max(find(depthwoa<=depth_section));
m_proj('Equidistant Cylindrical','lon',[-180 180],'lat',[-90 90]);
m_pcolor([lonwoa(181:end)-360;lonwoa(1:180)],latwoa,[squeeze(tempwoa(ind,:,181:360)) squeeze(tempwoa(ind,:,1:180))]);shading interp;
needJet2
if(depth_section==2000)
caxis([-2 12])
elseif(depth_section==1100)
caxis([-2 14])
end
xlabel('Lon');
ylabel('Lat');
m_grid
printname=['paperfigs/WOA_temperature_at_' num2str(depth_section) '.eps']
print(printname,'-depsc2','-r150')
close

for k=1:7
expid=char(expfiles(k))
filename=[root_dir expid '_temperature_annual_' num2str(year_ini) '-' num2str(year_end) '.nc'];

lat=nc_varget(filename,'TLAT');
lon=nc_varget(filename,'TLON');
depth=nc_varget(filename,'depth');
temp=nc_varget(filename,'temp');

ind=max(find(depth<=depth_section));
dnm=squeeze(nanmean(temp,1));

%mask=squeeze(dnm(1,:,:));
%mask(:,:)=1;
%mask(isnan(squeeze(dnm(1,:,:)))==0)=NaN;
micom_flat(squeeze(dnm(ind,:,:))');
needJet2
if(depth_section==2000)
caxis([-2 12])
elseif(depth_section==1100)
caxis([-2 14])
end
xlabel('Lon');
ylabel('Lat');
m_grid
printname=['paperfigs/' expid '_temperature_at_' num2str(depth_section) '.eps']
print(printname,'-depsc2','-r150')
close

end

