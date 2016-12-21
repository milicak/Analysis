clear all
grav=9.8;
Kelvin2Celsius=273.15;
nz=50;

rootdir='/work/milicak/RUNS/CMIP5/ESM2M/'
gridfile='grid_spec_v6_regMask.nc';
bathyfile=[rootdir 'area/deptho_fx_GFDL-ESM2M_piControl_r0i0p0.nc'];
H=ncgetvar(bathyfile,'deptho');
H(isnan(H))=0;
areafile=[rootdir 'area/areacello_fx_GFDL-ESM2M_piControl_r0i0p0.nc'];
area=ncgetvar(areafile,'areacello');
lon=ncgetvar(gridfile,'geolon_c');
lat=ncgetvar(gridfile,'geolat_c');

tmask=ncgetvar(gridfile,'tmask');
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
tmask(tmask~=1)=0;
area=area.*tmask; H=H.*tmask;
tmask=repmat(tmask,[1 1 nz]);
boundary_SO=repmat(boundary_SO,[1 1 nz]);

BPE=[];
FBPE=[];
HPE=[];

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
dzt=double(ncgetvar(filename_dzt,'thkcello'));
dzt(isnan(dzt)==1)=0; 


for timeind=1:length(time)
  Time(real_ind)=time(timeind);
  T=temp(:,:,:,timeind);
  S=salt(:,:,:,timeind);
  dzts=dzt(:,:,:,timeind);
  T=T.*tmask;
  S=S.*tmask;
  dzts=dzts.*tmask;
  eta=-H+squeeze(sum(dzts,3));

  if real_ind==1
   [h_sorted, vol_sorted] = sort_topog_eta(-H,eta,area);
  else
    h_sorted(end)=sum(eta(:).*area(:))./sum(area(:));
  end
 [BPE(end+1) FBPE(end+1) HPE(end+1)]=bpe_calc2(T,S,dzts,area,H,h_sorted,vol_sorted,grav);
  %fprintf('bpe_mom: timings, %f s, %f s, %f s. BPE=%g J/m^2\n',tim1,tim2,tim3,BPE(end))
  real_ind=real_ind+1

end %timeind

end % kind




