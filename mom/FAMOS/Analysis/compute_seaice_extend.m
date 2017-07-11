clear all

fice_cr = 0.15;
%project_name = 'om3_core3_2'
project_name = 'om3_core3_2_BG_neg'
%project_name = 'om3_core3_2_GS_neg'
root_folder = '/hexagon/work/milicak/RUNS/mom/' ;

fname = [root_folder project_name '/om3_core3/history/00010101.ice_month.nc'];
aname = '/export/grunchfs/unibjerknes/milicak/bckup/noresm/CORE2/Arctic/DATA/gfdl-mom/grids_bathymetry/ocean.static.nc';

fice = ncread(fname,'CN');
area = ncread(aname,'area_t');

fice = squeeze(nansum(fice,3));
fice(fice<fice_cr) = 0.0;
area = repmat(area,[1 1 size(fice,3)]);
xice = fice.*area;
xice = xice(:,100:end,:);
xice = squeeze(nansum(xice,1));
xice = squeeze(nansum(xice,1));

xice = xice';
xice = reshape(xice,[12 length(xice)/12]);

