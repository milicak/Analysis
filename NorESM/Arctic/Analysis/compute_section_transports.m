clear all

warning off

lon=nc_varget('/home/uni/milicak/Analysis/NorESM/Arctic/Analysis/grid.nc','plon');
lat=nc_varget('/home/uni/milicak/Analysis/NorESM/Arctic/Analysis/grid.nc','plat');

%project_name='NOIIA_T62_tn11_sr10m60d_01';
%folder_name=['/work/matsbn/archive/' project_name '/ocn/hist/']
%project_name='NOIIA_T62_tn11_001';
project_name='NOINY_T62_tn11_001';
%project_name='N1850AERCN_f19_tn11_001';
folder_name=['/work/milicak/archive/' project_name '/ocn/hist/']
prefix=[folder_name project_name '.micom.hm.'];

datesep='-';
year_ini=1;
year_end=95;
Nz=70;
nx=size(lon,2);
ny=size(lon,1);
sdate=sprintf('%4.4d%c%2.2d',year_ini,datesep,1);
depth=nc_varget([prefix sdate '.nc'],'depth');
nz=size(depth,1);
timeind=0;

%Denmark Strait i-indices
a=[78;79;80;81;82;83;84;85;86;86];
%Denmark Strait j-indices
b=[323;323;323;323;323;323;323;323;322;322];

%Faroe-Scotland
a_FS=[104 104 104 105 105 105];
b_FS=[313 312 311 310 309 309];
uv_FS=[0 0 1 0 0 0];

%Iceland-Faroe
a_IF=[97   98  99 100 101 102];
b_IF=[319 319 318 317 316 315];
uv_IF=[1   0    1  1   1   1];

ind=1;

for years=year_ini:year_end
no = num2str(years,'%.4d');
for months=1:12
no2 = num2str(months,'%.2d');

%filename=['N1850AERCN_f19_tn11_011.micom.hm.' no '-' no2 '.nc'];
%filename=['NOIIA_T62_tn11_001.micom.hm.' no '-' no2 '.nc'];
filename=[folder_name project_name '.micom.hm.' no '-' no2 '.nc'];

%h=nc_varget(filename,'dz');
templvl=nc_varget(filename,'templvl');
salnlvl=nc_varget(filename,'salnlvl');
uflxlvl=nc_varget(filename,'uflxlvl');
vflxlvl=nc_varget(filename,'vflxlvl');
zlvl=nc_varget(filename,'depth');

% Denmark Strait Overflow sigma_theta>27.85
for k=1:length(a)
temp_denmark(:,k)=squeeze(templvl(:,b(k),a(k)));
salt_denmark(:,k)=squeeze(salnlvl(:,b(k),a(k)));
vflx_denmark(:,k)=squeeze(vflxlvl(:,b(k),a(k)))*1e-9;
end
pres_denmark=sw_pres(zlvl,65);
dens_denmark_overflow=sw_pden(salt_denmark,temp_denmark,pres_denmark,0)-1e3;
dens_denmark_overflow(dens_denmark_overflow<27.85)=NaN;
vflx_denmark(isnan(dens_denmark_overflow)==1)=NaN;
tr_denmark_overflow(ind)=nansum(vflx_denmark(:));


% Faroe-Scotland Overflow sigma_theta>27.85
for k=1:length(a_FS)
temp_FS(:,k)=squeeze(templvl(:,b_FS(k),a_FS(k)));
salt_FS(:,k)=squeeze(salnlvl(:,b_FS(k),a_FS(k)));
vflx_FS(:,k)=squeeze(vflxlvl(:,b_FS(k),a_FS(k)))*1e-9;
uflx_FS(:,k)=squeeze(uflxlvl(:,b_FS(k),a_FS(k)))*1e-9;
end
dens_FS_overflow=sw_pden(salt_FS,temp_FS,pres_denmark,0)-1e3;
dens_FS_overflow(dens_FS_overflow<28.05)=NaN;
tr_FS_overflow=0;
for k=1:length(a_FS)
if(uv_FS(k)==0)
for kk=1:Nz
if(isnan(dens_FS_overflow(kk,k))==0)
dnm=nansum(uflx_FS(kk,k));
if(isnan(dnm)==0)
tr_FS_overflow=tr_FS_overflow+dnm;
end
end
end %kk
else %uv_FS
for kk=1:Nz
if(isnan(dens_FS_overflow(kk,k))==0)
dnm1=nansum(uflx_FS(kk,k));
dnm2=nansum(vflx_FS(kk,k));
if(isnan(dnm1)==0)
if(isnan(dnm2)==0)
dnm=dnm1+dnm2;
else
dnm=dnm1;
end
else
if(isnan(dnm2)==0)
dnm=dnm2;
else
dnm=0;
end
end
if(isnan(dnm)==0)
tr_FS_overflow=tr_FS_overflow+dnm;
end
end
end %kk
end
end
tr_faroe_scotland_overflow(ind)=nansum(tr_FS_overflow(:));

% Iceland-Faroe Overflow sigma_theta>27.85
for k=1:length(a_IF)
temp_IF(:,k)=squeeze(templvl(:,b_IF(k),a_IF(k)));
salt_IF(:,k)=squeeze(salnlvl(:,b_IF(k),a_IF(k)));
vflx_IF(:,k)=squeeze(vflxlvl(:,b_IF(k),a_IF(k)))*1e-9;
uflx_IF(:,k)=squeeze(uflxlvl(:,b_IF(k),a_IF(k)))*1e-9;
end
dens_IF_overflow=sw_pden(salt_IF,temp_IF,pres_denmark,0)-1e3;
dens_IF_overflow(dens_IF_overflow<27.85)=NaN;
tr_IF_overflow=0;
for k=1:length(a_IF)
if(uv_IF(k)==0)
for kk=1:Nz
if(isnan(dens_IF_overflow(kk,k))==0)
dnm=nansum(vflx_IF(kk,k));
if(isnan(dnm)==0)
tr_IF_overflow=tr_IF_overflow+dnm;
end
end
end %kk
else %uv_IF
for kk=1:Nz
if(isnan(dens_IF_overflow(kk,k))==0)
dnm1=nansum(uflx_IF(kk,k));
dnm2=nansum(vflx_IF(kk,k));
if(isnan(dnm1)==0)
if(isnan(dnm2)==0)
dnm=dnm1+dnm2;
else
dnm=dnm1;
end
else
if(isnan(dnm2)==0)
dnm=dnm2;
else
dnm=0;
end
end
if(isnan(dnm)==0)
tr_IF_overflow=tr_IF_overflow+dnm;
end
end
end %kk
end
end
tr_iceland_faroe_overflow(ind)=nansum(tr_IF_overflow(:));
savename=['matfiles/' project_name '_nordic_overflows.mat'];
save(savename,'tr_iceland_faroe_overflow','tr_faroe_scotland_overflow','tr_denmark_overflow')

ind=ind+1
end %months
end %years
