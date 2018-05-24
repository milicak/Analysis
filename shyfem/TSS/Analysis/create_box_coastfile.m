clear all

Nx = 75;
Ny = 100;


Lx = 100e3; %100 km
Ly = 120e3; %100 km

% bottom coast
x1 = 0:Lx/Nx:Lx;
x1 = x1';
y1 = zeros(size(x1,1),size(x1,2));
% right coast
y2 = 0:Ly/Ny:Ly;
y2 = y2';
x2 = Lx*ones(size(y2,1),size(y2,2));
% top coast
x3 = Lx:-Lx/Nx:0;
x3 = x3';
y3 = Ly*ones(size(x3,1),size(x3,2));
% leftcoast
y4 = Ly:-Ly/Ny:0;
y4 = y4';
x4 = 0*ones(size(y4,1),size(y4,2));
% combine all sides
XY = [x1 y1;x2 y2;x3 y3;x4 y4];

% write it onto coast file
fileID = fopen('shyfem_box_coast.dat','w');
fprintf(fileID,'%12.4f %12.4f\n',XY');
fclose(fileID);

