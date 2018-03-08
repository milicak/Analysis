clear all

inputdir = '/okyanus/users/milicak/models/MITgcm_c65/Projects/Blacksea_lonlat/input/forc/2011';
outputdir = '/okyanus/users/milicak/models/MITgcm_c65/Projects/Blacksea_lonlat/input/forc/2011';

invar = [{'rsdl'} {'rsds'} {'ps'} {'pr'} {'qas'} {'uas_rot'} {'vas_rot'} {'tas'}];
outvar = [{'LWDOWN'} {'SWDOWN'} {'APRES'} {'PRECIP'} {'ASHUM'} {'UWIND'} {'VWIND'} {'ATEMP'}];

for i=1:length(invar)
    fname = [inputdir '/' char(invar(i)) '_masked_remap_ext.nc'];
    oname = [outputdir '/' char(outvar(i)) '_2011.data'];
    var = ncread(fname,'var');
    fid=fopen(oname,'w','b'); 
    fwrite(fid,var,'real*4'); 
    fclose(fid)
end

