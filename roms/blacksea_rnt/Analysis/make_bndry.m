clear ll
filename='blacksea-bry.nc';
clmname='blacksea-clim_all.nc';
display('first run d_obc_roms2roms');


time=nc_read(clmname,'zeta_time');
zeta=nc_read(clmname,'zeta');

%west BC
zeta_west=squeeze(zeta(1,:,:));

% write time in seconds
ncwrite(filename,'bry_time',time*86400);

% write zeta
ncwrite(filename,'zeta_west',zeta_west);


temp=nc_read(clmname,'temp');
%west BC
temp_west=squeeze(temp(1,:,:,:));
% write temp
ncwrite(filename,'temp_west',temp_west);

salt=nc_read(clmname,'salt');
%west BC
salt_west=squeeze(salt(1,:,:,:));
% write temp
ncwrite(filename,'salt_west',salt_west);

u=nc_read(clmname,'u');
%west BC
u_west=squeeze(u(1,:,:,:));
% write u
ncwrite(filename,'u_west',u_west);

v=nc_read(clmname,'v');
%west BC
v_west=squeeze(v(1,:,:,:));
% write v
ncwrite(filename,'v_west',v_west);

clear u v temp salt

ubar=nc_read(clmname,'ubar');
%west BC
ubar_west=squeeze(ubar(1,:,:,:));
% write ubar
ncwrite(filename,'ubar_west',ubar_west);

vbar=nc_read(clmname,'vbar');
%west BC
vbar_west=squeeze(vbar(1,:,:,:));
% write vbar
ncwrite(filename,'vbar_west',vbar_west);


