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

% 432x288 interior grid 
lonmin=27 ;
lonmax=42 ; 
latmin=40.0 ;
latmax=48.0 ;
NX = 446 ;
%NX = 510 ;
NY = 254 ;
rdelx=NX/(lonmax-lonmin) ;   % Calculate central spacing the same as before. 
rdely=NY/(latmax-latmin) ;
tmp_delX = 1/rdelx ;
tmp_delY = 1/rdely ;

% Stretched grid based on above grid. 
% Stretch 24 points at N edge, 48 at S edge and 18 points at W edge and 90 at E edge.
% Extend existing grid to 540x360
stretchN = 1; %[1:8/46:5]' ;
stretchS = 1; %[1:8/94:5]' ;
delY = [flipud(stretchS).*tmp_delY; tmp_delY.*ones(NY,1);stretchN.*tmp_delY] ;
stretchW = 1; %[1:8/34:5]' ;
stretchE = 1; %[1:8/178:5]' ;
delX = [flipud(stretchW).*tmp_delX; tmp_delX.*ones(NX,1);stretchE.*tmp_delX] ;
latmin = latmin - sum(stretchS.*tmp_delY) ; % Stretch south.
latmax = latmax + sum(stretchN.*tmp_delY) ; % Stretch north.
lonmin = lonmin - sum(stretchW.*tmp_delX) ; % Stretch west. 
lonmax = lonmax + sum(stretchE.*tmp_delX) ; % Stretch east. 
NX = length(delX) ;
NY = length(delY) ;
 fprintf(1,'delY=') ;
 fprintf(1,'     %5.4e,%5.4e,%5.4e,%5.4e,%5.4e,%5.4e,%5.4e,%5.4e,%5.4e,%5.4e,\n',delY(1:length(stretchS))) ;
 fprintf(1,'\n     %d*%5.4e,\n',NY-(length(stretchN)+length(stretchS)),tmp_delY) ;
 fprintf(1,'     %5.4e,%5.4e,%5.4e,%5.4e,%5.4e,%5.4e,%5.4e,%5.4e,%5.4e,%5.4e,\n',delY(NY-length(stretchN)+1:NY)) ;
 fprintf(1,'\n\ndelX=') ;
 fprintf(1,'     %5.4e,%5.4e,%5.4e,%5.4e,%5.4e,%5.4e,%5.4e,%5.4e,%5.4e,%5.4e,\n',delX(1:length(stretchW))) ;
 fprintf(1,'\n     %d*%5.4e,\n',NX-(length(stretchE)+length(stretchW)),tmp_delX) ;
 fprintf(1,'     %5.4e,%5.4e,%5.4e,%5.4e,%5.4e,%5.4e,%5.4e,%5.4e,%5.4e,%5.4e,\n',delX(NX-length(stretchE)+1:NX)) ;
 fprintf(1,'\n\n') ;  
XC = lonmin+cumsum(delX) - delX./2 ;
YC = latmin+cumsum(delY) - delY./2 ;
XG = lonmin+cumsum(delX) - delX ;
YG = latmin+cumsum(delY) - delY ;
XGN1 = XG ;
XGN1(NX+1) = XG(NX) + delX(NX);
YGN1 = YG ;
YGN1(NY+1) = YG(NY) + delY(NY);

% Testing
if 0
    incr=2.5;    
    m_proj('lambert','long',[lonmin-incr lonmax+incr],'lat',[latmin-incr latmax+incr]);
    [x,y]=meshgrid(XC,YC) ;
    m_plot(x(:),y(:),'.') ;
    hold on
    m_grid('box','fancy','tickdir','in');
    m_coast('patch',[.7 .7 .7],'edgecolor','r');
    hold off
end % if

delZ = [2:1:20, 20.*ones(1,60), 30:10:200] ;
depths = cumsum(delZ) - delZ./2 ;
NZ = length(depths) ;
deltat = 600 ;  % timestep in secs.
start_date = datenum('01-Jan-2011') ;

 fprintf(1,'                      [%g] degN                       \n',latmax) ;
 fprintf(1,'    [%g] degE                            [%g] degE    \n',lonmin,lonmax) ;
 fprintf(1,'                      [%g] degN                       \n\n',latmin) ;
 fprintf(1,' [%d] steps in longitude with (Min, Max, Mean) spacing = (%g, %g, %g)km.\n',NX,...
 min(delX)*110*min(cos(YC.*pi/180)), max(delX)*110*max(cos(YC.*pi/180)),(lonmax-lonmin)*110*cos((latmax+latmin)*pi/(2*180))/NX) ;
 fprintf(1,' [%d] steps in latitude with  (Min, Max, Mean) spacing = (%g, %g, %g)km.\n',NY,...
 min(delY)*110,max(delY)*110,110*(latmax-latmin)/NY) ;
 fprintf(1,' [%d] vertical levels (see depths variable).         \n\n',NZ) ;
 fprintf(1,' Starting integration on [%s] with [%d]s steps.     \n',datestr(start_date),deltat) ;
 fprintf(1,'\n\n') ;
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
[LONC LATC] = meshgrid(XC,YC);
[LONG LATG] = meshgrid(XG,YG);
LONC = LONC';
LONG = LONG';
LATC = LATC';
LATG = LATG';

% DX*.bin should be (Nx*NY,1) size
delX = repmat(delX,[1 NY]);
delY = repmat(delY,[1 NX]);
delX = delX(:);
delY = delY';
delY = delY(:);
%convert degree to m
% dx
% m_lldist([lon(1,1) lon(2,1)],[lat(1,1) lat(2,1)])*1e3
m_lldist([LONC(1,1) LONC(2,1)],[LATC(1,1) LATC(2,1)])*1e3 
% dy
% m_lldist([lon(1,1) lon(1,2)],[lat(1,1) lat(1,2)])*1e3 
m_lldist([LONC(1,1) LONC(1,2)],[LATC(1,1) LATC(1,2)])*1e3
delX = delX.*111e3;
delY = delY.*111e3;
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
 fprintf(1,'delZ into %s\n\n',dzfile) ;
  
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
fid=fopen(dzfile,'w',ieee); fwrite(fid,delZ,accur); fclose(fid);
fid=fopen(razfile,'w',ieee); fwrite(fid,delX.*delY,accur); fclose(fid);
fid=fopen(rawfile,'w',ieee); fwrite(fid,delX.*delY,accur); fclose(fid);
fid=fopen(rafile,'w',ieee); fwrite(fid,delX.*delY,accur); fclose(fid);
fid=fopen(rasfile,'w',ieee); fwrite(fid,delX.*delY,accur); fclose(fid);
end % if

disp(' ');
fprintf(1,'ygOrigin = %2.5f,\n',min(YG(:))) ;
fprintf(1,'xgOrigin = %2.5f,\n',min(XG(:))) ;


