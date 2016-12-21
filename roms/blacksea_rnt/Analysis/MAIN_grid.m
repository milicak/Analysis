% Main program to generate the grid file for ROMS.
% Please mannually step through this script and edit when
% it is requested. You will find a line marked EDIT.
% E. Di Lorenzo - May 2003 - update Aug. 2005
disp('Please mannually step through this script');
return

% This script will help you generate rectangular curvilinear grids only.

%==========================================================
%	Preparing the grid param
%==========================================================
  
 % EDIT: set a name to recognize the grid
 nameit='blacksea';  % 0.75 km grid

 % EDIT: set path where you want to store the grid.
 outdir=['./']; 
 if ~exist(outdir), unix(['mkdir ',outdir]);end
 grdfile=[outdir,nameit,'-grid.nc'];  

% EDIT: insert detailed coastline file if wanted. You can extract it
% form the web at: rimmer.ngdc.noaa.gov/coast
% After you donwload the file use ConvertCstdat2mat.m
% otherwise use default. The format is lon,lat in the mat file.
 seagridCoastline=which('rgrd_CoastlineWorld.mat');  % default centered on Atlantic/Indian
 seagridCoastline=which('rgrd_CoastlineWorldPacific.mat'); % default centered on Pacific
 seagridCoastline='blacksea_coast.mat'; % default centered on Pacific

 
 rgrd_DrawCstLine(seagridCoastline);
 
 %use zoom command to get roughly corner areas 
 
 % zoom in the picture to approximately select the location of
 % your final grid.
 [Lons]=get(gca,'xlim');
 LonMin=Lons(1); LonMax=Lons(2);
 [Lats]=get(gca,'ylim');
 LatMin=Lats(1); LatMax=Lats(2);
 close
 
 % EDIT: set ax= [LonMin, LonMax, LatMin, LatMax]
 % so that you include the location of the grid your
 % are building

 ax= [LonMin, LonMax, LatMin, LatMax]
 

 % EDIT: put the name of the file in which the scirpt will
 % save the 4 corners of your grid in LON,LAT . 
 CornerFile= [outdir,'GridCorners-',nameit,'.dat'];

% yu have two options to generate the corners of the grid:
% OPT: 1
% If your corner are the one in ax then just write the 
% corner file. WriteCornerFileFromAX.m
  rgrd_WriteCornerFileFromAX(ax,CornerFile);

% OPT: 2 
% IF you already have a corner file than skip the FindGridCorners
 % use this routine to design grid if needed. FindGridCorners.m 
 rgrd_FindGridCorners (ax,seagridCoastline,CornerFile);
 close all
 
 
 
 % Plot grid
 rgrd_PlotGridCorners(ax,CornerFile,seagridCoastline);

 % Find the distance and needed reolution for the grid.
 % TellMeCornerDist.m
 [x_spacing,y_spacing]=rgrd_TellMeCornerDist(CornerFile);
  % remember these spacing, round them to be even.
  disp('You need to set these in Seagrid');
  Cells_Edge_1 = round(y_spacing/2)*2
  Cells_Edge_2 = round(x_spacing/2)*2

 
%==========================================================
%	Build grid  -  Running Seagrid 
%==========================================================
% Seagrid will be used only to generate the curv. grid 
% nothing else, no bath, no masking here.
 % execute seagrid and prepare grid
 % in seagrid just 
 % 1) load the coastline file and the boundary file
 % 2) set the spacing in setup using Cells_Edge_1, Cells_Edge_2
 % 3) On the menu compute select "Set all water"
 % 4) then save the seagrid.mat file and exit.
  seagrid(seagridCoastline)
 % if you like you can also load the topography and use the
 % mask computation options. I prefer taking care of this later
 % in this script. It is up to you.
 
 % convert seagrid file to ROMS grid
 seagrid2roms('seagrid.mat', grdfile);

 % EDIT add new grid in the rnt_gridinfo.m 
 configfile=which('rnt_gridinfo');
 unix(['vi ',configfile]);
 grd=rnt_gridload(nameit);

% To look at the deltax and deltay use 
 rnt_plcm(1./grd.pm,grd);
 rnt_plcm(1./grd.pn,grd);

%==========================================================
%	topography
%==========================================================

%EDIT: Choose how you want to make your topo. Below is some
% code that will do either Sandwell and Smith or ETOPO 5

  h=grd.h;
  h(:,:)=-4000; % set to some analytical function or use
  % Sandwell and Smith below.

% OPTION 1:
  % Extract Sandwell and Smith topo -----------------------
  %region to be extracted from the Sandwell and Smith topo
  %[south north west east];
  region =[min(grd.latr(:))-1 max(grd.latr(:))+1 ...
           min(grd.lonr(:))-1+360 max(grd.lonr(:))+1+360];

  region =[min(grd.latr(:))-1 max(grd.latr(:))+1 ...
           min(grd.lonr(:))-1 max(grd.lonr(:))+1]
  
  [image_data,vlat,vlon] = mygrid_sand(region);

   hold on
  rnt_gridbox(grd,'k');
  
  % DX=1; DY=1;
  
  [vlon,vlat]=meshgrid(vlon,vlat);
  
  % still need to do some work to make this better and more
  % efficient. May take long.
%tic;  h=rnt_griddata(vlon,vlat,image_data,grd.lonr,grd.latr,'cubic');toc;
  h=griddata(vlon,vlat,image_data,grd.lonr,grd.latr,'cubic');
  % End Extract Sandwell and Smith topo --------------------

% OPTION 2: 
% Extract ETOPO

file=which('etopo5.nc');  % file is located in path in rgrd toolbox
%[topo,lon,lat] = rgrd_GetEtopo5 (file,lonmin,lonmax,latmin,latmax);
[topo,lon,lat] = rgrd_GetEtopo5 (file,region(3), region(4),region(1), region(2));
tic;  h=rnt_griddata(lon,lat,topo,grd.lonr,grd.latr,'cubic');toc;

% End Extract Etopo5 --------------------
  
  % store raw topography
  h(h>0) = 0;
  h = abs(h); % need to be positive for ROMS convention.
  nc=netcdf(grdfile,'w');
  nc{'h'}(:,:)=h';
  nc{'hraw'}(1,:,:)=h';
  close(nc);
  % reload grid
  grd=rnt_gridload(nameit);
  
  %EDIT: set minimum depth for topography.
  hmin = 10; 
  hmax = 2500; 
  hraw = sq(grd.hraw(1,:,:));
  hraw(hraw< hmin) = hmin;
  hraw(hraw> hmax) = hmax;
  rnt_plcm(rvalue(hraw),grd); title 'rvalue h';
  
  
  
  
  % Now start smoothing ----------------------------------
  % start smoothing if you find rvalue > 0.2
  % this is an approximate method.

  % topography soothing
  % OPT 1 : shapiro
  tmp = shapiro2(hraw,2,2);   % once filtered
  for i=1:10
     tmp = shapiro2(tmp,2,2);   % once filtered
  end  
  rnt_plcm(rvalue(tmp),grd); title 'rvalue h';
  
  % OPT 2 : smoothing in logaritmic space
  rfac=0.35;   % maximum slope of topography allowed in smoothing
  tmp = rgrd_smoothgrid(hraw,hmin,rfac); % this is Pierick's routine
  rnt_plcm(rvalue(tmp),grd); title 'rvalue h'; 

  % OPT 3 : shapiro filter in selected regions only where rfac is too high
  % this is Hernan's way. However you can smooth the topo only 
  % after you completed the mask, as it is needed as one of the input 
  % files.
  rfac=0.35;
  order=2; % order of shapiro filter
  [tmp]=rgrd_smth_bath(hraw,rmask,order,rfac);
   rnt_plcm(rvalue(tmp),grd); title 'rvalue h';

    
  %save topo
  nc=netcdf(grdfile,'w');
  nc{'h'}(:,:)=tmp';
  close(nc)
% end smoothing ----------------------------------------
  
  
 % check what has been done so far... 
  figure;
  grd=rnt_gridload(nameit);
  subplot(2,2,1); rnt_plcm(sq(grd.hraw(1,:,:)),grd); title 'hraw'
  subplot(2,2,2); rnt_plcm(grd.h,grd); title (['h  (min depth ',num2str(hmin),' )'])
  subplot(2,2,3); rnt_plcm(rvalue(grd.h),grd); title 'rvalue h'
  subplot(2,2,4); rnt_plcm(grd.h-sq(grd.hraw(1,:,:)),grd); title 'h - hraw'
 
%==========================================================
%	Masking
%==========================================================
    
  grd=rnt_gridload(nameit);
  mask=grd.maskr;
  mask(grd.h <= hmin+0.1) =0;

  % you can also interpolate the mask from an existing grid
  % before you do the final re-touches
  grd1=rnt_gridload('usw8');
  mask = rgrd_GetMask(grd1,grd);
  mask(isnan(mask)) =0;
  
  %save raw mask
  nc=netcdf(grdfile,'w');
  nc{'mask_rho'}(:)=mask';
  close(nc);
  
  % utility from Rutgers modified to use rnt_griddata
  % will produce a file called ijcoast.mat
  seagridCoastline=grd.cstfile;
  [C]=rgrd_ijcoast(grdfile,seagridCoastline);  
    
 
  
  editmask(grdfile,'ijcoast.mat'); %by Andrey Scherbina
  % if you do not want to change anything still
  % run editmask, press the SAVE button once and
  % then exit. Thanks.

  % Your grid is ready.
  grd=rnt_gridload(nameit);

