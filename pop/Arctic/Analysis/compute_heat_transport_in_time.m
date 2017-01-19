clear all

root_name = '/fimm/work/milicak/mnt/viljework/archive/';
%root_name = '/fimm/work/milicak/mnt/norstore/NS2345K/noresm/cases/';

%project_name = 'B1850CN_f19_tn11_kdsens';
%project_name = 'B1850CN_f19_tn11_kdsens01';
%project_name = 'B1850CN_f19_tn11_kdsens02';
%project_name = 'B1850CN_f19_tn11_kdsens03';
%project_name = 'B1850CN_f19_tn11_kdsens04';
%project_name = 'B1850CN_f19_tn11_kdsens05';
%project_name = 'B1850CN_f19_tn11_kdsens06';
project_name = 'B1850CN_f19_tn11_kdsens07';

folder_name = [root_name project_name '/ocn/hist/'];


grid_file='/bcmhsm/milicak/RUNS/noresm/CORE2/Arctic/DATA/ncar-pop/areacello_fx_CCSM4_piControl_r0i0p0.nc';
area=ncgetvar(grid_file,'areacello');

if 1
resolution1=2.5; %1; %0.5;
resolution2=1.875; %1; %0.5;
nx=360*1/resolution1;
ny=180*1/resolution2;
deg2rad=pi/180;
%grid_center_lat=ones(nx,1)*(-89.5:resolution:89.5);
%grid_center_lon=(0.5:resolution:359.5)'*ones(1,ny);
grid_center_lat=ones(nx,1)*(-90+resolution2*0.5:resolution2:90-resolution2*0.5);
grid_center_lon=(0+resolution1*0.5:resolution1:360-resolution1*0.5)'*ones(1,ny);
grid_corner_lat=zeros(4,nx,ny);
grid_corner_lon=zeros(4,nx,ny);
grid_corner_lat(1,:,:)=grid_center_lat-0.5*resolution2;
grid_corner_lat(2,:,:)=grid_center_lat-0.5*resolution2;
grid_corner_lat(3,:,:)=grid_center_lat+0.5*resolution2;
grid_corner_lat(4,:,:)=grid_center_lat+0.5*resolution2;
grid_corner_lon(1,:,:)=grid_center_lon-0.5*resolution1;
grid_corner_lon(2,:,:)=grid_center_lon+0.5*resolution1;
grid_corner_lon(3,:,:)=grid_center_lon+0.5*resolution1;
grid_corner_lon(4,:,:)=grid_center_lon-0.5*resolution1;
grid_area=2*(sin(grid_corner_lat(4,1,:)*deg2rad) ...
            -sin(grid_corner_lat(1,1,:)*deg2rad))*pi/nx;
grid_area=ones(nx,1)*reshape(grid_area,1,[]);
m2rad=distdim(1,'m','rad');
%convert rad2 area to m2
grid_area=grid_area./(m2rad.*m2rad);

end

datesep = '-';
fyear = 1;
lyear = 250;
daysweights = [31 28 31 30 31 30 31 31 30 31 30 31]./365;

nitr = 1;
for year=fyear:lyear
  htglobal = 0;
  htatlantic = 0;
  for month=1:12
     
     sdate=sprintf('%4.4d%c%2.2d',year,datesep,month);
     disp(sdate)
     filename = [folder_name project_name '.pop.h.' sdate '.nc'];
     tmp = ncgetvar(filename,'N_HEAT');

     if(nitr==1)
        lat = ncgetvar(filename,'lat_aux_grid');
     end
     dnm = tmp(:,1,1); %global heat transport
     htglobal = htglobal+dnm*daysweights(month);
     dnm = tmp(:,2,2)+tmp(:,4,2)+tmp(:,5,2); %atlantic heat transport
     htatlantic = htatlantic+dnm*daysweights(month);
  end
     HTglobal(:,nitr) = htglobal;
     HTatlantic(:,nitr) = htatlantic;
     nitr = nitr+1;
end

save(['matfiles/' project_name '_heat_transport_' num2str(fyear) '_' num2str(lyear) '.mat'],'HTglobal','HTatlantic','lat')

exit
