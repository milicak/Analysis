function [G,S,T] = Z_get_basic_info(ncdir,num_N);
%
% Z_get_basic_info.m  5/3/2006  Parker MacCready
%
% this returns structures
%   G has horizontal grid info including bathymetry
%   S has vertical S-coordinate information
%   T has time information
%
% Get basic grid information using file number "num_N"

% make the file name
[infile] = ncdir;
%[infile] = Z_infile_maker(ncdir,num_N);
nc = netcdf(infile);

% fields are packed as (t,k,j,i) with k increasing upwards
% and we are assuming that there is only one time level per file

% get grid and bathymetry
G.h = nc{'h'}(:);             % depth (m) of bathymetry (positive down)
G.x_rho = nc{'x_rho'}(:);
G.y_rho = nc{'y_rho'}(:);
%G.x_rho = nc{'lon_rho'}(:); 
%G.y_rho = nc{'lat_rho'}(:);
%G.x_u = nc{'lon_u'}(:); G.y_u = nc{'lat_u'}(:);
%G.x_v = nc{'lon_v'}(:); G.y_v = nc{'lat_v'}(:);
%G.x_psi = nc{'lon_psi'}(:); G.y_psi = nc{'lat_psi'}(:);
G.x_u = nc{'x_u'}(:); G.y_u = nc{'y_u'}(:);
G.x_v = nc{'x_v'}(:); G.y_v = nc{'y_v'}(:);
G.x_psi = nc{'x_psi'}(:); G.y_psi = nc{'y_psi'}(:);
%G.mask_rho = logical(nc{'mask_rho'}(:));
G.mask_rho = nc{'mask_rho'}(:); %Gatimu
G.mask_u = nc{'mask_u'}(:); G.mask_v = nc{'mask_v'}(:); G.mask_psi = nc{'mask_psi'}(:);
pm = nc{'pm'}(:); pn = nc{'pn'}(:);
G.DX = 1./pm; G.DY = 1./pn; % grid sizes (m)
[G.M,G.L] = size(G.h);

% get vertical sigma-coordinate information (column vectors, bottom to top)
S.s_rho = nc{'s_rho'}(:);         % s-coordinate for "rho" (box mid-points)
S.s_w = nc{'s_w'}(:);         % s-coordinate for "w" (box interfaces)
S.hc = nc{'hc'}(:);                       % s-coordinate critical depth (m)
S.Cs_r = nc{'Cs_r'}(:);       % s=coordinate structure function (rho)
S.Cs_w = nc{'Cs_w'}(:);       % s=coordinate structure function (w)
S.N = length(S.s_rho);        % number of vertical s-levels

% time info
T.ocean_time = nc{'ocean_time'}(:);
T.save_num = num_N;

close(nc);
