%this subroutine creates an idealized topography for MITgcm model
%in ASCII format, netcdf is not supported yet
clear all
%clc
close all

project_name = ['shear_flow']

%project_name1 = ['/work/milicak/RUNS/mitgcm/' project_name '/input_exp1.0/'];
project_name1 = ['/mnt/hexwork/RUNS/mitgcm/' project_name '/input_exp1.0/'];

prec = 'real*8';
ieee = 'b';

% bathymetry HAS TO BE NEGATIVE
title = 'shear_flow'
switch title
    case 'shear_flow'

        g=9.8;
        rho0=1e3;
        nu=1e-6;
        H=0.2;
        z=0:0.001:H;
        Ri=0.167;
        delta=0.045135; % mixed layer depth
        Re_aim=2000;  %Reynolds number;


        % Dimensions of grid in x y z
        nz = 32*16;
        alpha_x = 1;   %aspect ratio in x-direction
        alpha_y = 0.5; %aspect ratio in y-direction
        nx = nz*alpha_x;
        ny = nz*alpha_y*0.5;

        % Nominal depth of model (meters)
        depth = H;

        % Size of domain in x direction
        Lx = depth*alpha_x;
        Ly = depth*alpha_y;

        %uniform delta_z
        delta_z(1,1:nz) = depth/nz;


        zr=0.5*delta_z:delta_z:depth;
        do_Re=true;
        while do_Re
        for U0=0:0.001:1
        u_z=U0*erf((4/delta)*(zr-0.5*max(zr)));
        dudz=abs((u_z(2:end)-u_z(1:end-1))./(zr(2:end)-zr(1:end-1)));
        delta_vort=2*U0/(max(dudz));
        Re=U0*delta_vort/nu;
        if(Re>=Re_aim)
          do_Re=false;
          U0_aim=U0
          delta_aim=delta_vort
          break
        end
        end
        end

        N2=Ri*((2*U0)^2)./(delta_aim^2);

        % Density difference
        delta_rho=N2*delta_aim/(g/rho0)
        Nz=((Re^(9/4))/4)^(1/3) 

        % temp coeff for linear equation of state
        alpha = 20;
        % Sref and Tref and density using liner equation of state for only temperature
        Sref = 35.0;
        Tref = 20.0;
        T0 = (delta_rho+alpha*Tref)/alpha;


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
        Q=0.0*rand([nx,ny]);

        % Create initial conditions for salt and temp
        salt=zeros([nx,ny,nz]);
        temp=zeros([nx,ny,nz]);
        % Initial profile
        salt(:,:,:)=Sref;
        temp(:,:,:)=Tref;

        %Use salt as passive tracer
        salt(:,:,1:0.5*int16(nz))=Sref+5;

        dnm=Tref+0.5*(T0-Tref)*erf((4/delta)*(zr-0.5*max(zr)));
        dnm=repmat(dnm,[nx 1 ny]);
        temp=permute(dnm,[1 3 2])+1e-4*rand([nx,ny,nz]);
        temp=flipdim(temp,3);

        clear dnm
        u=U0*erf((4/delta)*(zr-0.5*max(zr)));
        u=repmat(u,[nx 1 ny]);
        u=permute(u,[1 3 2])+1e-5*rand([nx,ny,nz]);      

        % Cold water
%        for i=1:nx
%            for j=1:ny
%                for k=1:nz
%                    temp(i,j,k)=temp(i,j,k)+0.5*(T0-Tref)*erf((4/delta)*(zr(k)-0.5*max(zr(:))));
%                end
%            end
%        end
        % Peridoic B.C. in y-direction
        temp(:,end,:) = temp(:,1,:);
        u(:,end,:) = u(:,1,:);

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
fid=fopen([project_name1 'U.init'],'w',ieee); fwrite(fid,u,prec); fclose(fid);
%fid=fopen([project_name1 'Qnet.forcing'],'w',ieee); fwrite(fid,Q,prec); fclose(fid);

