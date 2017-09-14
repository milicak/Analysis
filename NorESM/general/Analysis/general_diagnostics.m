% This subroutine computes general diagnostics of files you provide
% including amoc, global tracer profiles, basin zonal means
%clear all

%root_folder='/hexagon/work/milicak/archive/';
%root_folder='/hexagon/work/matsbn/archive/';

%root_folder='/hexagon/work/agu002/archive/';
%root_folder='/fimm/work/milicak/mnt/norstore/NS2345K/noresm_mehmet/';
%root_folder='/hexagon/work/agu002/noresm/';

%root_folder='/fimm/work/milicak/mnt/norstore/NS4659K/chuncheng/cases_test_Xmas2015/';
%root_folder='/fimm/work/milicak/mnt/norstore/NS4659K/chuncheng/cases/';
%root_folder='/fimm/work/milicak/mnt/norstore/NS2345K/noresm/cases/';
%root_folder='/fimm/work/milicak/mnt/viljework/noresm/';
root_folder='/fimm/work/milicak/mnt/viljework/archive/';
%root_folder='/fimm/work/milicak/mnt/viljeworkalok/archive/';
%root_folder='/hexagon/work/detivan/archive/';
%root_folder='/hexagon/work/cgu025/archive/';
%root_folder='/fimm/work/milicak/mnt/SKDData/ela066/';

clear proj
proj=projectname;
expid=proj.expid

fyear = 228; %166; % first year
lyear = 248; % last year

m2y = 1; % if it is monthly then m2y=1; if it is yearly data then m2y=0;
tripolar = true;
onedegree = true;
low=true;
%onedegree = false;
%low=false;

if (tripolar)
  % tripolar 1degree grid
  if(onedegree)
    grid_file='/fimm/home/bjerknes/milicak/Analysis/NorESM/climatology/Analysis/grid.nc';
    map_file2='/export/grunchfs/unibjerknes/milicak/bckup/noresm/CORE2/Arctic/DATA/maps/map_noresm_tnx1v1_to_section.nc';
  else
  % tripolar 0.25degree grid
  grid_file = '/export/grunchfs/unibjerknes/milicak/bckup/noresm/CORE2/Arctic/maps/grid_0_25degree.nc';
end
else
% bi-polar grid
grid_file='/fimm/home/bjerknes/milicak/Analysis/NorESM/climatology/Analysis/grid_bipolar.nc';
end

if (low)
  if(onedegree)
     map_file = '/export/grunchfs/unibjerknes/milicak/bckup/noresm/CORE2/Arctic/maps/map_tnx1v1_to_woa09_aave_20120501.nc'; %1 degree
   else
     map_file = '/export/grunchfs/unibjerknes/milicak/bckup/noresm/CORE2/Arctic/maps/map_noresm_tnx0.25v1_to_woa09_1deg_aave_.nc'; %0.25 degree
   end
 else
  map_file = '/export/grunchfs/unibjerknes/milicak/bckup/noresm/CORE2/Arctic/maps/map_noresm_tnx0.25v1_to_woa09_0_25deg_aave_.nc'; %0.25 degree high resl
end

global_EKE = false;
sshmean = false;
seaice = false;
seaicemean = true;
sshrms = false;
rad_toa = false; 
ocean_flx = false;
amoc_time = false;
amoc_mean = false;
kappaN2 = false;
drake_tr = false;
time_mean = false;
time_mean_mld = false;
time_vertical_tracer = false;
global_tracers = false;
global_upwelling = false;
global_surface = false;
global_zonalmean = false;
global_depthbias = false;
EminusP = false;
density_bins = false;
arctic_regions = false;
atlantic_inflow = false;

% top of the atmosphere radiation
if(rad_toa == true)
  %[rad_toa]=general_diagnostics_rad_toa(root_folder,expid,m2y,fyear,lyear)
  [rad_toa]=general_diagnostics_rad_toa2(root_folder,expid,fyear,lyear);
end

% total ocean flux
if(ocean_flx == true)
  [totalheatflx]=general_diagnostics_sflx_ocean(root_folder,expid,fyear,lyear);
end

% total EminusP
if(EminusP == true)
  [totalheatflx]=general_diagnostics_EminusP(root_folder,expid,fyear,lyear);
end

% density_bins_evolution
if(density_bins == true)
  [transfrm_area, transfrm_heat, transfrm_salt]=general_diagnostics_density_bins(root_folder,expid,fyear,lyear,m2y);
end

% amoc in time
if(amoc_time == true)
  % 1 for atlantic_arctic_ocean region
  % 2 for indian_pacific_ocean region
  % 3 for global_ocean
  region = 1;
  [amoc amoc_26_5 amoc_45]=general_diagnostics_amoc_time(root_folder,expid,m2y,fyear,lyear,region);
end

% amoc mean
if(amoc_mean == true)
  % 1 for atlantic_arctic_ocean region
  % 2 for indian_pacific_ocean region
  % 3 for global_ocean
  region = 1;
  [MOC_mean MOC_eddy lat depth]=general_diagnostics_amoc_mean(root_folder,expid,m2y,fyear,lyear,region)
end

% global energy = kappa*rho*N2 in time
if(kappaN2 == true)
  [energykd energycab]=general_diagnostics_kappaN2(root_folder,expid,m2y,fyear,lyear,grid_file);
end

% Drake passage transport
if(drake_tr == true)
  [drake]=general_diagnostics_drake_passage(root_folder,expid,m2y,fyear,lyear,grid_file)
end

% global EKE
if(global_EKE == true)
  [EKE]=general_diagnostics_EKE(root_folder,expid,m2y,fyear,lyear,grid_file);
  if 1
   pclon=reshape(ncgetvar(grid_file,'pclon'),[],4)';
   pclat=reshape(ncgetvar(grid_file,'pclat'),[],4)';
   dnm=squeeze(nanmean(EKE,3));
     %global pclon pclat MAP_PROJECTION    
     figure
     m_proj('Equidistant Cylindrical','lon',[-180 180],'lat',[-90 90]);
     micom_flat(log10(dnm.*1e4),pclon,pclat)
     colorbar
     colormap(jet(256))
     caxis([0 3.5])
     xlabel('Lon')
     ylabel('Lat')
%     m_gshhs_l('patch',[.7 .7 .7]);
m_coast('patch',[.7 .7 .7]);
m_grid
end
end

% global ssh time rms
if(sshrms == true)
  [sshrms]=general_diagnostics_sshrms(root_folder,expid,m2y,fyear,lyear,grid_file);
end

% global ssh time mean
if(sshmean == true)
  [ssh]=general_diagnostics_sshmean(root_folder,expid,m2y,fyear,lyear,grid_file);
end

% global seaice extend
if(seaice == true)
  [areaiceNH areaiceSH]=general_diagnostics_seaiceextend(root_folder,expid,m2y,fyear,lyear,grid_file);
end

% global seaice mean
if(seaicemean == true)
  [icemean hicemean]=general_diagnostics_seaicemean(root_folder,expid,m2y,fyear,lyear,grid_file);
end

% global time mean
if(time_mean == true)
  [templvl salnlvl]=general_diagnostics_timemean(root_folder,expid,m2y,fyear,lyear,grid_file);
end

% global time mean MLD
if(time_mean_mld == true)
  %skip=1 %every month
  %str=1 % Jan
  str=3;skip=12;
  [mld maxmld ustar]=general_diagnostics_timemean_mld(root_folder,expid,m2y,fyear,lyear,grid_file,str,skip);
end

% arctic_regions
if(arctic_regions == true)
  [temp_canada salt_canada temp_eurasia salt_eurasia zt]=general_diagnostics_arctic_regions(expid,fyear,lyear,grid_file);
end


% global tracer in time
if(time_vertical_tracer == true)
  %[Tempglobal Tglobal TempNH TempSH Sglobal SaltNH SaltSH]=general_diagnostics_timetracer(root_folder,expid,grid_file,m2y,fyear,lyear);
  [Tempglobal Saltglobal depth]=general_diagnostics_timetracer_vertical(root_folder,expid,grid_file,m2y,fyear,lyear);

  save(['matfiles/' expid 'temp_salt_global_vertical.mat'],'Tempglobal','Saltglobal','depth')
  if 0
    cc=reshape(Tempglobal,[12 size(Tempglobal,1)/12 70]);    
    dnm=squeeze(nanmean(cc,1));
    out2=load('woa09an1_globaltempsalt');
    for i=1:size(dnm,1);
      tempbias(i,:)=interp1(depth,dnm(i,:),out2.depth);
    end
  end
end

% global mean profiles of tracers
if(global_tracers == true)
  [Tglobal Sglobal Kdglobal Ahglobal depth]=general_diagnostics_global_profile(grid_file,expid,fyear,lyear);
end

% plot atlantic inflow
if(atlantic_inflow == true)
  root_folder_mat=['matfiles/']
  %root_folder_mat=['/export/grunchfs/unibjerknes/milicak/bckup/Analysis/NorESM/general/Analysis/matfiles/']
  [dnm]=general_diagnostics_Atlantic_inflow(root_folder_mat,expid,m2y,fyear,lyear,grid_file,map_file2);
end

% global surface temp salt error
if(global_surface == true)
  [sst_data sss_data sst_woa09 sss_woa09]= general_diagnostics_surface(map_file,expid,fyear,lyear,low);

  if 1
     fld=sst_data-sst_woa09;
     %fld=sss_data-sss_woa09;
     %fld=sst_data-temp_ctrl_mi;
     fld=fld';
     if(low)
       out=load('woa09an1.mat');
     else
       out=load('woa09an1_04.mat');
     end
     figure_height_scale=1;
     cbar_width_scale=2/3;
     fontsize=12;
     x=out.lon;y=out.lat;
     cv=[-.5 -.35 -.25 -.15 -.05 .05 .15 .25 .35 .5];
     %cv=[-3:0.2:3];
     cv=cv*10;
     %cv=cv*6;

     figure;clf;hold on
     set(gcf,'paperunits','inches','papersize',[8 6*figure_height_scale], ...
      'paperposition',[0 0 8 6*figure_height_scale],'color',[1 1 1], ...
      'renderer','painters','inverthardcopy','off')
     set(gca,'outerposition',[0 0 1 1],'position',[0.1 0.2 0.8 0.75], ...
      'color',[.7 .7 .7])
     if(low)
       m_proj('Equidistant Cylindrical','lon',[0 360],'lat',[-90 90]); %global
     else
       m_proj('Equidistant Cylindrical','lon',[-180 180],'lat',[-90 90]); %global
     end
      %m_proj('Equidistant Cylindrical','lon',[290 360],'lat',[-0 70]); % north atlantic
      colormap(cbsafemap(511,'rdbu'))
      [c,h]=m_contourf(x,y,-fld,[-cv(1) inf],'linecolor','none');
      m_grid
      set(findobj(h,'type','patch'),'facecolor','flat','cdata',-inf);
      [c,hc]=m_contourf(x,y,fld,cv,'linecolor','none');
      m_contour(x,y,fld,cv,'linecolor','k')
      [c,h]=m_contourf(x,y,-fld,[-cv(1) inf],'linecolor','none');
      set(findobj(h,'type','patch'),'facecolor','flat','cdata',-inf);

      xlabel('Latitude','fontsize',fontsize)
      ylabel('Longitude','fontsize',fontsize)
      hb=cbarfmb([-inf inf],cv,'vertical','nonlinear');
  %ylabel(hb,'K','fontsize',fontsize);
  ylabel(hb,'psu','fontsize',fontsize);
  pos=get(hb,'position');
  pos(3)=pos(3)*cbar_width_scale;
  set(hb,'position',pos,'fontsize',fontsize)
  cdatamidlev([hc;hb],cv,'nonlinear');
  caxis([cv(1) cv(end)])
  caxis(hb,[cv(1) cv(end)])
  m_coast('patch',[.6 .6 .6]);

end

end
% global upwelling mean of tracers in different basins
if(global_upwelling == true)
  mask_index = 0; % 2 for Atlantic Ocean
  %filename='/work-common/shared/bjerknes/milicak/mnt/norstore/NS2345K/noresm/cases/NOIIA_T62_tn11_sr10m60d_01/ocn/hist/NOIIA_T62_tn11_sr10m60d_01.micom.hm.0001-01.nc';
  datesep='-';
  
  if m2y==1
    prefix=[root_folder expid '/ocn/hist/' expid '.micom.hm.'];
  else
    prefix=[root_folder expid '/ocn/hist/' expid '.micom.hy.'];
  end

% Get dimensions and time attributes
if m2y==1
  sdate=sprintf('%4.4d%c%2.2d',fyear,datesep,1);
else
  sdate=sprintf('%4.4d%c%2.2d',fyear);
end

if m2y==1
  n=1;
  for year=fyear:lyear
    for month=1:12
      sdate=sprintf('%4.4d%c%2.2d',year,datesep,month);
      disp(sdate)
      filename=[prefix sdate '.nc'];
      [t_zm_dst(:,n) s_zm_dst(:,n) ptmp_zm_woa09_a(:,n) s_zm_woa09_a(:,n) lat_woa09 depth_a]= ...
      general_diagnostics_upwelling_california(filename,map_file,mask_index);
      %[t_zm_dst(:,n) s_zm_dst(:,n) ptmp_zm_woa09_a(:,n) s_zm_woa09_a(:,n) lat_woa09 depth_a]= ...
      %    general_diagnostics_upwelling_peru(filename,map_file,mask_index);
      %[t_zm_dst(:,n) s_zm_dst(:,n) ptmp_zm_woa09_a(:,n) s_zm_woa09_a(:,n) lat_woa09 depth_a]= ...
      %   general_diagnostics_upwelling_benguela(filename,map_file,mask_index);
      n=n+1;
    end
  end
else
  for year=fyear:lyear
    n=n+1;
    sdate=sprintf('%4.4d%c%2.2d',year);
    filename=[prefix sdate '.nc'];
    [t_zm_dst s_zm_dst difdia_zm_dst difiso_zm_dst ptmp_zm_woa09_a s_zm_woa09_a lat_woa09 depth_a]= ...
    general_diagnostics_upwelling(filename,map_file,mask_index);    
    n=n+1;
  end
end

save(['matfiles/' expid '_CaliforniaUpwell_tempsalt_' num2str(fyear) '_' num2str(lyear) '.mat'],'depth_a','ptmp_zm_woa09_a','t_zm_dst','s_zm_dst','s_zm_woa09_a')
%save(['matfiles/' expid '_PeruUpwell_tempsalt_' num2str(fyear) '_' num2str(lyear) '.mat'],'depth_a','ptmp_zm_woa09_a','t_zm_dst','s_zm_dst','s_zm_woa09_a')
%save(['matfiles/' expid '_BenguelaUpwell_tempsalt_' num2str(fyear) '_' num2str(lyear) '.mat'],'depth_a','ptmp_zm_woa09_a','t_zm_dst','s_zm_dst','s_zm_woa09_a')

end
% global tracers bias at depth in different basins
if(global_depthbias == true)
  depth_cri = 500;
  mask_index = 0; % 0 for Global
  %mask_index = 1; % 1 for Pacific Ocean
  %mask_index = 2; % 2 for Atlantic Ocean
  %mask_index = 4; % 4 for Southern Ocean
  %mask_index = 6; % 6 for Arctic Ocean
  %mask_index = 7; % 7 for Indian Ocean

  root_folder_mat=['matfiles/']
  %root_folder_mat=['/export/grunchfs/unibjerknes/milicak/bckup/Analysis/NorESM/general/Analysis/matfiles/']
  [t_zm_dst s_zm_dst ptmp_zm_woa09_a s_zm_woa09_a ]= ...
  general_diagnostics_depth_bias(map_file,expid,fyear,lyear,mask_index,root_folder_mat,depth_cri);
end

% global zonal mean of tracers in different basins
if(global_zonalmean == true)

  %mask_index = 0; % 0 for Global
  %mask_index = 1; % 1 for Pacific Ocean
  mask_index = 2; % 2 for Atlantic Ocean
  %mask_index = 4; % 4 for Southern Ocean
  %mask_index = 6; % 6 for Arctic Ocean
  %mask_index = 7; % 7 for Indian Ocean

  root_folder_mat=['matfiles/']
  %root_folder_mat=['/export/grunchfs/unibjerknes/milicak/bckup/Analysis/NorESM/general/Analysis/matfiles/']
  [t_zm_dst s_zm_dst difdia_zm_dst difiso_zm_dst ptmp_zm_woa09_a s_zm_woa09_a lat_woa09 depth_a]= ...
  general_diagnostics_zonal_mean(map_file,expid,fyear,lyear,mask_index,root_folder_mat);

  if 1
    t_zm_dst(t_zm_dst==0)=NaN;
    fld=(t_zm_dst-ptmp_zm_woa09_a)';
  %fld=(s_zm_dst-s_zm_woa09_a)';
  %fld=(t_zm_dst-mehmet)';
  ifirst=find(~isnan(nanmean(fld)),1,'first');
  ilast=find(~isnan(nanmean(fld)),1,'last');
  %ilast=155;
  figure_height_scale=1;
  cbar_width_scale=2/3;
  fontsize=12;
  x=lat_woa09;
  y=depth_a;
  cv=[-.5 -.35 -.25 -.15 -.05 .05 .15 .25 .35 .5];
  %cv=[-3:0.2:3];
  cv=cv*10;
  %cv=cv*2;

  figure;clf;hold on
  set(gcf,'paperunits','inches','papersize',[8 6*figure_height_scale], ...
    'paperposition',[0 0 8 6*figure_height_scale],'color',[1 1 1], ...
    'renderer','painters','inverthardcopy','off')
  set(gca,'outerposition',[0 0 1 1],'position',[0.1 0.2 0.8 0.75], ...
    'color',[.7 .7 .7])

  colormap(cbsafemap(511,'rdbu'))
  [c,h]=contourf(x,y,-fld,[-cv(1) inf],'linecolor','none');
  set(findobj(h,'type','patch'),'facecolor','flat','cdata',-inf);
  [c,hc]=contourf(x,y,fld,cv,'linecolor','none');
  contour(x,y,fld,cv,'linecolor','k')

  xlabel('Latitude','fontsize',fontsize)
  ylabel('Depth [m]','fontsize',fontsize)
  hb=cbarfmb([-inf inf],cv,'vertical','nonlinear');
  %ylabel(hb,'K','fontsize',fontsize);
  ylabel(hb,'psu','fontsize',fontsize);
  pos=get(hb,'position');
  pos(3)=pos(3)*cbar_width_scale;
  set(hb,'position',pos,'fontsize',fontsize)
  cdatamidlev([hc;hb],cv,'nonlinear');
  caxis([cv(1) cv(end)])
  caxis(hb,[cv(1) cv(end)])
  set(gca,'box','on','layer','top', ...
    'xlim',[x(ifirst) x(ilast)],'ydir','reverse', ...
    'fontsize',fontsize)
end

end

%exit

