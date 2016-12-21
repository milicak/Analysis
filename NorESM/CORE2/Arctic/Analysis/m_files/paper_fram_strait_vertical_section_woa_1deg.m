clear all
rearth=6370;
int_method='conserve';

% WOA Fram Strait
map_file='/bcmhsm/milicak/RUNS/noresm/CORE2/Arctic/DATA/maps/map_woa09_1deg_to_section.nc';
filename_t='/fimm/home/bjerknes/milicak/Analysis/NorESM/climatology/Analysis/t00an1.nc';
%filename_t='/home/fimm/bjerknes/milicak/Analysis/NorESM/climatology/Analysis/WOA09_temp.nc';
temp=ncgetvar(filename_t,'t');
zt=ncgetvar(filename_t,'depth');

section=map_scalar2section(temp,map_file,int_method);
section(2).name='Arctic 70E';

for i_sec=1:5 %length(section)
  figure(i_sec);clf
  pcolor([0 section(i_sec).edge_dist]*rearth,-zt, ...
         [section(i_sec).data;section(i_sec).data(end,:)]');
  shading flat;colorbar
  title([ 'WOA ' section(i_sec).name])
  xlabel('Distance (km)')
  ylabel('Depth (m)')
  if(i_sec==1)
     ylim([-4500 0]);
     caxis([-1.5 3.5])
     printname=['paperfigs/woa_1deg_fram_strait_section'];
  elseif(i_sec==2)
     ylim([-5000 0]);
     caxis([-1.5 1.5])
     title('WOA')
     colorbar off
     fontsize=18;
     set(findall(gcf,'type','text'),'FontSize',fontsize)
     set(gca,'fontsize',fontsize)
     set(gcf,'color','w');
     set(gcf, 'InvertHardCopy', 'off')
     %printname=['paperfigs/woa_1deg_Arctic70E_section'];
     printname=['paperfigs2/woa_1deg_Arctic70E_section'];
  elseif(i_sec==3)
     ylim([-4500 0]);
     caxis([-1.5 3.5])
     printname=['paperfigs/woa_1deg_fram_strait_79_5N_section'];
  elseif(i_sec==4)
     ylim([-4500 0]);
     caxis([-1.5 7])
     interpcolormap([[0 0 .1];[0 0 1];[0 1 1];[0 1 0];[1 1 0];[1 0 1];[1 0 0];[1 .9 .8]],[1 1 1 1 1.3 .7 1.3],'l');
     title('WOA')
     colorbar off
     fontsize=18;
     set(findall(gcf,'type','text'),'FontSize',fontsize)
     set(gca,'fontsize',fontsize)
     set(gcf,'color','w');
     %printname=['paperfigs/woa_1deg_Atlantic_inflow_section'];
     printname=['paperfigs2/woa_1deg_Atlantic_inflow_section'];
  elseif(i_sec==5)
     ylim([-650 0]);
     caxis([2 7])
     printname=['paperfigs/woa_1deg_Barents_Sea_section'];
  end
  print(i_sec,'-depsc2','-r150',printname)
  if(i_sec==2 | i_sec==4)
   export_fig(i_sec,printname,'-eps','-r150');  
  end
%  close all
end

close all
