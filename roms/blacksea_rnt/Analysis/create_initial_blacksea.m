clear all
%%%%%%%%%%%%%%%%%%%%%   START OF USER INPUT  %%%%%%%%%%%%%%%%%%%%%%%%%%
%cd ~/matlab/nctoolbox/
%setup_nctoolbox
%addpath('/home/mil021/models/COAWST/Tools/mfiles/roms_clm')

clim_name='blacksea-clim_all.nc';
ini_name='blacksea-ini.nc';
bndry_name='blacksea-bndry.nc';


% (1) Enter start date (T1) to get climatology data 
T1=datenum(2012,1,1,0,0,0); %start date
% (3) Enter working directory (wdr)
wdr='/home/mil021/Analysis/roms/blacksea_rnt/Analysis';

% (4) Enter path and name of the ROMS grid (modelgrid)
nameit='blacksea';

gn=rnt_gridload(nameit);
gn.vtra = 1;
gn.vstr = 4;
gn.theta_s = 5.0;
gn.theta_b = 0.4;

fn=clim_name;

% Call to create the initial (ini) file
disp('going to create init file')
make_initial_blacksea(fn,gn,ini_name,wdr,T1)



