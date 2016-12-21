clear all
%close all

%root_name=['/mnt/hexwork/RUNS/mitgcm/shear_flow/'];
root_name=['/hexagon/work/milicak/RUNS/mitgcm/shear_flow/'];

project_name=['Exp01.1']

%foldername=['/net/m1i/models/MITgcm/Projects/dambreaking/run/'];
%foldername=['/net/m1i/models/MITgcm/Projects/overflow_slope/run/'];
foldername=[root_name project_name '/']

variable_name=['T']; %T for temp; S for salt

hmax=0.2; %meter

section=64; %97;  %section 

dumpfreq=0.5; %from data in the run folder
deltat=0.001; %from data in the run folder
timeend=1945000;

depth=rdmds([foldername 'Depth']);
xc=rdmds([foldername 'XC']);
drc=rdmds([foldername 'DRC']);
H=-depth(:,section);
x=squeeze(xc(:,1));
Z=cumsum(sq(drc));

timeind=1

time=0;
itr=time;
hhh=figure('Visible','off');
variable=rdmds([foldername variable_name],itr);
variable(variable==0)=NaN;
max_temp=max(variable(:));
min_temp=min(variable(:));
variable=(variable-min_temp)./(max_temp-min_temp);
%variable=1-(variable-min_temp)./(max_temp-min_temp);
pcolor(x./hmax,Z./hmax,squeeze(variable(:,section,:))');shading interp;colorbar
caxis([0 1])
needJet2
xlabel('x'); ylabel('z');
no=num2str(timeind,'%.4d');
printname=['gifs/vertical_section' no];
print(hhh,'-dpng','-zbuffer',printname)
close all
timeind=timeind+1

for time=0:dumpfreq/deltat:timeend
itr=time;
hhh=figure('Visible','off');
variable=rdmds([foldername variable_name],itr);
variable(variable==0)=NaN;
variable=(variable-min_temp)./(max_temp-min_temp);
%variable=1-(variable-min_temp)./(max_temp-min_temp);
dnm(1:256,:,:)=variable(257:512,:,:);
dnm(257:512,:,:)=variable(1:256,:,:);
pcolor(x./hmax,Z./hmax,squeeze(dnm(:,section,:))');shading interp;colorbar
%pcolor(x./hmax,Z./hmax,squeeze(variable(:,section,:))');shading interp;colorbar
caxis([0 1])
needJet2
%needredblue
%set(gca,'PlotBoxAspectRatio',[4 1 1])
Time=time*deltat/86400;
xlabel('x'); ylabel('z');
%title(['Time = ' num2str(Time) ' days']);
no=num2str(timeind,'%.4d');
printname=['gifs/vertical_section' no];
print(hhh,'-dpng','-zbuffer',printname)
close all
timeind=timeind+1
end
