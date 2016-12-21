%
%EASYGRID   Generates grid for ROMS.
%
%   This is a "quick-and-dirty" way to generate a grid for ROMS, as
%   well as a simple initial conditions file where specified values
%   are constant over the grid domain.
%
%   USAGE: Before running this script, you need to specify the 
%          parameters in the "USER SETTINGS" section of this code. Beside
%          each variable there are detailed instructions. NOTE the 
%          "SWITCHES" section, which turns ON or OFF different
%          functionalities of EASYGRID, for example: edit_mask turns on/off 
%          the mask-editing routine and smooth_grid turns on/off bathymetry 
%          smoothing. You probably will need to run EASYGRID several times in 
%          a iterative manner to create, smooth and mask-edit a grid. See
%          tutorial link below.       
%
%   TUTORIAL: https://www.myroms.org/wiki/index.php/easygrid
%   
%   DEPENDENCIES: MEXNC (specific for your architecture), SNCTOOLS
%                 and the ROMS Matlab toolkit.
%                 For a tutorial on how to download/install dependencies,
%                 see: https://www.myroms.org/wiki/index.php/MEXNC
%
%   LIMITATIONS: This script should NOT be used to generate GLOBAL grids.
%
%   OUTPUTS: 1) NetCDF file (.nc) with grid for ROMS (if save_grid is ON).
%            2) NetCDF file (.nc) with initial conditions (if save_init is ON).
%            3) Screen output of many parameters that need to be 
%               copy-pasted into the ocean.in file (if screen_output is ON).
%            4) Plot of the grid (if plot_grid is ON).
%            5) Mask-Editing interactive plot (if edit_mask is ON), 
%               to change sea-cells into land-cells and vice versa.
%
%   TESTING: After download, run EASYGRID with all the default parameters.
%            If working properly, EASYGRID should save two NetCDF files 
%            (grid and initialization files) for the ROMS "Fjord Tidal Case".
%            Also screen-output of grid parameters and a plot of the grid
%            should be generated.
%
%==================================================================
% DISCLAIMER:
%   This software is provided "as is" without warranty of any kind.  
%==================================================================
%                                     Version: 0 Date: 2008-Apr-24
%
%                      Written by: Diego A. Ibarra (dibarra@dal.ca)
%             with borrowed code from Katja Fennel and John Wilkin,
%                 and with help of many functions by Hernan Arango.
% 
%   See also   SMTH_BATH   SPHERIC_DIST   PCOLORJW.


%****************************************************************************************************************************************************
% USER SETTINGS *************************************************************************************************************************************
%****************************************************************************************************************************************************

% -------------------------------------------------------------------------
% SWITCHES ( ON = 1; OFF = 0 ) --------------------------------------------
% -------------------------------------------------------------------------
    create_grid = 1;   % Create GRID. Turn OFF to work with a previously created grid (i.e. grid variables existing on Workspace)
      plot_grid = 1;   % Plot grid
    smooth_grid = 1;   % Smooth bathymetry using H. Arango's smth_bath.m , which applies a Shapiro filter to the bathymetry
      edit_mask = 0;   % Edit rho-mask using interactive plot. Use this to manually change sea-pixels into land-pixels and vice-versa 
  screen_output = 1;   % Displays (on screen) many parameters that need to be copy-pasted in the ocean.in file    
      save_grid = 1;   % Save GRID in a NetCDF file
                       % ON = 1; OFF = 0
    
% -------------------------------------------------------------------------
% GRID SETTINGS -----------------------------------------------------------
% -------------------------------------------------------------------------

% Geographical and Grid parameters --------
     lat =  40.85;        % Latitude  (degrees) of the bottom-left corner of the grid.
     lon =  34.0;        % Longitude (degrees) of the bottom-left corner of the grid. 

     lat_end = 44.0;        % Latitude  (degrees) of the top-right corner of the grid.
     lon_end = 42.0;        % Longitude (degrees) of the top-right corner of the grid. 
     dl = 1/100;               % distance between grid points in degrees

     rotangle = 0;             % Angle (degrees) to rotate the grid conterclock-wise
     
       
% Bathymetry -------------- % Bathymetry for ROMS is measured positive downwards (zeros are not allowed) see: https://www.myroms.org/wiki/index.php/Grid_Generation#Bathymetry
                            % To allow variations in surface elevation (eg. tides) while keeping all depths positive,
                            % an arbitrary offset (see minh below) is added to the depth vector.
      
      hh = nan;             % Analytical Depth (meters) used to create a uniform-depth grid. If using a bathymetry file, leave hh = nan;
    minh = 10;              % Arbitrary depth offset in meters (see above). minh should be a little more than the maximum expected tidal variation.
   Bathy = 'blacksea_bathy.mat';% Bathymetry file. If using the analytical depth above (i.e. hh ~= nan), then Bathy will not be used.
                            % The bathymetry file should be a .mat file containing 3 vectors (xbathy, ybathy and zbathy). where xbathy = Longitude, 
                            % ybathy = Latitude and zbathy = depth (positive, in meters). xbathy and ybathy are in decimal degrees See: http://en.wikipedia.org/wiki/Decimal_degrees
       %Bathymetry smoothing routine...  See "Switches section" (above) to turn this ON or OFF
       if smooth_grid == 1;
           order = 2;       % Order of Shapiro filter (2,4,8)... default: 2
            rlim = 0.35;    % Maximum r-factor allowed (0.35)... default: 0.35
           npass = 50;      % Maximum number of passes.......... default: 50
       end
%---------------------------------
                       

% Coastline ----------------------
   Coast = load('blacksea_coast.mat'); % If there isn't a coastline file... comment-out this line: e.g. %Coast = load('Fjord_coast.mat');
                                    % The coastline is only used for plotting. The coastline .mat file should contain 2 vectors named "lat" and "lon"
                                     
       
% -------------------------------------------------------------------------
% OUTPUT: File naming and NetCDF descriptors ------------------------------
% -------------------------------------------------------------------------
Grid_filename = 'BlackSea'; 	   % Filename for grid and initial conditions files (don't include extension). 
                               % "_grd.nc" is added to grid file and "_ini.nc" is added to initial conditions file
Descrip_grd   = 'Test grid';               %Description for grid .nc file
Descrip_ini   = 'Test initial conditions'; %Description for initial conditions .nc file
Author        = 'Mehmet Ilicak';
Computer      = 'My Computer';


%****************************************************************************************************************************************************
% END OF USER SETTINGS ******************************************************************************************************************************
%****************************************************************************************************************************************************


tic % Start the timer


disp([char(13),char(13),char(13),char(13),char(13),char(13)])
disp('***************************************************************')
disp('** EASYGRID ***************************************************')
disp('***************************************************************')


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% START of GRID generation %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if create_grid == 1; % Only create grid if switch (in USER SETTINGS) is turned ON

    disp([char(13),'GENERATING grid...'])
      %linear increase
      lonr=(lon:dl:lon_end);  
      %
      % Get the latitude for an isotropic grid
      i=1;
      latr(i)=lat;
      while latr(i)<=lat_end
	  i=i+1;
	  latr(i)=latr(i-1)+dl*cos(latr(i-1)*pi/180);
      end
    [lon_rho,lat_rho]=meshgrid(lonr,latr);
    [lon_u,lon_v,lon_psi]=rho2uvp(lon_rho);
    [lat_u,lat_v,lat_psi]=rho2uvp(lat_rho);

    Lp=size(lon_rho,2);  L=size(lon_rho,2)-1; Lm=size(lon_rho,2)-2;
    Mp=size(lon_rho,1);  M=size(lon_rho,1)-1; Mm=size(lon_rho,1)-2;

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Grid spacing and other grid parameters  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    el      = lat_u(end,1) - lat_u(1,1);
    xl      = lon_v(1,end) - lon_v(1,1);

    %Thanks to John Wilkin for this following section.
    dx=zeros(Mp,Lp);
    dy=zeros(Mp,Lp);

    dx(:,2:L)=spheriq_dist(lon_u(:,2:L),lat_u(:,2:L),lon_u(:,1:Lm),lat_u(:,1:Lm)); %sperical distance calculation
    dx(:,1)=dx(:,2);
    dx(:,Lp)=dx(:,L);
    dy(2:M,:)=spheriq_dist(lon_v(2:M,:),lat_v(2:M,:),lon_v(1:Mm,:),lat_v(1:Mm,:)); %sperical distance calculation
    dy(1,:)=dy(2,:);
    dy(Mp,:)=dy(M,:);
    pm=1./dx;
    pn=1./dy;

    dndx = zeros(size(pm));
    dmde = dndx;
    dndx(2:M,2:L)=0.5*(1./pn(2:M,3:Lp) - 1./pn(2:M,1:Lm));
    dmde(2:M,2:L)=0.5*(1./pm(3:Mp,2:L) - 1./pm(1:Mm,2:L));



    % Coriolis %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    f = 2 .* 7.29E-5 .* sin(lat_rho .* (pi/180)); %Estimation of Coriolis over the grid domain. OMEGA=7.29E-5
    %More info: http://en.wikipedia.org/wiki/Coriolis_effect#Formula


    % Bathymetry %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    if ~isnan(hh);
        h = hh*ones(size(x));
        h = ones(length(y),1)*h(:)';
    else
        load(Bathy);
        h = griddata(xbathy,ybathy,zbathy,lon_rho,lat_rho,'linear');
        h(isnan(h)) = -1;
    end
    h(h<0) = 0;   % Flatten hills and mountains (i.e. positive depths)
    h = h + minh; % Add the depth offset minh (specified in USER SETTINGS)
    clear xbathy ybathy zbathy
    %NOTE: Bathymetry smoothing occurs below "generating masks"

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % GENERATING MASKS  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    disp(['DONE!',char(13),char(13),char(13),'GENERATING masks...'])
    
    %  Land/Sea mask on RHO-points... and a NaN version of the mask for plotting.
    mask_rho = ones(size(lon_rho));
    mask_rho_nan = mask_rho;

    mask_rho(h <= minh) = 0;
    mask_rho_nan(h <= minh) = nan;

    %  Land/Sea mask on U-points.
    mask_u = mask_rho(:,1:L) .* mask_rho(:,2:Lp);

    %  Land/Sea mask on V-points.
    mask_v = mask_rho(1:M,:) .* mask_rho(2:Mp,:);

    %  Land/Sea mask on PSI-points.
    mask_psi = mask_u(1:M,:) .* mask_u(2:Mp,:);
    disp('DONE!')
    % %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
else
    disp([char(13),char(13)])
    disp('---------------------------------------')
    disp('WORKING with previously-generated GRID!')
    disp('---------------------------------------')
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% END of grid generation   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Check for a grid variable. If it is not there... Warn user to TURN ON create_grid in USER SETTINGS
if exist('lat_rho','var') == 0;
    disp([char(13),char(13)])
    warning('ABSENT GRID VARIABLE!!!')
    disp('NOTE: You may have to SWITCH ON create_grid in the USER SETTINGS section and run EASYGRID again')
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% SMOOTHING Bathymetry %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if smooth_grid == 1; % Only smooth bathymetry if switch (in USER SETTINGS) is turned ON
    disp([char(13),char(13),'SMOOTHING Bathymetry...'])
    %h = smth_bath(h,mask_rho); %Smooth the grid 
    h = smooth_bath(h,mask_rho,order,rlim,npass); %Smooth the grid
    disp('DONE!')
    clear smoothing
else
    clear smoothing
end
%--------------------------------------------------------------------------



  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% SCREEN DISPLAY %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if screen_output == 1; % Only display on screen if switch (in USER SETTINGS) is turned ON
    disp([char(13),char(13),char(13)])
    disp(['SCREEN DISPLAY:',char(13)])
    disp('COPY-PASTE the following parameters into your ocean.in file')
    disp('----------------------------------------------------------------------------------------------')
    disp(char(13))
    disp(['    Lm == ' num2str(Lm) '         ! Number of I-direction INTERIOR RHO-points'])
    disp(['    Mm == ' num2str(Mm) '         ! Number of J-direction INTERIOR RHO-points'])
    disp(char(13))
    disp(['Make sure the Baroclinic time-step (DT) in your ocean.in file is less than: ' num2str(sqrt(((min(min(dx))^2)+(min(min(dy))^2)) / (9.8 * (min(min(h))^2)))) ' seconds'])
    disp('----------------------------------------------------------------------------------------------')
end
%--------------------------------------------------------------------------




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% PLOTTING GRID %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if plot_grid == 1; % Only plot if switch (in USER SETTINGS) is turned ON
    disp([char(13),'PLOTTING grid...'])
    % check if you have John Wilkin's pcolor... if not use the normal pcolor
    cla % Erase axis but keep figure (this is to refresh old plot with new plot, while keeping figure size).
    if exist('pcolorjw.m') == 2;
        pcolorjw(lon_rho,lat_rho,h.*mask_rho_nan);shading faceted;cb=colorbar; title(cb,[{'Depth'};{'(m)'}])
    else
        pcolor(lon_rho,lat_rho,h.*mask_rho_nan);shading faceted;cb=colorbar; title(cb,[{'Depth'};{'(m)'}])
    end
    axis square
    xlabel('Longitude (degrees)');
    ylabel('Latitude (degrees)');
    title(['ROMS grid: ' Grid_filename]);    
    % Check if there is a coastline file
    if exist('Coast') == 1;
        hold on
        plot(Coast.lon,Coast.lat,'k');
    end
    clear cb
    disp(['DONE!'])
end
%--------------------------------------------------------------------------

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% MASK EDITING  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if edit_mask == 1; % Only edit mask if switch (in USER SETTINGS) is turned ON
    disp([char(13),'EDITING MASK...'])
    disp('To FINISH editing... press right-button (on mouse).')
    figure(2)
    pcolorjw(lon_rho,lat_rho,mask_rho);caxis([0 1]);shading faceted;colormap([0.6 0.4 0;0.6 0.9 1]);colorbar;
    axis square
    xlabel('Longitude (degrees)');
    ylabel('Latitude (degrees)');
    title('LEFT-button: sea/land toggle ... RIGHT-button: Finish!','BackgroundColor','red');
    hold on
    if exist('Coast') == 1; 
        plot(Coast.lon,Coast.lat,'k');
    end
    button = 1;
    while button == 1
        [xi,yi,button] = ginput(1);
        if button == 1;
            costfunct = ((lon_rho-xi).^2) + ((lat_rho-yi).^2);
            [loni,lonj] = find(costfunct == min(min(costfunct)));
                if mask_rho(loni,lonj) == 0;
                    mask_rho(loni,lonj) = 1;
                else
                    mask_rho(loni,lonj) = 0;
                end
            pcolorjw(lon_rho,lat_rho,mask_rho);caxis([0 1]);shading faceted;colormap([0.6 0.4 0;0.6 0.9 1]);colorbar;
                if exist('Coast') == 1;
                    plot(Coast.lon,Coast.lat,'k');
                end
        end
        % Update u, v, psi and rho_nan MASKS
        mask_rho_nan = mask_rho;
        mask_rho_nan(mask_rho == 0) = nan;
        mask_u = mask_rho(:,1:L) .* mask_rho(:,2:Lp);
        mask_v = mask_rho(1:M,:) .* mask_rho(2:Mp,:);
        mask_psi = mask_u(1:M,:) .* mask_u(2:Mp,:); 
    end
    clear button xi yi costfunct
    disp(['DONE!'])
end
%--------------------------------------------------------------------------


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% SAVE GRID FILE  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if save_grid == 1; % Only save grid if switch (in USER SETTINGS) is turned ON
    try
        % creating grid files
        grd_name   = [Grid_filename '_grd.nc'];
        nc         = netcdf(grd_name,'clobber');
        nc.description = Descrip_grd;
        nc.author  = Author;
        nc.created = [ 'by ' nc.author ' on ' Computer 'at '  datestr(now) ', using roms_make_simple_grid.m'];
        nc.type    = 'grid file';
        disp(char(13))
        disp(['SAVING Grid NetCDF file: ' grd_name '   ...'])
        %Note: Other NetCDF definitions are specifies at the beginning of this code under the USER SETTINGS section.

        % Dimensions
        nc('xi_rho') = Lp;
        nc('xi_u')   = L;
        nc('xi_v')   = Lp;
        nc('xi_psi') = L;

        nc('eta_rho')= Mp;
        nc('eta_u')  = Mp;
        nc('eta_v')  = M;
        nc('eta_psi')= M;

        nc('one')    = 1;


        % Create variables to NetCDF
        dims                  = { 'eta_rho'; 'xi_rho'};
        nc{ 'dmde'}           = ncdouble(dims);
        nc{ 'dmde'}(:,:)      = dmde;
        nc{ 'dmde'}.long_name = 'eta derivative of inverse metric factor pm' ;
        nc{ 'dmde'}.units     = 'meter' ;
        %--------------------------------------------------------------------------
        dims                  = { 'eta_rho'; 'xi_rho'};
        nc{ 'dndx'}           = ncdouble(dims);
        nc{ 'dndx'}(:,:)      = dndx;
        nc{ 'dndx'}.long_name = 'xi derivative of inverse metric factor pn' ;
        nc{ 'dndx'}.units     = 'meter' ;
        %--------------------------------------------------------------------------
        dims                  = { 'one'};
        nc{ 'el'}             = ncdouble(dims);
        nc{ 'el'}(:)          = el;
        nc{ 'el'}.long_name   = 'domain length in the ETA-direction' ;
        nc{ 'el'}.units       = 'degrees' ;
        %--------------------------------------------------------------------------
        dims                  = { 'eta_rho'; 'xi_rho'};
        nc{ 'f'}              = ncdouble(dims);
        nc{ 'f'}(:,:)         = f;
        nc{ 'f'}.long_name    = 'Coriolis parameter at RHO-points' ;
        nc{ 'f'}.units        = 'second-1' ;
        %--------------------------------------------------------------------------
        dims                  = { 'eta_rho'; 'xi_rho'};
        nc{ 'h'}              = ncdouble(dims);
        nc{ 'h'}(:,:)         = h;
        nc{ 'h'}.long_name    = 'bathymetry at RHO-points' ;
        nc{ 'h'}.units        = 'meter' ;
        %--------------------------------------------------------------------------
        dims                     = { 'eta_rho'; 'xi_rho'};
        nc{ 'lat_rho'}           = ncdouble(dims);
        nc{ 'lat_rho'}(:,:)      = lat_rho;
        nc{ 'lat_rho'}.long_name = 'latitude of RHO-points' ;
        nc{ 'lat_rho'}.units     = 'degree_north' ;
        %--------------------------------------------------------------------------
        dims                     = { 'eta_psi'; 'xi_psi'};
        nc{ 'lat_psi'}           = ncdouble(dims);
        nc{ 'lat_psi'}(:,:)      = lat_psi;
        nc{ 'lat_psi'}.long_name = 'latitude of PSI-points' ;
        nc{ 'lat_psi'}.units     = 'degree_north' ;
        %--------------------------------------------------------------------------
        dims                     = { 'eta_u'; 'xi_u'};
        nc{ 'lat_u'}             = ncdouble(dims);
        nc{ 'lat_u'}(:,:)        = lat_u;
        nc{ 'lat_u'}.long_name   = 'latitude of U-points' ;
        nc{ 'lat_u'}.units       = 'degree_north' ;
        %--------------------------------------------------------------------------
        dims                     = { 'eta_v'; 'xi_v'};
        nc{ 'lat_v'}             = ncdouble(dims);
        nc{ 'lat_v'}(:,:)        = lat_v;
        nc{ 'lat_v'}.long_name   = 'latitude of V-points' ;
        nc{ 'lat_v'}.units       = 'degree_north' ;
        %--------------------------------------------------------------------------
        dims                     = { 'eta_rho'; 'xi_rho'};
        nc{ 'lon_rho'}           = ncdouble(dims);
        nc{ 'lon_rho'}(:,:)      = lon_rho;
        nc{ 'lon_rho'}.long_name = 'longitude of RHO-points' ;
        nc{ 'lon_rho'}.units     = 'degree_east' ;
        %--------------------------------------------------------------------------
        dims                     = { 'eta_psi'; 'xi_psi'};
        nc{ 'lon_psi'}           = ncdouble(dims);
        nc{ 'lon_psi'}(:,:)      = lon_psi;
        nc{ 'lon_psi'}.long_name = 'longitude of PSI-points' ;
        nc{ 'lon_psi'}.units     = 'degree_east' ;
        %--------------------------------------------------------------------------
        dims                     = { 'eta_u'; 'xi_u'};
        nc{ 'lon_u'}             = ncdouble(dims);
        nc{ 'lon_u'}(:,:)        = lon_u;
        nc{ 'lon_u'}.long_name   = 'longitude of U-points' ;
        nc{ 'lon_u'}.units       = 'degree_east' ;
        %--------------------------------------------------------------------------
        dims                     = { 'eta_v'; 'xi_v'};
        nc{ 'lon_v'}             = ncdouble(dims);
        nc{ 'lon_v'}(:,:)        = lon_v;
        nc{ 'lon_v'}.long_name   = 'longitude of V-points' ;
        nc{ 'lon_v'}.units       = 'degree_east' ;
        %--------------------------------------------------------------------------
        dims                      = { 'eta_rho'; 'xi_rho'};
        nc{ 'mask_rho'}           = ncdouble(dims);
        nc{ 'mask_rho'}(:,:)      = mask_rho;
        nc{ 'mask_rho'}.long_name = 'mask on RHO-points' ;
        nc{ 'mask_rho'}.option_0  = 'land' ;
        nc{ 'mask_rho'}.option_1  = 'water' ;
        %--------------------------------------------------------------------------
        dims                      = { 'eta_psi'; 'xi_psi'};
        nc{ 'mask_psi'}           = ncdouble(dims);
        nc{ 'mask_psi'}(:,:)      = mask_psi;
        nc{ 'mask_psi'}.long_name = 'mask on PSI-points' ;
        nc{ 'mask_psi'}.option_0  = 'land' ;
        nc{ 'mask_psi'}.option_1  = 'water' ;
        %--------------------------------------------------------------------------
        dims                      = { 'eta_u'; 'xi_u'};
        nc{ 'mask_u'}             = ncdouble(dims);
        nc{ 'mask_u'}(:,:)        = mask_u;
        nc{ 'mask_u'}.long_name   = 'mask on U-points' ;
        nc{ 'mask_u'}.option_0    = 'land' ;
        nc{ 'mask_u'}.option_1    = 'water' ;
        %--------------------------------------------------------------------------
        dims                      = { 'eta_v'; 'xi_v'};
        nc{ 'mask_v'}             = ncdouble(dims);
        nc{ 'mask_v'}(:,:)        = mask_v;
        nc{ 'mask_v'}.long_name   = 'mask on V-points' ;
        nc{ 'mask_v'}.option_0    = 'land' ;
        nc{ 'mask_v'}.option_1    = 'water' ;
        %--------------------------------------------------------------------------
        dims                      = { 'eta_rho'; 'xi_rho'};
        nc{ 'pm'}                 = ncdouble(dims);
        nc{ 'pm'}(:,:)            = pm;
        nc{ 'pm'}.long_name       = 'curvilinear coordinate metric in XI' ;
        nc{ 'pm'}.units           = 'meter-1' ;
        %--------------------------------------------------------------------------
        dims                      = { 'eta_rho'; 'xi_rho'};
        nc{ 'pn'}                 = ncdouble(dims);
        nc{ 'pn'}(:,:)            = pn;
        nc{ 'pn'}.long_name       = 'curvilinear coordinate metric in ETA' ;
        nc{ 'pn'}.units           = 'meter-1' ;
        %--------------------------------------------------------------------------
        dims                      = { 'one'};
        nc{ 'spherical'}          = ncchar(dims);
        nc{ 'spherical'}(:)       = 'T';
        nc{ 'spherical'}.long_name= 'Grid type logical switch' ;
        nc{ 'spherical'}.option_T = 'spherical' ;
        %--------------------------------------------------------------------------
        dims                      = {'one'};
        nc{ 'xl'}                 = ncdouble(dims);
        nc{ 'xl'}(:)              = xl;
        nc{ 'xl'}.long_name       = 'domain length in the XI-direction' ;
        nc{ 'xl'}.units           = 'degrees' ;
        %-------------------------------------------------------------------------- 
        dims                      = {'one'};
        nc{ 'el'}                 = ncdouble(dims);
        nc{ 'el'}(:)              = el;
        nc{ 'el'}.long_name       = 'domain length in the ETA-direction' ;
        nc{ 'el'}.units           = 'degrees' ;
        %--------------------------------------------------------------------------
        % Parameters
%        dims                  = { 'one'};
%        nc{ 'X'}              = ncdouble(dims);
%        nc{ 'X'}(:)           = X;
%        nc{ 'X'}.description  = 'width of domain (degrees)';
        %--------------------------------------------------------------------------
%        dims                  = { 'one'};
%        nc{ 'Y'}              = ncdouble(dims);
%        nc{ 'Y'}(:)           = Y;
%        nc{ 'Y'}.description  = 'length of domain (degrees)';
        %--------------------------------------------------------------------------
%        dims                  = { 'one'};
%        nc{ 'dx'}             = ncdouble(dims);
%        nc{ 'dx'}(:)          = (resol ./ (60*1852)) .* spheriq_dist(lon,lat,lon+1,lat);;   % Estimated resolution in x (degrees)0.002;
%        nc{ 'dx'}.description = 'resolution in x (degrees)';
        %--------------------------------------------------------------------------
%        dims                  = { 'one'};
%        nc{ 'dy'}             = ncdouble(dims);
%        nc{ 'dy'}(:)          = resol ./ (60*1852);         % Estimated resolution in y (degrees)
%        nc{ 'dy'}.description = 'resolution in y (degrees)';
        
        disp('DONE!')
        close(nc);
        clear nc
    catch
%        warning('Problem writing .nc grid file. You may not have MEXCDF installed...')
    end
end
%--------------------------------------------------------------------------

        disp('Please run editmask(grd_name,coast_file_name) for land/sea mask ')


