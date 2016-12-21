clear all
%method='linear';                  % linear interpolation
 method='spline';                  % spline interpolation

display('first run create_climatology_blacksea file')

roms_clm_name='blacksea-clim_all.nc';
roms_grd_name='blacksea-grid.nc';
%clm_name='../../blacksea/Analysis/myocean_blacksea_tempsaltvel_01_01_2012_to_12_31_2012.nc'; %old one
clm_name='../../blacksea/Analysis/Eastern_BlackSea_reanalysis_2012.nc';

nameit='blacksea';

grd=rnt_gridload(nameit);
grd.vtra = 1;
grd.vstr = 4;
grd.theta_s = 5.0;
grd.theta_b = 0.4;

datadir='.';
outdir='./';


% get variables from the climatology file
lonclm=nc_varget(clm_name,'lon');
latclm=nc_varget(clm_name,'lat');
depthclm=ncgetvar(clm_name,'dep');
timeclm=ncgetvar(clm_name,'time');
[Nyclim Nxclim]=size(latclm);
depthclm3D=repmat(depthclm,[1 Nyclim Nxclim]);
Nzclim=length(depthclm);
lonclm3D=repmat(lonclm,[1 1 Nzclim]);
latclm3D=repmat(latclm,[1 1 Nzclim]);
lonclm3D=permute(lonclm3D,[3 1 2]);
latclm3D=permute(latclm3D,[3 1 2]);
timedays=timeclm+datenum(1992,01,01,0,0,0);
datestr(timedays(1))
%datestr(timedays)
K=length(depthclm);
%z_r=rnt_setdepth(0,grd);
%  Compute depths at horizontal and vertical RHO-points.
%--------------------------------------------------------------------------
igrid = 1;
grd.zeta = zeros(size(grd.h));
[z_r] = set_depth(grd.Vtransform, grd.Vstretching,                          ...
                  grd.theta_s, grd.theta_b, grd.hc, grd.N,                      ...
                 igrid, grd.h, grd.zeta);
nn=0;
for ind=1:15:length(timeclm)
   nn=nn+1;
   tempclm=nc_varget(clm_name,'sea_water_temperature',[ind-1 0 0 0],[1 -1 -1 -1])-273.15;
   saltclm=nc_varget(clm_name,'sea_water_salinity',[ind-1 0 0 0],[1 -1 -1 -1]);
   uvelclm=nc_varget(clm_name,'eastward_sea_water_velocity',[ind-1 0 0 0],[1 -1 -1 -1]);
   vvelclm=nc_varget(clm_name,'northward_sea_water_velocity',[ind-1 0 0 0],[1 -1 -1 -1]);
   sshclm=nc_varget(clm_name,'sea_surface_height_above_sea_level',[ind-1 0 0],[1 -1 -1]);
  
   %initial values are set to 0;
   temproms=zeros(grd.Lp,grd.Mp,grd.N);
   saltroms=zeros(grd.Lp,grd.Mp,grd.N);
   uvelroms=zeros(grd.L ,grd.Mp,grd.N);
   vvelroms=zeros(grd.Lp,grd.M ,grd.N);


   % fill missing values of sshclm
   sshclm=get_missing_val(lonclm,latclm,sshclm,NaN,0);
   sshroms=griddata(lonclm,latclm,sshclm,grd.lonr,grd.latr,'cubic');
   sshroms=sshroms.*grd.maskr;

   % fill missing values of tracers and interpolate lon lat of roms grid with z of climatology
   tempZ=zeros(grd.Lp,grd.Mp,K);
   saltZ=zeros(grd.Lp,grd.Mp,K);
   for k=1:K
       dnm=get_missing_val(lonclm,latclm,squeeze(tempclm(k,:,:)),NaN,0);
       tempZ(:,:,k)=griddata(lonclm,latclm,dnm,grd.lonr,grd.latr,'cubic');
       dnm=get_missing_val(lonclm,latclm,squeeze(saltclm(k,:,:)),NaN,0);
       saltZ(:,:,k)=griddata(lonclm,latclm,dnm,grd.lonr,grd.latr,'cubic');
       display(['tracers are interpolated at level = ' num2str(k)])
   end
   saltZ(isnan(saltZ))=0;
   tempZ(isnan(tempZ))=0;
   % interpolate Z grid to s-grid
   for j=1:grd.Mp
      for i=1:grd.Lp
	Zroms = squeeze(z_r(i,j,:));
        Toa   = squeeze(tempZ(i,j,:));
        Soa   = squeeze(saltZ(i,j,:));
        temproms(i,j,:) = interp1(-depthclm, Toa, Zroms, method).*grd.maskr(i,j);
        saltroms(i,j,:) = interp1(-depthclm, Soa, Zroms, method).*grd.maskr(i,j);
      end
   end
%%%%%% Write the netcdf file %%%%%%
   ncid = netcdf.open(roms_clm_name,'WRITE');
   varid = netcdf.inqVarID(ncid,'temp');
                           %nx ny nz time
   netcdf.putVar(ncid,varid,[0 0 0 nn-1],[grd.Lp grd.Mp grd.N 1],temproms);
   varid = netcdf.inqVarID(ncid,'temp_time');
   netcdf.putVar(ncid,varid,[nn-1],[1],timedays(ind));
   varid = netcdf.inqVarID(ncid,'salt');
   netcdf.putVar(ncid,varid,[0 0 0 nn-1],[grd.Lp grd.Mp grd.N 1],saltroms);
   varid = netcdf.inqVarID(ncid,'salt_time');
   netcdf.putVar(ncid,varid,[nn-1],[1],timedays(ind));
   varid = netcdf.inqVarID(ncid,'zeta');
   netcdf.putVar(ncid,varid,[0 0 nn-1],[grd.Lp grd.Mp 1],sshroms);
   varid = netcdf.inqVarID(ncid,'zeta_time');
   netcdf.putVar(ncid,varid,[nn-1],[1],timedays(ind));
   netcdf.close(ncid);
 
   % fill missing values of velocities and interpolate lon lat of roms grid with z of climatology
   uvelZ=zeros(grd.L,grd.Mp,K);
   vvelZ=zeros(grd.Lp,grd.M,K);
   for k=1:K
       dnm=get_missing_val(lonclm,latclm,squeeze(uvelclm(k,:,:)),NaN,0);
       uvelZ(:,:,k)=griddata(lonclm,latclm,dnm,grd.lonu,grd.latu,'cubic');
       dnm=get_missing_val(lonclm,latclm,squeeze(vvelclm(k,:,:)),NaN,0);
       vvelZ(:,:,k)=griddata(lonclm,latclm,dnm,grd.lonv,grd.latv,'cubic');              
       display(['velocities are interpolated at level = ' num2str(k)])
   end
   uvelZ(isnan(uvelZ))=0;
   vvelZ(isnan(vvelZ))=0;
   % interpolate Z grid to s-grid
   for j=1:grd.Mp
      for i=1:grd.L
	Zroms = squeeze(z_r(i,j,:));
        Uoa   = squeeze(uvelZ(i,j,:));
        uvelroms(i,j,:) = interp1(-depthclm, Uoa, Zroms, method)*grd.masku(i,j);
      end
   end
   for j=1:grd.M
      for i=1:grd.Lp
        Zroms = squeeze(z_r(i,j,:));
        Voa   = squeeze(vvelZ(i,j,:));
        vvelroms(i,j,:) = interp1(-depthclm, Voa, Zroms, method)*grd.maskv(i,j);
      end
   end

   [ubar,vbar]=uv_barotropic(uvelroms,vvelroms,z_r);
   
%%%%%% Write the netcdf file %%%%%%
   ncid = netcdf.open(roms_clm_name,'WRITE');
   varid = netcdf.inqVarID(ncid,'u');
   netcdf.putVar(ncid,varid,[0 0 0 nn-1],[grd.L grd.Mp grd.N 1],uvelroms);
   varid = netcdf.inqVarID(ncid,'v');
   netcdf.putVar(ncid,varid,[0 0 0 nn-1],[grd.Lp grd.M grd.N 1],vvelroms);
   varid = netcdf.inqVarID(ncid,'ubar');
   netcdf.putVar(ncid,varid,[0 0 nn-1],[grd.L grd.Mp 1],ubar);
   varid = netcdf.inqVarID(ncid,'vbar');
   netcdf.putVar(ncid,varid,[0 0 nn-1],[grd.Lp grd.M 1],vbar);
   varid = netcdf.inqVarID(ncid,'v2d_time');
   netcdf.putVar(ncid,varid,[nn-1],[1],timedays(ind));
   varid = netcdf.inqVarID(ncid,'v3d_time');
   netcdf.putVar(ncid,varid,[nn-1],[1],timedays(ind));
   netcdf.close(ncid);

   ind

end %ind
