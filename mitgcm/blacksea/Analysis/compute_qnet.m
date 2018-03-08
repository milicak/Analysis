clear all

root_folder = '/okyanus/users/milicak/models/MITgcm_c65/Projects/Blacksea_lonlat/work';
root_folder2 = '/okyanus/users/milicak/models/MITgcm_c65/Projects/Blacksea_lonlat/2011_exp2';

latg = rdmds([root_folder '/' 'YG']);
lon = rdmds([root_folder '/' 'XC']);
lat = rdmds([root_folder '/' 'YC']);
area = rdmds([root_folder '/' 'RAC']);
fcor = coriolis(latg);
level = 1; % surface plot

t0 = rdmds([root_folder2 '/' 'T'],0);
t0 = squeeze(t0(:,:,1));
mask = ones(size(t0,1),size(t0,2));
mask(t0==0) = NaN;
totalarea = mask.*area;
totalarea = nansum(totalarea(:));

k = 1;
for i=1:364
    % qnet = lwnet+swnet-hs-hl
    qnet = rdmds([root_folder2 '/' 'EXFqnet'],i*864);
    hl = rdmds([root_folder2 '/' 'EXFhl'],i*864);
    hs = rdmds([root_folder2 '/' 'EXFhs'],i*864);
    swnet = rdmds([root_folder2 '/' 'EXFswnet'],i*864);
    lwnet = rdmds([root_folder2 '/' 'EXFlwnet'],i*864);
    qnet = qnet.*area.*mask;
    hl = hl.*area.*mask;
    hs = hs.*area.*mask;
    lwnet = lwnet.*area.*mask;
    swnet = swnet.*area.*mask;
    QNET(k) = nansum(qnet(:))./totalarea;
    HL(k) = nansum(hl(:))./totalarea;
    HS(k) = nansum(hs(:))./totalarea;
    SWNET(k) = nansum(swnet(:))./totalarea;
    LWNET(k) = nansum(lwnet(:))./totalarea;
    k = k+1
end

