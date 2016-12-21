%This subroutine computes AMOC in GOLD in depth space
clear all
layervsz='z'; % l for layer z for depth

if layervsz=='z'
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
elseif layervsz=='l'
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

if layervsz=='z'
	zt=nc_varget(flname0,'zt');
end
lon=nc_varget(flname0,'xh');
lat=nc_varget(flname0,'yh');

temp0=nc_varget(flname0,'temp');
temp1=nc_varget(flname1,'temp');
temp2=nc_varget(flname2,'temp');
temp4=nc_varget(flname4,'temp');
temp6=nc_varget(flname6,'temp');
temp8=nc_varget(flname8,'temp');
salt0=nc_varget(flname0,'salt');
salt1=nc_varget(flname1,'salt');
salt2=nc_varget(flname2,'salt');
salt4=nc_varget(flname4,'salt');
salt6=nc_varget(flname6,'salt');
salt8=nc_varget(flname8,'salt');

if layervsz=='l'
	e=nc_varget(flname0,'e');
	h0=e(1:end-1,:,:)-e(2:end,:,:);
	e=nc_varget(flname1,'e');
	h1=e(1:end-1,:,:)-e(2:end,:,:);
	e=nc_varget(flname2,'e');
	h2=e(1:end-1,:,:)-e(2:end,:,:);
	e=nc_varget(flname4,'e');
	h4=e(1:end-1,:,:)-e(2:end,:,:);
	e=nc_varget(flname6,'e');
	h6=e(1:end-1,:,:)-e(2:end,:,:);
	e=nc_varget(flname8,'e');
	h8=e(1:end-1,:,:)-e(2:end,:,:);
end

% density at 2000m
%dens0=sw_dens_new(salt0,temp0,2025*ones(size(temp0,1), size(temp0,2), size(temp0,3)))-1e3;
%dens1=sw_dens_new(salt1,temp1,2025*ones(size(temp0,1), size(temp0,2), size(temp0,3)))-1e3;
%dens2=sw_dens_new(salt2,temp2,2025*ones(size(temp0,1), size(temp0,2), size(temp0,3)))-1e3;
%dens4=sw_dens_new(salt4,temp4,2025*ones(size(temp0,1), size(temp0,2), size(temp0,3)))-1e3;
%dens6=sw_dens_new(salt6,temp6,2025*ones(size(temp0,1), size(temp0,2), size(temp0,3)))-1e3;
%dens8=sw_dens_new(salt8,temp8,2025*ones(size(temp0,1), size(temp0,2), size(temp0,3)))-1e3;

% density at 0 (i.e. potential density)
dens0=sw_dens_new(salt0,temp0,0*ones(size(temp0,1), size(temp0,2), size(temp0,3)))-1e3;
dens1=sw_dens_new(salt1,temp1,0*ones(size(temp0,1), size(temp0,2), size(temp0,3)))-1e3;
dens2=sw_dens_new(salt2,temp2,0*ones(size(temp0,1), size(temp0,2), size(temp0,3)))-1e3;
dens4=sw_dens_new(salt4,temp4,0*ones(size(temp0,1), size(temp0,2), size(temp0,3)))-1e3;
dens6=sw_dens_new(salt6,temp6,0*ones(size(temp0,1), size(temp0,2), size(temp0,3)))-1e3;
dens8=sw_dens_new(salt8,temp8,0*ones(size(temp0,1), size(temp0,2), size(temp0,3)))-1e3;

mask=double(nc_varget('/archive/gold/datasets/CM2G63L/tikal/mosaic.unpacked/basin.nc','basin'));
grdname2=['/archive/m1i/gold/global/Exp01.0/RESTART/ocean_geometry.nc']
area=(nc_varget(grdname2,'Ah')); 


if layervsz=='z'
save('matfiles/density_depth.mat','salt0','salt1','salt2','salt4','salt6','salt8', ...
                                  'temp0','temp1','temp2','temp4','temp6','temp8', ...
                                  'mask','area','lon','lat','zt')
	% for SO in depth coordinate
	mask(mask~=1)=0; % 1 SO
	mask3d=repmat(mask,[1 1 50]);
	mask3d=permute(mask3d,[3 1 2]);
	mask3d(isnan(temp0))=NaN;
	area3d=repmat(area,[1 1 50]);
	area3d=permute(area3d,[3 1 2]);
	% zonal average
	d0=mask3d.*dens0.*area3d;
	dnm=mask3d.*area3d;
	dd0=squeeze(nansum(d0,3))./squeeze(nansum(dnm,3));
elseif layervsz=='l'
save('matfiles/density_layer.mat','salt0','salt1','salt2','salt4','salt6','salt8', ...
                                  'temp0','temp1','temp2','temp4','temp6','temp8', ...
                                  'h0','h1','h2','h4','h6','h8', ...
                                  'mask','area','lon','lat')
end
