
clear all
folder_name='/hexagon/work/milicak/archive';
%project_name='N1850_f19_tn11_01_default'
project_name='NOIIA_T62_tn025_001'
%grid_file='grid.nc'; %1 degree
grid_file='/hexagon/work/milicak/shared/grid.nc'; %quarter degree

lat=nc_varget(grid_file,'plat');
dx=nc_varget(grid_file,'pdx');
dy=nc_varget(grid_file,'pdy');
f=coriolis(lat);
months_end=12;
%time_str=101;
%time_end=130;
time_str=1;
time_end=120;

ind1=657;  %for 25.9Nsection
%ind1=286;  %for 45.1Nsection

if ind1==657
  indy1=119;  %western boundary for 25.9N
  indy2=382;  %eastern boundary for 25.9N
  indfs1=119; %western boundary of FS 
  indfs2=128; %eastern boundary of FS
  inddw1=136; %western boundary of DWBC
  inddw2=145; %eastern boundary of DWBC
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
% for months = 1:months_end
   %no2 = num2str(months,'%.2d');
   %filename=[folder_name '/' project_name '/ocn/hist/' project_name '.micom.hm.' no '-' no2 '.nc'];
   filename=[folder_name '/' project_name '/ocn/hist/' project_name '.micom.hy.' no '.nc'];
   zt=nc_varget(filename,'depth');

   vflx=nc_varget(filename,'vflxlvl');
   temp=nc_varget(filename,'templvl');
   taux=nc_varget(filename,'taux');
   tauy=nc_varget(filename,'tauy');
%   tauy=nc_varget(filename,'tauy');
%   vflx_gm=nc_varget(filename,'vmfltdlvl');
%   dnm_gm=nansum(sq(vflx_gm(:,ind1,30:96))*1e-9,2);
%   amoc_gm_max(ind)=max(nancumsum(dnm));                             % Max AMOC_GM transport at 25.59N

%   sec26v(:,:,ind)=sq(vflx(:,ind1,indy1:indy2))*1e-9;
%   sec26t(:,:,ind)=sq(temp(:,ind1,indy1:indy2));

   dnm1=nansum(sq(vflx(:,ind1,indy1:indy2))*1e-9,2);   %261 corresponds to 25.59N which is corner of Florida. 30:96 from east to west
   %amoc_max(ind)=max(nancumsum(dnm1));                                   % Max AMOC transport at 25.59N
   amoc_max(:,ind)=(nancumsum(dnm1));                                   % Max AMOC transport at 25.59N

   dnm1=nansum(sq(vflx(1:40,ind1,inddw2+1:indy2))*1e-9,2);
   amoc_UMO(:,ind)=(nancumsum(dnm1));

%%% Florida Current %%%
   dnm4=nansum(sq(vflx(:,ind1,indfs1:indfs2))*1e-9,2); 
   %amoc_fs(ind)=max(nancumsum(dnm4)); 
   amoc_fs(:,ind)=(nancumsum(dnm4)); 

%%% Deep Western BC %%%
   dnm=nansum(sq(vflx(:,ind1,inddw1:inddw2))*1e-9,2); 
   %amoc_DWBC(ind)=min(nancumsum(dnm)); 
   amoc_DWBC(:,ind)=(nancumsum(dnm)); 
   amoc_DWBC_upper(ind)=max(nancumsum(dnm)); 

%%% Ocean Interior %%%  %Northward transport so negative so minimum
   dnm=nansum(sq(vflx(:,ind1,inddw2+1:indy2))*1e-9,2); 
   %amoc_OI(ind)=min(nancumsum(dnm)); 
   amoc_OI(:,ind)=(nancumsum(dnm)); 

%%% Ekman %%%    
   dnm_EK=-(taux.*dx./f)*1e-9;  % Ekman Transport which is M_y=-taux/f  need to multiply by dx and divide 1e-9 to get in Sv.
   amoc_EK(:,ind)=(dnm_EK(ind1,indy1:indy2));

%%% Ekman in x-direction%%%    
   dnm_EK2=-(taux.*dy./f)*1e-9;  % Ekman Transport which is M_x=tauy/f  need to multiply by dx and divide 1e-9 to get in Sv.
   amoc_EK2(:,ind)=(dnm_EK2(ind1-10,indy1:indy2));

%    for i=1:nx
%    for j=1:ny
%      tauy_dx(i,j)=(tauy(i,j)-tauy(inw(i,j),jnw(i,j)))./(qdx(i,j));
%      taux_dy(i,j)=(taux(i,j)-taux(ins(i,j),jns(i,j)))./(qdy(i,j));
%    end
%    end
%    taucurl=tauy_dx-taux_dy;
  ind
  ind=ind+1;
%  end
end


