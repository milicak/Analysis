clear all
rearth=6370;
int_method='conserve';

% Geomar-Orca Fram Strait
map_file='/bcmhsm/milicak/RUNS/noresm/CORE2/Arctic/DATA/maps/map_geomar_orca_to_section.nc';

filename_s='/work/milicak/RUNS/noresm/CORE2/Arctic/DATA/geomar/ORCA05_5yr_19480101_20071231_vosaline.nc';
filename_t='/work/milicak/RUNS/noresm/CORE2/Arctic/DATA/geomar/ORCA05_5yr_19480101_20071231_votemper.nc';
filename_s='/bcmhsm/milicak/RUNS/noresm/CORE2/Arctic/DATA/geomar/ORCA05_5yr_19480101_20071231_vosaline.nc';
filename_t='/bcmhsm/milicak/RUNS/noresm/CORE2/Arctic/DATA/geomar/ORCA05_5yr_19480101_20071231_votemper.nc';
%salt=ncgetvar(filename_s,'vosaline');
temp=ncgetvar(filename_t,'votemper');
temp(temp==0)=NaN;
%salt(salt==0)=NaN;
lon=ncgetvar(filename_t,'nav_lon');
lat=ncgetvar(filename_t,'nav_lat');
zt=ncgetvar(filename_t,'deptht');
lon=lon(2:end-1,1:end-1);
lat=lat(2:end-1,1:end-1);

%tmp=squeeze(temp(2:end-1,1:end-1,:,49:end)); %last cycle 
tmp=squeeze(temp(2:end-1,1:end-1,:,55:end)); 
temp=squeeze(nanmean(tmp,4));
%tmp=squeeze(salt(2:end-1,1:end-1,:,49:end)); %last cycle 
%salt=squeeze(nanmean(tmp,4));
clear tmp


section=map_scalar2section(temp,map_file,int_method);
section(2).name='Arctic 70E';

for i_sec=1:5 %length(section)
  figure(i_sec);clf
  pcolor([0 section(i_sec).edge_dist]*rearth,-zt, ...
         [section(i_sec).data;section(i_sec).data(end,:)]');
  shading flat;colorbar
  title([ 'Kiel-ORCA05 ' section(i_sec).name])
  xlabel('Distance (km)')
  ylabel('Depth (m)')
  if(i_sec==1)
     ylim([-4000 0]);
     caxis([-1.5 3.5])
     printname=['paperfigs/geomar_orca_fram_strait_section'];
  elseif(i_sec==2)
     ylim([-4500 0]);
     caxis([-1.5 1.5])
     title('Kiel-ORCA05')
     colorbar off
     fontsize=18;
     set(findall(gcf,'type','text'),'FontSize',fontsize)
     set(gca,'fontsize',fontsize)
     set(gcf,'color','w');
     %printname=['paperfigs/geomar_orca_Arctic70E_section'];
     printname=['paperfigs2/geomar_orca_Arctic70E_section'];
  elseif(i_sec==3)
     ylim([-4000 0]);
     caxis([-1.5 3.5])
     printname=['paperfigs/geomar_orca_fram_strait_79_5N_section'];
  elseif(i_sec==4)
     ylim([-4500 0]);
     caxis([-1.5 7])
     interpcolormap([[0 0 .1];[0 0 1];[0 1 1];[0 1 0];[1 1 0];[1 0 1];[1 0 0];[1 .9 .8]],[1 1 1 1 1.3 .7 1.3],'l');
     title('Kiel-ORCA05')
     colorbar off
     fontsize=18;
     set(findall(gcf,'type','text'),'FontSize',fontsize)
     set(gca,'fontsize',fontsize)
     set(gcf,'color','w');
     %printname=['paperfigs/geomar_orca_Atlantic_inflow_section'];
     printname=['paperfigs2/geomar_orca_Atlantic_inflow_section'];
  elseif(i_sec==5)
     ylim([-650 0]);
     caxis([2 7])
     printname=['paperfigs/geomar_orca_Barents_Sea_section'];
  end
  print(i_sec,'-depsc2','-r150',printname)
  if(i_sec==2 | i_sec==4)
   export_fig(i_sec,printname,'-eps','-r150');  
  end
%  close all
end

