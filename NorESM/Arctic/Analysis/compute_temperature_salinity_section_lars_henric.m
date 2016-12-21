clear all

pathname='/fimm/work/milicak/mnt/';
modelname='NorESM1-M'
project_name='historical'
version='r2i1p1'

K2C=273.15;
pathnameu=[pathname 'output2/NCC/' modelname '/' project_name '/mon/ocean/Omon/' version '/latest/umo'];
pathnamev=[pathname 'output2/NCC/' modelname '/' project_name '/mon/ocean/Omon/' version '/latest/vmo'];
pathnamet=[pathname 'output1/NCC/' modelname '/' project_name '/mon/ocean/Omon/' version '/latest/thetao'];
pathnames=[pathname 'output1/NCC/' modelname '/' project_name '/mon/ocean/Omon/' version '/latest/so'];


yearsini=1990:4:2002;
yearsend=1993:4:2005;

timeind=1;
temp=zeros(70,384,320);
salt=zeros(70,384,320);
k=0;
for time=1:length(yearsini)
   sdate=sprintf('%4.4d%2.2d%c%4.4d%2.2d',yearsini(time),1,'-',yearsend(time),12);
   %netcdf files
   filenamet=[pathnamet '/thetao_Omon_' modelname '_' project_name '_' version '_'  sdate '.nc'];
   filenames=[pathnames '/so_Omon_' modelname '_' project_name '_' version '_'  sdate '.nc'];
   for month=1:48
     temp=temp+nc_varget(filenamet,'thetao',[month-1 0 0 0],[1 -1 -1 -1])-K2C;
     salt=salt+nc_varget(filenames,'so',[month-1 0 0 0],[1 -1 -1 -1]);
     k=k+1
   end
end

temp=temp./k;
salt=salt./k;
zt=nc_varget(filenames,'lev');
temp=permute(temp,[3 2 1]);
salt=permute(salt,[3 2 1]);

save NorESM_historical_1990_2004_temp_salt_mean temp salt zt

rearth=6370;
int_method='conserve';
map_file='/bcmhsm/milicak/RUNS/noresm/CORE2/Arctic/DATA/maps/map_noresm_gx1v6_to_section.nc';

section=map_scalar2section(temp,map_file,int_method);
section2=map_scalar2section(salt,map_file,int_method);

for i_sec=1:2
  figure(i_sec);clf
  pcolor([0 section(i_sec).edge_dist]*rearth,-zt, ...
         [section(i_sec).data;section(i_sec).data(end,:)]');
  shading flat;colorbar
  title([ 'NorESM ' section(i_sec).name])
  xlabel('Distance (km)')
  ylabel('Depth (m)')
  if(i_sec==1)
     ylim([-4000 0]);
     needJet2
     %caxis([-1.5 3.5])
     printname=['paperfigs/noresm_31E_section'];
  elseif(i_sec==2)
     ylim([-4000 0]);
     %caxis([-1.5 1.5])
     printname=['paperfigs/noresm_Atlantic_section'];
  end
  print(i_sec,'-depsc2','-r150',printname)
end




