%this subroutine is to make a grid file with depth and Coriolis force
% etc.

clear all
clc

% Title of the project
title='bogaz_100m'

% Create the bathymetry; size(depth) has to be (1:M,1:L)


switch title

    case 'bogaz_100m'
        Lx = 40e3; %40 km
        Lxoff = 3e3; %3 km how far from the boundaries
        Lcontraction = 4e3; % m length of contraction
        Lsill = 1e3; % m length of sill
        Ly = 1300; %meter
        dx = 50; % meter
        dy = 50; % meter

        L = Lx/dx; % grid points in x-direction ; it's better if L+2 is 2^n
        M = Ly/dy; % grid points in y-direction ; it's better if M+2 is 2^n
        lon = dx/2:dx:Lx-dx/2;
        lat = dy/2:dy:Ly-dy/2;

        % Grid file name
        grdname='Bogaz_100m.nc';
        max_depth=70;
        min_depth=0;
        
        % first closed everywhere
        D = max_depth*ones(L,M);

        % depth should be positive
        for i=1:L; for j=1:M
            if(lon(i) > Lxoff & lon(i) < Lx-Lxoff)
                D(i,j) = max_depth;
            end
        end; end
        % The sill
        lon_c = Lx-(Lxoff+3e3)+0.5*Lsill;
        for i=1:L; for j=1:M
            if(lon(i) > Lx-(Lxoff+3e3) & lon(i) < Lx-(Lxoff+3e3)+Lsill)
                tmp =((lon(i)-lon_c)^2 ) / (1e5);
                D(i,j) = D(i,j) - 13.0*exp(-tmp);
            end
        end; end
        % The contraction
        lon_c = (Lxoff+9e3)+0.5*Lcontraction;
        for i=1:L; for j=1:M
            if(lon(i) > (Lxoff+9e3) & lon(i) < (Lxoff+9e3)+Lcontraction)
                tmp =((lon(i)-lon_c)^2 ) / (1e5);
                Lyoff = 300*exp(-tmp);
                if (lat(j)<Lyoff | lat(j)>Ly-Lyoff)
                %D(i,j) = D(i,j) - 13.0*exp(-tmp);
                    D(i,j) = min_depth; 
                end
            end
        end; end
        D(1,:) = min_depth;
        D(end,:) = min_depth;
        D(:,1) = min_depth;
        D(:,end) = min_depth;
        
        D(D>max_depth) = max_depth;
        D(D<min_depth) = 0.5*min_depth;
        depth = D;
        %  Coriolis parameter normally f=4*pi*sin(pi*geolatb/180)/(24*3600);
        f(1:L,1:M) = 9.66e-5;
end

% Compute the mask
%
wet = ones(L,M); % at first put everywhere water
wet(find(depth<=0)) = 0; % where depth < 0 is land points

Nk = 15;
wet3 = repmat(wet,[1 1 Nk]);
hini(1:L,1:M,1:Nk) = 1e-15;
ind = int16(0.5*L);
hini(1:ind,:,Nk) = D(1:ind,:);
hini(ind+1:end,:,1) = D(ind+1:end,:);
hini(wet3==0) = 1e-15;

%
% Create the grid file
%
disp(' ')
disp(' Create the grid file...')
disp([' L = ',num2str(L)])
disp([' M = ',num2str(M)])
create_hgrid(L,M,Nk,grdname,title)

%
% Fill the grid file
%
disp(' ')
disp(' Fill the grid file...')
ncwrite(grdname,'h',hini);
ncwrite(grdname,'depth',depth);
ncwrite(grdname,'depth_t',depth);
ncwrite(grdname,'wet',wet);

