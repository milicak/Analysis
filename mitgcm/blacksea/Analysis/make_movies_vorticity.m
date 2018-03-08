clear all
colormaptype = 'demcmap';
%colormaptype = 'gebcoland';
%colormaptype = 'gray';

root_folder = '/okyanus/users/milicak/models/MITgcm_c65/Projects/Blacksea_lonlat/work';
root_folder2 = '/okyanus/users/milicak/models/MITgcm_c65/Projects/Blacksea_lonlat/2011_exp2';

latg = rdmds([root_folder '/' 'YG']);
lon = rdmds([root_folder '/' 'XC']);
lat = rdmds([root_folder '/' 'YC']);
fcor = coriolis(latg);
level = 1; % surface plot

t0 = rdmds([root_folder2 '/' 'T'],0);
t0 = squeeze(t0(:,:,1));
mask = ones(size(t0,1),size(t0,2));
mask(t0~=0) = NaN;

k = 1;
for i=180:180
    no=num2str(k,'%.4d');
    vort = rdmds([root_folder2 '/' 'vorticity'],i*864);
    %figure(1)
    hhh=figure('Visible','off');
    set(gcf, 'units', 'centimeters', 'pos', [0 0 22.5 10])
    %set(gca, 'units', 'centimeters', 'pos', [2 1.2 15 8])
    set(gcf, 'PaperPositionMode','auto')
    %set(1, 'Position', [220 220 800 600])
    bb = pcolor(lon,latg,mask);shf
    hold on
    pcolor(lon,latg,sq(vort(:,:,level))./fcor); shfn
    shading interp
    colormap(bluewhitered(64))
    caxis([-1 1])
    %freezeColors
    set(bb,'facecolor',[.7 .7 .7])
    %pcolor(lon,lat,dnm);shading interp 
    %demcmap([0 2000])
    ylim([40.8 47.2])

    printname=['gifs/Blacksea_vort_2d_' no];
    print(hhh,'-r300','-dpng','-zbuffer',printname)
    close all
    k = k+1
end

