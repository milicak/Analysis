clear all
i_sec=2; %2 or 4
rearth=6370;
int_method='conserve';

% WOA Fram Strait
map_file='/bcmhsm/milicak/RUNS/noresm/CORE2/Arctic/DATA/maps/map_woa09_1deg_to_section.nc';
filename_t='/fimm/home/bjerknes/milicak/Analysis/NorESM/climatology/Analysis/t00an1.nc';
zt_phc=ncgetvar(filename_t,'depth');

n=0
% NorESM
map_file='/bcmhsm/milicak/RUNS/noresm/CORE2/Arctic/DATA/maps/map_noresm_tnx1v1_to_section.nc';
filename_t='/bcmhsm/milicak/RUNS/noresm/CORE2/Arctic/DATA/NorESM/NOIIA_T62_tn11_sr10m60d_01_temperature_pendatal_1-300.nc';
temp=ncgetvar(filename_t,'temp');
tmp=squeeze(temp(:,:,:,55:end)); %last cycle 
temp=squeeze(nanmean(tmp,4));
clear tmp
zt=ncgetvar(filename_t,'depth');
section=map_scalar2section(temp,map_file,int_method);

data1=section(i_sec).data;
lon=section(i_sec).edge_dist;
zt3d=repmat(zt,[1 length(lon)])';
ztphc3d=repmat(zt_phc,[1 length(lon)])';
lon3d=repmat(lon,[length(zt) 1])';
lonphc3d=repmat(lon,[length(zt_phc) 1])';
data=griddata(lon3d,zt3d,data1,lonphc3d,ztphc3d);
n=n+1

% NOC-ORCA 
map_file='/bcmhsm/milicak/RUNS/noresm/CORE2/Arctic/DATA/maps/map_nemo_cnrm_to_section.nc';
filename_t='/bcmhsm/milicak/RUNS/noresm/CORE2/Arctic/DATA/noc/18_temp_sal_velocity_tracer_means_first_and_last_cycles/ORCA1-N403_1948to2007y60_ptemp_salin_pass5.nc';
temp=ncgetvar(filename_t,'votemper');
zt=ncgetvar(filename_t,'deptht');
temp=temp(2:end-1,1:end-1,:);
section=map_scalar2section(temp,map_file,int_method);
data1=section(i_sec).data;
lon=section(i_sec).edge_dist;
zt3d=repmat(zt,[1 length(lon)])';
ztphc3d=repmat(zt_phc,[1 length(lon)])';
lon3d=repmat(lon,[length(zt) 1])';
lonphc3d=repmat(lon,[length(zt_phc) 1])';
data=data+griddata(lon3d,zt3d,data1,lonphc3d,ztphc3d);
n=n+1

% NEMO-CNRM
map_file='/bcmhsm/milicak/RUNS/noresm/CORE2/Arctic/DATA/maps/map_nemo_cnrm_to_section.nc';
filename_t='/bcmhsm/milicak/RUNS/noresm/CORE2/Arctic/DATA/nemo-cnrm/CNRM_TSUV_decade.nc';
zt=ncgetvar(filename_t,'gdept');

temp=ncgetvar(filename_t,'T_decade_Cy1');
temp(:,:,:,7:12)=ncgetvar(filename_t,'T_decade_Cy2');
temp(:,:,:,13:18)=ncgetvar(filename_t,'T_decade_Cy3');
temp(:,:,:,19:24)=ncgetvar(filename_t,'T_decade_Cy4');
temp(:,:,:,25:30)=ncgetvar(filename_t,'T_decade_Cy5');
tmp=squeeze(temp(2:end-1,1:end-1,:,28:end));
temp=squeeze(nanmean(tmp,4));
clear tmp
section=map_scalar2section(temp,map_file,int_method);
data1=section(i_sec).data;
lon=section(i_sec).edge_dist;
zt3d=repmat(zt,[1 length(lon)])';
ztphc3d=repmat(zt_phc,[1 length(lon)])';
lon3d=repmat(lon,[length(zt) 1])';
lonphc3d=repmat(lon,[length(zt_phc) 1])';
data=data+griddata(lon3d,zt3d,data1,lonphc3d,ztphc3d);
n=n+1

% NEMO-CERFCAS
map_file='/bcmhsm/milicak/RUNS/noresm/CORE2/Arctic/DATA/maps/map_nemo_cerfacs_to_section.nc';
filename_t='/bcmhsm/milicak/RUNS/noresm/CORE2/Arctic/DATA/nemo-cerfacs/CERFACS_TSUV_decade.nc';
zt=ncgetvar(filename_t,'gdept');
temp=ncgetvar(filename_t,'T_decade_Cy1');
temp(:,:,:,7:12)=ncgetvar(filename_t,'T_decade_Cy2');
temp(:,:,:,13:18)=ncgetvar(filename_t,'T_decade_Cy3');
temp(:,:,:,19:24)=ncgetvar(filename_t,'T_decade_Cy4');
temp(:,:,:,25:30)=ncgetvar(filename_t,'T_decade_Cy5');
tmp=squeeze(temp(2:end-1,1:end-1,:,28:end));
temp=squeeze(nanmean(tmp,4));
clear tmp
section=map_scalar2section(temp,map_file,int_method);
data1=section(i_sec).data;
lon=section(i_sec).edge_dist;
zt3d=repmat(zt,[1 length(lon)])';
ztphc3d=repmat(zt_phc,[1 length(lon)])';
lon3d=repmat(lon,[length(zt) 1])';
lonphc3d=repmat(lon,[length(zt_phc) 1])';
data=data+griddata(lon3d,zt3d,data1,lonphc3d,ztphc3d);
n=n+1

% POP 
map_file='/bcmhsm/milicak/RUNS/noresm/CORE2/Arctic/DATA/maps/map_ncar_pop_to_section.nc';
filename_t='/bcmhsm/milicak/RUNS/noresm/CORE2/Arctic/DATA/ncar-pop/TSUV/g40.000.pop.h.0001-0300.nc';
temp=ncgetvar(filename_t,'TEMP');
zt=ncgetvar(filename_t,'z_t')./1e2; %convert cm to meter
tmp=squeeze(temp(:,:,:,55:end));
temp=squeeze(nanmean(tmp,4));
clear tmp
section=map_scalar2section(temp,map_file,int_method);
data1=section(i_sec).data;
lon=section(i_sec).edge_dist;
zt3d=repmat(zt,[1 length(lon)])';
ztphc3d=repmat(zt_phc,[1 length(lon)])';
lon3d=repmat(lon,[length(zt) 1])';
lonphc3d=repmat(lon,[length(zt_phc) 1])';
data=data+griddata(lon3d,zt3d,data1,lonphc3d,ztphc3d);
n=n+1

% MIR-FREE
map_file='/bcmhsm/milicak/RUNS/noresm/CORE2/Arctic/DATA/maps/map_mri_free_to_section.nc';
filename_t='/bcmhsm/milicak/RUNS/noresm/CORE2/Arctic/DATA/mir-free/temperature_pentadal.nc';
temp=ncgetvar(filename_t,'temp');
zt=ncgetvar(filename_t,'level');
tmp=squeeze(temp(3:end-2,1:end-2,:,55:end));
temp=squeeze(nanmean(tmp,4));
clear tmp
temp(temp<-100)=NaN;
section=map_scalar2section(temp,map_file,int_method);
data1=section(i_sec).data;
lon=section(i_sec).edge_dist;
zt3d=repmat(zt,[1 length(lon)])';
ztphc3d=repmat(zt_phc,[1 length(lon)])';
lon3d=repmat(lon,[length(zt) 1])';
lonphc3d=repmat(lon,[length(zt_phc) 1])';
data=data+griddata(lon3d,zt3d,data1,lonphc3d,ztphc3d);
n=n+1

% MOM 0.25
map_file='/bcmhsm/milicak/RUNS/noresm/CORE2/Arctic/DATA/maps/map_mom_0_25_to_section.nc';
filename_t='/bcmhsm/milicak/RUNS/noresm/CORE2/Arctic/DATA/mom0.25/ocean.temp.pent_avg.last_cycle_COREyr1948_2007.nc';
temp=ncgetvar(filename_t,'temp');
zt=ncgetvar(filename_t,'st_ocean');
tmp=squeeze(temp(:,:,:,7:end)); %last cycle 
temp=squeeze(nanmean(tmp,4));
clear tmp
section=map_scalar2section(temp,map_file,int_method);
data1=section(i_sec).data;
lon=section(i_sec).edge_dist;
zt3d=repmat(zt,[1 length(lon)])';
ztphc3d=repmat(zt_phc,[1 length(lon)])';
lon3d=repmat(lon,[length(zt) 1])';
lonphc3d=repmat(lon,[length(zt_phc) 1])';
data=data+griddata(lon3d,zt3d,data1,lonphc3d,ztphc3d);
n=n+1

% MOM 
map_file='/bcmhsm/milicak/RUNS/noresm/CORE2/Arctic/DATA/maps/map_gfdl_mom_to_section.nc';
filename_t='/bcmhsm/milicak/RUNS/noresm/CORE2/Arctic/DATA/gfdl-mom/annual_tracers/ocean.1708-2007.temp.nc';
temp=ncgetvar(filename_t,'temp');
zt=ncgetvar(filename_t,'st_ocean');
tmp=squeeze(temp(:,:,:,271:end));
temp=squeeze(nanmean(tmp,4));
clear tmp
section=map_scalar2section(temp,map_file,int_method);
data1=section(i_sec).data;
lon=section(i_sec).edge_dist;
zt3d=repmat(zt,[1 length(lon)])';
ztphc3d=repmat(zt_phc,[1 length(lon)])';
lon3d=repmat(lon,[length(zt) 1])';
lonphc3d=repmat(lon,[length(zt_phc) 1])';
data=data+griddata(lon3d,zt3d,data1,lonphc3d,ztphc3d);
n=n+1

% GOLD
map_file='/bcmhsm/milicak/RUNS/noresm/CORE2/Arctic/DATA/maps/map_gfdl_gold_to_section.nc';
filename_t='/bcmhsm/milicak/RUNS/noresm/CORE2/Arctic/DATA/gfdl-gold/annual_tracers/ocean_z.1708-2007.temp.nc';
temp=ncgetvar(filename_t,'temp');
zt=nc_varget(filename_t,'zt');
temp(temp<-100)=NaN;
tmp=squeeze(temp(:,:,:,271:end));
temp=squeeze(nanmean(tmp,4));
clear tmp
section=map_scalar2section(temp,map_file,int_method);
data1=section(i_sec).data;
lon=section(i_sec).edge_dist;
zt3d=repmat(zt,[1 length(lon)])';
ztphc3d=repmat(zt_phc,[1 length(lon)])';
lon3d=repmat(lon,[length(zt) 1])';
lonphc3d=repmat(lon,[length(zt_phc) 1])';
data=data+griddata(lon3d,zt3d,data1,lonphc3d,ztphc3d);
n=n+1


% Geomar-Orca
map_file='/bcmhsm/milicak/RUNS/noresm/CORE2/Arctic/DATA/maps/map_geomar_orca_to_section.nc';
filename_t='/bcmhsm/milicak/RUNS/noresm/CORE2/Arctic/DATA/geomar/ORCA05_5yr_19480101_20071231_votemper.nc';
temp=ncgetvar(filename_t,'votemper');
temp(temp==0)=NaN;
zt=ncgetvar(filename_t,'deptht');
tmp=squeeze(temp(2:end-1,1:end-1,:,55:end));
temp=squeeze(nanmean(tmp,4));
clear tmp
section=map_scalar2section(temp,map_file,int_method);
data1=section(i_sec).data;
lon=section(i_sec).edge_dist;
zt3d=repmat(zt,[1 length(lon)])';
ztphc3d=repmat(zt_phc,[1 length(lon)])';
lon3d=repmat(lon,[length(zt) 1])';
lonphc3d=repmat(lon,[length(zt_phc) 1])';
data=data+griddata(lon3d,zt3d,data1,lonphc3d,ztphc3d);
n=n+1

% CMCC-ORCA F
map_file='/bcmhsm/milicak/RUNS/noresm/CORE2/Arctic/DATA/maps/map_nemo_cnrm_to_section.nc';
filename_t='/bcmhsm/milicak/RUNS/noresm/CORE2/Arctic/DATA/cmcc/CMCC_5YM_PT_0001_0300.nc'
temp=ncgetvar(filename_t,'votemper');
zt=ncgetvar(filename_t,'deptht');
tmp=squeeze(temp(2:end-1,1:end-1,:,55:60));
tmp=squeeze(nanmean(tmp,4));
temp=tmp;
clear tmp
section=map_scalar2section(temp,map_file,int_method);
data1=section(i_sec).data;
lon=section(i_sec).edge_dist;
zt3d=repmat(zt,[1 length(lon)])';
ztphc3d=repmat(zt_phc,[1 length(lon)])';
lon3d=repmat(lon,[length(zt) 1])';
lonphc3d=repmat(lon,[length(zt_phc) 1])';
data=data+griddata(lon3d,zt3d,data1,lonphc3d,ztphc3d);
n=n+1

% FESOM
filename_t='/bcmhsm/milicak/RUNS/noresm/CORE2/Arctic/DATA/fesom/FESOM_task18.nc';
temp=ncgetvar(filename_t,'Temp');
zt=-ncgetvar(filename_t,'deps');
map_file='/bcmhsm/milicak/RUNS/noresm/CORE2/Arctic/DATA/maps/map_fesom_to_section.nc';
tmp=squeeze(temp(:,:,:,55:end)); %last cycle 
temp=squeeze(nanmean(tmp,4));
clear tmp
section=map_scalar2section(temp,map_file,int_method);
data1=section(i_sec).data;
lon=section(i_sec).edge_dist;
zt3d=repmat(zt,[1 length(lon)])';
ztphc3d=repmat(zt_phc,[1 length(lon)])';
lon3d=repmat(lon,[length(zt) 1])';
lonphc3d=repmat(lon,[length(zt_phc) 1])';
data=data+griddata(lon3d,zt3d,data1,lonphc3d,ztphc3d);
n=n+1

% HYCOM
map_file='/bcmhsm/milicak/RUNS/noresm/CORE2/Arctic/DATA/maps/map_fsu_hycom_to_section.nc';
filename_t='/bcmhsm/milicak/RUNS/noresm/CORE2/Arctic/DATA/fsu-hycom/TSuv_pentadals_glb1x3.nc';
temp=ncgetvar(filename_t,'temperature');
zt=ncgetvar(filename_t,'Depth');
filename_t='/bcmhsm/milicak/RUNS/noresm/CORE2/Arctic/DATA/NorESM/NOIIA_T62_tn11_sr10m60d_01_temperature_pendatal_1-300.nc';
ztref=ncgetvar(filename_t,'depth');
ztref=ztref(2:end);Nz=size(ztref,1);
timeind=1
for Time=55:60
for i=1:size(temp,1)
for j=1:size(temp,2)
temp1=squeeze(temp(i,j,:,Time));
zt1=squeeze(zt(i,j,:,Time));
zt1(temp1<-100)=[];
temp1(temp1<-100)=[];
if(isempty(zt1)~=1)
[B I]=unique(zt1);
zt1=zt1(I);
temp1=temp1(I);
T1(i,j,1:Nz,timeind)=interp1(zt1,temp1,ztref);
else
T1(i,j,1:Nz,timeind)=NaN;
S1(i,j,1:Nz,timeind)=NaN;
end
end
end
timeind=timeind+1
end
temp=T1;
temp=squeeze(nanmean(temp,4));
section=map_scalar2section(temp,map_file,int_method);
data1=section(i_sec).data;
lon=section(i_sec).edge_dist;
zt3d=repmat(ztref,[1 length(lon)])';
ztphc3d=repmat(zt_phc,[1 length(lon)])';
lon3d=repmat(lon,[length(ztref) 1])';
lonphc3d=repmat(lon,[length(zt_phc) 1])';
data=data+griddata(lon3d,zt3d,data1,lonphc3d,ztphc3d);
n=n+1

% HYCOMv2 Fram Strait
map_file='/bcmhsm/milicak/RUNS/noresm/CORE2/Arctic/DATA/maps/map_fsu_hycom2_to_section.nc';
filename_t='/bcmhsm/milicak/RUNS/noresm/CORE2/Arctic/DATA/fsu-hycom2/TSuv_pentadals_cyc5_fsu-hycom2.nc';
temp=ncgetvar(filename_t,'temperature');
zt=ncgetvar(filename_t,'Depth');
filename_t='/bcmhsm/milicak/RUNS/noresm/CORE2/Arctic/DATA/NorESM/NOIIA_T62_tn11_sr10m60d_01_temperature_pendatal_1-300.nc';
ztref=ncgetvar(filename_t,'depth');
ztref=ztref(2:end);Nz=size(ztref,1);

timeind=1
for Time=7:12
for i=1:size(temp,1)
for j=1:size(temp,2)
temp1=squeeze(temp(i,j,:,Time));
zt1=squeeze(zt(i,j,:,Time));
zt1(temp1<-100)=[];
temp1(temp1<-100)=[];
if(isempty(zt1)~=1)
[B I]=unique(zt1);
zt1=zt1(I);
temp1=temp1(I);
T1(i,j,1:Nz,timeind)=interp1(zt1,temp1,ztref);
else
T1(i,j,1:Nz,timeind)=NaN;
S1(i,j,1:Nz,timeind)=NaN;
end
end
end
timeind=timeind+1
end
temp=T1;
temp=squeeze(nanmean(temp,4));
% remove the last point
%temp=temp(:,1:end-1,:);
temp=temp(:,1:end-3,:);
section=map_scalar2section(temp,map_file,int_method);
data1=section(i_sec).data;
lon=section(i_sec).edge_dist;
zt3d=repmat(ztref,[1 length(lon)])';
ztphc3d=repmat(zt_phc,[1 length(lon)])';
lon3d=repmat(lon,[length(ztref) 1])';
lonphc3d=repmat(lon,[length(zt_phc) 1])';
data=data+griddata(lon3d,zt3d,data1,lonphc3d,ztphc3d);
n=n+1


data=data./n;
%pcolor([0 section(i_sec).edge_dist]*rearth,-ztref, ...
%       [section(i_sec).data;section(i_sec).data(end,:)]');
pcolor([lonphc3d]*rearth,-ztphc3d,data);
shading flat;colorbar
title([ 'MMM'])
xlabel('Distance (km)')
ylabel('Depth (m)')

if(i_sec==2)
     caxis([-1.5 1.5])
     colorbar off
     fontsize=18;
     set(findall(gcf,'type','text'),'FontSize',fontsize)
     set(gca,'fontsize',fontsize)
     set(gcf,'color','w');
     ylim([-4000 0])
     printname=['paperfigs2/mmm_Arctic70E_section'];
elseif(i_sec==4)
     ylim([-3000 0]);
     caxis([-1.5 7])
     interpcolormap([[0 0 .1];[0 0 1];[0 1 1];[0 1 0];[1 1 0];[1 0 1];[1 0 0];[1 .9 .8]],[1 1 1 1 1.3 .7 1.3],'l');
     colorbar off
     fontsize=18;
     set(findall(gcf,'type','text'),'FontSize',fontsize)
     set(gca,'fontsize',fontsize)
     set(gcf,'color','w');
     printname=['paperfigs2/mmm_Atlantic_inflow_section'];
end
print(1,'-depsc2','-r150',printname)


