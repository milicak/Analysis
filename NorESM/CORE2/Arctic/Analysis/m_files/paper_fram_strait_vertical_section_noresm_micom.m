clear all
rearth=6370;
int_method='conserve';

% NorESM Fram Strait
map_file='/bcmhsm/milicak/RUNS/noresm/CORE2/Arctic/DATA/maps/map_noresm_tnx1v1_to_section.nc';
%filename_s='/work/milicak/RUNS/noresm/CORE2/Arctic/DATA/NorESM/NOIIA_T62_tn11_sr10m60d_01_salinity_pendatal_1-300.nc';
%filename_t='/work/milicak/RUNS/noresm/CORE2/Arctic/DATA/NorESM/NOIIA_T62_tn11_sr10m60d_01_temperature_pendatal_1-300.nc';
filename_s='/bcmhsm/milicak/RUNS/noresm/CORE2/Arctic/DATA/NorESM/NOIIA_T62_tn11_sr10m60d_01_salinity_pendatal_1-300.nc';
filename_t='/bcmhsm/milicak/RUNS/noresm/CORE2/Arctic/DATA/NorESM/NOIIA_T62_tn11_sr10m60d_01_temperature_pendatal_1-300.nc';
%salt=ncgetvar(filename_s,'saln');
temp=ncgetvar(filename_t,'temp');
%lon=ncgetvar(filename_t,'TLON');
%lat=ncgetvar(filename_t,'TLAT');
zt=ncgetvar(filename_t,'depth'); %convert cm to meter

%tmp=squeeze(temp(:,:,:,49:end)); %last cycle 
tmp=squeeze(temp(:,:,:,55:end)); %last cycle 
temp=squeeze(nanmean(tmp,4));
%tmp=squeeze(salt(:,:,:,49:end)); %last cycle 
%salt=squeeze(nanmean(tmp,4));
clear tmp

section=map_scalar2section(temp,map_file,int_method);
section(2).name='Arctic 70E';

for i_sec=1:5 %length(section)
  figure(i_sec);clf
  pcolor([0 section(i_sec).edge_dist]*rearth,-zt, ...
         [section(i_sec).data;section(i_sec).data(end,:)]');
  shading flat;colorbar
  title([ 'BERGEN ' section(i_sec).name])
  xlabel('Distance (km)')
  ylabel('Depth (m)')
  if(i_sec==1)
     ylim([-4000 0]);
     caxis([-1.5 3.5])
     printname=['paperfigs/noresm_micom_fram_strait_section'];
  elseif(i_sec==2)
     ylim([-4500 0]);
     caxis([-1.5 1.5])
     title('Bergen')
     colorbar off
     fontsize=18;
     set(findall(gcf,'type','text'),'FontSize',fontsize)
     set(gca,'fontsize',fontsize)
     set(gcf,'color','w');
     %printname=['paperfigs/noresm_micom_Arctic70E_section'];
     printname=['paperfigs2/noresm_micom_Arctic70E_section'];
  elseif(i_sec==3)
     ylim([-4000 0]);
     caxis([-1.5 3.5])
     printname=['paperfigs/noresm_micom_fram_strait_79_5N_section'];
  elseif(i_sec==4)
     ylim([-4500 0]);
     caxis([-1.5 7])
     interpcolormap([[0 0 .1];[0 0 1];[0 1 1];[0 1 0];[1 1 0];[1 0 1];[1 0 0];[1 .9 .8]],[1 1 1 1 1.3 .7 1.3],'l');
     title('Bergen')
     colorbar off
     fontsize=18;
     set(findall(gcf,'type','text'),'FontSize',fontsize)
     set(gca,'fontsize',fontsize)
     set(gcf,'color','w');
     %printname=['paperfigs/noresm_micom_Atlantic_inflow_section'];
     printname=['paperfigs2/noresm_micom_Atlantic_inflow_section'];
  elseif(i_sec==5)
     ylim([-650 0]);
     caxis([2 7])
     printname=['paperfigs/noresm_micom_Barents_Sea_section'];
  end
  print(i_sec,'-depsc2','-r150',printname)
  if(i_sec==2 | i_sec==4)
   export_fig(i_sec,printname,'-eps','-r150');  
  end
%  close all
end
close all
