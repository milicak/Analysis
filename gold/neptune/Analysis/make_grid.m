%this subroutine is to make a grid file with depth and Coriolis force
% etc.

clear all
clc

% Title of the project
title='neptune_1km'

% Create the bathymetry; size(depth) has to be (1:M,1:L)


switch title

    case 'neptune_1km'
        L=500; % grid points in x-direction ; it's better if L+2 is 2^n
        M=501; % grid points in y-direction ; it's better if M+2 is 2^n

        % Grid file name
        grdname='Neptune_1km.nc';
        max_depth=2000;
        min_depth=0;
        
        load topo_2d 
        % depth should be positive
        for i=1:L; for j=1:M-1
          D(i,j)=-topo(i,j);
        end; end
        D(:,end+1)=D(:,1);
        D(end,:)=D(1,:);

        D(D>max_depth)=max_depth;
        D(D<min_depth)=0.5*min_depth;
        depth=D';
        %  Coriolis parameter normally f=4*pi*sin(pi*geolatb/180)/(24*3600);
        f(1:M,1:L)=1.0e-4;
end

% Compute the mask
%
wet=ones(M,L); % at first put everywhere water
wet(find(depth<0))=0; % where depth < 0 is land points

%
% Create the grid file
%
disp(' ')
disp(' Create the grid file...')
disp([' L = ',num2str(L)])
disp([' M = ',num2str(M)])
create_grid(L,M,grdname,title)

%
% Fill the grid file
%
disp(' ')
disp(' Fill the grid file...')
nc=netcdf(grdname,'write');

nc{'depth_t'}(:)=depth;
%nc{'depth'}(:)=depth;
nc{'f'}(:)=f;
nc{'wet'}(:)=wet;

result=close(nc);
