% read MITgcm data from Max's simulations
% and create binary files
% in the format wanted by Besio
%
% milicak Sep 2013

clear all; close all;

%% output options for binary files.
ieee='b';
accuracy='real*8';

%% path to input files
%pathIn = '/bcmhsm/milicak/RUNS/mitgcm/submesoscale/rough_topo/';
pathIn = '/bcmhsm/milicak/RUNS/mitgcm/submesoscale/rough_topo_high_freq/';

%% path to output files

dx=200; %200 meter is the resolution
dy=200; %200 meter is the resolution
x=dx/2:dx:1152*200-dx/2;
y=dx/2:dx:1152*200-dx/2;
[lon lat]=meshgrid(x,y);
lon=lon';lat=lat';
x=lon;y=lat;

depth=rdmds('/bcmhsm/milicak/RUNS/mitgcm/submesoscale/rough_topo/Depth');
msk=0*depth;msk(depth~=0)=1;

%
[nx,ny] = size(x);
InfoFld(:,1) = reshape(x,[nx*ny 1]);
InfoFld(:,2) = reshape(y,[nx*ny 1]);
InfoFld(:,3) = reshape(lon,[nx*ny 1]);
InfoFld(:,4) = reshape(lat,[nx*ny 1]);
InfoFld(:,5) = reshape(msk,[nx*ny 1]);
% note binary file could be read later simply
% via readbin(grdfileOUT,[nx ny 5],1,accuracy);

timestep=90;
timeini=43245;
timeend=95625;
dT=40;
Nx=1152;
Ny=1152;

n=1;
for ii = timeini:timestep:timeend    
    %%read velocities
    hhh=figure('Visible','off');

    diags=double(rdmds([pathIn 'diagvels'],ii));
    %thisU = squeeze(diags(:,:,4,1)); %4 is around 2000m
    %thisV = squeeze(diags(:,:,4,2)); %4 is around 2000m
    thisU = squeeze(diags(:,:,1,1)); %1 is around 2.5m
    thisV = squeeze(diags(:,:,1,2)); %1 is around 2.5m
    %first dimension is y-direction
    thisU(:,end+1)=thisU(:,1);
    thisV(end+1,:)=thisV(1,:);

    dudy=zeros(Ny+1,Nx+1);
    dvdx=zeros(Ny+1,Nx+1);
    %dudy
    dudy(2:end-1,:)=(thisU(2:end,:)-thisU(1:end-1,:))./dy;
    %dvdx
    dvdx(:,2:end-1)=(thisV(:,2:end)-thisV(:,1:end-1))./dx;
    %vorticity ksi
    ksi=-dudy+dvdx;
    %dudx
    dudx=(thisU(:,2:end)-thisU(:,1:end-1))./dx;
    %dvdy
    dvdy=(thisV(2:end,:)-thisV(1:end-1,:))./dy;
    tmp1=0.25*(dvdx(2:end,1:end-1)+dvdx(1:end-1,1:end-1)+dvdx(2:end,2:end)+dvdx(1:end-1,2:end));
    tmp2=0.25*(dudy(2:end,1:end-1)+dudy(1:end-1,1:end-1)+dudy(2:end,2:end)+dudy(1:end-1,2:end));
    tmp3=0.25*(ksi(2:end,1:end-1)+ksi(1:end-1,1:end-1)+ksi(2:end,2:end)+ksi(1:end-1,2:end));
    %Sn
    Sn=dudx-dvdy;
    %Ss
    Ss=tmp1+tmp2;
    %Okubo-Weiss OW
    OW=Sn.^2+Ss.^2-tmp3.^2;
    pcolor(ksi'./-1.5e-4);shading flat;colorbar
    colormap(bluewhitered(40))
    caxis([-1 1]) 
    no=num2str(n,'%.4d');
    printname=['gifs/vorticity' no];
    print(hhh,'-dpng','-r150',printname)
    close all

    n=n+1;
end



