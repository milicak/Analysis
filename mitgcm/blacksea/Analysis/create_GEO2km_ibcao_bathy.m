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

outfile = 'Blacksea_2km_bathy.bin' ;
ibcaofile = '/export/grunchfs/unibjerknes/milicak/bckup/world_grid/GEBCO_2014_1D.nc';

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

% 3. Remove Marmara Sea
xx = [26.9853   28.1456   29.4804   30.5027   28.6438   27.2465   26.9853 26.9853];
yy = [41.1000   41.1779   41.0721   40.6074   40.2104   40.2404   40.2000 41.1000];
fprintf(1,'3. Remove Marmara Sea.\n') ;
in = insphpoly(lambda,phi,xx,yy,0,90);
in = double(in);
bath4(in==1) = NaN;
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

% 4. Remove obcs.
if 1
    fprintf(1,'4. Remove obcs.\n') ;
    %itimu note: default is periodic obcs, so it is enough to put west and
    bath4(isnan(bath4)) = 0;
    %south boundaries to close the whole domain
    bath4(:,1) = 0 ; %west
    bath4(1,:) = 0 ; %south
    bath4(:,end) = 0 ; %east
    bath4(end,:) = 0 ; %north
    %bath4(end,end) = 0 ; %close only northeastern corner
    %bath4(  1,end) = 0 ; %close only southeastern corner
    %bath4(  1,  1) = 0 ; %close only southwestern corner    
end % if

if 0
% 3. Remove lakes and other features by hand.
fprintf(1,'3. Remove lakes and other features manually.\n') ;
figure
snip = [  
           19  147  30  155 ; % itimu
           87  195  95  215 ; % itimu
          121  197 122  198 ; % itimu
          214  301 215  302 ; % itimu
          210  334 212  338 ; % itimu
          269  326 271  329 ; % itimu   
          %put land to simulate Iceland's Vestmannaey Jar's Archipelago
          473   66 474   67 ; % itimu
          474   68 475   68 ; % itimu
       ] ;     
for ii = 1:size(snip,1)
    bath4(snip(ii,2):snip(ii,4),snip(ii,1):snip(ii,3)) = land ;
end % ii

if 0   % Uncomment to check "snip" variable.
    bath5 = bath4 ;
    inds = find(bath5==0) ;
    bath5(inds) = NaN ;
    pcolor(bath5)
    shading flat
    butt = 1 ;
    while(butt == 1)
        [x,y,butt] = ginput(1) 
        bath5 = bath4 ;
        inds = find(bath5==0) ;
        bath5(inds) = NaN ;
        pcolor(bath5)
        shading flat
        drawnow
    end % while
end % if 0
end % if 0

% 5. Round off corners.
if 0
    fprintf(1,'5. Round off corners.\n') ;   % Maybe this will help keep the model stable?
    bath4(2    ,2:6)       = 0 ;   % SW corner
    bath4(3    ,2:5)       = 0 ;
    bath4(4    ,2:4)       = 0 ;
    bath4(5    ,2:3)       = 0 ;
    bath4(6    ,2)         = 0 ;
    bath4(2    ,end-4:end) = 0 ;   % SE corner
    bath4(3    ,end-3:end) = 0 ;
    bath4(4    ,end-2:end) = 0 ;
    bath4(5    ,end-1:end) = 0 ;
    bath4(6    ,end)       = 0 ;
    bath4(end  ,end-4:end) = 0 ;   % NE corner
    bath4(end-1,end-3:end) = 0 ;
    bath4(end-2,end-2:end) = 0 ;
    bath4(end-3,end-1:end) = 0 ;
    bath4(end-4,end)       = 0 ;
%    outfile = 'ibcaoSS_270x180x97_bat_smooth_corners.bin' ;
end % if

% Write out field.
fprintf(1,' Writing field to %s\n',outfile) ;
ieee='b';
accuracy='real*8';
fid=fopen(outfile,'w',ieee); 
fwrite(fid,bath4',accuracy);
fclose(fid);
bath5 = bath4 ;
inds = find(bath5==0) ;
if ~isempty(inds)
  bath5(inds) = NaN ;
end
incr=0.5;    
m_proj('lambert','long',[lonmin-incr lonmax+incr],'lat',[latmin-incr latmax+incr]);
%m_proj('mercator','long',[lonmin-incr lonmax+incr],'lat',[latmin-incr latmax+incr]);
m_pcolor(XC,YC,bath5); shading interp; colorbar;
hold on
m_coast('patch',[.7 .7 .7],'edgecolor','r');
m_grid('box','fancy','tickdir','in');
hold off

bath5(isnan(bath5)) = 0;

mask = zeros(size(bath5,1),size(bath5,2));
mask(bath5<0) = 1;

%writing bathy lon lat values to netcdf file
ncid=netcdf.create(['BlackSea_grid_NX_' num2str(NX) '_NY_' num2str(NY) '.nc'],'NC_CLOBBER');

%Define dimensions
ni_dimid=netcdf.defDim(ncid,'x',NX);  
nj_dimid=netcdf.defDim(ncid,'y',NY); 
nz_dimid=netcdf.defDim(ncid,'z',NZ); 

% Define variables and assign attributes
tlon_varid=netcdf.defVar(ncid,'nav_lon','double',[ni_dimid nj_dimid]);
netcdf.putAtt(ncid,tlon_varid,'long_name','T grid center longitude');
netcdf.putAtt(ncid,tlon_varid,'units','degrees_east');

tlat_varid=netcdf.defVar(ncid,'nav_lat','double',[ni_dimid nj_dimid]);
netcdf.putAtt(ncid,tlat_varid,'long_name','T grid center latitude');
netcdf.putAtt(ncid,tlat_varid,'units','degrees_north');

navlev_varid=netcdf.defVar(ncid,'nav_lev','double',[nz_dimid]);
netcdf.putAtt(ncid,navlev_varid,'long_name','T grid center vertical');
netcdf.putAtt(ncid,navlev_varid,'units','meter');

glon_varid=netcdf.defVar(ncid,'nav_long','double',[ni_dimid nj_dimid]);
netcdf.putAtt(ncid,glon_varid,'long_name','T grid corner longitude');
netcdf.putAtt(ncid,glon_varid,'units','degrees_east');

glat_varid=netcdf.defVar(ncid,'nav_latg','double',[ni_dimid nj_dimid]);
netcdf.putAtt(ncid,glat_varid,'long_name','T grid corner latitude');
netcdf.putAtt(ncid,glat_varid,'units','degrees_north');

tdepth_varid=netcdf.defVar(ncid,'mbathy','double',[ni_dimid nj_dimid]);
netcdf.putAtt(ncid,tdepth_varid,'long_name','depth of T grid cells');
netcdf.putAtt(ncid,tdepth_varid,'units','meter');
%netcdf.putAtt(ncid,tdepth_varid,'coordinates','TLON TLAT');

tmask_varid=netcdf.defVar(ncid,'tmaskutil','double',[ni_dimid nj_dimid]);
netcdf.putAtt(ncid,tmask_varid,'long_name','sea mask of T grid cells');
netcdf.putAtt(ncid,tmask_varid,'units',' ');
%netcdf.putAtt(ncid,tmask_varid,'coordinates','TLON TLAT');
% End definitions and leave define mode.
netcdf.endDef(ncid)

% Provide values for time invariant variables.
netcdf.putVar(ncid,navlev_varid,double(delZ));
netcdf.putVar(ncid,tlon_varid,double(LONC));
netcdf.putVar(ncid,tlat_varid,double(LATC));
netcdf.putVar(ncid,glon_varid,double(LONG));
netcdf.putVar(ncid,glat_varid,double(LATG));
netcdf.putVar(ncid,tdepth_varid,double(bath5'));
netcdf.putVar(ncid,tmask_varid,double(mask'));
% Close netcdf file
netcdf.close(ncid)



