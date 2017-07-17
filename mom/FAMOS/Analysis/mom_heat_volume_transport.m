clear all

k=1;
rho_cp       = 1; rho0         = 1035;
sv2mks = 1e9; 

monthsini={'1708','1728','1748','1768','1788','1808','1828','1848','1868','1888','1908','1928','1948','1968','1988'};
monthsend={'1727','1747','1767','1787','1807','1827','1847','1867','1887','1907','1927','1947','1967','1987','2007'};

for kk=1:15

%first cycle
temp_xflux_adv_int_z=nc_varget(['/archive/Bonnie.Samuels/siena/17apr2012/MOM4_SIS_IAFII_17apr2012/gfdl.default-prod/pp/ocean/ts/monthly/20yr/ocean.' char(monthsini(kk)) '01-' char(monthsend(kk)) '12.temp_xflux_adv_int_z.nc'],'temp_xflux_adv_int_z');
temp_xflux_gm_int_z=nc_varget(['/archive/Bonnie.Samuels/siena/17apr2012/MOM4_SIS_IAFII_17apr2012/gfdl.default-prod/pp/ocean/ts/monthly/20yr/ocean.' char(monthsini(kk)) '01-' char(monthsend(kk)) '12.temp_xflux_gm_int_z.nc'],'temp_xflux_gm_int_z');
temp_xflux_ndiffuse_int_z=nc_varget(['/archive/Bonnie.Samuels/siena/17apr2012/MOM4_SIS_IAFII_17apr2012/gfdl.default-prod/pp/ocean/ts/monthly/20yr/ocean.' char(monthsini(kk)) '01-' char(monthsend(kk)) '12.temp_xflux_ndiffuse_int_z.nc'],'temp_xflux_ndiffuse_int_z');
temp_xflux_sigma=nc_varget(['/archive/Bonnie.Samuels/siena/17apr2012/MOM4_SIS_IAFII_17apr2012/gfdl.default-prod/pp/ocean/ts/monthly/20yr/ocean.' char(monthsini(kk)) '01-' char(monthsend(kk)) '12.temp_xflux_sigma.nc'],'temp_xflux_sigma');
temp_xflux_submeso_int_z=nc_varget(['/archive/Bonnie.Samuels/siena/17apr2012/MOM4_SIS_IAFII_17apr2012/gfdl.default-prod/pp/ocean/ts/monthly/20yr/ocean.' char(monthsini(kk)) '01-' char(monthsend(kk)) '12.temp_xflux_submeso_int_z.nc'],'temp_xflux_submeso_int_z');

temp_yflux_adv_int_z=nc_varget(['/archive/Bonnie.Samuels/siena/17apr2012/MOM4_SIS_IAFII_17apr2012/gfdl.default-prod/pp/ocean/ts/monthly/20yr/ocean.' char(monthsini(kk)) '01-' char(monthsend(kk)) '12.temp_yflux_adv_int_z.nc'],'temp_yflux_adv_int_z');
temp_yflux_gm_int_z=nc_varget(['/archive/Bonnie.Samuels/siena/17apr2012/MOM4_SIS_IAFII_17apr2012/gfdl.default-prod/pp/ocean/ts/monthly/20yr/ocean.' char(monthsini(kk)) '01-' char(monthsend(kk)) '12.temp_yflux_gm_int_z.nc'],'temp_yflux_gm_int_z');
temp_yflux_ndiffuse_int_z=nc_varget(['/archive/Bonnie.Samuels/siena/17apr2012/MOM4_SIS_IAFII_17apr2012/gfdl.default-prod/pp/ocean/ts/monthly/20yr/ocean.' char(monthsini(kk)) '01-' char(monthsend(kk)) '12.temp_yflux_ndiffuse_int_z.nc'],'temp_yflux_ndiffuse_int_z');
temp_yflux_sigma=nc_varget(['/archive/Bonnie.Samuels/siena/17apr2012/MOM4_SIS_IAFII_17apr2012/gfdl.default-prod/pp/ocean/ts/monthly/20yr/ocean.' char(monthsini(kk)) '01-' char(monthsend(kk)) '12.temp_yflux_sigma.nc'],'temp_yflux_sigma');
temp_yflux_submeso_int_z=nc_varget(['/archive/Bonnie.Samuels/siena/17apr2012/MOM4_SIS_IAFII_17apr2012/gfdl.default-prod/pp/ocean/ts/monthly/20yr/ocean.' char(monthsini(kk)) '01-' char(monthsend(kk)) '12.temp_yflux_submeso_int_z.nc'],'temp_yflux_submeso_int_z');

transx=nc_varget(['/archive/Bonnie.Samuels/siena/17apr2012/MOM4_SIS_IAFII_17apr2012/gfdl.default-prod/pp/ocean/ts/monthly/20yr/ocean.' char(monthsini(kk)) '01-' char(monthsend(kk)) '12.tx_trans.nc'],'tx_trans');
transy=nc_varget(['/archive/Bonnie.Samuels/siena/17apr2012/MOM4_SIS_IAFII_17apr2012/gfdl.default-prod/pp/ocean/ts/monthly/20yr/ocean.' char(monthsini(kk)) '01-' char(monthsend(kk)) '12.ty_trans.nc'],'ty_trans');

% heat transport
transx_heat  = rho_cp*(temp_xflux_adv_int_z+temp_xflux_gm_int_z+temp_xflux_ndiffuse_int_z+temp_xflux_sigma+temp_xflux_submeso_int_z);
transy_heat  = rho_cp*(temp_yflux_adv_int_z+temp_yflux_gm_int_z+temp_yflux_ndiffuse_int_z+temp_yflux_sigma+temp_yflux_submeso_int_z);
% seawater transport
transx = sv2mks*squeeze(nansum(transx,2));
transy = sv2mks*squeeze(nansum(transy,2));

heat_trans_fram=squeeze(transy_heat(:,191,266:286));
heat_trans_barents=squeeze(transx_heat(:,177:190,295));
volume_trans_fram=squeeze(transy(:,191,266:286));
volume_trans_barents=squeeze(transx(:,177:190,295));

for year=1:240
%Fram
ind=find(volume_trans_fram(year,:)>0);
ind2=find(volume_trans_fram(year,:)<=0);
fram_volume_total(k)=nansum(volume_trans_fram(year,:));
fram_heat_total(k)=nansum(heat_trans_fram(year,:));
fram_volume_inflow(k)=nansum(volume_trans_fram(year,ind));
fram_heat_inflow(k)=nansum(heat_trans_fram(year,ind));
fram_volume_outflow(k)=nansum(volume_trans_fram(year,ind2));
fram_heat_outflow(k)=nansum(heat_trans_fram(year,ind2));
%Barents
ind=find(volume_trans_barents(year,:)>0);
ind2=find(volume_trans_barents(year,:)<=0);
barents_volume_total(k)=nansum(volume_trans_barents(year,:));
barents_heat_total(k)=nansum(heat_trans_barents(year,:));
barents_volume_inflow(k)=nansum(volume_trans_barents(year,ind));
barents_heat_inflow(k)=nansum(heat_trans_barents(year,ind));
barents_volume_outflow(k)=nansum(volume_trans_barents(year,ind2));
barents_heat_outflow(k)=nansum(heat_trans_barents(year,ind2));
k=k+1;
end

end %kk

save mom_fram_transports fram_heat_inflow fram_heat_outflow fram_heat_total fram_volume_inflow fram_volume_outflow fram_volume_total
save mom_barents_transports barents_heat_inflow barents_heat_outflow barents_heat_total barents_volume_inflow barents_volume_outflow barents_volume_total
