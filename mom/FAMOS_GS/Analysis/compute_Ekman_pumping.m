clear all

%project_name = 'om3_core3_2'
%project_name = 'om3_core3_2_BG_neg'
%project_name = 'om3_core3_2_BG_pos'
%project_name = 'om3_core3_2_GS_neg'
project_name = 'om3_core3_2_GS_pos'
%project_name = 'om3_core3_ctrl'
%root_folder = '/hexagon/work/milicak/RUNS/mom/' ;
%root_folder = '/export/grunchfs/unibjerknes/milicak/bckup/mom/FAMOS/';
root_folder = '/shared/projects/uniklima/globclim/milicak/mom/FAMOS/';

fname = [root_folder project_name '/om3_core3/history/tau_curl_19480101.ocean_month.nc'];
%aname = '/export/grunchfs/unibjerknes/milicak/bckup/noresm/CORE2/Arctic/DATA/gfdl-mom/grids_bathymetry/ocean.static.nc';
aname = '/work/users/mil021/RUNS/mom/FAMOS/om3_core3_2/om3_core3/history/ocean.static.nc';

taucurl = ncread(fname,'tau_curl');
taucurl = squeeze(taucurl(:,:,end-347:end));

rhozero = 1027;

lon = ncread(aname,'geolon_t');
lat = ncread(aname,'geolat_t');

fcor = coriolis(lat);

% Ekman pumping velocity ==> W_ek = curl(tau)/(rho*f)
fcor = repmat(fcor,[1 1 size(taucurl,3)]);
w_Ek0 = taucurl./(rhozero.*fcor);


savename = ['matfiles/' project_name '_w_Ek.mat']
save(savename,'w_Ek0','lon','lat')
