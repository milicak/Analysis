% Script to set irminger grid and domain 
% for a 2km nominal resolution
% itimu, Jan 10 
% based on set_spill_jet_grid_stretched.m by twhn Jul 04, Sep 07

fprintf(1,' Setting domain boundaries and resolution for 2km Spill jet model with OBCS: \n\n') ;

%output parameters
%dxfile='dx_2km.bin';
%dyfile='dy_2km.bin';
dzfile='dz_2km.bin';
loncfile='LONC.bin';
latcfile='LATC.bin';
longfile='LONG.bin';
latgfile='LATG.bin';
dxffile='DXF.bin';
dyffile='DYF.bin';
dxgfile='DXG.bin';
dygfile='DYG.bin';
dxcfile='DXC.bin';
dycfile='DYC.bin';
dxvfile='DXV.bin';
dyufile='DYU.bin';
razfile='RAZ.bin';
rawfile='RAW.bin';
rafile='RA.bin';
rasfile='RAS.bin';

accur='real*8';
ieee='b';


grfile = '/okyanus/users/milicak/dataset/urmia/ROMS_Urmia.nc'
LONC = ncread(grfile, 'lon_rho');
LATC = ncread(grfile, 'lat_rho');
LONG = ncread(grfile, 'lon_psi');
LATG = ncread(grfile, 'lat_psi');
LONC = LONC(2:end-1,2:end-1);
LATC = LATC(2:end-1,2:end-1);

% LONC = LONC(3:end-1,2:end-1);
% LATC = LATC(3:end-1,2:end-1);
% LONG = LONG(1:end-1,1:end-1);
% LATG = LATG(1:end-1,1:end-1);

% LONC = LONC(3:end-2,2:end-1);
% LATC = LATC(3:end-2,2:end-1);
% LONG = LONG(2:end-2,1:end-1);
% LATG = LATG(2:end-2,1:end-1);

LONC = fliplr(LONC');
LATC = fliplr(LATC');
LONG = fliplr(LONG');
LATG = fliplr(LATG');
LONG = LONG(1:end-1,1:end-1);
LATG = LATG(1:end-1,1:end-1);

% reduce one last points
LONC = LONC(:,2:end-1);
LATC = LATC(:,2:end-1);
LONG = LONG(:,2:end-1);
LATG = LATG(:,2:end-1);
% return

[NX, NY] = size(LONC);
%
% compute lonc and latc
% LONC (x,y) dimensions
% LATC (x,y) dimensions
% LONC.bin  longitude east of cell center
% LATC.bin  latitude north of cell center
% LONG.bin  longitude east of southwest corner of cell
% LATG.bin  latitude north of southwest corner of cell
% DYF.bin   meridional distance in m between V-points
% DXF.bin   zonal distance in m between U-points
% DYU.bin   meridional distance in m between U-points
% DXV.bin   zonal distance in m between V-points
% DYC.bin   meridional distance in m between tracer points
% DXC.bin   zonal distance in m between tracer points
% DYG.bin   meridional distance in m between cell corners
% DXG.bin   zonal distance in m between cell corners
% RAZ.bin   vertical face area in m^2 for vorticity points
% RAW.bin   vertical face area in m^2 for u cells
% RAS.bin   vertical face area in m^2 for v cells
% RA.bin    vertical face area in m^2 for tracer cells

% DX*.bin should be (Nx*NY,1) size
earthRadiusInMeters = 6371000;
dx = distance(LATC(1:end-1,:),LONC(1:end-1,:),LATC(2:end,:),LONC(2:end,:),earthRadiusInMeters);
dy = distance(LATC(:,1:end-1),LONC(:,1:end-1),LATC(:,2:end),LONC(:,2:end),earthRadiusInMeters);
dx(end+1,:) = dx(end,:);
dy(:,end+1) = dy(:,end);
dx = dx(:);
dy = dy(:);
delX = dx;
delY = dy;

% Writing files
if 1
 fprintf(1,' Writing fields to grid files \n') ;
 fprintf(1,'delX into %s\n',dxffile) ; 
 fprintf(1,'delY into %s\n',dyffile) ;
  
fid=fopen(loncfile,'w',ieee); fwrite(fid,LONC,accur); fclose(fid);
fid=fopen(longfile,'w',ieee); fwrite(fid,LONG,accur); fclose(fid);
fid=fopen(latcfile,'w',ieee); fwrite(fid,LATC,accur); fclose(fid);
fid=fopen(latgfile,'w',ieee); fwrite(fid,LATG,accur); fclose(fid);
fid=fopen(dxffile,'w',ieee); fwrite(fid,delX,accur); fclose(fid);
fid=fopen(dyffile,'w',ieee); fwrite(fid,delY,accur); fclose(fid);
fid=fopen(dxgfile,'w',ieee); fwrite(fid,delX,accur); fclose(fid);
fid=fopen(dygfile,'w',ieee); fwrite(fid,delY,accur); fclose(fid);
fid=fopen(dxcfile,'w',ieee); fwrite(fid,delX,accur); fclose(fid);
fid=fopen(dycfile,'w',ieee); fwrite(fid,delY,accur); fclose(fid);
fid=fopen(dxvfile,'w',ieee); fwrite(fid,delX,accur); fclose(fid);
fid=fopen(dyufile,'w',ieee); fwrite(fid,delY,accur); fclose(fid);
fid=fopen(razfile,'w',ieee); fwrite(fid,delX.*delY,accur); fclose(fid);
fid=fopen(rawfile,'w',ieee); fwrite(fid,delX.*delY,accur); fclose(fid);
fid=fopen(rafile,'w',ieee); fwrite(fid,delX.*delY,accur); fclose(fid);
fid=fopen(rasfile,'w',ieee); fwrite(fid,delX.*delY,accur); fclose(fid);
end % if



