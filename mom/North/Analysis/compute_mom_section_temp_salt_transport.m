clear all
Cp=3985; %specific heat ratio m^2/(s^2*C)
rho0=1035; %

rcp8_5 = 2; %if rcp==1 or control==0 is processed
gridfile = '/archive/esm2m/fre/postriga_esm_20110506/ESM2M/ESM2M_pi-control_C2/gfdl.default-prod/pp/ocean/ocean.static.nc';
mask = nc_varget(gridfile,'ht');
lonh = nc_varget(gridfile,'geolon_t');
lath = nc_varget(gridfile,'geolat_t');    

jind_Be = [111 112];
iind_Be = [176 176];
u_Be = [0 0];
v_Be = [1 1];

jind_CAA = 219:227;
iind_CAA = 178*ones(1,length(jind_CAA));
u_CAA = 0*ones(1,length(jind_CAA));
v_CAA = 1*ones(1,length(jind_CAA));

iind_EC = 158;
jind_EC = 279;
u_EC = 1;
v_EC = 0;

jind_DS = 241:257;
iind_DS = 176*ones(1,length(jind_DS));
u_DS = 0*ones(1,length(jind_DS));
v_DS = 1*ones(1,length(jind_DS));

iind_IFC = [175 175 175 175 175 175 175 175 174 173 172 171 170 169 168];
jind_IFC = [267 268 269 270 271 272 273 274 274 274 274 274 274 274 274];
u_IFC = [0 0 0 0 0 0 0 1 1 1 1 1 1 1 1];
v_IFC = [1 1 1 1 1 1 1 1 0 0 0 0 0 0 0];

iind_sec = [iind_DS iind_IFC];
jind_sec = [jind_DS jind_IFC];
u_sec = [u_DS u_IFC];
v_sec = [v_DS v_IFC];


if rcp8_5 == 1
  % RCP 8.5
  folder_name = '/archive/esm2m/fre/postriga_esm_20110506/ESM2M/ESM2M-HC2_2006-2100_all_rcp85_ZC2/gfdl.default-prod/pp/ocean/ts/annual/95yr/'
  savename = 'matfiles/ESM2M_rcp8_5';
  fyear = 2006;
  lyear = 2100;
elseif rcp8_5 ==0
  % control
  folder_name = '/archive/esm2m/fre/postriga_esm_20110506/ESM2M/ESM2M_pi-control_C2/gfdl.default-prod/pp/ocean/ts/annual/100yr/'
  savename = 'matfiles/ESM2M_pi_control';
  fyear = [101:100:1401];
  lyear = [200:100:1500];
elseif rcp8_5 == 2
  % historical
  folder_name = '/archive/esm2m/fre/postriga_esm_20110506/ESM2M/ESM2M-C2_all_historical_HC2/gfdl.default-prod/pp/ocean/ts/annual/145yr/'
  savename = 'matfiles/ESM2M_historical';
  fyear = 1861;
  lyear = 2005;
end

timeind = 1;

for i=1:length(lyear)
  fy = num2str(fyear(i),'%.4d');
  ly = num2str(lyear(i),'%.4d');
  
  filename_s = [folder_name 'ocean.' fy '-' ly '.salt.nc'];
  filename_t = [folder_name 'ocean.' fy '-' ly '.temp.nc'];
  filename_h = [folder_name 'ocean.' fy '-' ly '.dht.nc'];
  filename_uh = [folder_name 'ocean.' fy '-' ly '.tx_trans.nc'];
  filename_vh = [folder_name 'ocean.' fy '-' ly '.ty_trans.nc'];  
  filename_tuh = [folder_name 'ocean.' fy '-' ly '.temp_adv_flux_x_int_z.nc'];  
  filename_tvh = [folder_name 'ocean.' fy '-' ly '.temp_adv_flux_y_int_z.nc'];  

  salt = nc_varget(filename_s,'salt');
  temp = nc_varget(filename_t,'temp');
  h = nc_varget(filename_h,'dht');
  uh = nc_varget(filename_uh,'tx_trans');
  vh = nc_varget(filename_vh,'ty_trans');
  tuh = nc_varget(filename_tuh,'temp_adv_flux_x_int_z');
  tvh = nc_varget(filename_tvh,'temp_adv_flux_y_int_z');
  
  for time=1:size(salt,1)
    for ii=1:length(iind_sec)
      saltsec(timeind,ii,:) = squeeze(salt(time,:,iind_sec(ii),jind_sec(ii)));
      tempsec(timeind,ii,:) = squeeze(temp(time,:,iind_sec(ii),jind_sec(ii)));
      hsec(timeind,ii,:) = squeeze(h(time,:,iind_sec(ii),jind_sec(ii)));
      trsec(timeind,ii,:) = (squeeze(uh(time,:,iind_sec(ii),jind_sec(ii))).*u_sec(ii) + squeeze(vh(time,:,iind_sec(ii),jind_sec(ii))).*v_sec(ii))*1e-9;
      temptrsec(timeind,ii,:) = (squeeze(tuh(time,iind_sec(ii),jind_sec(ii))).*u_sec(ii) + squeeze(tvh(time,iind_sec(ii),jind_sec(ii))).*v_sec(ii))*1e-9;
    end    
%%% English Channel is closed in MOM
%    for ii=1:length(iind_EC)
%%      saltEC(timeind,ii,:) = squeeze(salt(time,:,iind_EC(ii),jind_EC(ii)));
%%      tempEC(timeind,ii,:) = squeeze(temp(time,:,iind_EC(ii),jind_EC(ii)));
%%      hEC(timeind,ii,:) = squeeze(h(time,:,iind_EC(ii),jind_EC(ii)));
%      trEC(timeind,ii,:) = (squeeze(uh(time,:,iind_EC(ii),jind_EC(ii))).*u_EC(ii) + squeeze(vh(time,:,iind_EC(ii),jind_EC(ii))).*v_EC(ii))*1e-6;
%    end 
    for ii=1:length(iind_CAA)
      saltCAA(timeind,ii,:) = squeeze(salt(time,:,iind_CAA(ii),jind_CAA(ii)));
      tempCAA(timeind,ii,:) = squeeze(temp(time,:,iind_CAA(ii),jind_CAA(ii)));
      hCAA(timeind,ii,:) = squeeze(h(time,:,iind_CAA(ii),jind_CAA(ii)));
      trCAA(timeind,ii,:) = (squeeze(uh(time,:,iind_CAA(ii),jind_CAA(ii))).*u_CAA(ii) + squeeze(vh(time,:,iind_CAA(ii),jind_CAA(ii))).*v_CAA(ii))*1e-9;
      temptrCAA(timeind,ii,:) = (squeeze(tuh(time,iind_CAA(ii),jind_CAA(ii))).*u_CAA(ii) + squeeze(tvh(time,iind_CAA(ii),jind_CAA(ii))).*v_CAA(ii))*1e-9;
    end
    for ii=1:length(iind_Be)
      saltBe(timeind,ii,:) = squeeze(salt(time,:,iind_Be(ii),jind_Be(ii)));
      tempBe(timeind,ii,:) = squeeze(temp(time,:,iind_Be(ii),jind_Be(ii)));
      hBe(timeind,ii,:) = squeeze(h(time,:,iind_Be(ii),jind_Be(ii)));
      trBe(timeind,ii,:) = (squeeze(uh(time,:,iind_Be(ii),jind_Be(ii))).*u_Be(ii) + squeeze(vh(time,:,iind_Be(ii),jind_Be(ii))).*v_Be(ii))*1e-9;
      temptrBe(timeind,ii,:) = (squeeze(tuh(time,iind_Be(ii),jind_Be(ii))).*u_Be(ii) + squeeze(tvh(time,iind_Be(ii),jind_Be(ii))).*v_Be(ii))*1e-9;
    end 
    save(savename,'saltsec','tempsec','hsec','trsec' ...
                 ,'saltBe','tempBe','trBe','hBe' ...
                 ,'saltCAA','tempCAA','trCAA','hCAA')
    timeind = timeind+1
  end


end



