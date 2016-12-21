clear all

foldername='/hexagon/work/milicak/RUNS/micom/biharmonic/'

grav=9.81;
projectname='exp03.2'
grdname=[foldername projectname '/' 'grid.nc'];
year='2004'
month=num2str(11,'%.2d');
%filename=[foldername projectname '/' projectname '_hm_' year '.' month '.nc'];
%filename=[foldername projectname '/exp03.2_uvelvvel_1990_2005.nc'];
filename=[foldername 'movie_files/exp03.2_uvelvvel_2005_01_03.nc'];
%filename=[foldername 'movie_files/exp04.1_uvelvvel_2004_01_12.nc'];


qdx=ncgetvar(grdname,'qdx');
qdy=ncgetvar(grdname,'qdy');
pdx=ncgetvar(grdname,'pdx');
pdy=ncgetvar(grdname,'pdy');
qlat=ncgetvar(grdname,'qlat');
qlon=ncgetvar(grdname,'qlon');
radian=57.295779513;
corioq=sin(qlat./radian)*4.*pi/86164.0;

%uvel=ncgetvar(filename,'uvel');
%vvel=ncgetvar(filename,'vvel');
uflx=ncgetvar(filename,'uflx');
vflx=ncgetvar(filename,'vflx');
dp=ncgetvar(filename,'dp');

Nx=size(uflx,1);
Ny=size(uflx,2);

for timeind=1:536
%4th layer velocity
%uu=squeeze(uvel(:,:,4,timeind));
%vv=squeeze(vvel(:,:,4,timeind));
uu=squeeze(uflx(:,:,4,timeind)).*grav;
vv=squeeze(vflx(:,:,4,timeind)).*grav;
dpp=squeeze(dp(:,:,4,timeind));
uu=uu./(dpp.*qdy);
vv=vv./(dpp.*qdx);
u_y(1:Nx,2:Ny)=(uu(:,2:end)-uu(:,1:end-1))./qdy(:,2:end);
v_x(2:Nx,1:Ny)=(vv(2:end,:)-vv(1:end-1,:))./qdx(2:end,:);

%compute relative vorticity
xi=-u_y+v_x;
%compute sigmaT
ST=u_y+v_x;

%compute sigmaT
uu(end+1,:)=uu(1,:);
vv(:,end+1)=vv(:,1);
u_x=(uu(2:end,:)-uu(1:end-1,:))./pdx;
v_y=(vv(:,2:end)-vv(:,1:end-1))./pdy;
SN=u_x-v_y;
OW=SN.^2+ST.^2-xi.^2;

%subplot(2,1,1)
hhh=figure('Visible','off');
pcolor(deg2km(qlon),deg2km(qlat)-deg2km(min(qlat(:))),xi./corioq);shading interp;colorbar;
needJet2
set(gca,'DataAspectRatio',[1.1 1.6 1])
%colormap(bluewhitered(20))
caxis([-.7 .7])
%subplot(2,1,2)
%pcolor(deg2km(qlon),deg2km(qlat)-deg2km(min(qlat(:))),OW);shading interp;colorbar;        
%caxis([-1.e-9 1e-9])
%colormap(bluewhitered(20))

no=num2str(timeind,'%.4d')
printname=['gifs/vorticity' no];
print(hhh,'-dpng','-r150',printname)
close all
end





