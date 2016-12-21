clear all
rearth=6370;
int_method='conserve';

% MRI Fram Strait
map_file='/bcmhsm/milicak/RUNS/noresm/CORE2/Arctic/DATA/maps/map_mri_data_to_section.nc';
filename_s='/work/milicak/RUNS/noresm/CORE2/Arctic/DATA/mir-data/salinity_pentadal.nc';
filename_t='/work/milicak/RUNS/noresm/CORE2/Arctic/DATA/mir-data/temperature_pentadal.nc';
gridfile='/work/milicak/RUNS/noresm/CORE2/Arctic/DATA/mir-data/lonlat_t.nc';
filename_s='/bcmhsm/milicak/RUNS/noresm/CORE2/Arctic/DATA/mir-data/salinity_pentadal.nc';
filename_t='/bcmhsm/milicak/RUNS/noresm/CORE2/Arctic/DATA/mir-data/temperature_pentadal.nc';
gridfile='/bcmhsm/milicak/RUNS/noresm/CORE2/Arctic/DATA/mir-data/lonlat_t.nc';
%salt=ncgetvar(filename_s,'s');
temp=ncgetvar(filename_t,'temp');
lon=ncgetvar(gridfile,'glon_t');
lat=ncgetvar(gridfile,'glat_t');
zt=ncgetvar(filename_t,'level');
lon=lon(3:end-2,1:end-2);
lat=lat(3:end-2,1:end-2);

%tmp=squeeze(temp(3:end-2,1:end-2,:,1:end)); %last cycle 
tmp=squeeze(temp(3:end-2,1:end-2,:,7:end));
temp=squeeze(nanmean(tmp,4));
%tmp=squeeze(salt(3:end-2,1:end-2,:,1:end)); %last cycle 
%salt=squeeze(nanmean(tmp,4));
clear tmp
temp(temp<-100)=NaN;
%salt(salt<-100)=NaN;

section=map_scalar2section(temp,map_file,int_method);
section(2).name='Arctic 70E';

for i_sec=1:5 %length(section)
  figure(i_sec);clf
  pcolor([0 section(i_sec).edge_dist]*rearth,-zt, ...
         [section(i_sec).data;section(i_sec).data(end,:)]');
  shading flat;colorbar
  title([ 'MRI-A ' section(i_sec).name])
  xlabel('Distance (km)')
  ylabel('Depth (m)')
  if(i_sec==1)
     ylim([-4000 0]);
     caxis([-1.5 3.5])
     printname=['paperfigs/mir_data_fram_strait_section'];
  elseif(i_sec==2)
     ylim([-4500 0]);
     caxis([-1.5 1.5])
     title('MRI-A')
     colorbar off
     fontsize=18;
     set(findall(gcf,'type','text'),'FontSize',fontsize)
     set(gca,'fontsize',fontsize)
     set(gcf,'color','w');
     %printname=['paperfigs/mir_data_Arctic70E_section'];
     printname=['paperfigs2/mri_data_Arctic70E_section'];
  elseif(i_sec==3)
     ylim([-4000 0]);
     caxis([-1.5 3.5])
     printname=['paperfigs/mir_data_fram_strait_79_5N_section'];
  elseif(i_sec==4)
     ylim([-4500 0]);
     caxis([-1.5 7])
     interpcolormap([[0 0 .1];[0 0 1];[0 1 1];[0 1 0];[1 1 0];[1 0 1];[1 0 0];[1 .9 .8]],[1 1 1 1 1.3 .7 1.3],'l');
     title('MRI-A')
     colorbar off
     fontsize=18;
     set(findall(gcf,'type','text'),'FontSize',fontsize)
     set(gca,'fontsize',fontsize)
     set(gcf,'color','w');
     %printname=['paperfigs/mir_data_Atlantic_inflow_section'];
     printname=['paperfigs2/mri_data_Atlantic_inflow_section'];
  elseif(i_sec==5)
     ylim([-650 0]);
     caxis([2 7])
     printname=['paperfigs/mir_data_Barents_Sea_section'];
  end
  print(i_sec,'-depsc2','-r150',printname)
  if(i_sec==2 | i_sec==4)
   export_fig(i_sec,printname,'-eps','-r150');  
  end
end
  close all

