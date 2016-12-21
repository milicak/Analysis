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
u_rho=u_rho-min(u_rho(:));
z_rho=permute(z_rho,[3 2 1]);
z_w=permute(z_w,[3 2 1]);
rho=1e3-0.2*temp+0.8*salt;
dz=z_w(2:end,:,:)-z_w(1:end-1,:,:); %5 meter
N2=9.81*(rho(2:end,:,:)-rho(1:end-1,:,:))./(1026*5);
dUdz=(u_rho(2:end,:,:)-u_rho(1:end-1,:,:))./5;
Ri=-squeeze(N2(:,3,3))./squeeze(dUdz(:,3,3)).^2;

plot(squeeze(temp(:,3,3)),squeeze(z_rho(:,3,3)))
plot(squeeze(u_rho(:,3,3)),squeeze(z_rho(:,3,3)))


hl1=line(squeeze(temp(:,3,3)),squeeze(z_rho(:,3,3)),'Color','k','linewidth',2);
ax(1)=gca;
set(ax(1),'Position',[0.12 0.12 0.75 0.70])
set(ax(1),'XColor','k','YColor','k');
xlabel('Temp [C]')
ylabel('Depth [m]')

ax(2)=axes('Position',get(ax(1),'Position'),...
   'XAxisLocation','top',...
   'YAxisLocation','right',...
   'Color','none',...
   'XColor','r','YColor','r');

set(ax,'box','off')

hl2=line(squeeze(u_rho(:,3,3)),squeeze(z_rho(:,3,3)),'Color','r','linewidth',2,'Parent',ax(2));
xlim([-0.1 1.1])
xlabel('U [m/s]')
ylabel('Depth [m]')


printname=['paperfigs/roms_xzsection_initial']
print(1,'-depsc2','-r300',printname);


close(1)

