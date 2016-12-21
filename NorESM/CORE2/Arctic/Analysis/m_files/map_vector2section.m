function section=map_vector2section(u,v,map_file,method)
%MAP_VECTOR2SECTION maps vector data to a section.
%   SECTION=MAP_VECTOR2SECTION(U,V,MAP_FILE,METHOD) maps the numeric arrays U
%   and V with eastward and northward vector components, respectively, to a
%   section using interpolation weights provided in the file MAP_FILE. The U
%   and V arrays must by arrays of size [M,P] or [M1,M2,P] where M or M1*M2
%   must match the number of grid cells used for generating the map file. The
%   argument METHOD indicate the interpolation method that can be one of the
%   following:
%     conserve - for first-order conservative interpolation (default).
%     bilinear - for bilinear interpolation.
%   Mapping is done for U(:,i) or U(:,:,i) for each i from 1 to P to
%   produce interpolated section data array of size [N,P] where N is the number
%   of section grid cells. Missing data must be set to NaN. SECTION is returned
%   as a structure containing the fields:
%     name:        section name.
%     u:           the eastward vector component.
%     v:           the northward vector component.
%     v_along:     the vector component along the section with positive
%                  direction towards the end of the section.
%     v_across:    the vector component across the section with positive
%                  direction to the left of the direction along and towards the
%                  end of the section.
%     center_lon:  longitude of the center of section grid cells (unit
%                  degrees).
%     center_lat:  latitude of the center of section grid cells (unit degrees).
%     edge_lon:    longitude of the edges of section grid cells (unit degrees).
%     edge_lat:    latitude of the edges of section grid cells (unit degrees).
%     center_dist: distance from center of section grid cells to section start
%                  (unit radians).
%     edge_dist:   distance from edge of section grid cells to section start
%                  (unit radians; the first edge distance of 0 radians is
%                  omitted).
%
%   If more than one section is defined in the map file, SECTION will be
%   returned as a structure array with a length corresponding to the number of
%   sections.

% Mats Bentsen (mats.bentsen@uni.no) 2013/08/05

% Check number of input/output arguments.
narginchk(4,4)
nargoutchk(0,1)

% Check arguments.
if ~isnumeric(u)||~isnumeric(v)||any(size(u)~=size(v))
  error('The arguments ''u'' and ''v'' must be an numeric arrays of equal size.')
end
if ~isstr(map_file)||~exist(map_file,'file')
  error('Argument ''map_file'' is not the name of an existing file.')
end
if ~strcmp(method,'conserve')&&~strcmp(method,'bilinear')
  error('Argument ''method'' must be either ''conserve'' or ''bilinear''.')
end

% Get information from map file.
ncid=netcdf.open(map_file,'NC_NOWRITE');
[dimname_tmp,n_a]=netcdf.inqDim(ncid,netcdf.inqDimID(ncid,'n_a'));
[dimname_tmp,n_b]=netcdf.inqDim(ncid,netcdf.inqDimID(ncid,'n_b'));
[dimname_tmp,n_sec]=netcdf.inqDim(ncid,netcdf.inqDimID(ncid,'n_sec'));
netcdf.close(ncid)
xc_b=ncread(map_file,'xc_b');
yc_b=ncread(map_file,'yc_b');
xe_b=ncread(map_file,'xe_b');
ye_b=ncread(map_file,'ye_b');
distc_b=ncread(map_file,'distc_b');
diste_b=ncread(map_file,'diste_b');
angle_b=ncread(map_file,'angle_b');
is_first=ncread(map_file,'is_first');
is_last=ncread(map_file,'is_last');
sec_name=char(ncread(map_file,'sec_name')');
S_conserve=sparse(double(ncread(map_file,'row_conserve')), ...
                  double(ncread(map_file,'col_conserve')), ...
                  ncread(map_file,'S_conserve'),n_b,n_a);
if strcmp(method,'bilinear')
  S_bilinear=sparse(double(ncread(map_file,'row_bilinear')), ...
                    double(ncread(map_file,'col_bilinear')), ...
                    ncread(map_file,'S_bilinear'),n_b,n_a);
end

% Make sure the data is a 2 dimensional matrix with the last dimension
% kept intact.
if length(u(:))==n_a
  u=u(:);
  v=v(:);
else
  u=reshape(u,[],size(u,ndims(u)));
  v=reshape(v,[],size(v,ndims(v)));
  if size(u,1)~=n_a
    error('The dimension of the input data does not match the source dimension in the map file.')
  end
end

% Map vector components to section.
sec_u=[];
sec_v=[];
for k=1:size(u,2)
  u_a=u(:,k);
  v_a=v(:,k);
  mask_a=ones(size(u_a));
  mask_a(find(isnan(u_a)|isnan(v_a)))=0;
  u_a(find(mask_a==0))=0;
  v_a(find(mask_a==0))=0;
  destarea_conserve=S_conserve*mask_a;
  u_conserve_b=S_conserve*u_a;
  u_conserve_b=u_conserve_b./destarea_conserve;
  v_conserve_b=S_conserve*v_a;
  v_conserve_b=v_conserve_b./destarea_conserve;
  if strcmp(method,'conserve')
    sec_u(:,k)=u_conserve_b;
    sec_v(:,k)=v_conserve_b;
  else
    destarea_bilinear=S_bilinear*mask_a;
    u_bilinear_b=S_bilinear*u_a;
    u_bilinear_b=u_bilinear_b./destarea_bilinear;
    u_bilinear_b(find(destarea_conserve==0))=nan;
    v_bilinear_b=S_bilinear*v_a;
    v_bilinear_b=v_bilinear_b./destarea_bilinear;
    v_bilinear_b(find(destarea_conserve==0))=nan;
    ind=find(isnan(u_bilinear_b)&~isnan(u_conserve_b));
    u_bilinear_b(ind)=u_conserve_b(ind);
    v_bilinear_b(ind)=v_conserve_b(ind);
    sec_u(:,k)=u_bilinear_b;
    sec_v(:,k)=v_bilinear_b;
  end
end

% Get vector component along and across the section.
cosa=cos(angle_b)*ones(1,size(u,2));
sina=sin(angle_b)*ones(1,size(u,2));
sec_v_along = cosa.*sec_u+sina.*sec_v;
sec_v_across=-sina.*sec_u+cosa.*sec_v;

% Fill section structure.
for i_sec=1:n_sec
  is=is_first(i_sec):is_last(i_sec);
  section(i_sec).name=sec_name(i_sec,:);
  section(i_sec).u=sec_u(is,:);
  section(i_sec).v=sec_v(is,:);
  section(i_sec).v_along=sec_v_along(is,:);
  section(i_sec).v_across=sec_v_across(is,:);
  section(i_sec).center_lon=xc_b(is)';
  section(i_sec).center_lat=yc_b(is)';
  section(i_sec).edge_lon=xe_b(:,is);
  section(i_sec).edge_lat=ye_b(:,is);
  section(i_sec).center_dist=distc_b(is)';
  section(i_sec).edge_dist=diste_b(is)';
end
