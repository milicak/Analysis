% this module interpolates mom temp and salt values into 1 deg WOA grid
clear all
ntime = 744;
lat_cr = 26.5; %North 26.5 for amoc
depth_mom=ncgetvar('/export/grunchfs/unibjerknes/milicak/bckup/mom/om3_core3_ctrl/INPUT_initial/ocean_temp_salt.res.nc','ZT');
lat = ncgetvar('levitus_ewg_temp_salt_cm2m.nc','y_T');

project_name = ['om3_core3_ctrl'];
project_name1 = ['om3_core3_patchy_full_01'];
project_name2 = ['om3_core3_patchy_full_02'];

out=load(['matfiles/' project_name '_amoc.mat']);
out1=load(['matfiles/' project_name1 '_amoc.mat']);
out2=load(['matfiles/' project_name2 '_amoc.mat']);


figure(1)
pcolor(lat(180,:),-depth_mom,out.amocmean');shfn
xlim([-33 65])
caxis([-7 14])
xlabel('Lat')
ylabel('Depth [m]')
printname = ['paperfigs/' project_name '_amocmean.eps']
print(1,'-depsc2',printname)
close

figure(2)
pcolor(lat(180,:),-depth_mom,out1.amocmean');shfn
xlim([-33 65])
caxis([-7 14])
xlabel('Lat')
ylabel('Depth [m]')
printname = ['paperfigs/' project_name1 '_amocmean.eps']
print(2,'-depsc2',printname)
close

figure(3)
pcolor(lat(180,:),-depth_mom,out2.amocmean');shfn
xlim([-33 65])
caxis([-7 14])
xlabel('Lat')
ylabel('Depth [m]')
printname = ['paperfigs/' project_name2 '_amocmean.eps']
print(3,'-depsc2',printname)
close

figure(4)
dnm=reshape(out.amoc,[12 124]);
plot(1:124,nanmean(dnm,1),'b','linewidth',2)
hold on
dnm=reshape(out1.amoc,[12 124]);
plot(1:124,nanmean(dnm,1),'r','linewidth',2)
dnm=reshape(out2.amoc,[12 124]);
plot(1:124,nanmean(dnm,1),'k','linewidth',2)
ylim([6 22])
legend('ctrl','patchy01','patchy02','location','northeast')
xlim([1 124])
xlabel('Time [years]')
ylabel('AMOC [Sv]')
printname = ['paperfigs/amoctimeall.eps']
print(4,'-depsc2',printname)
close








