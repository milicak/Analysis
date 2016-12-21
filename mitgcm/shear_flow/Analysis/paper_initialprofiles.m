clear all
%close all

%root_name=['/work/m1i/RUNS/mitgcm/internal_waves/'];
%root_name=['/vftmp/Mehmet.Ilicak/RUNS/mitgcm/mix_eff/'];
root_name=['/work/milicak/RUNS/mitgcm/shear_flow/hexagon/work/milicak/RUNS/mitgcm/shear_flow/'];

project_name=['Exp01.1'];

foldername=[root_name project_name '/']

variable_name=['T']; %T for temp; S for salt
variable_name2=['U']; %T for temp; S for salt

H=-0.2;

itr=0; % 108000 for Exp1.0 ; 24000 for Exp1.1 ; 12000 for Exp1.2 ; 4500 for Exp1.3

depth=rdmds([foldername 'Depth']);
xc=rdmds([foldername 'XC']);
drc=rdmds([foldername 'DRC']);
hFacC=rdmds([foldername 'hFacC']);
variable=rdmds([foldername variable_name],itr);
variable(variable==0)=NaN;
variable2=rdmds([foldername variable_name2],itr);
variable2(isnan(variable)==1)=NaN;
x=squeeze(xc(:,1));
Z=cumsum(sq(drc));


section=size(variable,2)*0.5;  %section 
variable=(variable-min(variable(:)))./(max(variable(:))-min(variable(:)));
variable2=-0.5+(variable2-min(variable2(:)))./(max(variable2(:))-min(variable2(:)));

hl1=line(squeeze(variable(end/2,end/2,:)),-Z./H,'color','k','linewidth',2)
xlim([-0.1 1.1])
xlabel('\rho')
ylabel('z')

ax(1)=gca;
set(ax(1),'Position',[0.12 0.12 0.75 0.70])
set(ax(1),'XColor','k','YColor','k');

ax(2)=axes('Position',get(ax(1),'Position'),...
   'XAxisLocation','top',...
   'YAxisLocation','right',...
   'Color','none',...
   'XColor','r','YColor','k');
set(ax,'box','off')

hl2=line(squeeze(variable2(end/2,end/2,:)),-Z./H,'Color','r','linewidth',2,'Parent',ax(2));
xlim([-0.6 0.6])
xlabel('U')
ylabel('z')

printname=['paperfigs/mitgcm_xzsection_mix_eff_' [project_name] '_initialprofile.eps']
%printname=['paperfigs/mitgcm_xzsection_mix_eff_' [project_name] '.eps']
print(1,'-depsc2','-zbuffer',printname);%close(1)
%print(1,'-depsc2',printname);%close(1)

