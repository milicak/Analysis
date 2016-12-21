clear all

expid='NOIIA_T62_tn025_001';
datesep='-';
%grid_file='/hexagon/work/shared/noresm/inputdata/ocn/micom/tnx0.25v1/20130930/grid.nc';
grid_file=['/hexagon/work/milicak/archive/' expid '/ocn/hist/grid.nc'];
lon=ncgetvar(grid_file,'plon');
lat=ncgetvar(grid_file,'plat');
x=lon;
x=x(1000:end,:);
x(x<0)=x(x<0)+360;
lon(1000:end,:)=x;

%grid_file='/home/fimm/bjerknes/milicak/Analysis/NorESM/climatology/Analysis/grid.nc';
fyear=100;
lyear=110;
prefix=['/hexagon/work/milicak/archive/' expid '/ocn/hist/' expid '.micom.hy.'];

clear lon lat x

for year=fyear:lyear
sdate=sprintf('%4.4d',year);
disp(sdate)
%surface
%u1(:,:,:,year-fyear+1)=nc_varget([prefix sdate '.nc'],'uvellvl',[0 0 0 0],[-1 1 -1 -1]);
%full column
u1(:,:,:,year-fyear+1)=nc_varget([prefix sdate '.nc'],'uvellvl',[0 0 0 0],[-1 -1 -1 -1]);
end
umean=squeeze(nanmean(u1,4));

%Hanning 2D filter
clear b
N=12;
nx=0:N-1;
ny=nx;
for i=1:N
for j=1:N
b(i,j) = 0.5*(0.5*(1 - cos(2*pi*nx(i)/(N-1)))+0.5*(1 - cos(2*pi*ny(j)/(N-1))));
end;end
%surface
%ujet_f = filter2(b,umean)./sum(b(:));
%full column
for k=1:size(umean,1)
  ujet_f(k,:,:) = filter2(b,squeeze(umean(k,:,:)))./sum(b(:));
end

break

m_proj('Gall-Peters','lon',[-110 250],'lat',[-90 90])
m_proj('Equidistant Cylindrical','lon',[-110 250],'lat',[-90 90])
m_pcolor(lon',lat',(umean-ujet_f).*100);shading flat;colorbar
caxis([-1.5 1.5])                                 
colormap(bluewhitered)
m_coast('patch',[.7 .7 .7]);
m_grid
set(gca,'Box','on')
set(gcf, 'units', 'centimeters', 'pos', [0 0 22.5 10])
set(gcf, 'PaperPositionMode','auto')
print -dpng -opengl -r300 1_4_degree_NorESM_jet
close

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear all

expid='NOIIA_T62_tn11_sr10m60d_01';
datesep='-';
grid_file='/work/shared/noresm/inputdata/ocn/micom/tnx1v1/20120120/grid.nc';
lon=ncgetvar(grid_file,'plon');
lat=ncgetvar(grid_file,'plat');
x=lon;
x=x(250:end,:);
x(x<0)=x(x<0)+360;
lon(250:end,:)=x;
months2days=[31  28  31  30  31   30   31  31   30 31   30 31];
yeardays=sum(months2days);

%grid_file='/home/fimm/bjerknes/milicak/Analysis/NorESM/climatology/Analysis/grid.nc';
fyear=100;
lyear=110;
prefix=['/work/milicak/archive/' expid '/ocn/hist/' expid '.micom.hm.'];

for year=fyear:lyear
  tmp=zeros(size(lon,2),size(lon,1));
  for month=1:12
    sdate=sprintf('%4.4d%c%2.2d',year,datesep,month);
    disp(sdate)
    tmp=tmp+nc_varget([prefix sdate '.nc'],'uvellvl',[0 0 0 0],[-1 1 -1 -1]).*months2days(month);
  end
  tmp=tmp./yeardays;
  u1(:,:,year-fyear+1)=tmp;
end
umean=squeeze(nanmean(u1,3));

%Hanning 2D filter
clear b
N=12;
nx=0:N-1;
ny=nx;
for i=1:N
for j=1:N
b(i,j) = 0.5*(0.5*(1 - cos(2*pi*nx(i)/(N-1)))+0.5*(1 - cos(2*pi*ny(j)/(N-1))));
end;end
ujet_f = filter2(b,umean)./sum(b(:));

m_proj('Gall-Peters','lon',[-110 250],'lat',[-90 90])
m_proj('Equidistant Cylindrical','lon',[-110 250],'lat',[-90 90])
m_pcolor(lon',lat',(umean-ujet_f).*100);shading flat;colorbar
caxis([-1.5 1.5])
colormap(bluewhitered)
m_coast('patch',[.7 .7 .7]);
m_grid
set(gca,'Box','on')
set(gcf, 'units', 'centimeters', 'pos', [0 0 22.5 10])
set(gcf, 'PaperPositionMode','auto')
print -dpng -opengl -r300 1_degree_NorESM_jet





