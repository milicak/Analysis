function [status]=create_climatology_netcdf4(grd,clmfile)

% Create netcdf file.
ncid=netcdf.create(clmfile,'NC_64BIT_OFFSET');
%ncid=netcdf.create(clmfile,'NC_CLOBBER');


% Define dimensions.

onetime_dimid=netcdf.defDim(ncid,'one_time',1);
zetatime_dimid=netcdf.defDim(ncid,'zeta_time',366);
v2dtime_dimid=netcdf.defDim(ncid,'v2d_time',366);
v3dtime_dimid=netcdf.defDim(ncid,'v3d_time',366);
temptime_dimid=netcdf.defDim(ncid,'temp_time',366);
salttime_dimid=netcdf.defDim(ncid,'salt_time',366);

nir_dimid=netcdf.defDim(ncid,'xi_rho',grd.Lp);
niu_dimid=netcdf.defDim(ncid,'xi_u',grd.Lp-1);
niv_dimid=netcdf.defDim(ncid,'xi_v',grd.Lp);
nip_dimid=netcdf.defDim(ncid,'xi_psi',grd.Lp-1);

njr_dimid=netcdf.defDim(ncid,'eta_rho',grd.Mp);
nju_dimid=netcdf.defDim(ncid,'eta_u',grd.Mp);
njv_dimid=netcdf.defDim(ncid,'eta_v',grd.Mp-1);
njp_dimid=netcdf.defDim(ncid,'eta_psi',grd.Mp-1);

nzr_dimid=netcdf.defDim(ncid,'s_rho',grd.N);
nzw_dimid=netcdf.defDim(ncid,'s_w',grd.N+1);
nzt_dimid=netcdf.defDim(ncid,'tracer',grd.N);


% Define variables and assign attributes
zetatime_varid=netcdf.defVar(ncid,'zeta_time','float',zetatime_dimid);
netcdf.putAtt(ncid,zetatime_varid,'long_name','time for zeta climatology');
netcdf.putAtt(ncid,zetatime_varid,'units','days');

v2dtime_varid=netcdf.defVar(ncid,'v2d_time','float',v2dtime_dimid);
netcdf.putAtt(ncid,v2dtime_varid,'long_name','time for 2d velocity climatology');
netcdf.putAtt(ncid,v2dtime_varid,'units','days');

v3dtime_varid=netcdf.defVar(ncid,'v3d_time','float',v3dtime_dimid);
netcdf.putAtt(ncid,v3dtime_varid,'long_name','time for 3d velocity climatology');
netcdf.putAtt(ncid,v3dtime_varid,'units','days');

temptime_varid=netcdf.defVar(ncid,'temp_time','float',temptime_dimid);
netcdf.putAtt(ncid,temptime_varid,'long_name','time for 3d temperature climatology');
netcdf.putAtt(ncid,temptime_varid,'units','days');

salttime_varid=netcdf.defVar(ncid,'salt_time','float',salttime_dimid);
netcdf.putAtt(ncid,salttime_varid,'long_name','time for 3d salinity climatology');
netcdf.putAtt(ncid,salttime_varid,'units','days');


csr_varid=netcdf.defVar(ncid,'Cs_r','float',[nzr_dimid]);
netcdf.putAtt(ncid,csr_varid,'long_name','S-coordinate stretching function at RHO-points');

csw_varid=netcdf.defVar(ncid,'Cs_w','float',[nzw_dimid]);
netcdf.putAtt(ncid,csw_varid,'long_name','S-coordinate stretching function at W-points');

tcline_varid=netcdf.defVar(ncid,'Tcline','float',[onetime_dimid]);
netcdf.putAtt(ncid,tcline_varid,'long_name','S-coordinate surface/bottom layer width');
netcdf.putAtt(ncid,tcline_varid,'units','meter');

vstr_varid=netcdf.defVar(ncid,'Vstretching','int',[onetime_dimid]);
netcdf.putAtt(ncid,vstr_varid,'long_name','vertical terrain-following stretching function');

vtra_varid=netcdf.defVar(ncid,'Vtransform','int',[onetime_dimid]);
netcdf.putAtt(ncid,vtra_varid,'long_name','vertical terrain-following transformation equation');

hc_varid=netcdf.defVar(ncid,'hc','float',[onetime_dimid]);
netcdf.putAtt(ncid,hc_varid,'long_name','S-coordinate parameter, critical depth');
netcdf.putAtt(ncid,hc_varid,'units','meter');

lonr_varid=netcdf.defVar(ncid,'lon_rho','float',[nir_dimid njr_dimid]);
netcdf.putAtt(ncid,lonr_varid,'long_name','longitude of RHO-points');
netcdf.putAtt(ncid,lonr_varid,'units','degrees_east');

lonu_varid=netcdf.defVar(ncid,'lon_u','float',[niu_dimid nju_dimid]);
netcdf.putAtt(ncid,lonu_varid,'long_name','longitude of U-points');
netcdf.putAtt(ncid,lonu_varid,'units','degrees_east');

lonv_varid=netcdf.defVar(ncid,'lon_v','float',[niv_dimid njv_dimid]);
netcdf.putAtt(ncid,lonv_varid,'long_name','longitude of V-points');
netcdf.putAtt(ncid,lonv_varid,'units','degrees_east');

latr_varid=netcdf.defVar(ncid,'lat_rho','float',[nir_dimid njr_dimid]);
netcdf.putAtt(ncid,latr_varid,'long_name','latitude of RHO-points');
netcdf.putAtt(ncid,latr_varid,'units','degrees_north');

latu_varid=netcdf.defVar(ncid,'lat_u','float',[niu_dimid nju_dimid]);
netcdf.putAtt(ncid,latu_varid,'long_name','latitude of U-points');
netcdf.putAtt(ncid,latu_varid,'units','degrees_north');

latv_varid=netcdf.defVar(ncid,'lat_v','float',[niv_dimid njv_dimid]);
netcdf.putAtt(ncid,latv_varid,'long_name','latitude of V-points');
netcdf.putAtt(ncid,latv_varid,'units','degrees_north');

zeta_varid=netcdf.defVar(ncid,'zeta','float',[nir_dimid njr_dimid v2dtime_dimid]);
netcdf.putAtt(ncid,zeta_varid,'long_name','sea surface height climatology');
netcdf.putAtt(ncid,zeta_varid,'units','meter');
netcdf.putAtt(ncid,zeta_varid,'coordinates','lon_rho lat_rho');

ubar_varid=netcdf.defVar(ncid,'ubar','float',[niu_dimid nju_dimid v2dtime_dimid]);
netcdf.putAtt(ncid,ubar_varid,'long_name','vertically integrated u-momentum component climatology');
netcdf.putAtt(ncid,ubar_varid,'units','m s-1');
netcdf.putAtt(ncid,ubar_varid,'coordinates','lon_u lat_u');

vbar_varid=netcdf.defVar(ncid,'vbar','float',[niv_dimid njv_dimid v2dtime_dimid]);
netcdf.putAtt(ncid,vbar_varid,'long_name','vertically integrated v-momentum component climatology');
netcdf.putAtt(ncid,vbar_varid,'units','m s-1');
netcdf.putAtt(ncid,vbar_varid,'coordinates','lon_v lat_v');

hbathy_varid=netcdf.defVar(ncid,'h','float',[nir_dimid njr_dimid]);
netcdf.putAtt(ncid,hbathy_varid,'long_name','bathymetry of RHO-points');
netcdf.putAtt(ncid,hbathy_varid,'units','meter');

srho_varid=netcdf.defVar(ncid,'s_rho','float',[nzw_dimid]);
netcdf.putAtt(ncid,srho_varid,'long_name','S-coordinate at RHO-points');

sw_varid=netcdf.defVar(ncid,'s_w','float',[nzw_dimid]);
netcdf.putAtt(ncid,sw_varid,'long_name','S-coordinate at W-points');

thb_varid=netcdf.defVar(ncid,'theta_b','float',[onetime_dimid]);
netcdf.putAtt(ncid,thb_varid,'long_name','S-coordinate bottom control parameter');

ths_varid=netcdf.defVar(ncid,'theta_s','float',[onetime_dimid]);
netcdf.putAtt(ncid,ths_varid,'long_name','S-coordinate surface control parameter');

uvel_varid=netcdf.defVar(ncid,'u','float',[niu_dimid nju_dimid nzr_dimid v3dtime_dimid]);
netcdf.putAtt(ncid,uvel_varid,'long_name','u-momentum component climatology');
netcdf.putAtt(ncid,uvel_varid,'units','m s-1');
netcdf.putAtt(ncid,uvel_varid,'coordinates','lon_u lat_u');

% Global attributes

% End definitions and leave define mode.
netcdf.endDef(ncid)


% Provide values for time invariant variables.
netcdf.putVar(ncid,lonr_varid,grd.lonr);
netcdf.putVar(ncid,lonu_varid,grd.lonu);
netcdf.putVar(ncid,lonv_varid,grd.lonv);
netcdf.putVar(ncid,latr_varid,grd.latr);
netcdf.putVar(ncid,latu_varid,grd.latu);
netcdf.putVar(ncid,latv_varid,grd.latv);
netcdf.putVar(ncid,hc_varid,grd.hc);
netcdf.putVar(ncid,hbathy_varid,grd.h);
netcdf.putVar(ncid,tcline_varid,grd.hc);
netcdf.putVar(ncid,vstr_varid,grd.vstr);
netcdf.putVar(ncid,vtra_varid,grd.vtra);
netcdf.putVar(ncid,thb_varid,grd.theta_b);
netcdf.putVar(ncid,ths_varid,grd.theta_s);

% Close netcdf file
netcdf.close(ncid)

