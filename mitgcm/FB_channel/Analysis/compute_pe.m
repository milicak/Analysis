clear all

gravity=9.8;
Kelvin2Celsius=273.15;
nz=50;

rootdir='/work/milicak/RUNS/CMIP5/ESM2M/'
gridfile='grid_spec_v6_regMask.nc';
areafile=[rootdir 'area/areacello_fx_GFDL-ESM2M_piControl_r0i0p0.nc'];
area=ncgetvar(areafile,'areacello');
bathyfile=[rootdir 'area/deptho_fx_GFDL-ESM2M_piControl_r0i0p0.nc'];
H=ncgetvar(bathyfile,'deptho');
H(isnan(H))=0;
area=repmat(area,[1 1 nz]);
lon=ncgetvar(gridfile,'geolon_c');
lat=ncgetvar(gridfile,'geolat_c');
tmask=ncgetvar(gridfile,'tmask');

area2d=ncgetvar(areafile,'areacello');
tmask2d=ncgetvar(gridfile,'tmask');
tmask2d(tmask2d~=1)=NaN; 
totalarea=area2d.*tmask2d;
totalarea=nansum(totalarea(:));

% Southern Ocean mask==1
nx=size(tmask,1);ny=size(tmask,2);

boundary_SO(1:nx,1:ny)=0;
for i=1:nx
for j=1:ny-1
if(tmask(i,j)==1 & tmask(i,j+1)~=1 & tmask(i,j+1)>0)
boundary_SO(i,j)=1;
else
boundary_SO(i,j)=0;
end
end
end
tmask(tmask~=1)=NaN;
tmask=repmat(tmask,[1 1 nz]);
boundary_SO=repmat(boundary_SO,[1 1 nz]);

yearsini=1861:5:2005;
yearsend=1865:5:2005;

real_ind=1;
for kind=1:length(yearsend)

filename_s=[rootdir 'so/so_Omon_GFDL-ESM2M_historical_r1i1p1_'  num2str(yearsini(kind)) '01-' num2str(yearsend(kind)) '12.nc'];
filename_t=[rootdir 'thetao/thetao_Omon_GFDL-ESM2M_historical_r1i1p1_'  num2str(yearsini(kind)) '01-' num2str(yearsend(kind)) '12.nc'];
filename_v=[rootdir 'vo/vo_Omon_GFDL-ESM2M_historical_r1i1p1_'  num2str(yearsini(kind)) '01-' num2str(yearsend(kind)) '12.nc'];
filename_w=[rootdir 'wmo/wmo_Omon_GFDL-ESM2M_historical_r1i1p1_'  num2str(yearsini(kind)) '01-' num2str(yearsend(kind)) '12.nc'];
filename_dzt=[rootdir 'thkcello/thkcello_Omon_GFDL-ESM2M_historical_r1i1p1_'  num2str(yearsini(kind)) '01-' num2str(yearsend(kind)) '12.nc'];

time=ncgetvar(filename_s,'time');
salt=double(ncgetvar(filename_s,'so'));
temp=double(ncgetvar(filename_t,'thetao'));
temp=temp-Kelvin2Celsius;
v_velocity=double(ncgetvar(filename_v,'vo'));
wmo=double(ncgetvar(filename_w,'wmo'));
dzt=double(ncgetvar(filename_dzt,'thkcello'));
dzt(isnan(dzt)==1)=0;

 for timeind=1:length(time)
  Time(real_ind)=time(timeind);
  thetas=temp(:,:,:,timeind);
  salts=salt(:,:,:,timeind);
  vvels=v_velocity(:,:,:,timeind);
  dzts=dzt(:,:,:,timeind);
  wmos=wmo(:,:,:,timeind);
  ps=int_for_p(thetas,salts,dzts,gravity);
  %ps=2000e4+0*zs; % uncomment to use sigma2 for BPE calculation
  rhos=wright_eos2(thetas,salts,ps);
  % PE= g*rho*z*dz*dx*dy
  zw(1:nx,1:ny,nz+1)=H;
  for k=nz:-1:1
    zw(:,:,k)=zw(:,:,k+1)-dzts(:,:,k);
  end
  zt=0.5*(zw(:,:,1:end-1)+zw(:,:,2:end));
  tmp=gravity.*rhos.*dzts.*zt.*area; %convert to PetaWatt (PW) early, it might help in precision
  tmp=tmp.*tmask; % SO mask
  pe(real_ind)=nansum(tmp(:));
  clear tmp
  % Advect_PE = -g*rho*z*V*dz*dx
  tmp=-gravity.*rhos.*vvels.*zt.*boundary_SO.*dzts.*111e3;
  peadvect(real_ind)=nansum(tmp(:));
  clear tmp
  % PE2KE = g*(rho*w*dx*dy)*dz
  tmp=wmos.*gravity.*dzts.*tmask;
  pe2ke(real_ind)=nansum(tmp(:));
  clear tmp
  real_ind=real_ind+1
 end %timeind

end %kind

plot((pe(2:end)-pe(1:end-1))./((Time(2:end)-Time(1:end-1)).*86400),'-*')


