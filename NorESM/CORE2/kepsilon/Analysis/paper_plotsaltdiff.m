clear all

expid='NOIIA_T62_tn11_003';
%expid='NOIIA_T62_tn11_sr10m60d_01'
year_ini=1;
year_end=100;

root_dir='/work/milicak/RUNS/noresm/CORE2/kepsilon/';
filename=[root_dir expid '_atlantic_zonalmean_timemean_' num2str(year_ini) '-' num2str(year_end) '.nc'];

lat=nc_varget(filename,'lat');
depth=nc_varget(filename,'depth');

sdiff=nc_varget(filename,'sdiff');
salt=nc_varget(filename,'salt');
swoa=nc_varget(filename,'swoa');

pcolor(lat,-depth,sdiff);shading interp;needJet2
caxis([-.4 0.4])
xlabel('Lat');
ylabel('depth [m]')
printname=['paperfigs/' expid '_Atlantic_sdiff.eps']
print(printname,'-depsc2','-r150')

pcolor(lat,-depth,swoa);shading interp;needJet2
caxis([33 37])
xlabel('Lat');
ylabel('depth [m]')
printname=['paperfigs/' expid '_Atlantic_swoa.eps']
print(printname,'-depsc2','-r150')

pcolor(lat,-depth,salt);shading interp;needJet2
caxis([33 37])
xlabel('Lat');
ylabel('depth [m]')
printname=['paperfigs/' expid '_Atlantic_salt.eps']
print(printname,'-depsc2','-r150')



