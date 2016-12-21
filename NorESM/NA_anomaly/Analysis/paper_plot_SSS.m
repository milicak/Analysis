clear all

folder_name='/export/grunchfs/unibjerknes/milicak/bckup/Analysis/NorESM/general/Analysis/matfiles/';

% tripolar 1degree grid
%grid_file='/fimm/home/bjerknes/milicak/Analysis/NorESM/climatology/Analysis/grid.nc';
% tripolar 0.25degree grid
grid_file = '/bcmhsm/milicak/RUNS/noresm/CORE2/Arctic/maps/grid_0_25degree.nc';

pclon=reshape(ncgetvar(grid_file,'pclon'),[],4)';
pclat=reshape(ncgetvar(grid_file,'pclat'),[],4)';

project_name='NOIIA_T62_tn025_001'
%project_name='NOIIA_T62_tn11_sr10m60d_01'

fyear=100;
lyear=120;

filename=[folder_name project_name '_timemean_' num2str(fyear) '_' num2str(lyear) '.mat']
load(filename)

lonpts=[-32.5 -21.5 -10.5 -2.5 3.5 11.5 10.5];
latpts=[52.5 53.5 58.5 60.5 63.5 68.5 76.5];


figure(1)
sss=squeeze(salnlvl(:,:,1));
m_proj('Equidistant Cylindrical','lon',[-180 180],'lat',[-90 90]);
micom_flat(sss,pclon,pclat)
shfn
caxis([25 40])
hold on
%m_plot(lonpts,latpts,'k-o','MarkerFaceColor','k','Markersize',3);
xlabel('Lon')
ylabel('Lat')
%     m_gshhs_l('patch',[.7 .7 .7]);
m_coast('patch',[.7 .7 .7]);
m_grid

printname=['paperfigs/' project_name '_sss.eps']
print(1,'-depsc2','-r300',printname)

%close

