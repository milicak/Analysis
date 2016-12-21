clear all

expid='NOIIA_T62_tn11_003';
%expid='NOIIA_T62_tn11_sr10m60d_01'
year_ini=1;
year_end=100;

root_dir='/work/milicak/RUNS/noresm/CORE2/kepsilon/';
filename=[root_dir expid '_atlantic_zonalmean_timemean_' num2str(year_ini) '-' num2str(year_end) '.nc'];

lat=nc_varget(filename,'lat');
depth=nc_varget(filename,'depth');

tdiff=nc_varget(filename,'tdiff');
temp=nc_varget(filename,'temp');
twoa=nc_varget(filename,'twoa');

pcolor(lat,-depth,tdiff);shading interp;needJet2
caxis([-.4 0.4])
xlabel('Lat');
ylabel('depth [m]')
printname=['paperfigs/' expid '_Atlantic_tdiff.eps']
print(printname,'-depsc2','-r150')

pcolor(lat,-depth,twoa);shading interp;needJet2
caxis([33 37])
xlabel('Lat');
ylabel('depth [m]')
printname=['paperfigs/' expid '_Atlantic_twoa.eps']
print(printname,'-depsc2','-r150')

pcolor(lat,-depth,temp);shading interp;needJet2
caxis([33 37])
xlabel('Lat');
ylabel('depth [m]')
printname=['paperfigs/' expid '_Atlantic_temp.eps']
print(printname,'-depsc2','-r150')



