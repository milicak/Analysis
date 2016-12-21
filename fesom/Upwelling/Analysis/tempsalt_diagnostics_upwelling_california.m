clear all

fyear = 1; % first year
lyear = 60; % last year

% tripolar 1degree grid
grid_file='/fimm/home/bjerknes/milicak/Analysis/NorESM/climatology/Analysis/grid.nc';

map_file = '/bcmhsm/milicak/RUNS/noresm/CORE2/Arctic/maps/map_fesom_to_woa09_1deg_aave_.nc'; 

  n=1;
      if n==1
	resolution=1; %1; %0.5;
	nx=360;
	ny=180;
	deg2rad=pi/180;
	%grid_center_lat=ones(nx,1)*(-89.5:resolution:89.5);
	%grid_center_lon=(0.5:resolution:359.5)'*ones(1,ny);
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
	% convert to km^2
	area=grid_area*6371*6371;

	t_woa09_file='/fimm/home/bjerknes/milicak/Analysis/NorESM/climatology/Analysis/t00an1.nc';
	s_woa09_file='/fimm/home/bjerknes/milicak/Analysis/NorESM/climatology/Analysis/s00an1.nc';
	mask_woa09_file='/fimm/home/bjerknes/milicak/Analysis/NorESM/general/Analysis/woa_mask.mat';

	% Read WOA09 Southern Ocean mask
	load([mask_woa09_file]);

	% Load WOA09 data
	load(['/fimm/home/bjerknes/milicak/Analysis/NorESM/CORE2/Upwelling/Analysis/woa09an1.mat'])
	nx_b=nx;
	ny_b=ny;
	nz_b=nz;
	lon_woa09=lon;
	lat_woa09=lat;
	depth_woa09=depth;
	t_woa09=t;
	s_woa09=s;
	ptmp_woa09=ptmp;
	clear nx ny nz lon lat depth t s ptmp

% new one up to 42N
	xx=[243.6613
	  241.9747
	  240.5411
	  239.1075
	  237.8848
	  236.5355
	  235.3549
	  234.8489
	  234.3008
	  233.7105
	  233.2888
	  233.1623
	  233.0358
	  232.9937
	  231.9817
	  233.9213
	  237.3366
	  240.2881
	  243.6613];

	yy=[33.1694
	   32.8586
	   32.8586
	   32.8240
	   33.0313
	   33.5839
	   34.2401
	   35.0000
	   35.8635
	   36.7960
	   38.0394
	   39.0065
	   40.0772
	   40.9407
	   42.0460
	   42.7022
	   42.7022
	   41.1825
	   33.1694];

	[lon lat]=meshgrid(lon_woa09,lat_woa09);
	in=insphpoly(lon,lat,xx,yy,0,90);
	in=double(in');
	in(in==0)=NaN;
	inwoa_1=repmat(in.*area,[1 1 33]);
	infesom_1=repmat(in.*area,[1 1 45]);
     end %n==1

% Load time averaged model data
filename_s='/bcmhsm/milicak/RUNS/noresm/CORE2/Arctic/DATA/fesom/FESOM_task18.nc';
filename_t='/bcmhsm/milicak/RUNS/noresm/CORE2/Arctic/DATA/fesom/FESOM_task18.nc';
salt=ncgetvar(filename_s,'Salt');
temp=ncgetvar(filename_t,'Temp'); 

depth=-ncgetvar(filename_s,'deps');
nx_a=size(temp,1);
ny_a=size(temp,2);
depth_a=depth;
nz_a=max(find(depth_woa09(end)<=depth_a));
depth_a=depth_a(1:nz_a);

% Read interpolation indexes and weights
n_a=ncgetdim(map_file,'n_a');
n_b=ncgetdim(map_file,'n_b');
S=sparse(ncgetvar(map_file,'row'),ncgetvar(map_file,'col'), ...
         ncgetvar(map_file,'S'),n_b,n_a);


% Create 3D masks for atlantic
mask_index = 0; % 2 for Atlantic Ocean
mask_3d_woa09=reshape(reshape(mask_woa09,[],1)*ones(1,nz_b),nx_b,ny_b,nz_b);
if(mask_index~=0)
  mask_3d_woa09(find(isnan(t_woa09)|mask_3d_woa09~=mask_index))=0;
  mask_3d_woa09(find(mask_3d_woa09==mask_index))=1;
  mask_3d_dst=reshape(reshape(mask_woa09,[],1)*ones(1,nz_a),nx_b,ny_b,nz_a);
  mask_3d_dst(find(mask_3d_dst~=mask_index))=0;
  mask_3d_dst(find(mask_3d_dst==mask_index))=1;
else
  mask_3d_woa09(find(mask_3d_woa09~=mask_index))=1;
  mask_3d_dst=reshape(reshape(mask_woa09,[],1)*ones(1,nz_a),nx_b,ny_b,nz_a);
  mask_3d_dst(find(mask_3d_dst~=mask_index))=1;
end

% Interpolate model data to WOA09 grid
t_dst=zeros(nx_b,ny_b,nz_a);
s_dst=zeros(nx_b,ny_b,nz_a);
weight_dst=zeros(nx_b,ny_b,nz_a);
for time=12:60

 for k=1:nz_a
   t_src=reshape(temp(:,:,k,time),[],1);
   s_src=reshape(salt(:,:,k,time),[],1);
   mask_src=ones(size(t_src));
   mask_src(find(isnan(t_src)))=0;
   t_src(find(isnan(t_src)))=0;
   s_src(find(isnan(s_src)))=0;
   t_dst(:,:,k)=reshape(S*t_src,nx_b,ny_b);
   s_dst(:,:,k)=reshape(S*s_src,nx_b,ny_b);
   weight_dst(:,:,k)=reshape(S*mask_src,nx_b,ny_b);
 end
 iind=180;
 dnm=t_dst(1:iind,:,:);
 t_dst(1:iind,:,:)=t_dst(iind+1:end,:,:);
 t_dst(iind+1:end,:,:)=dnm;
 dnm=s_dst(1:iind,:,:);
 s_dst(1:iind,:,:)=s_dst(iind+1:end,:,:);
 s_dst(iind+1:end,:,:)=dnm;
 dnm=weight_dst(1:iind,:,:);
 weight_dst(1:iind,:,:)=weight_dst(iind+1:end,:,:);
 weight_dst(iind+1:end,:,:)=dnm;

infesom=infesom_1;
%infesom(t_dst==0)=NaN;
inwoa=inwoa_1;
inwoa(isnan(ptmp_woa09)==1)=NaN;

% Create WOA09 zonal means
ptmp_zm_woa09=squeeze(nansum(nansum(ptmp_woa09.*mask_3d_woa09.*inwoa),2)./nansum(nansum(mask_3d_woa09.*inwoa),2));
ptmp_zm_woa09_a=interp1(depth_woa09,ptmp_zm_woa09',depth_a)';
s_zm_woa09=squeeze(nansum(nansum(s_woa09.*mask_3d_woa09.*inwoa),2)./nansum(nansum(mask_3d_woa09.*inwoa),2));
s_zm_woa09_a=interp1(depth_woa09,s_zm_woa09',depth_a)';
for j=1:1
  k=find(isnan(ptmp_zm_woa09_a(j,:)),1,'first');
  if ~isempty(k)&&k>1
    ptmp_zm_woa09_a(j,k)=ptmp_zm_woa09_a(j,k-1);
    s_zm_woa09_a(j,k)=s_zm_woa09_a(j,k-1);
  end
end
ptmp_zm_woa09_a_time(:,n)=ptmp_zm_woa09_a';
s_zm_woa09_a_time(:,n)=s_zm_woa09_a';

% Create model zonal means
	t_zm_dst(:,n)=squeeze(nansum(nansum(t_dst.*mask_3d_dst.*infesom),2)./nansum(nansum(weight_dst.*mask_3d_dst.*infesom),2));
	s_zm_dst(:,n)=squeeze(nansum(nansum(s_dst.*mask_3d_dst.*infesom),2)./nansum(nansum(weight_dst.*mask_3d_dst.*infesom),2));
        n=n+1;

keyboard


end %time 1:60

%save(['matfiles/' expid '_CaliforniaUpwelling_tempsalt_' num2str(fyear) '_' num2str(lyear) '_years'],'depth_a','t_zm_dst_year','t_zm_dst','s_zm_dst','s_zm_dst_year','ptmp_zm_woa09_year', ...
%      'ptmp_zm_woa09_a_time','s_zm_woa09_a_time','s_zm_woa09_year')



