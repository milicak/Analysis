clear all

title = 'climatology_woa';
filename = 'climatology_woa.nc';

t_woa09_file='t00an1.nc';
s_woa09_file='s00an1.nc';
map_file='/home/nersc/matsbn/matlab/regrid/maps/map_woa09_to_tnx1v1_aave_20120501.nc';

nx_a=360;
ny_a=180;
nx_b=360;
ny_b=384;
nz=33;

% Read regrid indexes and weights
n_a=ncgetdim(map_file,'n_a');
n_b=ncgetdim(map_file,'n_b');
S=sparse(ncgetvar(map_file,'row'),ncgetvar(map_file,'col'), ...
         ncgetvar(map_file,'S'),n_b,n_a);

temp=nc_varget(t_woa09_file,'t');
salt=nc_varget(s_woa09_file,'s');
depth=nc_varget(t_woa09_file,'depth');

for k=1:nz

% Read WOA09 surface temperature
%t_a=ncgetvar(t_woa09_file,'t',[1 1 1],[inf inf 1]);
t_a=squeeze(temp(k,:,:))';
s_a=squeeze(salt(k,:,:))';

% Get destination area of interpolated data
mask_a=ones(nx_a,ny_a);
mask_a(find(isnan(t_a)))=0;
destarea=reshape(S*reshape(mask_a,[],1),nx_b,ny_b);

% Set NaN's of source data to zero
t_a(find(mask_a==0))=0;
s_a(find(mask_a==0))=0;

% Regrid WOA09 data on to tnx1v1 grid
t_b=reshape(S*reshape(t_a,[],1),nx_b,ny_b);
s_b=reshape(S*reshape(s_a,[],1),nx_b,ny_b);

% Normalize with destination area
tn_b=t_b./destarea;
sn_b=s_b./destarea;

p=reshape(ones(nx_b*ny_b,1)*depth(k)',nx_b,ny_b);
ptmp=sw_ptmp(sn_b,tn_b,p,zeros(nx_b,ny_b));

temp_woa_tripolar(k,:,1:ny_b)=ptmp;
salt_woa_tripolar(k,:,1:ny_b)=sn_b;
dnm=temp_woa_tripolar(k,:,ny_b);
dnm2=flipud(dnm');
dnm2=dnm2';
temp_woa_tripolar(k,:,ny_b+1)=dnm2;
dnm=salt_woa_tripolar(k,:,ny_b);
dnm2=flipud(dnm');
dnm2=dnm2';
salt_woa_tripolar(k,:,ny_b+1)=dnm2;

end % k-indice


temp_woa_tripolar=permute(temp_woa_tripolar,[1 3 2]);
salt_woa_tripolar=permute(salt_woa_tripolar,[1 3 2]);

% create the climatology_lvl file
disp(' ')
disp(' Create the grid file...')
create_climatology(nx_b,ny_b+1,nz,filename,title);

disp(' ')
disp(' Fill the grid file...')
nc = netcdf(filename,'write');

nc{'temp'}(:) = temp_woa_tripolar;
nc{'saln'}(:) = salt_woa_tripolar;
nc{'depth'}(:) = depth;

result = close(nc);

