function [temp_canada salt_canada temp_eurasia salt_eurasia zt]= ...
         general_diagnostics_arctic_regions(expid,fyear,lyear,gridfile)

fill_value=-1e33;

t_woa09_file='/fimm/home/bjerknes/milicak/Analysis/NorESM/climatology/Analysis/t00an1.nc';
s_woa09_file='/fimm/home/bjerknes/milicak/Analysis/NorESM/climatology/Analysis/s00an1.nc';
mask_woa09_file='/fimm/home/bjerknes/milicak/Analysis/NorESM/general/Analysis/woa_mask.mat';

% Read WOA09 Southern Ocean mask
load([mask_woa09_file]);

% Load WOA09 data
if exist(['woa09an1.mat'])
  load(['woa09an1.mat'])
else
  lat=ncgetvar(t_woa09_file,'lat');
  lon=ncgetvar(t_woa09_file,'lon');
  depth=ncgetvar(t_woa09_file,'depth');
  t=ncgetvar(t_woa09_file,'t');
  s=ncgetvar(s_woa09_file,'s');
  [nx ny nz]=size(t);
  p=reshape(ones(nx*ny,1)*depth',nx,ny,nz);
  ptmp=theta_from_t(s,t,p,zeros(nx,ny,nz));
  save('woa09an1.mat','nx','ny','nz','lat','lon','depth','t','s','ptmp');
end
nx_b=nx;
ny_b=ny;
nz_b=nz;
lon_woa09=lon;
lat_woa09=lat;
depth_woa09=depth;
t_woa09=t;
s_woa09=s;
ptmp_woa09=ptmp;
clear nx ny nz lon lat depth t s ptmp

% Load time averaged model data
load(['matfiles/' expid '_timemean_' num2str(fyear) '_' num2str(lyear) '.mat'])
%load(['/export/grunchfs/unibjerknes/milicak/bckup/Analysis/NorESM/general/Analysis/matfiles/' expid '_timemean_' num2str(fyear) '_' num2str(lyear) '.mat']);
area=ncgetvar(gridfile,'parea');
lon=ncgetvar(gridfile,'plon');
lat=ncgetvar(gridfile,'plat');

% canada basin
[x]=load('canada_basin_lon.txt');
[y]=load('canada_basin_lat.txt');

in=insphpoly(lon,lat,x,y,0,90);
in=double(in);
in(in==0)=NaN;
in=repmat(in,[1 1 70]);
% temperature
tmp=templvl; 

area=repmat(area,[1 1 70]);
area(isnan(tmp))=NaN;
total_area=in.*area;
total_area=squeeze(nansum(total_area,2)); 
total_area=squeeze(nansum(total_area,1));

tmp2=tmp.*in.*area;
tmp2=squeeze(nansum(tmp2,2));
tmp2=squeeze(nansum(tmp2,1));
temp_canada=tmp2./total_area;

% salinity
tmp=salnlvl; 
tmp2=tmp.*in.*area;
tmp2=squeeze(nansum(tmp2,2));
tmp2=squeeze(nansum(tmp2,1));
salt_canada=tmp2./total_area;

% eurasia basin
[x]=load('eurasia_basin_lon.txt');
[y]=load('eurasia_basin_lat.txt');

in=insphpoly(lon,lat,x,y,0,90);
in=double(in);
in(in==0)=NaN;
in=repmat(in,[1 1 70]);
% temperature
tmp=templvl;

total_area=in.*area;
total_area=squeeze(nansum(total_area,2));
total_area=squeeze(nansum(total_area,1));

tmp2=tmp.*in.*area;
tmp2=squeeze(nansum(tmp2,2));
tmp2=squeeze(nansum(tmp2,1));
temp_eurasia=tmp2./total_area;

% salinity
tmp=salnlvl;
tmp2=tmp.*in.*area;
tmp2=squeeze(nansum(tmp2,2));
tmp2=squeeze(nansum(tmp2,1));
salt_eurasia=tmp2./total_area;
zt=depth;

save(['matfiles/' expid '_timemean_' num2str(fyear) '_' num2str(lyear) '_arctic_basin_profiles.mat'], ... 
      'temp_canada','salt_canada','temp_eurasia','salt_eurasia','depth')



