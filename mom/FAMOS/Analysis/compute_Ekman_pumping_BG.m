clear all

%project_name = 'om3_core3_2'
%project_name = 'om3_core3_2_BG_neg'
project_name = 'om3_core3_2_BG_pos'
%project_name = 'om3_core3_2_GS_neg'
%project_name = 'om3_core3_2_GS_pos'
%project_name = 'om3_core3_ctrl'
%root_folder = '/hexagon/work/milicak/RUNS/mom/' ;
%root_folder = '/export/grunchfs/unibjerknes/milicak/bckup/mom/FAMOS/';
root_folder = '/shared/projects/uniklima/globclim/milicak/mom/FAMOS/';

fname = [root_folder project_name '/om3_core3/history/tau_curl_19480101.ocean_month.nc'];
%aname = '/export/grunchfs/unibjerknes/milicak/bckup/noresm/CORE2/Arctic/DATA/gfdl-mom/grids_bathymetry/ocean.static.nc';
aname = '/work/users/mil021/RUNS/mom/FAMOS/om3_core3_2/om3_core3/history/ocean.static.nc';
depth = ncread(aname,'ht');
mask2 = ones(size(depth,1),size(depth,2));
mask2(depth<300) = 0;

taucurl = ncread(fname,'tau_curl');
area = ncread(aname,'area_t');
areau = ncread(aname,'area_u');

fname = [root_folder project_name '/om3_core3/history/pot_rho_0_19480101.ocean_month.nc'];
rho0 = squeeze(ncread(fname,'pot_rho_0',[1 1 1 1],[Inf Inf 1 Inf]));
rhozero = 1027;

lon = ncread(aname,'geolon_t');
lonu = ncread(aname,'geolon_c');
lat = ncread(aname,'geolat_t');
latu = ncread(aname,'geolat_c');
% Beaufort Gyre mask                                                            
lon1 = [-130 -130 -170 -170];                                                   
lat1 = [70.5 80.5 80.5 70.5];                                                   
lon1(end+1) = lon1(1);                                                          
lat1(end+1) = lat1(1);                                                          
in = insphpoly(lon,lat,lon1,lat1,0.,90.);                                       
in = double(in);
inu = insphpoly(lonu,latu,lon1,lat1,0.,90.);                                       
inu = double(inu);

fcor = coriolis(lat);
fcoru = coriolis(latu);

% Ekman pumping velocity ==> W_ek = curl(tau)/(rho*f)
area = repmat(area,[1 1 size(taucurl,3)]);
areau = repmat(areau,[1 1 size(taucurl,3)]);
mask = repmat(in,[1 1 size(taucurl,3)]);
masku = repmat(inu,[1 1 size(taucurl,3)]);
fcor = repmat(fcor,[1 1 size(taucurl,3)]);
fcoru = repmat(fcoru,[1 1 size(taucurl,3)]);
mask2 = repmat(mask2,[1 1 size(taucurl,3)]);
w_Ek = taucurl./(rho0.*fcor);
w_Ek0 = taucurl./(rhozero.*fcor);
w_Ek0u = taucurl./(rhozero.*fcoru);

w_Eka = w_Ek.*mask.*area.*mask2;
w_Eka0 = w_Ek0.*mask.*area.*mask2;
w_Eka0u = w_Ek0u.*masku.*areau.*mask2;
areasum = area.*mask.*mask2;
areasumu = areau.*masku.*mask2;

w_Eka = squeeze(nansum(w_Eka,1));
w_Eka = squeeze(nansum(w_Eka,1));
w_Eka0 = squeeze(nansum(w_Eka0,1));
w_Eka0 = squeeze(nansum(w_Eka0,1));
w_Eka0u = squeeze(nansum(w_Eka0u,1));
w_Eka0u = squeeze(nansum(w_Eka0u,1));
areasum = squeeze(nansum(areasum,1));
areasum = squeeze(nansum(areasum,1));
areasumu = squeeze(nansum(areasumu,1));
areasumu = squeeze(nansum(areasumu,1));
w_Ek = w_Eka./areasum;
w_Ek0 = w_Eka0./areasum;
w_Ek0u = w_Eka0u./areasumu;

savename = ['matfiles/' project_name '_w_Ek_BG.mat']
save(savename,'w_Ek','w_Ek0','w_Ek0u')
