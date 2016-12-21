clear all

pathname='/fimm/work/milicak/mnt/';
modelname='NorESM1-M'
project_name='rcp85'
version='r1i1p1'

Nz=53; %number of layers
Cp=3985; %specific heat ratio
rho0=1027; %

area=nc_varget('grid_NorESM_bipolargrid.nc','parea');
lon=nc_varget('grid_NorESM_bipolargrid.nc','plon');
lat=nc_varget('grid_NorESM_bipolargrid.nc','plat');
mask=nc_varget('grid_NorESM_bipolargrid.nc','pmask');
[BSO CAA DS EC IFS FS BS]=sections_noresm_bipolar;

ind=1;
for i=1:size(BS,1)
x(ind)=lon(BS(i,2),BS(i,1));
y(ind)=lat(BS(i,2),BS(i,1));
ind=ind+1;
end

%additional
for i=1:1
x(ind)=206.78;
y(ind)=65.88;
ind=ind+1;
end
for i=1:1
x(ind)=-130.22;
y(ind)=67.95;
ind=ind+1;
end

for i=1:size(CAA,1)
x(ind)=lon(CAA(i,2),CAA(i,1));
y(ind)=lat(CAA(i,2),CAA(i,1));
ind=ind+1;
end
for i=1:size(DS,1)
x(ind)=lon(DS(i,2),DS(i,1));
y(ind)=lat(DS(i,2),DS(i,1));
ind=ind+1;
end
for i=1:size(IFS,1)
x(ind)=lon(IFS(i,2),IFS(i,1));
y(ind)=lat(IFS(i,2),IFS(i,1));
ind=ind+1;
end
for i=1:size(EC,1)
x(ind)=lon(EC(i,2),EC(i,1));
y(ind)=lat(EC(i,2),EC(i,1));
ind=ind+1;
end
cc=[6.4470
   19.0000
   39.7175
   71.4761
  111.8209
  161.1170];
dd=[49.1599
   49.9903
   54.2725
   60.9304
   66.1467
   66.2224];
x(end+1:end+6)=cc;
y(end+1:end+6)=dd;
y(end+1)=y(1);
x(end+1)=x(1);
in=insphpoly(lon,lat,x,y,0,90);
in=double(in);
in(in==0)=NaN;

pathnamehf=[pathname 'output1/NCC/' modelname '/' project_name '/mon/ocean/Omon/' version '/latest/hfds'];

yearsini=2006;
yearsend=2100;
sdate=sprintf('%4.4d%2.2d%c%4.4d%2.2d',yearsini,1,'-',yearsend,12);
%netcdf files
filenamehf=[pathnamehf '/hfds_Omon_' modelname '_' project_name '_' version '_'  sdate '.nc'];

timeind=1;
for time=1:1140 
     hfs=nc_varget(filenamehf,'hfds',[time-1 0 0],[1 -1 -1]);
     dnm=hfs.*in.*area./(Cp*rho0); %C*m3/s
     Qf(timeind)=nansum(dnm(:)).*1e-6; %Sv*C

     dnm=hfs.*in.*area; %Watt
     QTW(timeind)=nansum(dnm(:)).*1e-12; %TW
     

     savename=['matfiles/' modelname '_' project_name '_' version '_' num2str(yearsini(1)) '_' num2str(yearsend(end)) '_heatflux'];
     save(savename,'Qf','QTW')

     timeind=timeind+1
end %time


