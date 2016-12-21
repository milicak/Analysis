clear all


%expid='NOIIA_T62_tn11_sr10m60d_02'; %1 degree
%expid='NOIIA_T62_tn11_010'; %1 degree
%expid='NOIIA_T62_tn025_001'; %0.25 degree
%expid='N1850_f19_tn11_005';
expid='N1850_f19_tn11_01_2D';
%expid='N1850_f19_tn11_01_default';
%fyear=61;
%lyear=120;
fyear=100;
lyear=120;

%tripolar grid 1degree
grid_file='/fimm/home/bjerknes/milicak/Analysis/NorESM/climatology/Analysis/grid.nc';
%bi-polar grid 1degree
%grid_file='/fimm/home/bjerknes/milicak/Analysis/NorESM/climatology/Analysis/grid_bipolar.nc';
%tripolar grid 0.25degree
%grid_file='/bcmhsm/milicak/RUNS/noresm/CORE2/Arctic/maps/grid_0_25degree.nc';

area=ncgetvar(grid_file,'parea');


% Load time averaged model data
load(['matfiles/' expid '_timemean_' num2str(fyear) '_' num2str(lyear) '.mat']);

Nz=length(depth);
area=repmat(area,[1 1 Nz]);
area(isnan(templvl)==1)=NaN;

for k=1:Nz
  dnm=squeeze(templvl(:,:,k)).*squeeze(area(:,:,k));
  Tglobal(k)=nansum(dnm(:))/nansum(nansum(squeeze(area(:,:,k))));
  dnm=squeeze(salnlvl(:,:,k)).*squeeze(area(:,:,k));
  Sglobal(k)=nansum(dnm(:))/nansum(nansum(squeeze(area(:,:,k))));
  dnm=squeeze(difdialvl(:,:,k)).*squeeze(area(:,:,k));
  Kdglobal(k)=nansum(dnm(:))/nansum(nansum(squeeze(area(:,:,k))));
  dnm=squeeze(difisolvl(:,:,k)).*squeeze(area(:,:,k));
  Ahglobal(k)=nansum(dnm(:))/nansum(nansum(squeeze(area(:,:,k))));
end

%%%% for WOA 
resolution=1; %0.25; %1; %0.5;
nx=360*1/resolution;
ny=180*1/resolution;
deg2rad=pi/180;
grid_center_lat=ones(nx,1)*(-90+resolution*0.5:resolution:90-resolution*0.5);
grid_center_lon=(0+resolution*0.5:resolution:360-resolution*0.5)'*ones(1,ny);
grid_corner_lat=zeros(4,nx,ny);
grid_corner_lon=zeros(4,nx,ny);
grid_corner_lat(1,:,:)=grid_center_lat-0.5*resolution;
grid_corner_lat(2,:,:)=grid_center_lat-0.5*resolution;
grid_corner_lat(3,:,:)=grid_center_lat+0.5*resolution;
grid_corner_lat(4,:,:)=grid_center_lat+0.5*resolution;
grid_corner_lon(1,:,:)=grid_center_lon-0.5*resolution;
grid_corner_lon(2,:,:)=grid_center_lon+0.5*resolution;
grid_corner_lon(3,:,:)=grid_center_lon+0.5*resolution;
grid_corner_lon(4,:,:)=grid_center_lon-0.5*resolution;
grid_area=2*(sin(grid_corner_lat(4,1,:)*deg2rad) ...
            -sin(grid_corner_lat(1,1,:)*deg2rad))*pi/nx;
grid_area=ones(nx,1)*reshape(grid_area,1,[]);
rad2m=distdim(1,'rad','m');
grid_area=grid_area.*rad2m*rad2m;
twoa=ncgetvar('../../../climatology/Analysis/WOA09_temp.nc','t');
swoa=ncgetvar('../../../climatology/Analysis/WOA09_salt.nc','s');
depth_woa=ncgetvar('../../../climatology/Analysis/WOA09_salt.nc','depth');
grid_area=repmat(grid_area,[1 1 size(twoa,3)]);
grid_area(isnan(twoa)==1)=NaN;

for k=1:size(twoa,3)
  dnm=squeeze(twoa(:,:,k)).*squeeze(grid_area(:,:,k));
  TWOAglobal(k)=nansum(dnm(:))/nansum(nansum(squeeze(grid_area(:,:,k))));
  dnm=squeeze(swoa(:,:,k)).*squeeze(grid_area(:,:,k));
  SWOAglobal(k)=nansum(dnm(:))/nansum(nansum(squeeze(grid_area(:,:,k))));
end


