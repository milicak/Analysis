%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear all 
close all
load grid
nx=3360;
ny=3072;
fact=6370/6.378137;  % factor used to convert km output from m_lldist on
                     % a sphere with 6378.137 km to m on a sphere with
                     % radius 6370 km

% LONC, LATC: longitude and latitude of cell center
% writebin('LONC.bin',LON(4:2:(end-3),4:2:(end-3)));
% writebin('LATC.bin',LAT(4:2:(end-3),4:2:(end-3)));
writebin('LONC.bin',LON(3:1:(end-3),3:1:(end-3)));
writebin('LATC.bin',LAT(3:1:(end-3),3:1:(end-3)));

% LONG, LATG: longitude and latitude of cell corner
% writebin('LONG.bin',LON(3:2:(end-4),3:2:(end-4)));
% writebin('LATG.bin',LAT(3:2:(end-4),3:2:(end-4)));
writebin('LONG.bin',LON(2:1:(end-4),2:1:(end-4)));
writebin('LATG.bin',LAT(2:1:(end-4),2:1:(end-4)));

% DXF: x-distance between u-points
DXF=zeros(nx,ny);
for j=1:ny
  % DXF(:,j)=fact*m_lldist(LON(3:2:(end-1),j*2+2),LAT(3:2:(end-1),j*2+2));
  DXF(:,j)=fact*m_lldist(LON(2:1:(end-3),j*1+2),LAT(2:1:(end-3),j*1+2));
end
writebin('DXF.bin',DXF);

% DYF: y-distance between v-points
DYF=zeros(nx,ny);
for i=1:nx
  % DYF(i,:)=fact*m_lldist(LON(i*2+2,3:2:(end-1)),LAT(i*2+2,3:2:(end-1)));
  DYF(i,:)=fact*m_lldist(LON(i*1+2,2:1:(end-3)),LAT(i*1+2,2:1:(end-3)));
end
writebin('DYF.bin',DYF);

% DXC: x-distance between tracer points
DXC=zeros(nx,ny);
for j=1:ny
  % DXC(:,j)=fact*m_lldist(LON(2:2:(end-3),j*2+2),LAT(2:2:(end-3),j*2+2));
  DXC(:,j)=fact*m_lldist(LON(2:1:(end-3),j*1+2),LAT(2:1:(end-3),j*1+2));
end
writebin('DXC.bin',DXC);

% DYC: y-distance between tracer points
DYC=zeros(nx,ny);
for i=1:nx
  % DYC(i,:)=fact*m_lldist(LON(i*2+2,2:2:(end-3)),LAT(i*2+2,2:2:(end-3)));
  DYC(i,:)=fact*m_lldist(LON(i*1+2,2:1:(end-3)),LAT(i*1+2,2:1:(end-3)));
end
writebin('DYC.bin',DYC);

% DXV: x-distance between v-points
DXV=zeros(nx,ny);
for j=1:ny
  % DXV(:,j)=fact*m_lldist(LON(2:2:(end-3),j*2+1),LAT(2:2:(end-3),j*2+1));
  DXV(:,j)=fact*m_lldist(LON(2:1:(end-3),j*1+1),LAT(2:1:(end-3),j*1+1));
end
writebin('DXV.bin',DXV);

% DYU: y-distance between u-points
DYU=zeros(nx,ny);
for i=1:nx
  % DYU(i,:)=fact*m_lldist(LON(i*2+1,2:2:(end-3)),LAT(i*2+1,2:2:(end-3)));
  DYU(i,:)=fact*m_lldist(LON(i*1+1,2:1:(end-3)),LAT(i*1+1,2:1:(end-3)));
end
writebin('DYU.bin',DYU);

% DXG: x-distance between corner points
DXG=zeros(nx,ny);
for j=1:ny
  % DXG(:,j)=fact*m_lldist(LON(3:2:(end-1),j*2+1),LAT(3:2:(end-1),j*2+1));
  DXG(:,j)=fact*m_lldist(LON(3:1:(end-2),j*1+1),LAT(3:1:(end-2),j*1+1));
end
writebin('DXG.bin',DXG);

% DYG: y-distance between corner points
DYG=zeros(nx,ny);
for i=1:nx
  % DYG(i,:)=fact*m_lldist(LON(i*2+1,3:2:(end-1)),LAT(i*2+1,3:2:(end-1)));
  DYG(i,:)=fact*m_lldist(LON(i*1+1,3:1:(end-2)),LAT(i*1+1,3:1:(end-2)));
end
writebin('DYG.bin',DYG);

% tracer cell area: dxf * dyf
RA=DXF.*DYF;
writebin('RA.bin',RA);

% vorticity point area: dxv * dyu
RAZ=DXV.*DYU;
writebin('RAZ.bin',RAZ);

% u-cell area: dxc * dyg
RAW=DXC.*DYG;
writebin('RAW.bin',RAW);

% v-cell area: dxg * dyc
RAS=DXG.*DYC;
writebin('RAS.bin',RAS);

