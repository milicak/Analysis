clear all
Cp=3985; %specific heat ratio m^2/(s^2*C)
rho0=1035; %

rcp8_5 = 1; %if rcp or control is processed

if rcp8_5 == 1
  % RCP 8.5
  %folder_name = '/archive/esm2m/fre/postriga_esm_20110506/ESM2M/ESM2M-HC2_2006-2100_all_rcp85_ZC2/gfdl.default-prod/pp/ocean/ts/annual/95yr/'
  folder_name = '/work/milicak/RUNS/mom/'
  savename = 'matfiles/ESM2M_rcp8_5_heatfluxv2';
  fyear = 2006;
  lyear = 2100;
elseif rcp8_5 ==0
  % control
  folder_name = '/archive/esm2m/fre/postriga_esm_20110506/ESM2M/ESM2M_pi-control_C2/gfdl.default-prod/pp/ocean/ts/annual/100yr/'
  savename = 'matfiles/ESM2M_pi_control_heatflux';
  fyear = [101:100:1401];
  lyear = [200:100:1500];
elseif rcp8_5 == 2
  % historical
  folder_name = '/archive/esm2m/fre/postriga_esm_20110506/ESM2M/ESM2M-C2_all_historical_HC2/gfdl.default-prod/pp/ocean/ts/annual/145yr/'
  savename = 'matfiles/ESM2M_historical_heatflux';
  fyear = 1861;
  lyear = 2005;
end

%gridfile = '/archive/esm2m/fre/postriga_esm_20110506/ESM2M/ESM2M_pi-control_C2/gfdl.default-prod/pp/ocean/ocean.static.nc';
gridfile = '/work/milicak/RUNS/mom/ocean.static.nc';
mask = nc_varget(gridfile,'ht');
mask(isnan(mask)==0)=1;
%mask = nc_varget(gridfile,'wet');
area = nc_varget(gridfile,'area_t');
lonh = nc_varget(gridfile,'geolon_t');
lath = nc_varget(gridfile,'geolat_t');  

jind_Be = [111 112];
iind_Be = [176 176];
jind_CAA = 219:227;
iind_CAA = 178*ones(1,length(jind_CAA));
jind_DS = 241:257;
iind_DS = 176*ones(1,length(jind_DS));
iind_IFC = [175 175 175 175 175 175 175 175 174 173 172 171 170 169 168];
jind_IFC = [267 268 269 270 271 272 273 274 274 274 274 274 274 274 274];
iind_EC = 158;
jind_EC = 279;


ind=1;
for i=1:size(iind_Be,2)
x(ind)=lonh(iind_Be(i),jind_Be(i));
y(ind)=lath(iind_Be(i),jind_Be(i));
ind=ind+1;
end

%additional
for i=1:1
x(ind)=206.78;
y(ind)=65.88;
ind=ind+1;
end
for i=1:1
x(ind)=-130.22;
y(ind)=67.95;
ind=ind+1;
end

cc=[-68.7585
  -84.5659
  -83.7229
  -95.2401
 -113.1203];
dd=[68.2037
   71.9120
   67.6230
   65.2717
   65.1950];

for i=5:-1:1
x(ind)=cc(i);
y(ind)=dd(i);
ind=ind+1;
end

for i=1:size(iind_CAA,2)
x(ind)=lonh(iind_CAA(i),jind_CAA(i));
y(ind)=lath(iind_CAA(i),jind_CAA(i));
ind=ind+1;
end

for i=1:size(iind_DS,2)
x(ind)=lonh(iind_DS(i),jind_DS(i));
y(ind)=lath(iind_DS(i),jind_DS(i));
ind=ind+1;
end

for i=1:size(iind_IFC,2)
x(ind)=lonh(iind_IFC(i),jind_IFC(i));
y(ind)=lath(iind_IFC(i),jind_IFC(i));
ind=ind+1;
end

for i=1:1
x(ind)=-2.64;
y(ind)=57.64;
ind=ind+1;
end
for i=1:size(iind_EC,2)
x(ind)=lonh(iind_EC(i),jind_EC(i));
y(ind)=lath(iind_EC(i),jind_EC(i));
ind=ind+1;
end


cc=[6.4470
   19.0000
   39.7175
   71.4761
  111.8209
  161.1170];
dd=[49.1599
   49.9903
   54.2725
   60.9304
   66.1467
   66.2224];
x(end+1:end+6)=cc;
y(end+1:end+6)=dd;
y(end+1)=y(1);
x(end+1)=x(1);


in=insphpoly(double(lonh),double(lath),x,y,0,90);
in=double(in);
in=in.*mask;
in(in==0)=NaN;

timeind = 1;

for i=1:length(lyear)
  fy = num2str(fyear(i),'%.4d');
  ly = num2str(lyear(i),'%.4d');
  
  filename_LW = [folder_name 'ocean.' fy '-' ly '.lw_heat.nc'];
  filename_SW = [folder_name 'ocean.' fy '-' ly '.sw_heat.nc'];
  filename_sw = [folder_name 'ocean.' fy '-' ly '.swflx.nc'];
  filename_lh = [folder_name 'ocean.' fy '-' ly '.evap_heat.nc'];
  filename_sh = [folder_name 'ocean.' fy '-' ly '.sens_heat.nc'];
  filename_calv = [folder_name 'ocean.' fy '-' ly '.calving_melt_heat.nc'];
  filename_freeze = [folder_name 'ocean.' fy '-' ly '.fprec_melt_heat.nc'];

  LW = nc_varget(filename_LW,'lw_heat');
  SW = nc_varget(filename_SW,'sw_heat');
  sw = nc_varget(filename_sw,'swflx');
  lh = nc_varget(filename_lh,'evap_heat');
  sh = nc_varget(filename_sh,'sens_heat');
  calv = nc_varget(filename_calv,'calving_melt_heat');
  freeze = nc_varget(filename_freeze,'fprec_melt_heat');
  if i==1
      dz = ncread(filename_SW,'st_edges_ocean');
      dz = dz(2:end)-dz(1:end-1);
      dz = repmat(dz,[1 size(SW,1) size(SW,3) size(SW,4)]);
      dz = permute(dz,[2 1 3 4]);
  end
  break
  SW=1e-3*squeeze(nansum(squeeze(SW(:,2:end,:,:)),2)).*squeeze(nansum(squeeze(dz(:,2:end,:,:)),2));
  %SW = SW.*dz;
  %sum the SW in the vertical
  %SW = squeeze(nansum(squeeze(SW(:,2:end,:,:)),2))*1e-3;
  %dz2 = squeeze(nansum(squeeze(dz(:,2:end,:,:)),2));
  %SW = SW./dz2;
  %SW=squeeze(nansum((SW),2));

  for time=1:size(LW,1)
    hfs = squeeze(LW(time,:,:)+SW(time,:,:)+lh(time,:,:)+sh(time,:,:)+calv(time,:,:)+freeze(time,:,:));
    dnm = hfs.*in.*area*1e-6./(Cp*rho0); %Sv*C
    Qf(timeind) = nansum(dnm(:));
    hfs = squeeze(LW(time,:,:));
    dnm = hfs.*in.*area*1e-6./(Cp*rho0); %Sv*C
    LWt(timeind) = nansum(dnm(:));
    hfs = squeeze(SW(time,:,:));
    dnm = hfs.*in.*area*1e-6./(Cp*rho0); %Sv*C
    SWt(timeind) = nansum(dnm(:));
    hfs = squeeze(lh(time,:,:));
    dnm = hfs.*in.*area*1e-6./(Cp*rho0); %Sv*C
    lht(timeind) = nansum(dnm(:));
    hfs = squeeze(sh(time,:,:));
    dnm = hfs.*in.*area*1e-6./(Cp*rho0); %Sv*C
    sht(timeind) = nansum(dnm(:));
    hfs = squeeze(calv(time,:,:));
    dnm = hfs.*in.*area*1e-6./(Cp*rho0); %Sv*C
    calvt(timeind) = nansum(dnm(:));
    hfs = squeeze(freeze(time,:,:));
    dnm = hfs.*in.*area*1e-6./(Cp*rho0); %Sv*C
    freezet(timeind) = nansum(dnm(:));
    timeind = timeind+1
    %save(savename,'Qf')
    save(savename,'Qf','LWt','SWt','lht','sht','calvt','freezet')
  end
end

