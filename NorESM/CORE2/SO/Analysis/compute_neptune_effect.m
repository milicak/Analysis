% this subroutine computes neptune velocity
% using psi=-fL^2H and psi_x/H=v and -psi_y/H=u
clear all

%grid_file='/work/shared/noresm/inputdata/ocn/micom/tnx1v1/20120120/grid.nc';
grid_file='/home/fimm/bjerknes/milicak/Analysis/NorESM/climatology/Analysis/grid.nc';


% Get dimensions and time attributes

% Read grid information
qlon=ncgetvar(grid_file,'qlon');
qlat=ncgetvar(grid_file,'qlat');
plat=ncgetvar(grid_file,'plat');
qarea=ncgetvar(grid_file,'qarea');
pdepth=ncgetvar(grid_file,'pdepth');
qclon=ncgetvar(grid_file,'qclon');
qclat=ncgetvar(grid_file,'qclat');
angle=ncgetvar(grid_file,'angle');
qclon=permute(qclon(:,:,:),[3 1 2]);
qclat=permute(qclat(:,:,:),[3 1 2]);

radian=57.295779513;
corioq=sin(qlat./radian)*4.*pi/86164.;
coriop=sin(plat./radian)*4.*pi/86164.;
L=8+4.*cos(2*plat./radian);
L=L.*1e3; %convert from km to m;
psi=-coriop.*pdepth.*L.^2;
Dstar=log(pdepth);

nx=size(psi,1);
ny=size(psi,2);

pdx=ncgetvar(grid_file,'pdx');
pdy=ncgetvar(grid_file,'pdy');
inw=ncgetvar(grid_file,'inw');
jnw=ncgetvar(grid_file,'jnw');
ins=ncgetvar(grid_file,'ins');
jns=ncgetvar(grid_file,'jns');


for i=1:nx
for j=1:ny
  psi_dx(i,j)=(psi(i,j)-psi(inw(i,j),jnw(i,j)))./(pdx(i,j));
  psi_dy(i,j)=(psi(i,j)-psi(ins(i,j),jns(i,j)))./(pdy(i,j));
  Dstar_dx(i,j)=(Dstar(i,j)-Dstar(inw(i,j),jnw(i,j)))./(pdx(i,j));
  Dstar_dy(i,j)=(Dstar(i,j)-Dstar(ins(i,j),jns(i,j)))./(pdy(i,j));
end
end
    

u_star=-psi_dy./pdepth;
v_star=psi_dx./pdepth;

u_star2=-L.^2.*coriop.*Dstar_dy;
v_star2=L.^2.*coriop.*Dstar_dx;

speed=sqrt(u_star.^2+v_star.^2);
speed2=sqrt(u_star2.^2+v_star2.^2);


