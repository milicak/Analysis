clear all

folder_name='/fimm/work/milicak/mnt/norstore/NS2345K/noresm/cases/';
%folder_name='/hexagon/work/milicak/archive';

months2days=[31  28  31  30  31   30   31  31   30 31   30 31]./365;
yeardays=sum(months2days);

project_name='NBF1850OC_f19_tn11_01'
%project_name='NBF1850OC_f19_tn11_test_GM_02'
%project_name='N1850_f19_tn11_01_default'
%project_name='NOIIA_T62_tn11_sr10m60d_01';

grid_file='../../climatology/Analysis/grid.nc';

lat=ncread(grid_file,'plat');
dx=ncread(grid_file,'pdx');
f=coriolis(lat);
months_end=12;
%time_str=101;
%time_end=130;
time_str=250;
time_end=300;

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
   filename=[folder_name '/' project_name '/ocn/hist/' project_name '.micom.hy.' no '.nc'];
   zt=ncread(filename,'depth');

   vflx=ncread(filename,'vflx');
   uflx=ncread(filename,'uflx');
   h=ncread(filename,'dp')*1e-4;
   %temp=ncread(filename,'temp');

%   tauy=ncread(filename,'tauy');
%   vflx_gm=ncread(filename,'vmfltdlvl');
%   dnm_gm=nansum(sq(vflx_gm(:,ind1,30:96))*1e-9,2);
%   amoc_gm_max(ind)=max(nancumsum(dnm));                             % Max AMOC_GM transport at 25.59N

   sec26v(:,:,ind)=squeeze(vflx(indy1:indy2,ind1,:))*1e-9;
   sec26u(:,:,ind)=squeeze(uflx(indy1:indy2,ind1,:))*1e-9;
   %sec26t(:,:,ind)=squeeze(temp(indy1:indy2,ind1,:));
   sec26h(:,:,ind)=squeeze(h(indy1:indy2,ind1,:));

   dnm1=nansum(sq(vflx(indy1+1:indy2,ind1,:))*1e-9,1);   %261 corresponds to 25.59N which is corner of Florida. 30:96 from east to west
   %amoc_max(ind)=max(nancumsum(dnm1));                                   % Max AMOC transport at 25.59N
   amoc_max(:,ind)=(nancumsum(dnm1));                                   % Max AMOC transport at 25.59N

if ind1==261
%%% LEFT-HAND SIDE Florida Current %%%
   dnm2=(sq(vflx(31:31,ind1,:))*1e-9); 
   %amoc_fs(ind)=max(nancumsum(dnm2)); 
   amoc_fs(:,ind)=dnm2; 
   amoc_fs_sum(:,ind)=(nancumsum(dnm2)); 

%%% RIGHT-HAND SIDE Florida Current %%%
   dnm3=nansum(sq(vflx(32:34,ind1,:))*1e-9,1); 
   %amoc_fs2(ind)=max(nancumsum(dnm3)); 
   amoc_fs2(:,ind)=(nancumsum(dnm3)); 
end
%%% BOTH SIDES Florida Current %%%
   dnm4=nansum(sq(vflx(indfs1:indfs2,ind1,:))*1e-9,1); 
   %amoc_fs3(ind)=max(nancumsum(dnm4)); 
   amoc_fs3(:,ind)=(nancumsum(dnm4)); 

%%% Deep Western BC %%%
   dnm=nansum(sq(vflx(inddw1:inddw2,ind1,:))*1e-9,1); 
   %amoc_DWBC(ind)=min(nancumsum(dnm)); 
   amoc_DWBC(:,ind)=(nancumsum(dnm)); 
   amoc_DWBC_upper(ind)=max(nancumsum(dnm)); 

%%% Ocean Interior %%%  %Northward transport so negative so minimum
   dnm=nansum(sq(vflx(inddw2+1:indy2,ind1,:))*1e-9,1); 
   %amoc_OI(ind)=min(nancumsum(dnm)); 
   amoc_OI(:,ind)=(nancumsum(dnm)); 

%%% Ocean Interior2 %%%  %Northward transport so negative so minimum
   %dnm=nansum(sq(vflx(:,ind1,35:indy2))*1e-9,2); 
   if ind1==286
     dnm=nansum(sq(vflx(inddw2+1:indoi1,ind1,:))*1e-9,1); 
     amoc_OI2(:,ind)=(nancumsum(dnm)); 
   end

   taux = zeros(size(h,1),size(h,2));
   for months = 1:months_end
     no2 = num2str(months,'%.2d');
     filename2=[folder_name '/' project_name '/ocn/hist/' project_name '.micom.hm.' no '-' no2 '.nc'];
     taux=taux+ncread(filename2,'taux')*months2days(months);
   end
%%% Ekman %%%    
   dnm_EK=-(taux.*dx./f)*1e-9;  % Ekman Transport which is M_y=-taux/f  need to multiply by dx and divide 1e-9 to get in Sv.
   amoc_EK(:,ind)=(dnm_EK(indy1:indy2,ind1));

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


