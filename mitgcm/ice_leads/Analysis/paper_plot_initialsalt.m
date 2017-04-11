clear all

root_folder='matfiles/';

project_name1=[{'Exp01.3'} {'Exp01.7'} {'Exp01.8'}];

project_name=[{'Exp01.3'} {'Exp01.10'} {'Exp01.4'} ...
              {'Exp01.5'} {'Exp01.9'} {'Exp01.11'}];

legends=[{'Ctrl'} {'No-noise'} {'2W0'} {'2L'} {'4L'} {'6L'}];
legends1=[{'Ctrl'} {'hmxl/2'} {'linear'}];

load('~/Analysis/NorESM/CORE2/Arctic/Analysis/m_files/color_15.mat')

colors =[{'b'} {'r'} {'k'}];

for i=1:3
   filename=[root_folder char(project_name1(i)) '_mean_salt.mat'];
   load(filename)
   hold on
   plot(meansalt(1,:),-(0:128/511:128),'color', char(colors(i)) ,'linestyle','-','linewidth',2)
   %plot(meansalt(1,:),-(0:128/511:128),'color',[color(i,1) color(i,2) color(i,3)],'linestyle','-','linewidth',2)
end
ylabel('Depth [m]')
xlabel('Salt [psu]')
legend(char(legends1),'location','southwest')
printname='paperfigs/initial_salt.eps'
print(1,'-depsc2','-r300',printname);
