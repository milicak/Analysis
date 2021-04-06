%this subroutine creates an idealized topography for MITgcm model
%in ASCII format, netcdf is not supported yet
clear all
%clc
close all

project_name = ['adjustment_3d']

project_name1 = ['/okyanus/users/milicak/Analysis/mitgcm/' project_name '/Analysis/'];

prec = 'real*8';
ieee = 'b';

% bathymetry HAS TO BE NEGATIVE
title = 'adjustment_3d'
switch title
    case 'adjustment_3d'

        g=9.8;
        rho0=1e3;
        nu=1e-6;
        H=1000;

        % Dimensions of grid in x y z
        nz = 50;
        nx = 200;
        ny = 200;

        % Nominal depth of model (meters)
        depth = H;

        % Size of domain in x/y direction (meters)
        Lx = 200e3; 
        Ly = 200e3;

        %uniform delta_z
        delta_z(1,1:nz) = depth/nz;

        % temp coeff for linear equation of state
        alpha = 20;
        % Sref and Tref and density using liner equation of state for only temperature
        Sref = 35.0;
        Tref = 10.0;

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
        for i=1:nx
            for j=1:ny
                d(i,j) = -depth;
            end
        end
        % close BCs
        d(1,:) = 0.0;
        d(:,1) = 0.0;
        d(end,:) = 0.0;
        d(:,end) = 0.0;

        % surface heat flux is set to zero
        Q=0.0*rand([nx,ny]);

        % Create initial conditions for salt and temp
        salt=zeros([nx,ny,nz]);
        temp=zeros([nx,ny,nz]);
        % Initial profile
        salt(:,:,:)=Sref;
        temp(:,:,:)=Tref;
        %check salt(1,1,end) has to be bottom and the densiest
        temp(:,1:end/2,1:4)=18.0;
        temp(:,end/2+1:end,1:4)=15.0;
        for i=1:200
        for j=98:102
            dnm = 18.0-(18.0-15.0)*(j-98)/5 + 0.01*sin(6*Lon(i)*pi/Ly);
            temp(i,j,1)=dnm;
            temp(i,j,2)=dnm;
            temp(i,j,3)=dnm;
            temp(i,j,4)=dnm;
        end
        end

end  %switch

break

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
%fid=fopen([project_name1 'Qnet.forcing'],'w',ieee); fwrite(fid,Q,prec); fclose(fid);

