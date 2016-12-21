%this subroutine creates an idealized topography for MITgcm model
%in ASCII format, netcdf is not supported yet
clear all
%clc
%close all

project_name = ['ice_leads']

project_name1 = ['/hexagon/work/milicak/RUNS/mitgcm/' project_name '/input_exp1.0/'];

prec = 'real*8';
ieee = 'b';

% bathymetry HAS TO BE NEGATIVE
title = 'ice_leads'
switch title
    case 'ice_leads'

        g=9.8;
        deg2K=273.15;
        leads_width=2e3; %km
        leads_length=2e3; %km
        Q0=200; % Watts/m2 ; positive for cooling (dense water) ; negative for warming
        Tair0=-20+deg2K; % Air temperature Kelvin!
        qair0=4e-4; %specific humidity from Kampf and Backhaus paper

        rho0=1e3;
        H=256; %meter

        % Dimensions of grid in x y z
        nz = 256;
        nx = 2048;
        ny = 2048;

        % Nominal depth of model (meters)
        depth = H;

        % Size of domain in x direction
        Lx = 10.24e3; %meter
        Ly = 10.24e3; %meter
        Lx_mid = 0.5*Lx;
        Ly_mid = 0.5*Ly;

        %uniform delta_z
        delta_z(1,1:nz) = depth/nz;

        zr=0.5*delta_z:delta_z:depth;

        % Sref and Tref and density using liner equation of state for only temperature
        Tfreeze=-1.96;  %freezing temp -1.96
        Sref = 32.0;
        S0 = 32.4;
        hmxl = 40; % initial mixed layer depth
        Tref = Tfreeze;

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

        % Initial ice salt
        saltice=10.0*ones([nx,ny]); % psu

        % Air Wind speed 2 records!
        Wspeed=2*ones([nx,ny 2]); %m/s
        Uspeed=0*ones([nx,ny 2]); %m/s
        Vspeed=0*ones([nx,ny 2]); %m/s

        % Initial ice temperature
        tempice=(Tfreeze+deg2K)*ones([nx,ny]); % psu
        sigma_SB=5.67e-8; %Stephan-Boltzman constant
        %LW(1:nx,1:ny,1:2)=0.0;
        LW=sigma_SB.*tempice.^4;
        LW(:,:,2)=LW;

        % Initial snow thickness
        hsnow=0.0*ones([nx,ny]); % 
        % Initial ice thickness
        rand_mang=0.0025; %0.025; % 2.5 cm
        NX=128;NY=128;
        hice1=rand_mang*rand([NX,NY]);
        hice1(hice1<0.5*rand_mang)=0.0;

%%%%%%%%% interp %%%%%%%%%%%
        clear Lon Lat
        %Constant resolution dx
        for i=1:NX
            dx1(i) = Lx/(NX);
            Lon(i) = (i-1)*dx1(i);
        end
        %Constant resolution dy
        for i=1:NY
            dy1(i) = Ly/NY;
            Lat(i) = (i-1)*dy1(i);
        end
        [LON LAT] = meshgrid(Lon,Lat);
        LON = LON';LAT = LAT';
	hice=griddata(LON,LAT,hice1,lon,lat);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%

        %hice=rand_mang*rand([nx,ny]);
        %hice(hice<0.5*rand_mang)=0.0;

        % Specific humidity 2 records!
        qair=qair0*ones([nx,ny 2]);

        % Air Temperature 2 records!
        Tair=Tair0*ones([nx,ny 2]);
        for i=1:nx
            for j=1:ny
                if(abs(lon(i,j)-Lx_mid)>leads_width) || (abs(lat(i,j)-Ly_mid)>leads_length)
                  hice(i,j) = 10; %meter
                  hsnow(i,j) = 0.25; %meter
%                  Tair(i,j,:) = -2+273.16;
%                   LW(i,j,:)=sigma_SB.*tempice(i,j).^4;
                end
            end
        end
        %hice(:,:)=10;hsnow(:,:)=0.25;

        % bathymetry HAS TO BE NEGATIVE
        d(1:nx,1:ny)=-depth;
%        for i=1:nx
%            for j=1:ny
%                d(i,j) = -depth;
%            end
%        end

        % surface heat flux is set to Q0
        Q=Q0*ones([nx,ny]);
        hflux=Q;
        hflux(:,:,2)=hflux;

        % Create initial conditions for salt and temp
        salt=zeros([nx,ny,nz]);
        temp=zeros([nx,ny,nz]);
        % Initial profile
        salt(:,:,:)=Sref;
        temp(:,:,:)=Tref;

        dnm=(Sref)+0.25*(Sref-S0)*tanh(pi*(-zr+hmxl)./10)+0.25*(S0-Sref);
        keyboard
        dnm=repmat(dnm,[nx 1 ny]);
        %No noise in salinity
        salt=permute(dnm,[1 3 2]);
        %add random noise to the upper mixed layer area
        %kind=max(find(zr<=hmxl));
        %salt(:,:,1:kind)=salt(:,:,1:kind)+1e-4*rand([nx,ny,kind]);
      
        %salt=permute(dnm,[1 3 2])+1e-4*rand([nx,ny,nz]);
        %check salt(1,1,end) has to be bottom and the densiest
        %salt=flipdim(salt,3);

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

%break

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
fid=fopen([project_name1 'HFLUX.forcing'],'w',ieee); fwrite(fid,hflux,prec); fclose(fid);
fid=fopen([project_name1 'HEFF.init'],'w',ieee); fwrite(fid,hice,prec); fclose(fid);
fid=fopen([project_name1 'HSNOW.init'],'w',ieee); fwrite(fid,hsnow,prec); fclose(fid);
fid=fopen([project_name1 'ICESALT.init'],'w',ieee); fwrite(fid,saltice,prec); fclose(fid);
fid=fopen([project_name1 'Tair.forcing'],'w',ieee); fwrite(fid,Tair,prec); fclose(fid);
fid=fopen([project_name1 'qa.forcing'],'w',ieee); fwrite(fid,qair,prec); fclose(fid);
fid=fopen([project_name1 'LW.forcing'],'w',ieee); fwrite(fid,LW,prec); fclose(fid);
fid=fopen([project_name1 'USPEED.forcing'],'w',ieee); fwrite(fid,Uspeed,prec); fclose(fid);
fid=fopen([project_name1 'VSPEED.forcing'],'w',ieee); fwrite(fid,Vspeed,prec); fclose(fid);
fid=fopen([project_name1 'WSPEED.forcing'],'w',ieee); fwrite(fid,Wspeed,prec); fclose(fid);

