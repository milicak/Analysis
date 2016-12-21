clear all

expid='NOIIA_T62_tn11_005';
%expid='NOIIA_T62_tn11_sr10m60d_01'
expid2='NOIIA_T62_tn11_sr10m60d_01'
year_ini=1;
year_end=100;

%root_dir='/work/milicak/RUNS/noresm/CORE2/kepsilon/';
root_dir='/bcmhsm/milicak/RUNS/noresm/CORE2/kepsilon/';
filename=[root_dir expid '_pacific_zonalmean_timemean_' num2str(year_ini) '-' num2str(year_end) '.nc'];
filename2=[root_dir expid2 '_pacific_zonalmean_timemean_' num2str(year_ini) '-' num2str(year_end) '.nc'];

lat=nc_varget(filename,'lat');
depth=nc_varget(filename,'depth');

tdiff=nc_varget(filename,'tdiff');
temp=nc_varget(filename,'temp');
temp2=nc_varget(filename2,'temp');
twoa=nc_varget(filename,'twoa');

pcolor(lat,-depth,temp-temp2);shading interp;needJet2
caxis([-0.4 0.4])
colormap(bluewhitered(32))
xlabel('Lat');
ylabel('depth [m]')
xlim([-60 70])
printname=['paperfigs/' expid '_Pacific_tdiff_from_cntrl.eps']
print(printname,'-depsc2','-r150')
close

pcolor(lat,-depth,tdiff);shading interp;needJet2
caxis([-2 2])
xlabel('Lat');
ylabel('depth [m]')
xlim([-60 70])
colormap(bluewhitered(64))
printname=['paperfigs/' expid '_Pacific_tdiff.eps']
print(printname,'-depsc2','-r150')
close

pcolor(lat,-depth,twoa);shading interp;needJet2
caxis([-2 27])
xlabel('Lat');
ylabel('depth [m]')
xlim([-60 70])
printname=['paperfigs/' expid '_Pacific_twoa.eps']
print(printname,'-depsc2','-r150')
close

pcolor(lat,-depth,temp);shading interp;needJet2
caxis([-2 27])
xlabel('Lat');
xlim([-60 70])
ylabel('depth [m]')
printname=['paperfigs/' expid '_Pacific_temp.eps']
print(printname,'-depsc2','-r150')
close


