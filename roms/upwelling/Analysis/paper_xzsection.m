clear all
%clc
%close all
format long e

%root_dir=['/mnt/hexwork/RUNS/roms/overflow_slope/'];
root_dir=['/mnt/hexhome/RUNS/roms/upwelling/'];
timeindex=21;
jindex=1;

%timeindex=71;

%initial conditions
project_name=['kepsilon_noeddy']
ncdir = [root_dir project_name '/'];
filename=[ncdir 'ocean_his.nc'];
[G,S,T]=Z_get_basic_info(filename,1);
[zeta,u,v,w,ubar,vbar,u_rho,v_rho,w_rho,salt,temp,z_rho,z_w,ocean_time]=Z_get_uvwstz(filename,1,S,G);
z_rho=permute(z_rho,[3 2 1]);

figure(1)
pcolor(G.y_rho(:,21)*1e-3,squeeze(z_rho(:,:,21)),squeeze(temp(:,:,21)));shfn
title('initial')


% get basic info
project_name=['kepsilon_noeddy']
ncdir = [root_dir project_name '/'];
filename=[ncdir 'ocean_his.nc'];
[G,S,T]=Z_get_basic_info(filename,1);
[zeta,u,v,w,ubar,vbar,u_rho,v_rho,w_rho,salt,temp,z_rho,z_w,ocean_time]=Z_get_uvwstz(filename,timeindex,S,G);
z_rho=permute(z_rho,[3 2 1]);

tempk=temp;
figure(2)
pcolor(G.y_rho(:,21)*1e-3,squeeze(z_rho(:,:,21)),squeeze(temp(:,:,21)));shfn
title('k-epsilon')

% get basic info
project_name=['komega_noeddy']
ncdir = [root_dir project_name '/'];
filename=[ncdir 'ocean_his.nc'];
[G,S,T]=Z_get_basic_info(filename,1);
[zeta,u,v,w,ubar,vbar,u_rho,v_rho,w_rho,salt,temp,z_rho,z_w,ocean_time]=Z_get_uvwstz(filename,timeindex,S,G);
z_rho=permute(z_rho,[3 2 1]);

figure(3)
pcolor(G.y_rho(:,21)*1e-3,squeeze(z_rho(:,:,21)),squeeze(temp(:,:,21)-tempk(:,:,21)));shfn
title('k-omega')

% get basic info
project_name=['kkl_noeddy']
ncdir = [root_dir project_name '/'];
filename=[ncdir 'ocean_his.nc'];
[G,S,T]=Z_get_basic_info(filename,1);
[zeta,u,v,w,ubar,vbar,u_rho,v_rho,w_rho,salt,temp,z_rho,z_w,ocean_time]=Z_get_uvwstz(filename,timeindex,S,G);
z_rho=permute(z_rho,[3 2 1]);

figure(4)
pcolor(G.y_rho(:,21)*1e-3,squeeze(z_rho(:,:,21)),squeeze(temp(:,:,21)-tempk(:,:,21)));shfn
title('k-kl')

project_name=['kkl_eddy']
ncdir = [root_dir project_name '/'];
filename=[ncdir 'ocean_his.nc'];
[G,S,T]=Z_get_basic_info(filename,1);
[zeta,u,v,w,ubar,vbar,u_rho,v_rho,w_rho,salt,temp,z_rho,z_w,ocean_time]=Z_get_uvwstz(filename,60,S,G);
z_rho=permute(z_rho,[3 2 1]);

figure(5)
pcolor(G.y_rho(:,21)*1e-3,squeeze(z_rho(:,:,21)),squeeze(temp(:,:,21)));shfn
title('k-kl')

