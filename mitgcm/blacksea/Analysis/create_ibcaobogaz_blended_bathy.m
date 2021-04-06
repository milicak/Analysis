% Script to read IBCAO data and create irminger bathy for the 2km runs
% NOTE: This uses the new IBCAO 2km-res. version released in march 08
% (see paper Jakobsson et al, 2008, GRL, doi: 10.1029/2008gl033520) 
% and the geographic coords version of the IBCAO data
% 
% itimu, Jan 10 
% based on read_ibcao_SS_bathy.m by twhn Jul 04, Sep 07

close all
clear all; clear global;
more off
fprintf(1,' Reading/writing GEBCO 2014 30min bathymetry.\n\n') ;

outfile = 'Blacksea_2km_bathy_west_open.bin' ;
%ibcaofile = '/export/grunchfs/unibjerknes/milicak/bckup/world_grid/GEBCO_2014_1D.nc';
ibcaofile = '/okyanus/users/milicak/dataset/world_bathy/GEBCO_2014_1D.nc';
bogazfile = '/okyanus/users/milicak/dataset/world_bathy/bathy_kwm.nc';

run set_blacksea_2km_grid
[lambda,phi]=meshgrid(XC,YC) ;
land = 0 ;   % height of land for fixing grid.
deep_cutoff = -2500 ; % caxis variable - deepest height plotted.

%data = ncload(ibcaofile) ;
z = ncread(ibcaofile,'z');
dimension = ncread(ibcaofile,'dimension');
spacing = ncread(ibcaofile,'spacing');
x_range = ncread(ibcaofile,'x_range');
y_range = ncread(ibcaofile,'y_range');

bathy = reshape(z,dimension(1),dimension(2)) ;
clear z
bathy=fliplr(bathy) ;
x2 = x_range(1):spacing(1):x_range(2) ;
y2 = y_range(1):spacing(2):y_range(2) ;

% Get cutout.
subsetx = 24700:26700 ;
subsety = 15500:16600 ;
bathy_cut = bathy(subsetx,subsety)' ;
bathy_cut2 = bathy_cut ;
figure
tmp = find(bathy_cut>0) ;
bathy_cut(tmp) = NaN.*ones(size(tmp)) ;
pcolor(x2(subsetx),y2(subsety),bathy_cut) ;
caxis([deep_cutoff 0]) ;
shading flat
clear bathy
hold on
sel = 4 ;
tmpx = lambda(1:sel:end,1:sel:end) ;
tmpy = phi(1:sel:end,1:sel:end) ;
plot(tmpx(:),tmpy(:),'.') ;
hold off

% Read bogaz high resolution data
lonbogaz = ncread(bogazfile,'lon');
latbogaz = ncread(bogazfile,'lat');
depthbogaz = -ncread(bogazfile,'depth');
lonbstr = 28.8;
lonbend = 29.8;
latbstr = 41.0;
latbend = 42.0;
indstr = max(find(lonbogaz<=lonbstr));
indend = min(find(lonbogaz>=lonbend)); 
jndstr = max(find(latbogaz<=latbstr));
jndend = min(find(latbogaz>=latbend)); 
lonbogaz = lonbogaz(indstr:indend);
latbogaz = latbogaz(jndstr:jndend);
depthbogaz = depthbogaz(indstr:indend,jndstr:jndend);
xv = [lonbogaz(1) lonbogaz(end) lonbogaz(end) lonbogaz(1)]
yv = [latbogaz(1) latbogaz(1) latbogaz(end) latbogaz(end)]
xv(end+1) = xv(1);
yv(end+1) = yv(1);
[lonbogaz latbogaz] = meshgrid(lonbogaz,latbogaz);
lonbogaz = lonbogaz';
latbogaz = latbogaz';

% Interpolate onto model grid.
method='linear';   % Looks OK?
%method='spline';  % doesn't look so great (lots of isolated ocean spots).
%method='cubic' ;  % doesn't look so great.
fprintf(1,' Interpolating with [%s] method ...',method) ;
bath3=interp2(x2(subsetx),y2(subsety),bathy_cut2,lambda,phi,method);
fprintf(1,' done.\n\n') ;

%% Use Smith & Sandwell where ibcao runs out, i.e at the southeastern corner
%[SSbath,Y,X] = mygrid_sand([latmin-0.1; latmax+0.1; lonmin-0.1; lonmax+0.1],1);
%X=X-360;
%[x,y]=meshgrid(X,Y);    % old SS grid
%inds = find(isnan(bath3)) ;
%method='linear';
%tmpbath3=interp2(x,y,SSbath,lambda(inds),phi(inds),method);
%bath3(inds) = tmpbath3 ;

% dnm = bath3;
% in = insphpoly(lambda,phi,xv,yv,0,90); 
% in = double(in);
% interpolant = scatteredInterpolant(lonbogaz(:),latbogaz(:),depthbogaz(:));
% tmpbath3 = interp2(lonbogaz,latbogaz,depthbogaz,lambda(in==1),phi(in==1),method);
% %bath3(in) = tmpbath3 ;
% return


% Figure before futzing.
bath5 = bath3 ;
inds = find(bath5>0) ;
bath5(inds) = NaN.*ones(size(inds)) ;
figure
pcolor(lambda,phi,bath5) ;
shading flat
caxis([deep_cutoff 0]);
colorbar

% Futz bathymetry.
% 1. Remove shallow areas.
%bath4 = bath3 ;
%shallowest_depth = 5 ; % 20 !!
%fprintf(1,'1. Removing depths shallower than [%g]m deep.\n',shallowest_depth) ;
%tmp = find(bath4 > -shallowest_depth) ;
%bath4(tmp) = land.*ones(size(tmp)) ;

% 1. Remove shallow areas.
bath4 = bath3 ;
shallowest_depth = 10 ; % 20 !!
fprintf(1,'1. set minimum depth to [%g]m deep.\n',shallowest_depth) ;
bath4(bath4 > 0) = NaN;
% remove places shallower than -3 meter. Set them land. This will help us for
% interior points
% for the Azak Sea
xx = [36.3440 36.3342 37.0905 37.1019]; xx(end+1) = xx(1);
yy = [45.5596 44.9732 44.9545 45.5377]; yy(end+1) = yy(1);
in = insphpoly(lambda,phi,xx,yy,0,90);
in = double(in);
dnm = bath4;
bath4(bath4 >= -3) = NaN;
bath4(in==1) = dnm(in==1);
bath4(bath4 >= -shallowest_depth) = -shallowest_depth;


% 2. Remove ocean points with only 1 side open to the sea.
fprintf(1,'2. Removing isolated ocean points.\n') ;
for nn = 1:8   % 3 or 4 sweeps should be enough?
%for nn = 1:1   % 3 or 4 sweeps should be enough?
   for ii = 2:NY-1
      for jj = 2:NX-1
         sides(ii,jj) = (bath4(ii-1,jj  ) <= - shallowest_depth) + ...
                 (bath4(ii  ,jj-1) <= - shallowest_depth) + ...
                 (bath4(ii  ,jj+1) <= - shallowest_depth) + ...
                 (bath4(ii+1,jj  ) <= - shallowest_depth) ;
         if(sides(ii,jj) < 2 && bath4(ii,jj) <= - shallowest_depth)    % Less than 2 sides of this ocean point areocean points.
            bath4(ii,jj) = land ;
%           fprintf(1,' Splat (%d, %d)!\n',ii,jj) ;
         end % if
      end %jj
   end %ii
end % nn

if 0
    % 3. Remove Marmara Sea
    xx = [26.9853   28.1456   29.4804   30.5027   28.6438   27.2465   26.9853 26.9853];
    yy = [41.1000   41.1779   41.0721   40.6074   40.2104   40.2404   40.2000 41.1000];
    fprintf(1,'3. Remove Marmara Sea.\n') ;
    in = insphpoly(lambda,phi,xx,yy,0,90);
    in = double(in);
    bath4(in==1) = NaN;
end
    xx = [39.3959   39.3959   40.5023   40.4743   39.3959];
    yy = [47.5020   46.9101   46.8904   47.5625   47.5020];
    in = insphpoly(lambda,phi,xx,yy,0,90);
    in = double(in);
    bath4(in==1) = NaN;
    xx = [30.4749   30.4886   30.4302   30.1311   30.1586   30.3202   30.4749];
    yy = [46.2436   46.2639   46.4134   46.3636   46.1900   46.1679   46.2436];
    in = insphpoly(lambda,phi,xx,yy,0,90);
    in = double(in);
    bath4(in==1) = NaN;
    xx = [32.3117 32.3086 32.4583 32.4597]; xx(end+1) = xx(1);
    yy = [46.5972 46.4155 46.4211 46.6027]; yy(end+1) = yy(1);
    in = insphpoly(lambda,phi,xx,yy,0,90);
    in = double(in);
    bath4(in==1) = NaN;
if 1
    % open bosphorus
    bgzdpth = -60;
    bath4(63,121) = bgzdpth;
    bath4(64,122) = bgzdpth;
    bath4(67,123) = bgzdpth;
    bath4(64,121) = bgzdpth;
    bath4(63,120) = bgzdpth;
    bath4(67:68,124) = bgzdpth;
    bath4(72,124) = NaN;
    bath4(69,125) = NaN;
    bath4(65:66,122:123) = bgzdpth;
    for j=63:76; for i=120:129
        if(bath4(j,i) < 0)
            bath4(j,i) = bgzdpth;
        end
    end;end
    % dig blacksea exit
    bath4(77:79,129:130) = bath4(77:79,129:130) - 12.0;
    % dig marmara exit
    bath4(59:60,117:119) = bath4(59:60,117:119) - 12.0;
    bath4(61,118:120) = bgzdpth;
    bath4(62,120) = bgzdpth;
end
if 1 
    %open blacksea part of bosphorus
    bgzdpth2 = bath4(129,87);
    for ii = 77:86
        bath4(ii,128) = bgzdpth+(bgzdpth2-bgzdpth)*(ii-76)/(86-77+1);
    end
    bath4(79:87,127) = bath4(79:87,128);
    bath4(91,128) = -103.0;
end

% open boundary on the west side of the Marmara Sea
bath4(25:36,1) = bath4(25:36,2);

% Write out field.
fprintf(1,' Writing field to %s\n',outfile) ;
ieee='b';
accuracy='real*8';
fid=fopen(outfile,'w',ieee); 
fwrite(fid,bath4',accuracy);
fclose(fid);
