%this subroutine creates an idealized topography for MITgcm model
%in ASCII format, netcdf is not supported yet
clear all
%clc
%close all

project_name = ['thermobaricity']
expid = 'input_exp2.0'

project_name1 = ['/work/milicak/RUNS/mitgcm/' project_name '/' expid '/'];

if ( exist(eval('project_name1'),'dir') ~=0 )
    display('folder exist')
else
    mkdir(eval('project_name1'))
    display('folder created')
end

prec = 'real*8';
ieee = 'b';

% bathymetry HAS TO BE NEGATIVE
title = 'thermobaricity_2D'
switch title
    case 'thermobaricity_2D'

        g=9.8;
        %deg2K=273.15;
        %W0=1*7.4; %m/s wind speed
        Q0=250; %400; %250; % Watts/m2 ; positive for cooling (dense water) ; negative for warming
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
        Qzero = 0*ones([nx,ny]);
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
        Trefold = Tref;
        Srefold = Sref;
        Tref(1:110) = Tref(1);
        Sref(1:110) = Sref(1);
        %break
        for i=285:800
            Tref(1,i)=Tref(285)+(i-285)*(Tref(800)-Tref(285))/(800-285);
            Sref(1,i)=Sref(285)+(i-285)*(Sref(800)-Sref(285))/(800-285);
        end
        %break
        save(['matfiles/mitgcm_init_ctrl_TS' expid '.mat'],'Tref','Sref','zr')
        %additional warming
        if 1
        % first working config
            ind0 = 90; %100; %1; %300;
            ind1 = 91; % 150; %1; %300;
            ind2 = 470; %670; %700; %800; %1100;
            ind3 = 1000;
            Trefold2 = Tref;
            Srefold2 = Sref;
            %Tref(ind1:ind2) = Tref(ind1:ind2)+1.0*exp(-(zr(ind1:ind2)-ind1)/ind2);
            %Sref(ind1:ind2) = Sref(ind1:ind2)+1.0*exp(-(zr(ind1:ind2)-ind1)/ind2);
            %Tref(ind1:ind2) = Tref(ind1:ind2)+1.0*exp(-(zr(ind1:ind2)-ind1)/ind2);
            %Sref(ind1:ind2) = Sref(ind1:ind2)+.5*exp(-(zr(ind1:ind2)-ind1)/ind2);
            %Tref(ind1:ind2) = Tref(ind1:ind2)+.5*exp(-(zr(ind1:ind2)-ind1)/ind2);
            %Sref(ind1:ind2) = Sref(ind1:ind2)+.2*exp(-(zr(ind1:ind2)-ind1)/ind2);
            % remove startification from mixed layer
            %Tref(1:110) = Tref(1);
            %Sref(1:110) = Sref(1);
            for i=ind2:ind3
               Tref(i)=Tref(ind2)+(i-ind2)*(Tref(ind3)-Tref(ind2))/(ind3-ind2);        
               Sref(i)=Sref(ind2)+(i-ind2)*(Sref(ind3)-Sref(ind2))/(ind3-ind2);        
            end
            for i=ind0:ind1
               Tref(i)=Tref(ind0)+(i-ind0)*(Tref(ind1)-Tref(ind0))/(ind1-ind0);        
               Sref(i)=Sref(ind0)+(i-ind0)*(Sref(ind1)-Sref(ind0))/(ind1-ind0);        
            end
            rhmdjwf=densmdjwf(Sref',Tref',pr)-1030;
            alp0=2.15e-5;
            rh0=1027*(-alp0'.*(Tref-10)+8e-4*(Sref-32));
            alp1=2.65e-5+2.97e-8*pr;
            rh1=1027*(-alp1'.*(Tref-10)+8e-4*(Sref-32));
            %break
        end
        %break
        % Initial profile
        Sref = repmat(Sref,[ny 1 nx]);
        Sref = permute(Sref,[3 1 2]); 
        Tref = repmat(Tref,[ny 1 nx]);
        Tref = permute(Tref,[3 1 2]); 
        salt(:,:,:) = Sref;
        temp(:,:,:) = Tref;

        %add noise into temp between -0.001 and 0.001
        randnoise = zeros(nx,ny,nz);
        nzrand = 50;
        aa = 0.001*(1-rand(nx,ny,nzrand));
        randnoise(:,:,1:nzrand) = aa;
        temp = temp + randnoise;
        %Qrandnoise = 2*(0.5-rand(nx,ny));
        %Q = Q + Qrandnoise;
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
fid=fopen([project_name1 'Qnetzero.forcing'],'w',ieee); fwrite(fid,Qzero,prec); fclose(fid);

