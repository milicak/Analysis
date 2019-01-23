clear all

load('/home/milicak/models/MITgcm/Projects/mitgcm_sose/input/grid.mat');
outname = 'BATHY_4320x640_SO_9km.bin'

Nxc = size(Depth,1);
Nyc = size(Depth,2);

nx = 1:Nxc;
ny = 1:Nyc;

nxh = 1:0.5:Nxc;
nyh = 1:0.5:Nyc;

[nxg nyg]=meshgrid(nx,ny);
[nxgh nygh]=meshgrid(nxh,nyh);

depth2 = griddata(nxg,nyg,Depth',nxgh,nygh);

Depth2 = NaN*zeros(2*Nyc,2*Nxc);
Depth2(2:end,2:end) = depth2(:,:);
Depth2(1,2:end) = depth2(1,:);
Depth2(2:end,1) = depth2(:,1);
Depth2(1,1) = Depth(1,1);
Depth2(Depth2<0.1) = 0;
Depth2(Depth2<10 & Depth2~=0) = 10;

Depth2 = -Depth2';
Depth2(3479:3484,639) = 0;
Depth2(3479:3484,640) = 0;

writebin(outname,Depth2,1,'real*4');
