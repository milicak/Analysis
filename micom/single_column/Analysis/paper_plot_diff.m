% plots eddy diffusivity in time vs depth

clear all

root_name='/bcmhsm/milicak/RUNS/micom/single_column/run/';

project_name='Exp005'

folder_name=[root_name project_name '/'];

filename=[folder_name project_name '_hm_1989.12.nc'];

time=nc_varget(filename,'time');
dt=(time(2:end)-time(1:end-1))*86400;
Time=[0;cumsum(dt)];


h=nc_varget(filename,'dz');
uvel=nc_varget(filename,'uvel');
difdia=nc_varget(filename,'difdia');

htime=squeeze(h(:,:,1,1));
utime=squeeze(uvel(:,:,1,1));
difftime=squeeze(difdia(:,:,1,1));
time2d=repmat(Time,[1 size(htime,2)]); 

utime(htime==0)=NaN;
difftime(htime==0)=NaN;

% divide time2d by 3600 for hours right now it is seconds
pcolor(time2d./3600,cumsum(htime,2),utime);shading interp;colorbar
xlim([0 12])
caxis([0 1])
xlabel('Time [hours]')
ylabel('depth [m]')

printname=['paperfigs/' project_name '_u_velocity'];
print(printname,'-depsc2')
%print(printname,'-zbuffer','-dpng')
close

pcolor(time2d./3600,cumsum(htime,2),difftime);shading interp;colorbar
xlim([0 12])
%caxis([0 1])
xlabel('Time [hours]')
ylabel('depth [m]')

printname=['paperfigs/' project_name '_diffdia'];
print(printname,'-depsc2')
%print(printname,'-zbuffer','-dpng')
