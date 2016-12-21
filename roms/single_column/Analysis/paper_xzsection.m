clear all
%clc
%close all
format long e

%root_dir=['/mnt/hexwork/RUNS/roms/overflow_slope/'];
%root_dir=['/mnt/hexwork/RUNS/roms/single_column/'];
root_dir=['/mnt/fimm/RUNS/roms/single_column/'];
project_name=['Exp01.0']

ncdir = [root_dir project_name '/OUT/'];

%timeindex=71;
timeindex=1;
jindex=1;

filename=[ncdir 'ocean_his.nc'];
%filename=[ncdir 'ocean_avg.nc'];
grd=filename;

% get basic info
[G,S,T]=Z_get_basic_info(filename,1);
[zeta,u,v,w,ubar,vbar,u_rho,v_rho,w_rho,salt,temp,z_rho,z_w,ocean_time]=Z_get_uvwstz(filename,timeindex,S,G);
z_rho=permute(z_rho,[3 2 1]);

rho=nc_varget(filename,'rho',[timeindex-1 0 0 0],[1 -1 -1 -1]);
Akt=nc_varget(filename,'AKt',[timeindex-1 0 0 0],[1 -1 -1 -1]);
%tke=nc_varget(filename,'tke',[timeindex-1 0 0 0],[1 -1 -1 -1]);
%gls=nc_varget(filename,'gls',[timeindex-1 0 0 0],[1 -1 -1 -1]);

lon=G.x_rho(jindex,2:end-1);
lon=repmat(lon,[S.N+2,1]);
z_r=squeeze(z_rho(:,jindex,2:end-1));

var(2:S.N+1,:)=squeeze(u_rho(:,jindex,2:end-1));
var3(2:S.N+1,:)=squeeze(temp(:,jindex,2:end-1));
%var(2:S.N+1,:)=squeeze(rho(:,jindex,2:end-1));
var(end+1,:)=var(end,:);
var3(end+1,:)=var3(end,:);
var2=var;
%clear var
var1(2:S.N+2,:)=squeeze(Akt(:,jindex,2:end-1));
%var4(2:S.N+2,:)=squeeze(tke(:,jindex,2:end-1));
%var5(2:S.N+2,:)=squeeze(gls(:,jindex,2:end-1));

var(1,:)=var(2,:);
var1(1,:)=var1(2,:);
var3(1,:)=var3(2,:);
%var4(1,:)=var4(2,:);
%var5(1,:)=var5(2,:);


clear z_rho
z_rho(2:S.N+1,:)=z_r;
z_rho(1,:)=-G.h(jindex,2:end-1);
z_rho(end+1,:)=zeta(jindex,2:end-1);

pcolorjw(lon./1e3,z_rho,var);shading interp
%caxis([5 30])
colorbar
%set(gca,'PlotBoxAspectRatio',[4 1 1])
ylabel('z [m]')
xlabel('x [km]')
%days=ocean_time(timeindex)/86400
days=ocean_time/86400

%printname=['paperfigs/roms_xzsection_1.eps']
%print(1,'-depsc2',printname);close(1)

