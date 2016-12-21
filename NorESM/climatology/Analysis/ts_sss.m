
clear all
folder_name='/hexagon/work/milicak/archive';
%project_name='N1850_f19_tn11_01_default'
%project_name='N1850_f19_tn11_01_BG'
project_name='NOIIA_T62_tn11_sr10m60d_01'
%project_name='NOIIA_T62_tn11_ctrl'
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

ind=1;
for time_ind = time_str:time_end
 no = num2str(time_ind,'%.4d');
 for months = 1:months_end
   no2 = num2str(months,'%.2d');
   filename=[folder_name '/' project_name '/ocn/hist/' project_name '.micom.hm.' no '-' no2 '.nc'];
   salt(:,:,ind)=nc_varget(filename,'salnlvl',[0 0 0 0],[1 1 -1 -1]);
   ind
   ind=ind+1;
  end
end


