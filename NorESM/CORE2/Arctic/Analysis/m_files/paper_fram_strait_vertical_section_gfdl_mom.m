clear all
rearth=6370;
int_method='conserve';

% MOM Fram Strait
map_file='/bcmhsm/milicak/RUNS/noresm/CORE2/Arctic/DATA/maps/map_gfdl_mom_to_section.nc';
filename_s='/work/milicak/RUNS/noresm/CORE2/Arctic/DATA/gfdl-mom/annual_tracers/ocean.1708-2007.salt.nc';
filename_s='/work/milicak/RUNS/noresm/CORE2/Arctic/DATA/gfdl-mom/annual_tracers/ocean.1708-2007.salt.nc';
filename_t='/bcmhsm/milicak/RUNS/noresm/CORE2/Arctic/DATA/gfdl-mom/annual_tracers/ocean.1708-2007.temp.nc';
filename_t='/bcmhsm/milicak/RUNS/noresm/CORE2/Arctic/DATA/gfdl-mom/annual_tracers/ocean.1708-2007.temp.nc';
%salt=ncgetvar(filename_s,'salt');
temp=ncgetvar(filename_t,'temp');
zt=ncgetvar(filename_t,'st_ocean');
%temp(temp<-100)=NaN;
%salt(salt<-100)=NaN;

%tmp=squeeze(temp(:,:,:,241:end)); %last cycle 
tmp=squeeze(temp(:,:,:,271:end));
temp=squeeze(nanmean(tmp,4));
%tmp=squeeze(salt(:,:,:,241:end)); %last cycle 
%salt=squeeze(nanmean(tmp,4));
clear tmp

section=map_scalar2section(temp,map_file,int_method);
section(2).name='Arctic 70E';

for i_sec=1:5 %length(section)
  figure(i_sec);clf
  pcolor([0 section(i_sec).edge_dist]*rearth,-zt, ...
         [section(i_sec).data;section(i_sec).data(end,:)]');
  shading flat;colorbar
  title([ 'GFDL-MOM ' section(i_sec).name])
  xlabel('Distance (km)')
  ylabel('Depth (m)')
  if(i_sec==1)
     ylim([-3000 0]);
     caxis([-1.5 3.5])
     printname=['paperfigs/gfdl_mom_fram_strait_section'];
  elseif(i_sec==2)
     ylim([-4500 0]);
     caxis([-1.5 1.5])
     title('GFDL-MOM')
     colorbar off
     fontsize=18;
     set(findall(gcf,'type','text'),'FontSize',fontsize)
     set(gca,'fontsize',fontsize)
     set(gcf,'color','w');
     %printname=['paperfigs/gfdl_mom_Arctic70E_section'];
     printname=['paperfigs2/gfdl_mom_Arctic70E_section'];
  elseif(i_sec==3)
     ylim([-3000 0]);
     caxis([-1.5 3.5])
     printname=['paperfigs/gfdl_mom_fram_strait_79_5_section'];
  elseif(i_sec==4)
     ylim([-4500 0]);
     caxis([-1.5 7])
     interpcolormap([[0 0 .1];[0 0 1];[0 1 1];[0 1 0];[1 1 0];[1 0 1];[1 0 0];[1 .9 .8]],[1 1 1 1 1.3 .7 1.3],'l');
     title('GFDL-MOM')
     colorbar off
     fontsize=18;
     set(findall(gcf,'type','text'),'FontSize',fontsize)
     set(gca,'fontsize',fontsize)
     set(gcf,'color','w');
     %printname=['paperfigs/gfdl_mom_Atlantic_inflow_section'];
     printname=['paperfigs2/gfdl_mom_Atlantic_inflow_section'];
  elseif(i_sec==5)
     ylim([-650 0]);
     caxis([2 7])
     printname=['paperfigs/gfdl_mom_Barents_Sea_section'];
  end
  print(i_sec,'-depsc2','-r150',printname)
  if(i_sec==2 | i_sec==4)
   export_fig(i_sec,printname,'-eps','-r150');  
  end
end
  close all

