%this subroutine creates an idealized topography for MITgcm model
%in ASCII format, netcdf is not supported yet
clear all
%clc
close all

project_name = ['lock_exchange_nondim']

project_name1 = ['/bcmhsm/milicak/RUNS/mitgcm/' project_name '/input_exp1.0/'];
%project_name1=['/ncrc/home2/Mehmet.Ilicak/models/MITgcm/Projects/' project_name '/input/'];

prec = 'real*8';
ieee = 'b';

% bathymetry HAS TO BE NEGATIVE
title = 'lock_exchange_nondim'
switch title
    case 'lock_exchange_nondim'

        % Dimensions of grid in x y z
        nz = 32*16; %24*6; %24 procs for gaea c1 nz=144 for Re_h=125,500,1000 |  nz=288 for Re_h=2500 | nz=432 for Re_h=5000 | nz=640 for Re_h=10000 for 32 procs for gaea c2
        alpha_x = 8;   %aspect ratio in x-direction
        alpha_y = 0.5; %aspect ratio in y-direction
        nx = nz*alpha_x;
        ny = nz*alpha_y;

        % Nominal depth of model (nondimensional)
        depth = 1;

        % Size of domain in x direction
        Lx = depth*alpha_x;
        Ly = depth*alpha_y;
        x_dam = Lx*0.5; %location of the dam

        % Sref and Tref and density using liner equation of state for only temperature
        Sref = 0.0;
        Tref = 0.0;
        T0 = 1.0

        %uniform delta_z
        delta_z(1,1:nz) = depth/nz;
        %zr=0.5*delta_z:delta_z:depth;

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

        % surface heat flux is set to zero
        %Q=0.0*rand([nx,ny]);

        % Create initial conditions for salt and temp
        salt=zeros([nx,ny,nz]);
        temp=zeros([nx,ny,nz]);
        % Initial profile
        salt(:,:,:)=Sref;
        temp(:,:,:)=Tref;

        Lat_0 = 0.0;
        Lat_1 = Ly;
        l_width = 0.025;
        % Cold water
        for i=1:nx
            for j=1:ny
                for k=1:nz
                    cff1 = l_width*cos(6.0*pi*(lat(i,j)-Lat_0)/(Lat_1-Lat_0));
                    if(lon(i,j) < x_dam-cff1)
                        temp(i,j,k) = T0;
                    end
                end
            end
        end
        % Peridoic B.C. in y-direction
        temp(:,end,:) = temp(:,1,:);

end  %switch

%break

%close boundary in x-direction and periodic boundary in y-direction
d(1,:)=0.0;d(end,:)=0.0;

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
%fid=fopen([project_name1 'S.init'],'w',ieee); fwrite(fid,salt,prec); fclose(fid);
fid=fopen([project_name1 'T.init'],'w',ieee); fwrite(fid,temp,prec); fclose(fid);
%fid=fopen([project_name1 'Qnet.forcing'],'w',ieee); fwrite(fid,Q,prec); fclose(fid);

