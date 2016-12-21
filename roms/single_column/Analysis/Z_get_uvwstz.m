function [zeta,u,v,w,ubar,vbar,u_rho,v_rho,w_rho,salt,temp,z_rho,z_w,ocean_time] = ...
    Z_get_uvstz(infile,time_level,S,G)
%
% Z_get_uvwstz.m 2/08/2007  Gatimu; getting also vertical vel based on 
% Z_get_uvstz.m  4/21/2006  Parker MacCready 
%
% This gets the basic 3-D fields (and some 2D) for one time snapshot.
% It saves u and v, as well as these fields interpolated onto the rho-grid.
% It also saves salt and temp, and arrays of z-positions
%
% Note that the velocity is zero in places where the landmask applies, so
% that when we interpolate onto the rho-grid we would get the half of the
% velocity on the seaward side of the cell.  Tracers are also set to zero
% under the landmask.

nc = netcdf(infile);
%ocean_time = nc{'ocean_time'}(:);
ocean_time = nc_varget(infile,'ocean_time',[time_level-1],[1]);
tt1 = time_level; % time level, always = 1
zeta = squeeze(nc{'zeta'}(tt1,:,:)); % surface height (m)
u = squeeze(nc{'u'}(tt1,:,:,:));
v = squeeze(nc{'v'}(tt1,:,:,:));
w = squeeze(nc{'w'}(tt1,:,:,:));
ubar = squeeze(nc{'ubar'}(tt1,:,:));
vbar = squeeze(nc{'vbar'}(tt1,:,:));
% interpolate onto the rho grid
uu = 0.5 * (u(:,:,1:end-1) + u(:,:,2:end));
uu = cat(3,u(:,:,1),uu);
u_rho = cat(3,uu,u(:,:,end));
vv = 0.5 * (v(:,1:end-1,:) + v(:,2:end,:));
vv = cat(2,v(:,1,:),vv);
v_rho = cat(2,vv,v(:,end,:));
w_rho = 0.5 * (w(1:end-1,:,:) + w(2:end,:,:));
salt = squeeze(nc{'salt'}(tt1,:,:,:));
temp = squeeze(nc{'temp'}(tt1,:,:,:));
close(nc);
% calculate vertical positions
z_rho=depths(infile, infile, 1, 0, time_level);
z_w=depths(infile, infile, 5, 0, time_level);
%[z_rho,z_w] = Z_s2z_mat(G.h,zeta,S);;

