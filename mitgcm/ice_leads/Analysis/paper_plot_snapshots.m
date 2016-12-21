clear all
%close all

%root_name=['/bcmhsm/milicak/RUNS/mitgcm/ice_leads/'];
root_name=['/export/grunchfs/unibjerknes/milicak/bckup/mitgcm/ice_leads/'];
%root_name=['/work-common/shared/bjerknes/milicak/mnt/viljework/RUNS/mitgcm/ice_leads/']
project_name=['Exp01.11']

foldername=[root_name project_name '/']

variable_name=['S']; %T for temp; S for salt

depth=rdmds([foldername 'Depth']);
xc=rdmds([foldername 'XC']);
yc=rdmds([foldername 'YC']);
drc=rdmds([foldername 'DRC']);
x=squeeze(xc(:,1));
y=squeeze(yc(1,:));
Z=cumsum(sq(drc));

timeind=[900*14];
itr=timeind;
section=size(xc,2)/2;  %middle section
variable=rdmds([foldername variable_name],itr);
variable(variable==0)=NaN;



figure(1)
pcolor(x,-Z,squeeze(variable(:,section,:))');shading interp;colorbar
needJet2
caxis([32 32.02])
set(gca,'PlotBoxAspectRatio',[1 1 1])
xlabel('x'); ylabel('z');
no=num2str(timeind,'%.4d');
if(length(project_name)==7)
  printname=['paperfigs/verticalxz_section' project_name(1:5) '_' project_name(7) '_' no];
else
  printname=['paperfigs/verticalxz_section' project_name(1:5) '_' project_name(7:8) '_' no];
end
print(1,'-depsc2','-r300',printname)

figure(2)
pcolor(y,-Z,squeeze(variable(section,:,:))');shading interp;colorbar
needJet2
caxis([32 32.02])
set(gca,'PlotBoxAspectRatio',[1 1 1])
xlabel('y'); ylabel('z');
no=num2str(timeind,'%.4d');
if(length(project_name)==7)
  printname=['paperfigs/verticalyz_section' project_name(1:5) '_' project_name(7) '_' no];
else
  printname=['paperfigs/verticalyz_section' project_name(1:5) '_' project_name(7:8) '_' no];
end
print(2,'-depsc2','-r300',printname)
