clear all
%close all

%root_name=['/work/m1i/RUNS/mitgcm/internal_waves/'];
%root_name=['/vftmp/Mehmet.Ilicak/RUNS/mitgcm/mix_eff/'];
root_name=['/work/milicak/RUNS/mitgcm/shear_flow/hexagon/work/milicak/RUNS/mitgcm/shear_flow/'];

project_name=['Exp01.5'];

foldername=[root_name project_name '/']

variable_name=['T']; %T for temp; S for salt

H=-0.2;

itr=39000; % 108000 for Exp1.0 ; 24000 for Exp1.1 ; 12000 for Exp1.2 ; 4500 for Exp1.3

depth=rdmds([foldername 'Depth']);
xc=rdmds([foldername 'XC']);
drc=rdmds([foldername 'DRC']);
hFacC=rdmds([foldername 'hFacC']);
variable=rdmds([foldername variable_name],itr);
variable(variable==0)=NaN;
x=squeeze(xc(:,1));
Z=cumsum(sq(drc));


section=size(variable,2)*0.5;  %section 
variable=(variable-min(variable(:)))./(max(variable(:))-min(variable(:)));

dnm=squeeze(variable(:,section,:));
tmp(512,512)=0;
tmp(1:end/2,:)=dnm(end/2+1:end,:);
tmp(end/2+1:end,:)=dnm(1:end/2,:);

pcolor(x./abs(H),-Z./H,tmp');shading interp;colorbar

needJet2
xlim([min(x)/abs(H) max(x)/abs(H)])
set(gca,'PlotBoxAspectRatio',[1 1 1])
ylabel('z')
xlabel('x')
caxis([0 1])

%break

printname=['paperfigs/mitgcm_xzsection_mix_eff_' [project_name] '_initial.eps']
%printname=['paperfigs/mitgcm_xzsection_mix_eff_' [project_name] '.eps']
print(1,'-depsc2','-zbuffer',printname);%close(1)
%print(1,'-depsc2',printname);%close(1)

