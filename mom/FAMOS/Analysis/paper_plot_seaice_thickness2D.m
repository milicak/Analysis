clear all

project_name = [{'om3_core3_2'} {'om3_core3_2_BG_neg'} {'om3_core3_2_BG_pos'}]; 
project_name2 = [{'ctrl'} {'BG_neg'} {'BG_pos'}];

%project_name = [{'om3_core3_2'} {'om3_core3_2_BG_neg'} {'om3_core3_2_BG_pos'} {'om3_core3_2_GS_neg'} {'om3_core3_2_GS_pos'}];
%project_name2 = [{'ctrl'} {'BG_neg'} {'BG_pos'} {'GS_neg'} {'GS_pos'}];

time = 1980:2009;
indstr = 1999-1948+1;
ice_thickness_ann = containers.Map;
ice_thickness_sep = containers.Map;
ice_thickness_mar = containers.Map;
aname = '/export/grunchfs/unibjerknes/milicak/bckup/noresm/CORE2/Arctic/DATA/gfdl-mom/grids_bathymetry/ocean.static.nc';

lon=ncread(aname,'geolon_t');
lat=ncread(aname,'geolat_t');

for i = 1:length(project_name)
    fname = ['matfiles/' project_name{i} '_ice_thickness.mat'];
    load(fname);
    hice = nanmean(squeeze(hice(:,:,:,indstr:end)),4);
    ice_thickness_ann(project_name2{i}) = squeeze(nanmean(hice,3));
    ice_thickness_mar(project_name2{i}) = squeeze(hice(:,:,3));
    ice_thickness_sep(project_name2{i}) = squeeze(hice(:,:,9));
end
save('matfiles/ITU-MOM_2D_ice_thickness.mat','ice_thickness_ann','ice_thickness_mar','ice_thickness_sep');


figure(1)
m_projpolar
m_pcolor(lon,lat,ice_thickness_ann('BG_pos')-ice_thickness_ann('ctrl'));shf
caxis([-1.5 1.5])
colormap(bluewhitered(32))
m_coast('patch',[.7 .7 .7])
m_grid
title('BG-pos');
printname = ['paperfigs/seaice_thickness_BG_pos_annual_anomaly_map.eps'];
print(1,'-depsc2','-r300',printname)

figure(2)
m_projpolar
m_pcolor(lon,lat,ice_thickness_ann('BG_neg')-ice_thickness_ann('ctrl'));shf
caxis([-1.5 1.5])
colormap(bluewhitered(32))
m_coast('patch',[.7 .7 .7])
m_grid
title('BG-neg');
printname = ['paperfigs/seaice_thickness_BG_neg_annual_anomaly_map.eps'];
print(2,'-depsc2','-r300',printname)
