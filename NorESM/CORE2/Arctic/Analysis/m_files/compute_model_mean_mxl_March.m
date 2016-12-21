clear all

map_file='/bcmhsm/milicak/RUNS/noresm/CORE2/Arctic/DATA/maps/map_noresm_tnx1v1_to_woa09_1deg_aave_.nc';
% Get dimensions, longitude and latitude of WOA09 grid
dst_grid_dims=ncgetvar(map_file,'dst_grid_dims');
nx_b=dst_grid_dims(1);
ny_b=dst_grid_dims(2);
lon_b=reshape(ncgetvar(map_file,'xc_b'),nx_b,ny_b);
lat_b=reshape(ncgetvar(map_file,'yc_b'),nx_b,ny_b);
lon_b=lon_b(:,1);
lat_b=lat_b(1,:)';

mxl_model_woa=zeros(size(lon_b,1),size(lat_b,1));

files = [{'ORCA1'} {'gold'} {'mri'} {'ORCA1'} ...
         {'ORCA1'} {'hycom'} {'mom'} {'noresm_tnx1v1'} ...
         {'ORCA1'} {'geomar'} {'pop'} {'fesomv2'} {'hycom2'}];


files2 = [{'CERFACS'} {'GFDLGOLD'} {'MRIFREE'} {'NOCS'} ...
         {'CMCC'} {'FSU'} {'GFDL'} {'BERGEN'} ...
         {'CNRM'} {'KIEL'} {'NCAR'} {'AWI'} {'FSU-HYCOM2'}];

%for i=1 %length(files)
for i=1:13 %length(files)
map_file=['/bcmhsm/milicak/RUNS/noresm/CORE2/Arctic/DATA/maps/map_' char(files(i)) '_to_woa09_1deg_aave_.nc'];
filename = ['matfiles2/' char(files2(i)) '_march_mxl_depth.mat'];
% Read regrid indexes and weights
n_a=ncgetdim(map_file,'n_a');
n_b=ncgetdim(map_file,'n_b');
S=sparse(ncgetvar(map_file,'row'),ncgetvar(map_file,'col'), ...
         ncgetvar(map_file,'S'),n_b,n_a);
load(filename)
mld(mld<0)=0;
mxl=mld;
if(i==1 | i==5 | i==9 | i==10)
  mxl=mxl(2:end-1,1:end-1);
elseif(i==4)
  mxl(:,end+1)=mxl(:,end); 
elseif(i==3)
  mxl=mld(:,1:2:end-1);
elseif(i==13)
  mxl=mxl(:,1:end-1);
end
% Get dimensions, longitude and latitude of WOA09 grid
dst_grid_dims=ncgetvar(map_file,'dst_grid_dims');
nx_b=dst_grid_dims(1);
ny_b=dst_grid_dims(2);
% Interpolate model data to WOA09 grid
t_a=reshape(mxl,[],1);
if(i==12 | i==3)
  %dd=reshape(S*double(t_a),nx_b,ny_b);
  %dd1=dd(181:end,:);
  %dd2=dd(1:180,:);
  %dd=[dd1;dd2]; 
  %%dd(isnan(dd)==1)=0;
  mxl_model_woa=mxl_model_woa+mxl;
else
  mxl_model_woa=mxl_model_woa+reshape(S*double(t_a),nx_b,ny_b);
end
i
end


%mxl_model_woa=mxl_model_woa./length(files);

mxl_model_woa=mxl_model_woa./i;

filename_t='../../../../climatology/Analysis/t00an1.nc';
lon=ncgetvar(filename_t,'lon');
lat=ncgetvar(filename_t,'lat');

m_proj('stereographic','lat',90,'long',0,'radius',25);
m_pcolor(lon,lat,double(mxl_model_woa)');shfn
caxis([0 1500])
  x = [0:3:100 100 105 110:10:300 1100 1300 900 1000 1200 1400 1500];
  x=sort(x);
  Nx = length(x);
  clim = [min(x) max(x)];
  dx = min(diff(x));
  y = clim(1):dx:clim(2);
  for k=1:Nx-1, y(y>x(k) & y<=x(k+1)) = x(k+1); end % NEW
  f1=load('/fimm/home/bjerknes/milicak/matlab/tools/jet6');
  cmap=f1;
  cmap2 = [...
  interp1(x(:),cmap(:,1),y(:)) ...
  interp1(x(:),cmap(:,2),y(:)) ...
  interp1(x(:),cmap(:,3),y(:)) ...
  ];
  colormap(cmap2)
  caxis([0 450])
colorbar off
m_coast('patch',[.7 .7 .7]);
m_grid('xtick',[-120 -60 0 60 120])
    fontsize=18;
    set(findall(gcf,'type','text'),'FontSize',fontsize)
    set(gca,'fontsize',fontsize)
    set(gcf,'color','w');
title('MMM')
printname=['paperfigs2/mmm_march_mxl_depth'];
print(1,'-depsc2','-r150',printname)
%close
