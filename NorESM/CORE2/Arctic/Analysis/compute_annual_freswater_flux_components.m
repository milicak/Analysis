
clear all
expid='NOIIA_T62_tn11_sr10m60d_01';
datesep='-';
prefix=['/work-common/shared/bjerknes/milicak/mnt/norstore/NS2345K/noresm/cases/' expid '/ocn/hist/' expid '.micom.hm.'];
fyear=271
sdate=sprintf('%4.4d%c%2.2d',fyear,datesep,1);
zdepth_bnds=ncgetvar([prefix sdate '.nc'],'depth_bnds');
dz=zdepth_bnds(2,:)-zdepth_bnds(1,:);

Sref=34.8; % reference salinity

salt=ncgetvar('NOIIA_T62_tn11_sr10m60d_01_heat_freshwater_layer_CAA_new_monthly_241-300.nc','saltsec');
uvel=ncgetvar('NOIIA_T62_tn11_sr10m60d_01_heat_freshwater_layer_CAA_new_monthly_241-300.nc','utransec');

C=(Sref-salt)./Sref;
Cbar=nanmean(C(:,:,end-29:end),3);
Cbar=repmat(Cbar,[1 1 60]);
Cprime=C-Cbar;


Ubar=nanmean(uvel(:,:,end-29:end),3);
Ubar=repmat(Ubar,[1 1 60]);
Uprime=uvel-Ubar;


dz3d=repmat(dz,[size(uvel,1) 1 size(uvel,3)]);

comp1=Cbar.*Ubar.*dz3d;comp1=squeeze(nansum(comp1,1));comp1=squeeze(nansum(comp1,1));
comp2=Cbar.*Uprime.*dz3d;comp2=squeeze(nansum(comp2,1));comp2=squeeze(nansum(comp2,1));
comp3=Cprime.*Ubar.*dz3d;comp3=squeeze(nansum(comp3,1));comp3=squeeze(nansum(comp3,1));
comp4=Cprime.*Uprime.*dz3d;comp4=squeeze(nansum(comp4,1));comp4=squeeze(nansum(comp4,1));

comp1CbarUbar=comp1*1000;
comp2CbarUprime=comp2*1000;
comp3CprimeUbar=comp3*1000;
comp4CprimeUprime=comp4*1000;


%save fram_strait_FW_year_241_300 comp1CbarUbar comp2CbarUprime comp3CprimeUbar comp4CprimeUprime
%save barents_sea_FW_year_241_300 comp1CbarUbar comp2CbarUprime comp3CprimeUbar comp4CprimeUprime
%save davis_strait_FW_year_241_300 comp1CbarUbar comp2CbarUprime comp3CprimeUbar comp4CprimeUprime
%save bering_strait_FW_year_241_300 comp1CbarUbar comp2CbarUprime comp3CprimeUbar comp4CprimeUprime
%save svalbardtaimyr_FW_year_241_300 comp1CbarUbar comp2CbarUprime comp3CprimeUbar comp4CprimeUprime
save caa_FW_year_241_300 comp1CbarUbar comp2CbarUprime comp3CprimeUbar comp4CprimeUprime
