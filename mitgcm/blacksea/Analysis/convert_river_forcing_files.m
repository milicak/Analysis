clear all

outputdir = '/okyanus/users/milicak/models/MITgcm_c65/Projects/Blacksea_lonlat/input/forc/2011';

invar = [{'friver'}];
outvar = [{'JRA_runoffBS'}];

fname = '/okyanus/users/milicak/dataset/JRA55/runoff_all.2011.15Dec2016.nc'
lon1 = ncread(fname,'longitude');
lat1 = ncread(fname,'latitude');
[x y] = meshgrid(lon1,lat1);
lon1 = x';
lat1 = y';
lon = readbin('LONC.bin',[896 440],1,'real*8');
lat = readbin('LATC.bin',[896 440],1,'real*8');

for i=1:length(invar)
    oname = [outputdir '/' char(outvar(i)) '_2011.data'];
    var = ncread(fname,char(invar(i)));
end
for i=1:size(var,3)
    i
    dnm = griddata(lon1,lat1,double(squeeze(var(:,:,i))),lon,lat);
    runoff(:,:,i) = dnm;
end
writebin(oname,runoff,1,'real*4')
