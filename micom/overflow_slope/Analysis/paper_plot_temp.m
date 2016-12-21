% plots eddy diffusivity in time vs depth

clear all

root_name='/bcmhsm/milicak/RUNS/micom/overflow_slope/run/';

project_name='Exp001'

folder_name=[root_name project_name '/'];

filename=[folder_name project_name '_hm_1989.12.nc'];

h=nc_varget(filename,'dz');
temp=nc_varget(filename,'temp');
difdia=nc_varget(filename,'difdia');

temp(h==0)=NaN;
difdia(h==0)=NaN;

temp(temp>100)=NaN;

x=0.5:1:109.5;
zr=-1000:40:0;
bb=pcolor(x,zr',ones(length(x),length(zr))');shading interp
hold on
gcolor(squeeze(temp(1,:,2,:)),squeeze(h(1,:,2,:)));
set(bb,'facecolor',[.7 .7 .7])
xlim([0.5 109.5])
caxis([5 7.08])
xlabel('x [km]')
ylabel('depth [m]')
set(gca,'plotboxAspectRatio',[4 1 1])
colorbar

printname=['paperfigs/overflow_slope_' project_name '_temp_initial'];
%print(printname,'-zbuffer','-dpng')
print(printname,'-r300','-depsc2');
close

bb=pcolor(x,zr',ones(length(x),length(zr))');shading interp
hold on
gcolor(squeeze(temp(48,:,2,:)),squeeze(h(48,:,2,:)),'plm','nogrid');
set(bb,'facecolor',[.7 .7 .7])
xlim([0.5 109.5])
caxis([5 7.08])
xlabel('x [km]')
ylabel('depth [m]')
set(gca,'plotboxAspectRatio',[4 1 1])
colorbar

printname=['paperfigs/overflow_slope_' project_name '_temp_final'];
%print(printname,'-zbuffer','-dpng')
print(printname,'-r300','-depsc2');
close

