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
%pathIn = '/bcmhsm/milicak/RUNS/mitgcm/submesoscale/rough_topo_high_freq/';
pathIn = '/bcmhsm/milicak/RUNS/mitgcm/submesoscale/flat_topo_high_freq/';

%% path to output files
%pathOut = '/bcmhsm/milicak/RUNS/mitgcm/submesoscale/rough_topo_high_freq/binfiles';
pathOut = '/bcmhsm/milicak/RUNS/mitgcm/submesoscale/flat_topo_high_freq/binfiles';
grdfileOUT = [pathOut,'/MITgcmGrdInfo.bin'];

dx=200; %200 meter is the resolution
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
fid=fopen(grdfileOUT,'w',ieee);
fwrite(fid,InfoFld,accuracy);
fclose(fid);

timestep=90;
timeini=43245;
%timeend=95625; %rough
timeend=94185; %flat
dT=40;

n=1;
for ii = timeini:timestep:timeend    
    %%read velocities

    diags=double(rdmds([pathIn 'diagvels'],ii));
    %thisU = squeeze(diags(:,:,1,1)); %1 is around 5m
    %thisV = squeeze(diags(:,:,1,2)); %1 is around 5m
    %thisU = squeeze(diags(:,:,2,1)); %2 is around 500m
    %thisV = squeeze(diags(:,:,2,2)); %2 is around 500m
    %thisU = squeeze(diags(:,:,3,1)); %3 is around 1000m
    %thisV = squeeze(diags(:,:,3,2)); %3 is around 1000m
    thisU = squeeze(diags(:,:,4,1)); %4 is around 2000m
    thisV = squeeze(diags(:,:,4,2)); %4 is around 2000m

%    utmp=double(rdmds([pathIn 'U'],ii));
%    vtmp=double(rdmds([pathIn 'V'],ii));
%    thisU = squeeze(utmp(:,:,1)); %1 is the surface
%    thisV = squeeze(vtmp(:,:,1)); %1 is the surface
%    thisU = squeeze(utmp(:,:,100)); %100 is around 2000m
%    thisV = squeeze(vtmp(:,:,100)); %100 is around 2000m

    thisU(end+1,:)=thisU(1,:);
    thisV(:,end+1)=thisV(:,1);
    thisU=0.5*(thisU(2:end,:)+thisU(1:end-1,:));
    thisV=0.5*(thisV(:,2:end)+thisV(:,1:end-1));

%    yyyy = '2012';
%    mm = num2str(eval('int16(ii*dT/86400/30-0.5)'),'%.2d'); %convert iteration time to month
%    dd = num2str(eval('int16(ii*dT/86400-30*int16(ii*dT/86400/30-0.5))'),'%.2d');
%    hh = '12';
%    mn = '00';
%    ufileOUT = [pathOut,'/MITgcmUvel_',yyyy,'_',mm,'_',dd,'_',hh,mn,'.bin'];
%    vfileOUT = [pathOut,'/MITgcmVvel_',yyyy,'_',mm,'_',dd,'_',hh,mn,'.bin']; 

    ufileOUT = [pathOut,'/MITgcmUvel_', num2str(n,'%.3d') ,'.bin'];
    vfileOUT = [pathOut,'/MITgcmVvel_', num2str(n,'%.3d') ,'.bin']; 

    fid1=fopen(ufileOUT,'w',ieee);
    fwrite(fid1,thisU,accuracy);
    fclose(fid1);
    disp(['Created file : ',ufileOUT]); 
    fid2=fopen(vfileOUT,'w',ieee);
    fwrite(fid2,thisV,accuracy);
    fclose(fid2);
    disp(['Created file : ',vfileOUT]);           
    n=n+1;
end



