clear all

load gotm_jet_data

pcolor(time2d'./3600,-z,u);shading interp;colorbar
caxis([0 1])
xlabel('Time [hours]')
ylabel('depth [m]')
set(gca,'ytick',[0:100:1000])

printname='paperfigs/gotm_single_column_u_velocity'
print(printname,'-r300','-depsc2');

close

zr=0.5*(z(:,1:end-1)+z(:,2:end));
pcolor(time2d(1:end-1,:)'./3600,-zr,nuh);shading interp;colorbar
xlabel('Time [hours]')
ylabel('depth [m]')
set(gca,'ytick',[0:100:1000])

printname='paperfigs/gotm_single_column_diffdia'
print(printname,'-r300','-depsc2');

close

