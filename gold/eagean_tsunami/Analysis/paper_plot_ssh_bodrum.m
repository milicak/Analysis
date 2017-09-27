clear all

load('bodrum_tide');
timeini = datenum(2017,07,20,22,30,0); %20 th July 2017 22.30 pm
indstr=max(find(time<=timeini));
indend=indstr+120*3; % 3 hours the data is every 30 secs

figure
%plot(5*(ssh(indstr:indend)-mean(ssh)),'linewidth',2)
%plot(time(indstr:indend)-time(indstr),ssh(indstr:indend)-mean(ssh),'linewidth',2)

root_folder = '/hexagon/work/milicak/RUNS/gold/eagean_tsunami/';

project = 'Exp01.2'

grdname = [root_folder project '/OUT/ocean_geometry.nc'];
lon = ncread(grdname,'geolon');
lat = ncread(grdname,'geolat');
filename = [root_folder project '/prog.nc'];
%zeta = ncread(filename,'e');
% for Exp1.1 and Exp1.2
zeta = ncread(filename,'e',[840 1008 1 1],[2 2 1 Inf]);
% for Exp1.3 and Exp1.4
%zeta = ncread(filename,'e',[1617 1193 1 1],[2 2 1 Inf]);
hold on
ii = 8;
plot(ii:length(squeeze(zeta(1,1,1,:)))+ii-1,squeeze(zeta(1,1,1,:)),'r','linewidth',2)
%plot(squeeze(zeta(1,2,1,:)),'k','linewidth',2)
%plot(squeeze(zeta(2,1,1,:)),'g','linewidth',2)
%plot(squeeze(zeta(2,2,1,:)),'m','linewidth',2)
