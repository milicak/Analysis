%this subroutine creates an idealized topography for MITgcm model
%in ASCII format, netcdf is not supported yet
clear all
%clc
%close all

project_name = ['thermobaricity']

project_name1 = ['/work/milicak/RUNS/mitgcm/' project_name '/input_exp1.0/'];

prec = 'real*8';
ieee = 'b';

% bathymetry HAS TO BE NEGATIVE
title = 'thermobaricity_2D'
switch title
    case 'thermobaricity_2D'

        g=9.8;
        %deg2K=273.15;
        %W0=1*7.4; %m/s wind speed
        Q0=250; % Watts/m2 ; positive for cooling (dense water) ; negative for warming
        %Tair0=-25+deg2K; % Air temperature Kelvin! Winter
        %Tair0=10+deg2K; % Air temperature Kelvin! Summer 
        %qair0=4e-4; %specific humidity from Kampf and Backhaus paper

        %rho0=1e3;
        H=3000; %meter

        % Dimensions of grid in x y z
        nz = 3000;
        nx = 256*16;
        ny = 1;

        % Nominal depth of model (meters)
        depth = H;

        % Size of domain in x direction
        Lx = nx; %10.24e3; %meter
        Ly = 1; %10.24e3; %meter

        %uniform delta_z
        delta_z(1,1:nz) = depth/nz;

        zr=0.5*delta_z:delta_z:depth;

        % Sref and Tref and density using liner equation of state for only temperature
        Sref = 32.0;
        Tref = 10;

        %Constant resolution dx
        for i=1:nx
            dx(i) = Lx/(nx);
            Lon(i) = (i-1)*dx(i);
        end

        %Constant resolution dy
        for i=1:ny
            dy(i) = Ly/ny;
            Lat(i) = (i-1)*dy(i);
        end

        [lon lat] = meshgrid(Lon,Lat);
        lon = lon';lat = lat';

        % bathymetry HAS TO BE NEGATIVE
        d(1:nx,1:ny) = -depth;

        % surface heat flux is set to Q0
        Q = Q0*ones([nx,ny]);
        hflux = Q;
        hflux(:,:,2) = hflux;

        % Create initial conditions for salt and temp
        salt = zeros([nx,ny,nz]);
        temp = zeros([nx,ny,nz]);

        salt_lence = ncread('n-ice2015_ship-ctd.nc','PSAL');
        temp_lence = ncread('n-ice2015_ship-ctd.nc','TEMP');
        pr_lence = ncread('n-ice2015_ship-ctd.nc','PRES');
        lat = ncread('n-ice2015_ship-ctd.nc','LATITUDE');
        zr_lence = sw_dpth(pr_lence,mean(lat));
        pr = sw_pres(zr',mean(lat));
        T1 = squeeze(temp_lence(:,6));
        S1 = squeeze(salt_lence(:,6));
        S1(isnan(T1)) = [];
        zr_lence(isnan(T1)) = [];
        T1(isnan(T1)) = [];
        Tref = interp1(zr_lence,T1,zr);
        Sref = interp1(zr_lence,S1,zr);
        % remove NANs
        ind = max(find(isnan(Tref)));
        Tref(1:ind) = Tref(ind+1);
        % remove NANs
        ind = max(find(isnan(Sref)));
        Sref(1:ind) = Sref(ind+1);
        % apply smoothing filter of 5 points
        Tref = my_nanfilter(Tref,40,'tri');
        Sref = my_nanfilter(Sref,40,'tri');
        % Initial profile
        Sref = repmat(Sref,[ny 1 nx]);
        Sref = permute(Sref,[3 1 2]); 
        Tref = repmat(Tref,[ny 1 nx]);
        Tref = permute(Tref,[3 1 2]); 
        salt(:,:,:) = Sref;
        temp(:,:,:) = Tref;

        %add noise into temp between -0.001 and 0.001
        randnoise = zeros(nx,ny,nz);
        aa = 0.002*(1-rand(nx,ny,50));
        randnoise(:,:,1:50) = aa;
        temp = temp + randnoise;
        %break
        
        %check salt(1,1,end) has to be bottom and the densiest


        % Cold water
%        for i=1:nx
%            for j=1:ny
%                for k=1:nz
%                    temp(i,j,k)=temp(i,j,k)+0.5*(T0-Tref)*erf((4/delta)*(zr(k)-0.5*max(zr(:))));
%                end
%            end
%        end
        % Peridoic B.C. in y-direction
%        temp(:,end,:) = temp(:,1,:);
%        salt(:,end,:) = salt(:,1,:);

end  %switch


%close boundary in x-direction and periodic boundary in y-direction
%d(1,:)=0.0;d(end,:)=0.0;

%write the bathymetry in a file
fid=fopen([project_name1  'topog.slope'],'w',ieee); fwrite(fid,d,prec); fclose(fid);

%write delta x
dx=dx';
fid=fopen([project_name1 'dx.bin'],'w',ieee); fwrite(fid,dx,prec); fclose(fid);

%write delta y
dy=dy';
fid=fopen([project_name1 'dy.bin'],'w',ieee); fwrite(fid,dy,prec); fclose(fid);

%write delta z
delta_z=delta_z';
fid=fopen([project_name1 'dz.bin'],'w',ieee); fwrite(fid,delta_z,prec); fclose(fid);

%write Salt and Temp
fid=fopen([project_name1 'S.init'],'w',ieee); fwrite(fid,salt,prec); fclose(fid);
fid=fopen([project_name1 'T.init'],'w',ieee); fwrite(fid,temp,prec); fclose(fid);
%fid=fopen([project_name1 'U.init'],'w',ieee); fwrite(fid,u,prec); fclose(fid);
fid=fopen([project_name1 'Qnet.forcing'],'w',ieee); fwrite(fid,Q,prec); fclose(fid);

