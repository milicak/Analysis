% plots eddy diffusivity in time vs depth

clear all

root_name='/bcmhsm/milicak/RUNS/micom/dam_breaking/run/';
root_name='/hexagon/work/milicak/RUNS/micom/dam_breaking/run/';

project_name='Exp003'

folder_name=[root_name project_name '/'];

filename=[folder_name project_name '_hm_1989.12.nc'];
filename=['/bcmhsm/milicak/RUNS/micom/dam_breaking/run/Exp02.0/Exp02_0_hm_1989.12.nc'];

h=nc_varget(filename,'dz');
temp=nc_varget(filename,'temp');
%difdia=nc_varget(filename,'difdia');

temp(h==0)=NaN;
%difdia(h==0)=NaN;

temp(temp>100)=NaN;

gcolor(squeeze(temp(1,:,2,:)),squeeze(h(1,:,2,:)));
xlim([1 99])
%caxis([5 6.04])
caxis([5 26])
xlabel('x [km]')
ylabel('depth [m]')
set(gca,'plotboxAspectRatio',[4 1 1])
colorbar

printname=['paperfigs/dam_breaking_' project_name '_temp_initial'];
print(printname,'-r300','-depsc2');
%print(printname,'-zbuffer','-dpng')
close

gcolor(squeeze(temp(32,:,2,:)),squeeze(h(32,:,2,:)),'plm','nogrid');
xlim([1 99])
%caxis([5 6.04])
caxis([5 26])
xlabel('x [km]')
ylabel('depth [m]')
set(gca,'plotboxAspectRatio',[4 1 1])
colorbar

printname=['paperfigs/dam_breaking_' project_name '_temp_final'];
%print(printname,'-zbuffer','-dpng')
%print(printname,'-zbuffer','-depsc2')
print(printname,'-r300','-depsc2');
close

gcolor(squeeze(temp(3000,:,2,:)),squeeze(h(3000,:,2,:)),'plm','nogrid');
xlim([1 99])
%caxis([5 6.04])
caxis([5 26])
xlabel('x [km]')
ylabel('depth [m]')
set(gca,'plotboxAspectRatio',[4 1 1])
colorbar
printname=['paperfigs/dam_breaking_' project_name '_temp_end'];
print(printname,'-r300','-depsc2');
close

