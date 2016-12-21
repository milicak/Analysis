clear all


% eurasia basin
[x]=load('eurasia_basin_lon.txt');
[y]=load('eurasia_basin_lat.txt');

in=insphpoly(lon,lat,x,y,0,90);
in=double(in);
in(in==0)=NaN;
in=repmat(in,[1 1 70]);


