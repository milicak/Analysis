clear all
grid=0.25;
years=40;
%project_name='CAM5O1MICOM.100Y.cont'
project_name='ATM_f09_MICOM_tnx025_leith'

filenamel=['matfiles/' project_name '_FLNT_years_1_40.mat'];
filenames=['matfiles/' project_name '_FSNT_years_1_40.mat'];

fs=load(filenames);
fl=load(filenamel);
fs.rad_toa2d=permute(fs.rad_toa2d,[2 3 1]);
fl.rad_toa2d=permute(fl.rad_toa2d,[2 3 1]);

if(grid==0.25)
  resolutionx=1.25; %1; %0.5;
  resolutiony=0.9375; %1; %0.5;
elseif(grid==1)
  resolutionx=1.25; %1; %0.5;
  resolutiony=0.9375; %1; %0.5;
end
nx=360*1/resolutionx;
ny=180*1/resolutiony;
deg2rad=pi/180;
%grid_center_lat=ones(nx,1)*(-89.5:resolution:89.5);
%grid_center_lon=(0.5:resolution:359.5)'*ones(1,ny);
grid_center_lat=ones(nx,1)*(-90+resolutiony*0.5:resolutiony:90-resolutiony*0.5);
grid_center_lon=(0+resolutionx*0.5:resolutionx:360-resolutionx*0.5)'*ones(1,ny);
grid_corner_lat=zeros(4,nx,ny);
grid_corner_lon=zeros(4,nx,ny);
grid_corner_lat(1,:,:)=grid_center_lat-0.5*resolutiony;
grid_corner_lat(2,:,:)=grid_center_lat-0.5*resolutiony;
grid_corner_lat(3,:,:)=grid_center_lat+0.5*resolutiony;
grid_corner_lat(4,:,:)=grid_center_lat+0.5*resolutiony;
grid_corner_lon(1,:,:)=grid_center_lon-0.5*resolutionx;
grid_corner_lon(2,:,:)=grid_center_lon+0.5*resolutionx;
grid_corner_lon(3,:,:)=grid_center_lon+0.5*resolutionx;
grid_corner_lon(4,:,:)=grid_center_lon-0.5*resolutionx;
grid_area=2*(sin(grid_corner_lat(4,1,:)*deg2rad) ...
            -sin(grid_corner_lat(1,1,:)*deg2rad))*pi/nx;
grid_area=ones(nx,1)*reshape(grid_area,1,[]);
rad2m=distdim(1,'rad','m');
%convert rad2 to m2 area
grid_area=grid_area.*rad2m.*rad2m;

area3=repmat(grid_area,[1 1 size(fs.rad_toa2d,3)]);

dnm1=fl.rad_toa2d.*area3-fs.rad_toa2d.*area3;
dnm1=squeeze(nansum(dnm1,1));
dnm1=squeeze(nansum(dnm1,1));
dnm1=reshape(dnm1,[12 years]);
dnm2=nansum(grid_area(:));

plot((nanmean(dnm1,1)./dnm2))






