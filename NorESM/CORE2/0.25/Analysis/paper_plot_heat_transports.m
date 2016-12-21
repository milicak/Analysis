% 1 for atlantic_arctic_ocean region
% 2 for indian_pacific_ocean region
% 3 for global_ocean

clear all

%fy=1; %first year;
%ly=60; %last year
fy=61; %first year;
ly=120; %last year

load matfiles/global_ocean_heat_transport.mat
plot(lat_fas08,hf_tot_ocn_fas08,'linewidth',2)
hold on
load matfiles/NOIIA_T62_tn025_001_annual_heat_flux_1_120.mat
mhflx(isnan(mhflx))=0;
mhftd(isnan(mhftd))=0;
mhfld(isnan(mhfld))=0;
heat1=mhflx(fy:ly,:,3); %Global
heat1_atl=mhflx(fy:ly,:,1); %Atlantic
heat1_pac=mhflx(fy:ly,:,2); %Indian_Pacific
heat1_so=heat1-(heat1_atl+heat1_pac);
plot(lat,nanmean(heat1,1)./1e15,'g','linewidth',2);

heat1_eddy=mhftd(fy:ly,:,3)+mhfld(fy:ly,:,3);
heat1_eddy_atl=mhftd(fy:ly,:,1)+mhfld(fy:ly,:,1);
heat1_eddy_pac=mhftd(fy:ly,:,2)+mhfld(fy:ly,:,2);
heat1_eddy_so=heat1_eddy-(heat1_eddy_atl+heat1_eddy_pac);


%load matfiles/NOIIA_T62_tn11_sr10m60d_02_annual_heat_flux_1_60.mat
load matfiles/NOIIA_T62_tn11_sr10m60d_02_annual_heat_flux_61_120.mat
fy=1; %first year;
ly=60; %last year
mhflx(isnan(mhflx))=0;
mhftd(isnan(mhftd))=0;
mhfld(isnan(mhfld))=0;
heat2=mhflx(fy:ly,:,3); %Global
heat2_atl=mhflx(fy:ly,:,1); %Atlantic
heat2_pac=mhflx(fy:ly,:,2); %Indian_Pacific
heat2_so=heat2-(heat2_atl+heat2_pac);
plot(lat,nanmean(heat2,1)./1e15,'r','linewidth',2);

heat2_eddy=mhftd(fy:ly,:,3)+mhfld(fy:ly,:,3);
heat2_eddy_atl=mhftd(fy:ly,:,1)+mhfld(fy:ly,:,1);
heat2_eddy_pac=mhftd(fy:ly,:,2)+mhfld(fy:ly,:,2);
heat2_eddy_so=heat2_eddy-(heat2_eddy_atl+heat2_eddy_pac);

legend('Obs','0.25^\circ','1^\circ','location','northwest')
ylabel('Heat Transport [PW]')
xlabel('Lat') 

printname='paperfigs/heat_transports_v2'


plot(lat_fas08,hf_tot_ocn_fas08,'linewidth',2)
hold on
plot(lat,nanmean(heat1_so,1)./1e15,'g','linewidth',2);
plot(lat,nanmean(heat2_so,1)./1e15,'r','linewidth',2);
plot(lat,nanmean(heat2_eddy_so,1)./1e15,'k','linewidth',2)
plot(lat,nanmean(heat1_eddy_so,1)./1e15,'m','linewidth',2)
plot(lat,(nanmean(heat2_so,1)-nanmean(heat2_eddy_so,1))./1e15,'c','linewidth',2);
ylabel('Heat Transport [PW]')
xlabel('Lat') 
xlim([-90 -35])
legend('Obs','0.25^\circ','1^\circ','1^\circ eddy','0.25^\circ eddy','1^\circ residual','location','southwest')






