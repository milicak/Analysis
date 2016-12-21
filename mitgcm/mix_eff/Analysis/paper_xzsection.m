clear all
%close all

%root_name=['/work/m1i/RUNS/mitgcm/internal_waves/'];
root_name=['/hexagon/work/milicak/RUNS/mitgcm/mix_eff/'];

project_name=['Exp01.5'];

foldername=[root_name project_name '/']

variable_name=['T']; %T for temp; S for salt

H=-0.2;

itr=17600; % 108000 for Exp1.0 ; 24000 for Exp1.1 ; 12000 for Exp1.2 ; 4500 for Exp1.3 ; 3000 for Exp2.0 ; 3000 for Exp2.1 ; 7500 for Exp2.2 ; 17600 for Exp1.5 ; 14000 for Exp1.7

%depth=rdmds([foldername 'Depth']);
xc=rdmds([foldername 'XC']);
drc=rdmds([foldername 'DRC']);
%hFacC=rdmds([foldername 'hFacC']);
variable=rdmds([foldername variable_name],itr);
variable(variable==0)=NaN;
x=squeeze(xc(:,1));
Z=cumsum(sq(drc));
clear xc

section=size(variable,2)*0.5;  %section 
%variable=(variable-min(variable(:)))./(max(variable(:))-min(variable(:)));
variable1=rdmds([foldername variable_name],0);
variable1(variable1==0)=NaN;
min_var=min(variable1(:));
max_var=max(variable1(:));
variable=(variable-min_var)./(max_var-min_var);

hhh=figure('Visible','off');

pcolor(x./abs(H),-Z./H,squeeze(variable(:,section,:))');shading interp;colorbar

xlim([min(x)/abs(H) max(x)/abs(H)])
set(gca,'PlotBoxAspectRatio',[4 1 1])
ylabel('z')
xlabel('x')
caxis([0 1])

%break

printname=['paperfigs/mitgcm_xzsection_mix_eff_' [project_name] '.eps']
print(hhh,'-depsc2','-zbuffer','-r150',printname);
%print(hhh,'-depsc2','-zbuffer',printname);
