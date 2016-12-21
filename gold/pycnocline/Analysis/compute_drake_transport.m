%This subroutine computes drake passage transport in GOLD in depth space
clear all

if 0
%%root_dir=['/net2/Robert.Hallberg/CM2G/Kd_sens/']
%root_dir=['/net2/Robert.Hallberg/CM2G/Kd_add/']
root_dir=['/net2/rwh/CM2G/Kd_add/']
%project_name='CM2G_LM3_1990_G0_KDadd5'
project_name0='CM2G_LM3_1860_KDadd0'
project_name1='CM2G_LM3_1860_KDadd1'
project_name2='CM2G_LM3_1860_KDadd2'
project_name4='CM2G_LM3_1860_KDadd4'
project_name6='CM2G_LM3_1860_KDadd6'
project_name8='CM2G_LM3_1860_KDadd8'
%filepath=['/pp/ocean/av/annual_20yr/'];
filepath=['/pp/ocean_annual_z/av/annual_100yr/'];
%filename=['ocean_annual_z.2000-2019.ann.nc'];
filename=['ocean_annual_z.2501-2600.ann.nc'];
end

if 1
root_dir=['/archive/Bonnie.Samuels/fre/siena_201204/CM2G_LM3/18mar2013/']
project_name0='CM2G_LM3_1860_KDadd0_18mar2013'
project_name1='CM2G_LM3_1860_KDadd1_18mar2013'
project_name2='CM2G_LM3_1860_KDadd2_18mar2013'
project_name4='CM2G_LM3_1860_KDadd4_18mar2013'
project_name6='CM2G_LM3_1860_KDadd6_18mar2013'
project_name8='CM2G_LM3_1860_KDadd8_18mar2013'
filepath=['/gfdl.nescc-default-prod-openmp/pp/ocean_annual/av/annual_100yr/'];
filename=['ocean_annual.2501-2600.ann.nc'];
end

flname0=[root_dir project_name0 filepath filename];
flname1=[root_dir project_name1 filepath filename];
flname2=[root_dir project_name2 filepath filename];
flname4=[root_dir project_name4 filepath filename];
flname6=[root_dir project_name6 filepath filename];
flname8=[root_dir project_name8 filepath filename];
lon=nc_varget(flname0,'xh');
lat=nc_varget(flname0,'yh');

if 0
uh0=nc_varget(flname0,'uh');
uh1=nc_varget(flname1,'uh');
uh2=nc_varget(flname2,'uh');
uh4=nc_varget(flname4,'uh');
uh6=nc_varget(flname6,'uh');
uh8=nc_varget(flname8,'uh');
end
if 1
uh0=nc_varget(flname0,'uh_rho');
uh1=nc_varget(flname1,'uh_rho');
uh2=nc_varget(flname2,'uh_rho');
uh4=nc_varget(flname4,'uh_rho');
uh6=nc_varget(flname6,'uh_rho');
uh8=nc_varget(flname8,'uh_rho');
end

% Drake passage transport
uh0=squeeze(uh0(:,13:30,210));
uh1=squeeze(uh1(:,13:30,210));
uh2=squeeze(uh2(:,13:30,210));
uh4=squeeze(uh4(:,13:30,210));
uh6=squeeze(uh6(:,13:30,210));
uh8=squeeze(uh8(:,13:30,210));

drake0=nansum(squeeze(nansum(uh0,2)))*1e-6;
drake1=nansum(squeeze(nansum(uh1,2)))*1e-6;
drake2=nansum(squeeze(nansum(uh2,2)))*1e-6;
drake4=nansum(squeeze(nansum(uh4,2)))*1e-6;
drake6=nansum(squeeze(nansum(uh6,2)))*1e-6;
drake8=nansum(squeeze(nansum(uh8,2)))*1e-6;

drake_all=[max(drake0) max(drake1) max(drake2) max(drake4) max(drake6) max(drake8)];

%save('matfiles/drake_passage_transport.mat','drake0','drake1','drake2','drake4','drake6','drake8')
save('matfiles/drake_passage_transport_layer.mat','drake0','drake1','drake2','drake4','drake6','drake8')



