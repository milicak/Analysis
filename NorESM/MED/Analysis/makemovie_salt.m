clear all

lon=nc_varget('/home/fimm/bjerknes/milicak/Analysis/NorESM/Arctic/Analysis/grid.nc','plon');
lat=nc_varget('/home/fimm/bjerknes/milicak/Analysis/NorESM/Arctic/Analysis/grid.nc','plat');

project_name='NOIIA_T62_tn11_sr10m60d_01';
folder_name=['/hexagon/work/matsbn/archive/' project_name '/ocn/hist/']
%project_name='N1850AERCN_f19_tn11_002';
%folder_name=['/work/milicak/archive/' project_name '/ocn/hist/']
prefix=[folder_name project_name '.micom.hm.'];

datesep='-';
year_ini=1;
year_end=60;
nx=size(lon,2);
ny=size(lon,1);
sdate=sprintf('%4.4d%c%2.2d',year_ini,datesep,1);
depth=nc_varget([prefix sdate '.nc'],'depth');
nz=size(depth,1);
timeind=0;

for year=year_ini:year_end
for month=1:12
hhh=figure('Visible','off');
timeind=timeind+1;
sdate=sprintf('%4.4d%c%2.2d',year,datesep,month);
disp(sdate)
salt=nc_varget([prefix sdate '.nc'],'saln');       
h=nc_varget([prefix sdate '.nc'],'dz'); 
gcolor(squeeze(salt(:,273,55:110)),squeeze(h(:,273,55:110)),lon(273,55:110));
xlabel('lon')
ylabel('depth [m]')
needJet2
caxis([35 38.5])
no=num2str(timeind,'%.4d');
printname=['gifs/med_salt_vertical_section' no];
print(hhh,'-dpng','-zbuffer',printname)
end
end

