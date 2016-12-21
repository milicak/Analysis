clear all


folder_name='/hexagon/work/users/milicak/RUNS/gold/neptune/';

project_name='Exp01.0'

filename=[folder_name project_name '/prog_1.nc'];

pv=ncgetvar(filename,'PV');
h=ncgetvar(filename,'h');
% if h is less than 1cm set pv=0;
pv(h<0.01)=0;
pvsum=squeeze(nansum(pv,3))./1e-4;
for time=1:size(pvsum,3)
hhh=figure('Visible','off');
no=num2str(time,'%.4d');
pcolor(squeeze(pvsum(:,:,time))');shading interp;needJet2
printname=['gifs/total_pv' no];
print(hhh,'-dpng','-zbuffer',printname)
time
end
timeend=time+1;

filename=[folder_name project_name '/prog_2.nc'];
pv=ncgetvar(filename,'PV');
h=ncgetvar(filename,'h');
% if h is less than 1cm set pv=0;
pv(h<0.01)=0;
pvsum=squeeze(nansum(pv,3))./1e-4;
kk=1;
for time=timeend:timeend+size(pvsum,3)
hhh=figure('Visible','off');
no=num2str(time,'%.4d');
pcolor(squeeze(pvsum(:,:,kk))');shading interp;needJet2
printname=['gifs/total_pv' no];
print(hhh,'-dpng','-zbuffer',printname)
time
kk+1;
end

timeend=time+1;
filename=[folder_name project_name '/prog_3.nc'];
pv=ncgetvar(filename,'PV');
h=ncgetvar(filename,'h');
% if h is less than 1cm set pv=0;
pv(h<0.01)=0;
pvsum=squeeze(nansum(pv,3))./1e-4;
kk=1;
for time=timeend:timeend+size(pvsum,3)
hhh=figure('Visible','off');
no=num2str(time,'%.4d');
pcolor(squeeze(pvsum(:,:,kk))');shading interp;needJet2
printname=['gifs/total_pv' no];
print(hhh,'-dpng','-zbuffer',printname)
time
kk=kk+1;
end


