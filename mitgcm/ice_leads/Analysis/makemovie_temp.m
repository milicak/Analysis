clear all
%close all

%root_name=['/bcmhsm/milicak/RUNS/mitgcm/ice_leads/'];
root_name=['/export/grunchfs/unibjerknes/milicak/bckup/mitgcm/ice_leads/'];
root_name=['/work-common/shared/bjerknes/milicak/mnt/viljework/RUNS/mitgcm/ice_leads/']
project_name=['Exp01.9']

%foldername=['/net/m1i/models/MITgcm/Projects/dambreaking/run/'];
%foldername=['/net/m1i/models/MITgcm/Projects/overflow_slope/run/'];
foldername=[root_name project_name '/']

variable_name=['S']; %T for temp; S for salt


variable=rdmds([foldername variable_name],0);

section=size(variable,2)/2;  %middle section

dumpfreq=1800; %from data in the run folder
deltat=2.0; %2.0; %from data in the run folder
timeend=80*dumpfreq/deltat;

depth=rdmds([foldername 'Depth']);
xc=rdmds([foldername 'XC']);
yc=rdmds([foldername 'YC']);
drc=rdmds([foldername 'DRC']);
H=-depth(:,section);
x=squeeze(xc(:,1));
y=squeeze(yc(1,:));
Z=cumsum(sq(drc));

timeind=1

timevec=[0:dumpfreq/deltat:timeend];

for time=timevec
itr=time;
hhh=figure('Visible','off');
variable=rdmds([foldername variable_name],itr);
variable(variable==0)=NaN;
%variable=(variable-min_temp)./(max_temp-min_temp);
%variable=1-(variable-min_temp)./(max_temp-min_temp);

%pcolor(x,-Z,squeeze(variable(:,section,:))');shading interp;colorbar
pcolor(y,-Z,squeeze(variable(section,:,:))');shading interp;colorbar
needJet2
caxis([32 32.02])
%ylim([-10 0])
%needredblue
%set(gca,'PlotBoxAspectRatio',[4 1 1])
Time=time*deltat/86400;
xlabel('x'); ylabel('z');
%xlabel('y'); ylabel('z');

%title(['Time = ' num2str(Time) ' days']);
no=num2str(timeind,'%.4d');
printname=['gifs/vertical_section' no];
print(hhh,'-dpng','-r150',printname)
close all
timeind=timeind+1
end
