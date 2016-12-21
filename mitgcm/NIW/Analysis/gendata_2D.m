clear all

project_name = ['NIWs']

project_name1 = ['/hexagon/work/milicak/RUNS/mitgcm/' project_name '/input_exp1.0/'];

prec = 'real*8';
ieee = 'b';

% bathymetry HAS TO BE NEGATIVE
title = 'NIWs'
switch title
    case 'NIWs'
    tau0 = 2;
    % set parameters and filenames
    dYmin = 500; %500*1400/35080; %500; %minimum wanted y-spacing in meters
    dYmaxN = 2500; %minimum wanted y-spacing in meters in North
    dYmaxS = 5000; %minimum wanted y-spacing in meters in South
    Ny = 1400; %35080; %1400;
    Nsouth = 80; %number of pts to strecth south
    Nnorth = 40; %number of pts to strecth north
    NY = Ny+Nsouth+Nnorth; %wanted total number of pts in y-dir    
    
    % set local cartesian grid
    delY = [linspace(dYmaxS,dYmin,Nsouth) dYmin*ones(1,NY-Nnorth-Nsouth) linspace(dYmin,dYmaxN,Nnorth)];
    tmpYe = [0 cumsum(delY)];     
    tmpYc = 0.5*(tmpYe(1:end-1)+tmpYe(2:end));

    delX(1)=1000;


    % compute dz
    dZmin = 0.1; %minimum wanted z-spacing in meters
    dZmaxB = 7; %minimum wanted z-spacing in meters at the bottom
    dZmaxT = 0.1;  %minimum wanted z-spacing in meters at the top
    Nz = 500;
    Nbottom = 250; %number of pts to strecth bottom
    Ntop = 0; %number of pts to strecth top    
    NZ = Nz+Nbottom+Ntop; %wanted total number of pts in z-dir    

    %delta_z = [linspace(dZmaxB,dZmin,Nbottom) dZmin*ones(1,NZ-Ntop-Nbottom) linspace(dZmin,dZmaxT,Ntop)];
    delta_z(1:296) = 1000.0/296;

    % bathymetry HAS TO BE NEGATIVE
    H = sum(delta_z(:));
    H = 1000.0;
    d(1:size(delX,2),1:size(delY,2)) = -H;

    zw = [0 cumsum(delta_z)];
    zr = 0.5*(zw(2:end)+zw(1:end-1));

    % constant N2
    N2 = 6e-6*ones(size(delta_z));
    hmxl = 50; 
    ind=max(find(zr<=(H-hmxl)));
    N2(ind:end)=0;
    b  =  cumsum(N2.*delta_z,2);
    T = b /9.81/2e-4;
    
    
    %% acrtan temp
    %Ttop = 3.0;
    %Tbot = 0.0;  
    %b1 = 0.5*(Ttop+Tbot);
    %b2 = b1 - Tbot;
    %hc = 50;
    %hd = 30;
    %dnm = b1+b2*tanh((zr+hc)./hd);
    

    dnm = repmat(T,[size(d,1) 1 size(d,2)]);
    temp=permute(dnm,[1 3 2]);
    %check salt(1,1,end) has to be bottom and the densiest
    temp=flipdim(temp,3);

    %
    y = cumsum(delY);
    x = y;
    [x y] = meshgrid(x,y);
    xcenter = 250e3;
    ycenter = 700e3;
    radius = 100e3;
    %tau=0.2*exp(-(((y-ycenter)./radius).^2+((x-xcenter)./radius).^2));

    Nitr=15; %7days travel time and every 12 hours, so N=7*2=14;
    ind=max(find(x(1,:)<=460e3));
    for itr=1:Nitr
      L = xcenter + (max(y(:))+600e3-xcenter)*(itr-1)/(Nitr-1);
      [TH,R] = cart2pol((x(:,ind)-L),(y(:,ind)-ycenter));
      wind(:,:) = tau0*exp(-(((y(:,ind)-ycenter)./radius).^2+((x(:,ind)-L)./radius).^2));
      taux(:,:,itr) = -wind(:).*sin(TH);
      tauy(:,:,itr) = wind(:).*cos(TH);
      %[TH,R] = cart2pol((x-L),(y-ycenter));
      %taux(:,:,itr) = -wind(:,ind).*sin(TH);
      %tauy(:,:,itr) = wind(:,ind).*cos(TH);
    end

    taux2d = taux;
    tauy2d = tauy;
    clear taux tauy
    taux2d = permute(taux2d,[2 1 3]);
    tauy2d = permute(tauy2d,[2 1 3]);
    %keep the wind for 4 days
    dnm=taux2d;
    for k=4:10
      taux2d(:,:,k)=taux2d(:,:,3);
    end
    for k=11:22
      taux2d(:,:,k)=dnm(:,:,k-7);
    end
    dnm=tauy2d;
    for k=4:10
      tauy2d(:,:,k)=tauy2d(:,:,3);
    end
    for k=11:22
      tauy2d(:,:,k)=dnm(:,:,k-7);
    end

    %fill zeros after the 7th day
    taux2d(:,:,end+1:49)=0;
    tauy2d(:,:,end+1:49)=0;

end  %switch

%break

% closed boundary in south direction
d(1,1) = 0;
% closed boundary in north direction
d(1,end) = 0;

%write the wind forcing
fid=fopen([project_name1 'taux.forcing'],'w',ieee); fwrite(fid,taux2d,prec); fclose(fid);
fid=fopen([project_name1 'tauy.forcing'],'w',ieee); fwrite(fid,tauy2d,prec); fclose(fid);

%write the bathymetry in a file
fid=fopen([project_name1  'topog.slope'],'w',ieee); fwrite(fid,d,prec); fclose(fid);

%write delta x
delX=delX';
fid=fopen([project_name1 'dx.bin'],'w',ieee); fwrite(fid,delX,prec); fclose(fid);

%write delta y
delY=delY';
fid=fopen([project_name1 'dy.bin'],'w',ieee); fwrite(fid,delY,prec); fclose(fid);

%write delta z
delta_z=delta_z';
delta_z=flipud(delta_z);
fid=fopen([project_name1 'dz.bin'],'w',ieee); fwrite(fid,delta_z,prec); fclose(fid);

%write Salt and Temp
%fid=fopen([project_name1 'S.init'],'w',ieee); fwrite(fid,salt,prec); fclose(fid);
fid=fopen([project_name1 'T.init'],'w',ieee); fwrite(fid,temp,prec); fclose(fid);

