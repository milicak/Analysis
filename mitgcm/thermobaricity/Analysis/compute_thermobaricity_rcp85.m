%Thermobaric Convection
%Roland W. Garwood, Jr., Shirley M. Isakari Naval Postgraduate School, Monterey,
%California, USA and
%Patrick C. Gallacher
%NRL, Stennis Space Center, Mississippi, USA
clear all

ctrl = 1

load('matfiles/CESM1-BGC_Arctic_rcp85.mat')
%load('matfiles/NorESM1-M_Arctic_rcp85.mat')
%load('matfiles/GFDL-ESM2M_Arctic_rcp85.mat')
%load('matfiles/GFDL-ESM2G_Arctic_rcp85.mat')
%load('matfiles/IPSL-CM5A-MR_Arctic_rcp85.mat')
pr = sw_pres(zr,84.5);

% convert Kelvin to Celcius
T1ctr = T1ctr - 273.15;
T1rcp85 = T1rcp85 - 273.15;

if(max(S1ctr(:)) < 1)
    S1ctr = S1ctr * 1000;
    S1rcp85= S1rcp85 * 1000;
end

lon_region1 = [28.4183 50.1650 61.7595 59.7147 41.6135 24.3184 28.4183];
lat_region1 = [83.6591 84.0485 83.8828 82.8630 82.7320 82.2573 83.6591];

href = 1000;
indref = max(find(zr<=href));

if ctrl==1
% cntrl
  T1 = squeeze(nanmean(T1ctr,1));
  S1 = squeeze(nanmean(S1ctr,1));
else
% rcp 8.5
  T1 = squeeze(nanmean(T1rcp85,1));
  S1 = squeeze(nanmean(S1rcp85,1));
end

%convert potential temperature to conservative temperature to be used gsw
T1 = gsw_CT_from_pt(S1,T1);

rho = gsw_rho(S1,T1,pr);
Tref = T1(indref);
Sref = S1(indref);

%find max temp depth
indTmax = find(T1==max(T1(:)));
Tmax = max(T1(:));

Smax = S1(indTmax);
Tmxl = mean(T1(1:1));
%Tmxl = mean(T1(1:4));
hmax = zr(indTmax);
H2 = href-hmax;
DeltaT1 = Tmxl-Tref;
DeltaT2 = Tref-Tmax;
DeltaS2 = Sref-Smax;
beta = gsw_beta(S1(1),T1(1),0);
alpha0 = gsw_alpha(S1(1),T1(1),0);
alpha_tmp = gsw_alpha(S1,T1,pr);
zrtmp = zr;
zrtmp(isnan(alpha_tmp))=[];
alpha_tmp(isnan(alpha_tmp))=[];
P = polyfit(zrtmp,alpha_tmp',1);
%% IMPORTANT %%
%% alpha0 and alpha1 should be negative but beta should be positive
alpha1 = -P(1);
% another version of alpha0
alpha0_fit = P(2);
%alpha0 = -alpha0_fit;
alpha0 = -0.5*(alpha0+alpha0_fit);

% from control alpha values
if 0
    alpha0 = -3.6307e-05;
    alpha1 = -2.8655e-08;
end

Halpha = alpha0/alpha1;

%condition of thermobaricity
% alpha1*DeltaT1 > (alpha0*DeltaT2+beta*DeltaS2)/H2
DR1 = alpha1*DeltaT1; 
DR2 = ((alpha0*DeltaT2+beta*DeltaS2)/H2);
criteria = alpha1*DeltaT1 - ((alpha0*DeltaT2+beta*DeltaS2)/H2);
Sdeep = (beta*DeltaS2)/(alpha0*DeltaT2);
therm = gsw_thermobaric(S1,T1,pr);
DR2/DR1
%if criteria > 0
%    mask(i,j) = 1;
%end
%end;end



