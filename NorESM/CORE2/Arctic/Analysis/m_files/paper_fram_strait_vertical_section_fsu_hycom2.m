clear all
rearth=6370;
int_method='conserve';

% HYCOMv2 Fram Strait
map_file='/bcmhsm/milicak/RUNS/noresm/CORE2/Arctic/DATA/maps/map_fsu_hycom2_to_section.nc';
filename_s='/bcmhsm/milicak/RUNS/noresm/CORE2/Arctic/DATA/fsu-hycom2/TSuv_pentadals_cyc5_fsu-hycom2.nc';
filename_t='/bcmhsm/milicak/RUNS/noresm/CORE2/Arctic/DATA/fsu-hycom2/TSuv_pentadals_cyc5_fsu-hycom2.nc';
%salt=ncgetvar(filename_s,'salinity');
temp=ncgetvar(filename_t,'temperature');
lon=ncgetvar(filename_t,'Longitude');
lat=ncgetvar(filename_t,'Latitude');
zt=ncgetvar(filename_t,'Depth');
filename_t='/bcmhsm/milicak/RUNS/noresm/CORE2/Arctic/DATA/NorESM/NOIIA_T62_tn11_sr10m60d_01_temperature_pendatal_1-300.nc';
ztref=ncgetvar(filename_t,'depth');
ztref=ztref(2:end);Nz=size(ztref,1);

timeind=1
%for Time=1:12 %last cycle
for Time=7:12
for i=1:size(temp,1)
for j=1:size(temp,2)
temp1=squeeze(temp(i,j,:,Time));
%salt1=squeeze(salt(i,j,:,Time));
zt1=squeeze(zt(i,j,:,Time));
zt1(temp1<-100)=[];
temp1(temp1<-100)=[];
%salt1(salt1<-100)=[];
if(isempty(zt1)~=1)
[B I]=unique(zt1);
zt1=zt1(I);
temp1=temp1(I);
%salt1=salt1(I);
T1(i,j,1:Nz,timeind)=interp1(zt1,temp1,ztref);
%S1(i,j,1:Nz,timeind)=interp1(zt1,salt1,ztref);
else
T1(i,j,1:Nz,timeind)=NaN;
S1(i,j,1:Nz,timeind)=NaN;
end
end
end
timeind=timeind+1
end

temp=T1;
%salt=S1;
temp=squeeze(nanmean(temp,4));
%salt=squeeze(nanmean(salt,4));

% remove the last point
temp=temp(:,1:end-1,:);
%salt=salt(:,1:end-1,:);

section=map_scalar2section(temp,map_file,int_method);
section(2).name='Arctic 70E';

for i_sec=1:5 %length(section)
  figure(i_sec);clf
  pcolor([0 section(i_sec).edge_dist]*rearth,-ztref, ...
         [section(i_sec).data;section(i_sec).data(end,:)]');
  shading flat;colorbar
  title([ 'FSU-HYCOMv2 ' section(i_sec).name])
  xlabel('Distance (km)')
  ylabel('Depth (m)')
  if(i_sec==1 | i_sec==3)
     ylim([-3000 0]);
  elseif(i_sec==2)
     ylim([-4200 0]);
  end
  if(i_sec==1)
     caxis([-1.5 3.5])
     printname=['paperfigs2/fsu_hycom2_fram_strait_section'];
  elseif(i_sec==2)
     caxis([-1.5 1.5])
     title('FSU-HYCOMv2')
     colorbar off
     fontsize=18;
     set(findall(gcf,'type','text'),'FontSize',fontsize)
     set(gca,'fontsize',fontsize)
     set(gcf,'color','w');
     printname=['paperfigs2/fsu_hycom2_Arctic70E_section'];
  elseif(i_sec==3)
     caxis([-1.5 3.5])
     printname=['paperfigs/fsu_hycom2_fram_strait_79_5N_section'];
  elseif(i_sec==4)
     ylim([-4500 0]);
     caxis([-1.5 7])
     interpcolormap([[0 0 .1];[0 0 1];[0 1 1];[0 1 0];[1 1 0];[1 0 1];[1 0 0];[1 .9 .8]],[1 1 1 1 1.3 .7 1.3],'l');
     title('FSU-HYCOMv2')
     colorbar off
     fontsize=18;
     set(findall(gcf,'type','text'),'FontSize',fontsize)
     set(gca,'fontsize',fontsize)
     set(gcf,'color','w');
     printname=['paperfigs2/fsu_hycom2_Atlantic_inflow_section'];
  elseif(i_sec==5)
     ylim([-650 0]);
     caxis([2 7])
     printname=['paperfigs2/fsu_hycom2_Barents_Sea_section'];
  end
  print(i_sec,'-depsc2','-r150',printname)
%  close all
end

