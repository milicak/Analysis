clear all

load('bodrum_tide');
timeini = datenum(2017,07,20,22,30,0); %20 th July 2017 22.30 pm
indstr=max(find(time<=timeini));
indend=indstr+120*3; % 3 hours the data is every 30 secs

%plot(5*(ssh(indstr:indend)-mean(ssh)),'linewidth',2)
%plot(time(indstr:indend)-time(indstr),ssh(indstr:indend)-mean(ssh),'linewidth',2)

root_folder = '/hexagon/work/milicak/RUNS/gold/eagean_tsunami/';

project1 = 'Exp01.3'
project2 = 'Exp01.4'

grdname = [root_folder project1 '/OUT/ocean_geometry.nc'];
lon = ncread(grdname,'lonh');
lat = ncread(grdname,'lath');
mask = ncread(grdname,'wet');
filename1 = [root_folder project1 '/prog.nc'];
filename2 = [root_folder project2 '/prog.nc'];
% Bodrum Tide Gauge
lon1 = 27.423260; %27.419792;
lat1 = 37.02866;
i1 = max(find(lon<=lon1));
j1 = max(find(lat<=lat1));
zeta1 = squeeze(ncread(filename1,'e',[i1 j1 1 1],[1 1 1 Inf]));
zeta2 = squeeze(ncread(filename2,'e',[i1 j1 1 1],[1 1 1 Inf]));
figure
plot(squeeze(zeta1),'k','linewidth',2)
hold on
plot(squeeze(zeta2),'r','linewidth',2)

lon1 = 27.3093795; %27.419792;
lat1 = 37.9697799;
i1 = max(find(lon<=lon1));
j1 = max(find(lat<=lat1));
zeta1 = squeeze(ncread(filename1,'e',[i1 j1 1 1],[1 1 1 Inf]));
zeta2 = squeeze(ncread(filename2,'e',[i1 j1 1 1],[1 1 1 Inf]));
figure
plot(squeeze(zeta1),'k','linewidth',2)
hold on
plot(squeeze(zeta2),'r','linewidth',2)
