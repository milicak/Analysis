% this subroutine removes NaN froms roms initial and climatology files
clear all
display('run this code in grunch')

dnm=nc_read('blacksea-ini.nc','temp');
dnm(isnan(dnm))=0;
ncwrite('blacksea-ini.nc','temp',dnm);

dnm=nc_read('blacksea-ini.nc','salt');
dnm(isnan(dnm))=0;
ncwrite('blacksea-ini.nc','salt',dnm);

dnm=nc_read('blacksea-ini.nc','u');
dnm(isnan(dnm))=0;
ncwrite('blacksea-ini.nc','u',dnm);

dnm=nc_read('blacksea-ini.nc','v');
dnm(isnan(dnm))=0;
ncwrite('blacksea-ini.nc','v',dnm);

dnm=nc_read('blacksea-ini.nc','ubar');
dnm(isnan(dnm))=0;
ncwrite('blacksea-ini.nc','ubar',dnm);

dnm=nc_read('blacksea-ini.nc','vbar');
dnm(isnan(dnm))=0;
ncwrite('blacksea-ini.nc','vbar',dnm);

dnm=nc_read('blacksea-ini.nc','zeta');
dnm(isnan(dnm))=0;
ncwrite('blacksea-ini.nc','zeta',dnm);


dnm=nc_read('blacksea-clim_all.nc','temp');
dnm(isnan(dnm))=0;
ncwrite('blacksea-clim_all.nc','temp',dnm);

dnm=nc_read('blacksea-clim_all.nc','salt');
dnm(isnan(dnm))=0;
ncwrite('blacksea-clim_all.nc','salt',dnm);

dnm=nc_read('blacksea-clim_all.nc','u');
dnm(isnan(dnm))=0;
ncwrite('blacksea-clim_all.nc','u',dnm);

dnm=nc_read('blacksea-clim_all.nc','v');
dnm(isnan(dnm))=0;
ncwrite('blacksea-clim_all.nc','v',dnm);

dnm=nc_read('blacksea-clim_all.nc','ubar');
dnm(isnan(dnm))=0;
ncwrite('blacksea-clim_all.nc','ubar',dnm);

dnm=nc_read('blacksea-clim_all.nc','vbar');
dnm(isnan(dnm))=0;
ncwrite('blacksea-clim_all.nc','vbar',dnm);

dnm=nc_read('blacksea-clim_all.nc','zeta');
dnm(isnan(dnm))=0;
ncwrite('blacksea-clim_all.nc','zeta',dnm);
