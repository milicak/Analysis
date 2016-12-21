
clear all
folder_name='/hexagon/work/milicak/archive';
%project_name='N1850_f19_tn11_01_default'
%project_name='N1850_f19_tn11_01_BG'
%project_name='NOIIA_T62_tn11_sr10m60d_01'
project_name='NOIIA_T62_tn11_ctrl'
grid_file='grid.nc'; %1 degree

lat=nc_varget(grid_file,'plat');
dx=nc_varget(grid_file,'pdx');
dy=nc_varget(grid_file,'pdy');
f=coriolis(lat);
months_end=12;
%time_str=101;
%time_end=130;
time_str=1;
time_end=110;

ind1=261;  %for 25.9Nsection
%ind1=286;  %for 45.1Nsection

if ind1==261
  indy1=30;  %western boundary for 25.9N
  indy2=96;  %eastern boundary for 25.9N
  indfs1=31; %western boundary of FS 
  indfs2=34; %eastern boundary of FS
  inddw1=35; %western boundary of DWBC
  inddw2=40; %eastern boundary of DWBC
elseif ind1==286
  indy1=49;  %western boundary for 45.1N
  indy2=110; %eastern boundary for 45.1N
  indfs1=50; %western boundary of Shelf
  indfs2=61; %eastern boundary of Shelf
  inddw1=62; %western boundary of DWBC
  inddw2=69; %eastern boundary of DWBC
  indoi1=83; %Mid-Atl Ridge
end

ind=1;
for time_ind = time_str:time_end 
 no = num2str(time_ind,'%.4d');
 for months = 1:months_end
   no2 = num2str(months,'%.2d');
   filename=[folder_name '/' project_name '/ocn/hist/' project_name '.micom.hm.' no '-' no2 '.nc'];
   zt=nc_varget(filename,'depth');

   vflx=nc_varget(filename,'vflxlvl');
   temp=nc_varget(filename,'templvl');
   mmflxl=nc_varget(filename,'mmflxl');
   sigma=nc_varget(filename,'sigma');
   latsec=nc_varget(filename,'lat'); 
   taux=nc_varget(filename,'taux');
   tauy=nc_varget(filename,'tauy');

%%%% AMOC in sigma coordinates in time
   amoc_sigma(:,:,ind)=squeeze(mmflxl(1,:,:)).*1e-9;

%   tauy=nc_varget(filename,'tauy');
%   vflx_gm=nc_varget(filename,'vmfltdlvl');
%   dnm_gm=nansum(sq(vflx_gm(:,ind1,30:96))*1e-9,2);
%   amoc_gm_max(ind)=max(nancumsum(dnm));                             % Max AMOC_GM transport at 25.59N

   sec26v(:,:,ind)=sq(vflx(:,ind1,indy1:indy2))*1e-9;
   sec26t(:,:,ind)=sq(temp(:,ind1,indy1:indy2));

   dnm1=nansum(sq(vflx(:,ind1,indy1:indy2))*1e-9,2);   %261 corresponds to 25.59N which is corner of Florida. 30:96 from east to west
   %amoc_max(ind)=max(nancumsum(dnm1));                                   % Max AMOC transport at 25.59N
   amoc_max(:,ind)=(nancumsum(dnm1));                                   % Max AMOC transport at 25.59N

   dnm1=nansum(sq(vflx(1:40,ind1,inddw2+1:indy2))*1e-9,2);
   amoc_UMO(:,ind)=(nancumsum(dnm1));

if ind1==261
%%% LEFT-HAND SIDE Florida Current %%%
   dnm2=nansum(sq(vflx(:,ind1,31:31))*1e-9,2); 
   %amoc_fs(ind)=max(nancumsum(dnm2)); 
   amoc_fs(:,ind)=(nancumsum(dnm2)); 

%%% RIGHT-HAND SIDE Florida Current %%%
   dnm3=nansum(sq(vflx(:,ind1,32:34))*1e-9,2); 
   %amoc_fs2(ind)=max(nancumsum(dnm3)); 
   amoc_fs2(:,ind)=(nancumsum(dnm3)); 
end
%%% BOTH SIDES Florida Current %%%
   dnm4=nansum(sq(vflx(:,ind1,indfs1:indfs2))*1e-9,2); 
   %amoc_fs3(ind)=max(nancumsum(dnm4)); 
   amoc_fs3(:,ind)=(nancumsum(dnm4)); 

%%% Deep Western BC %%%
   dnm=nansum(sq(vflx(:,ind1,inddw1:inddw2))*1e-9,2); 
   %amoc_DWBC(ind)=min(nancumsum(dnm)); 
   amoc_DWBC(:,ind)=(nancumsum(dnm)); 
   amoc_DWBC_upper(ind)=max(nancumsum(dnm)); 

%%% Ocean Interior %%%  %Northward transport so negative so minimum
   dnm=nansum(sq(vflx(:,ind1,inddw2+1:indy2))*1e-9,2); 
   %amoc_OI(ind)=min(nancumsum(dnm)); 
   amoc_OI(:,ind)=(nancumsum(dnm)); 

%%% Ocean Interior2 %%%  %Northward transport so negative so minimum
   %dnm=nansum(sq(vflx(:,ind1,35:indy2))*1e-9,2); 
if ind1==286
    dnm=nansum(sq(vflx(:,ind1,inddw2+1:indoi1))*1e-9,2); 
    amoc_OI2(:,ind)=(nancumsum(dnm)); 
end

%%% Ekman %%%    
   dnm_EK=-(taux.*dx./f)*1e-9;  % Ekman Transport which is M_y=-taux/f  need to multiply by dx and divide 1e-9 to get in Sv.
   amoc_EK(:,ind)=(dnm_EK(ind1,indy1:indy2));

%%% Ekman in x-direction %%%    
   dnm_EK2=(tauy.*dy./f)*1e-9;  % Ekman Transport which is M_y=-taux/f  need to multiply by dx and divide 1e-9 to get in Sv.
   amoc_EK2(:,ind)=(dnm_EK2(ind1-3,indy1:indy2));

   EK_time(:,:,ind)=dnm_EK2;

%    for i=1:nx
%    for j=1:ny
%      tauy_dx(i,j)=(tauy(i,j)-tauy(inw(i,j),jnw(i,j)))./(qdx(i,j));
%      taux_dy(i,j)=(taux(i,j)-taux(ins(i,j),jns(i,j)))./(qdy(i,j));
%    end
%    end
%    taucurl=tauy_dx-taux_dy;
  ind
  ind=ind+1;
  end
end


