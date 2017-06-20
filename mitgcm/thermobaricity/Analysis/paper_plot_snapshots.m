clear all
%close all

root_name=['/export/grunchfs/unibjerknes/milicak/bckup/mitgcm/thermobaricity/'];
project_name=['Exp01.0']
%project_name=['Exp01.1']
%project_name=['Exp01.2']
%project_name=['Exp01.3']
itrnames = [{'31680'} {'52560'} {'288000'} {'86400'}]; % for Exp01.0 ; Exp01.1 ; Exp01.2 ; Exp01.3
timeind=[31680];
%timeind=[52560];
%timeind=[288000];
%timeind=[86400];

foldername=[root_name project_name '/']

variable_name=['T']; %T for temp; S for salt

depth=rdmds([foldername 'Depth']);
xc=rdmds([foldername 'XC']);
yc=rdmds([foldername 'YC']);
drc=rdmds([foldername 'DRC']);
x=squeeze(xc(:,1));
y=squeeze(yc(1,:));
Z=cumsum(sq(drc));

itr=timeind;
variable=rdmds([foldername variable_name],itr);
variable(variable==0)=NaN;



figure(1)
pcolor(x,-Z(1:end-1),squeeze(variable(:,1,:))');shading interp;colorbar
needJet2
caxis([-2 1.5])
set(gca,'PlotBoxAspectRatio',[1 1 1])
xlabel('x [m]'); ylabel('Depth [m]');
no=num2str(timeind,'%.4d');
if(length(project_name)==7)
  printname=['paperfigs/verticalxz_section' project_name(1:5) '_' project_name(7) '_' no];
else
  printname=['paperfigs/verticalxz_section' project_name(1:5) '_' project_name(7:8) '_' no];
end
print(1,'-depsc2','-r300',printname)
close

