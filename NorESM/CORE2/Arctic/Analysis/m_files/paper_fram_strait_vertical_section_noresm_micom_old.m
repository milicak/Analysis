% computes vertical section of Fram Strait
clear all

filename_s='/work/milicak/RUNS/noresm/CORE2/Arctic/DATA/NorESM/NOIIA_T62_tn11_sr10m60d_01_salinity_pendatal_1-300.nc';
filename_t='/work/milicak/RUNS/noresm/CORE2/Arctic/DATA/NorESM/NOIIA_T62_tn11_sr10m60d_01_temperature_pendatal_1-300.nc';
salt=ncgetvar(filename_s,'saln');
temp=ncgetvar(filename_t,'temp');
lon=ncgetvar(filename_t,'TLON');
lat=ncgetvar(filename_t,'TLAT');
zt=ncgetvar(filename_t,'depth'); %convert cm to meter
%gridfile='/work/milicak/RUNS/noresm/CORE2/Arctic/DATA/NorESM/grid_NORESM.nc';
%area=ncgetvar(gridfile,'parea');

tmp=squeeze(temp(:,:,:,49:end)); %last cycle 
temp=squeeze(nanmean(tmp,4));

tmp=squeeze(salt(:,:,:,49:end)); %last cycle 
salt=squeeze(nanmean(tmp,4));
clear tmp

lon_fram=[-11.5 13];
lat_fram=[81.3 79.6];
Nsection=15;
[s,a1,a2]=m_idist(lon_fram(1),lat_fram(1),lon_fram(2),lat_fram(2));
dist=0:s/Nsection:s;
[lon2,lat2,a2new]=m_fdist(lon_fram(1),lat_fram(1),a1,dist);
lon2(lon2>=180)=lon2(lon2>=180)-360;

for k=1:size(temp,3)
tempframlinear(:,k)=griddata(lon,lat,squeeze(temp(:,:,k)),lon2,lat2,'linear');
tempframnearest(:,k)=griddata(lon,lat,squeeze(temp(:,:,k)),lon2,lat2,'nearest');
end

figure(1)
pcolor(dist'./1e3,-zt,tempframlinear');shading flat;colorbar
ylim([-3250 0])
xlabel('Diistance [km]'); ylabel('Depth [m]');
caxis([-1.75 0.5])
printname=['paperfigs/noresm_micom_temp_vertical_fram_section'];
print(1,'-depsc2','-r150',printname)
close all



