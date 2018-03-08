clear all

%project_name = 'om3_core3_2'
%project_name = 'om3_core3_2_BG_neg'
%project_name = 'om3_core3_2_GS_neg'
%project_name = 'om3_core3_2_BG_pos'
project_name = 'om3_core3_2_GS_pos'
%project_name = 'om3_core3_ctrl'
%root_folder = '/hexagon/work/milicak/RUNS/mom/' ;
root_folder = '/mnt/grunchexport/';
%root_folder = '/export/grunchfs/unibjerknes/milicak/bckup/mom/';

fname1 = [root_folder 'mom/FAMOS/' project_name '/om3_core3/history/passive_tracer01_19480101.ocean_month.nc'];
fname2 = [root_folder 'mom/FAMOS/' project_name '/om3_core3/history/passive_tracer02_19480101.ocean_month.nc'];
fname4 = [root_folder 'mom/FAMOS/' project_name '/om3_core3/history/passive_tracer04_19480101.ocean_month.nc'];
aname = [root_folder 'noresm/CORE2/Arctic/DATA/gfdl-mom/grids_bathymetry/ocean.static.nc'];

area = ncread(aname,'area_t');
out = load('/mnt/grunchexport/grunchhome/milicak/Analysis/NorESM/Arctic_seaice/Analysis/region_masks.mat');
gridname = '/mnt/grunchexport/noresm/CORE2/Arctic/DATA/gfdl-mom/grids_bathymetry/ocean.static.nc';
lon = ncread(gridname,'geolon_t');
lat = ncread(gridname,'geolat_t');
return
regionnames = [{'KaraBarents'}];
in = insphpoly(lon,lat,out.lon1,out.lat1,0,90);
in = double(in);

k = 1;
for time = 385:720
   tr1 = ncread(fname1,'passive_tracer01',[1 1 1 time],[Inf Inf Inf 1]);
   tr1 = squeeze(nansum(tr1,1));
   tr1 = squeeze(nansum(tr1,1));
   tr1 = squeeze(nansum(tr1,2));
   tr01(k) = tr1;
   tr2 = ncread(fname2,'passive_tracer02',[1 1 1 time],[Inf Inf Inf 1]);
   tr2 = squeeze(nansum(tr2,1));
   tr2 = squeeze(nansum(tr2,1));
   tr2 = squeeze(nansum(tr2,2));
   tr02(k) = tr2;
   tr4 = ncread(fname4,'passive_tracer04',[1 1 1 time],[Inf Inf Inf 1]);
   tr4 = squeeze(nansum(tr4,1));
   tr4 = squeeze(nansum(tr4,1));
   tr4 = squeeze(nansum(tr4,2));
   tr04(k) = tr4;
   k = k+1
end
%return

%xice = xice';
%xice = reshape(xice,[12 length(xice)/12]);

savename = ['matfiles/' project_name '_tracers.mat']
save(savename,'tr01','tr02','tr04')
