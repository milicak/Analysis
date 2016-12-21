
clear all
folder_name='/hexagon/work/milicak/archive';
project_name='N1850_f19_tn11_01_default'
%project_name='NOIIA_T62_tn11_sr10m60d_01';
grid_file='grid.nc';
nreg=2;
i0=25;
j0=290; % a point in North-America

lat=nc_varget(grid_file,'plat');
mask=nc_varget(grid_file,'pmask');
dx=nc_varget(grid_file,'pdx');
f=coriolis(lat);
months_end=12;
%time_str=101;
%time_end=130;
time_str=1;
time_end=30;

ind=1;
for time_ind = time_str:time_end 
 no = num2str(time_ind,'%.4d');
 for months = 1:months_end
   no2 = num2str(months,'%.2d');
   filename=[folder_name '/' project_name '/ocn/hist/' project_name '.micom.hm.' no '-' no2 '.nc'];
   zt=nc_varget(filename,'depth');

   vflx=nc_varget(filename,'vflxlvl');
   uflx=nc_varget(filename,'uflxlvl');

   uflx=squeeze(nansum(uflx,1));
   vflx=squeeze(nansum(vflx,1));

   strmf(ind,:,:)=micom_strmf(uflx'.*1e-9,vflx'*1e-9,i0,j0,nreg)'.*mask;

  ind
  ind=ind+1;
  end
end


