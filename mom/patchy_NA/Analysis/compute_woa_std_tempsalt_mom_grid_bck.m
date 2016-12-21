% this module interpolates WOA temp and salt anomalies into the mom 1 degree grid
clear all

map_file='/bcmhsm/milicak/RUNS/noresm/CORE2/Arctic/DATA/maps/map_woa13_1deg_to_mom_patch_.nc';
mask_file='/fimm/home/bjerknes/milicak/Analysis/mom/APE/SO/Analysis/grid_spec_v6_regMask.nc';
mask=ncgetvar(mask_file,'tmask');

depth_mom=ncgetvar('/export/grunchfs/unibjerknes/milicak/bckup/mom/om3_core3_ctrl/INPUT_initial/ocean_temp_salt.res.nc','ZT');
nx_b=360;
ny_b=200;
nz_b=50;

woa_file_path='/bcmhsm/milicak/RUNS/noresm/CORE2/Arctic/DATA/woa013/';
%twoa_file=[woa_file_path 'woa13_decav_ptemp_annual_01.nc'];
%swoa_file=[woa_file_path 'woa13_decav_s_annual_01.nc'];
%twoa_file=[woa_file_path 'woa13_1955-1964_ptemp_annual_01.nc'];
%swoa_file=[woa_file_path 'woa13_1955-1964_s_annual_01.nc'];

%twoa_file=[woa_file_path 'woa13_1995-2004_t_annual_01.nc'];
%twoa_file=[woa_file_path 'woa13_1995-2004_ptemp_annual_01.nc'];
%swoa_file=[woa_file_path 'woa13_1995-2004_s_annual_01.nc'];

twoa_file=[woa_file_path 'woa13_2005-2012_t_annual_01.nc'];
%twoa_file=[woa_file_path 'woa13_2005-2012_ptemp_annual_01.nc'];
swoa_file=[woa_file_path 'woa13_2005-2012_s_annual_01.nc'];

%temp_sd_woa=ncgetvar(twoa_file,'ptemp_sd');
temp_sd_woa=ncgetvar(twoa_file,'t_sd');
salt_sd_woa=ncgetvar(swoa_file,'s_sd');
%temp_an_woa=ncgetvar(twoa_file,'ptemp_an');
temp_an_woa=ncgetvar(twoa_file,'t_sd');
salt_an_woa=ncgetvar(swoa_file,'s_an');
depth=ncgetvar(swoa_file,'depth');
%temp_sd_woa=ncgetvar(twoa_file,'ptemp_oa');
%salt_sd_woa=ncgetvar(swoa_file,'s_oa');
nz_a=size(temp_sd_woa,3);

% Read interpolation indexes and weights
n_a=ncgetdim(map_file,'n_a');
n_b=ncgetdim(map_file,'n_b');
S=sparse(ncgetvar(map_file,'row'),ncgetvar(map_file,'col'), ...
         ncgetvar(map_file,'S'),n_b,n_a);

% Interpolate model data to WOA13 grid
t_dst=zeros(nx_b,ny_b,nz_a);
s_dst=zeros(nx_b,ny_b,nz_a);
tan_dst=zeros(nx_b,ny_b,nz_a);
san_dst=zeros(nx_b,ny_b,nz_a);
for k=1:nz_a
  t_src=reshape(temp_sd_woa(:,:,k),[],1);
  s_src=reshape(salt_sd_woa(:,:,k),[],1);
  t_src(find(isnan(t_src)))=0;
  s_src(find(isnan(s_src)))=0;
  s_dst(:,:,k)=reshape(S*s_src,nx_b,ny_b);
  t_dst(:,:,k)=reshape(S*t_src,nx_b,ny_b);
  t_src=reshape(temp_an_woa(:,:,k),[],1);
  s_src=reshape(salt_an_woa(:,:,k),[],1);
  t_src(find(isnan(t_src)))=0;
  s_src(find(isnan(s_src)))=0;
  san_dst(:,:,k)=reshape(S*s_src,nx_b,ny_b);
  tan_dst(:,:,k)=reshape(S*t_src,nx_b,ny_b);
end
p_dst=repmat(depth,[1 nx_b ny_b]);
p_dst=permute(p_dst,[2 3 1]);
s_dst(s_dst<0)=0;
san_dst(san_dst<0)=0;
rho_dst=sw_dens(san_dst+s_dst,tan_dst+t_dst,p_dst)-sw_dens(san_dst,tan_dst,p_dst);
% filter Arctic Ocean; issues on the shelves and positive values
%mask3d=repmat(mask,[1 1 nz_b]);
%rho_dst(mask3d==4)=0;
rho_dst(rho_dst>0)=0;
break

rho_mom=zeros(nx_b,ny_b,nz_b);
for i=1:nx_b ; for j=1:ny_b
  rho_mom(i,j,:)=interp1(depth,squeeze(rho_dst(i,j,:)),depth_mom);
end ; end
% just in case remove NaN
rho_mom(isnan(rho_mom))=0;


% Create netcdf file.
ncid=netcdf.create(['/export/grunchfs/unibjerknes/milicak/bckup/mom/woa13rho_anomaly_2005_2012.nc'],'NC_CLOBBER');
% Define dimensions.
ni_dimid=netcdf.defDim(ncid,'gridlon_t',nx_b);
nj_dimid=netcdf.defDim(ncid,'gridlat_t',ny_b);
nz_dimid=netcdf.defDim(ncid,'zt',nz_b);

depth_varid=netcdf.defVar(ncid,'depth','float',[nz_dimid]);
netcdf.putAtt(ncid,depth_varid,'long_name','z level');
netcdf.putAtt(ncid,depth_varid,'units','m');

fill_value=-1e33;
rho_varid=netcdf.defVar(ncid,'rho_anom','float',[ni_dimid nj_dimid nz_dimid]);
netcdf.putAtt(ncid,rho_varid,'long_name','Ocean density anomaly');
netcdf.putAtt(ncid,rho_varid,'units','kg m-3');
netcdf.putAtt(ncid,rho_varid,'_FillValue',single(fill_value));

netcdf.endDef(ncid)

netcdf.putVar(ncid,depth_varid,single(depth_mom));
netcdf.putVar(ncid,rho_varid,[0 0 0],[nx_b ny_b nz_b],double(rho_mom));

% Close netcdf file
netcdf.close(ncid)
