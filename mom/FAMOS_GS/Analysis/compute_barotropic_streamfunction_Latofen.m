clear all

aname = '/export/grunchfs/unibjerknes/milicak/bckup/noresm/CORE2/Arctic/DATA/gfdl-mom/grids_bathymetry/ocean.static.nc';

lon = ncread(aname,'geolon_t');
lat = ncread(aname,'geolat_t');
lon1=[-1 9 9 -1 -1]; lat1=[69 69 72 72 69];
in = insphpoly(lon,lat,lon1,lat1,0,90);
in = double(in);
totalpnts = nansum(in(:));

ctl = ncread('data/ITU-MOM/om3_core3_2_barotropic_streamfunction.nc','ctlBT_streamfunction');
gsp = ncread('data/ITU-MOM/om3_core3_2_GS_pos_barotropic_streamfunction.nc','gspBT_streamfunction');
gsn = ncread('data/ITU-MOM/om3_core3_2_GS_neg_barotropic_streamfunction.nc','gsnBT_streamfunction');

in = repmat(in,[1 1 size(ctl,1)]);
in = permute(in,[3 1 2]);
ctl = ctl.*in;
gsp = gsp.*in;
gsn = gsn.*in;

ctl = squeeze(nansum(ctl,2));
ctl = squeeze(nansum(ctl,2));
gsp = squeeze(nansum(gsp,2));
gsp = squeeze(nansum(gsp,2));
gsn = squeeze(nansum(gsn,2));
gsn = squeeze(nansum(gsn,2));

% mean 
ctl = ctl./totalpnts;
gsp = gsp./totalpnts;
gsn = gsn./totalpnts;

ctl_BT = ctl;
gsp_BT = gsp;
gsn_BT = gsn;

save('ITU-MOM_Latofen_BT_streamfunction.mat','ctl_BT','gsp_BT','gsn_BT')
