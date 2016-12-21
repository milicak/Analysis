clear all

pathname='/fimm/work/milicak/mnt2/';
modelname='NorESM1-M'
%project_name='NRCP85AERCN_f19_g16_01'
project_name='NAER1850CNOC_f19_g16_06'
pathnameurho=[pathname project_name '/ocn/hist/'];
yearsini=700; %2006;
yearsend=1200; %2100;

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
in=in.*mask;
in(in==0)=NaN;

break
timeind=1;
for time=yearsini:yearsend
   for month=1:12
     sdate=sprintf('%4.4d%c%2.2d',time,'-',month);
     filenamehf=[pathnameurho project_name '.micom.hm.' sdate '.nc'];
%netcdf files
     hfs=nc_varget(filenamehf,'hflx',[0 0 0],[1 -1 -1]);
     dnm=hfs.*in.*area./(Cp*rho0); %C*m3/s
     Qf(timeind)=nansum(dnm(:)).*1e-6; %Sv*C

     dnm=hfs.*in.*area; %Watt
     QTW(timeind)=nansum(dnm(:)).*1e-12; %TW
     

     savename=['matfiles/' modelname '_' project_name '_'  num2str(yearsini) '_' num2str(yearsend) '_heatflux'];
     save(savename,'Qf','QTW')

     timeind=timeind+1
   end %month
end %time


