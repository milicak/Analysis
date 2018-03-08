clear all

project_name = 'om3_core3_2'
%project_name = 'om3_core3_2_BG_neg'
%project_name = 'om3_core3_2_GS_neg'
%project_name = 'om3_core3_2_BG_pos'
%project_name = 'om3_core3_2_GS_pos'
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

k = 1;
for time = 385:3:720
    no=num2str(k,'%.4d');
    tr4 = ncread(fname4,'passive_tracer04',[1 1 1 time],[Inf Inf 1 1]);
    hhh=figure('Visible','off');
    %set(gcf, 'units', 'centimeters', 'pos', [0 0 22.5 10])
    %set(gcf, 'PaperPositionMode','auto')
    m_projpolar
    m_pcolor(lon,lat,tr4);shading interp
    needJet2
    caxis([0 1])
    m_coast('patch',[.7 .7 .7])
    m_grid
    printname=['gifs/tracer_' no];                                    
    print(hhh,'-r300','-dpng',printname)
    k = k+1
end
%return

