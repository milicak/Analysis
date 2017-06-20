% initial and final profiles of zonal mean temp and salt
clear all

load color_15
% swap black with cyan for the first one
color(1,:)=[0 0 0];
color(3,:)=[0 1 1];
color(4,:)=[1 0 0];


root_folder = '/export/grunchfs/unibjerknes/milicak/bckup/mitgcm/thermobaricity/';

expnames = [{'Exp01.0'} {'Exp01.1'} {'Exp01.2'} {'Exp01.3'}];
regionnames = [{'Obs'} {'Warm1'} {'Warm2'} {'Warm3'}];

%expnames = [{'Exp01.0'} {'Exp01.1'} {'Exp01.2'}];
%regionnames = [{'Obs'} {'Warm1'} {'Warm2, Warm3'}];

zref = -(1:1:3000);
for j=1:length(expnames)
    fname = [root_folder char(expnames(j)) '/'];
    Tini = rdmds([fname 'T'],0);
    Tini = squeeze(nanmean(Tini,1));
    %figure(1)
    subplot(1,2,1)
    hold on
    if (j==4)
        plot(Tini,zref','--','color',[color(j,1) color(j,2) color(j,3)] ...
        ,'linewidth',2,'DisplayName',char(regionnames(j)));
    else
        plot(Tini,zref','color',[color(j,1) color(j,2) color(j,3)] ...
        ,'linewidth',2,'DisplayName',char(regionnames(j)));
    end
    %keyboard
end
legend(gca,'show','Location','Southeast')
ylabel('Depth [m]')                                         
xlabel('Temperature [ \circC]')                                                          
xlim([-2 3])
set(gca,'Box','on')                                                             
grid on
for j=1:length(expnames)
    fname = [root_folder char(expnames(j)) '/'];
    Sini = rdmds([fname 'S'],0);
    Sini = squeeze(nanmean(Sini,1));
    %figure(2)
    subplot(1,2,2)
    hold on
    plot(Sini,zref','color',[color(j,1) color(j,2) color(j,3)] ...
        ,'linewidth',2,'DisplayName',char(regionnames(j)));
    %keyboard
end
legend(gca,'show','Location','Southeast')
ylabel('Depth [m]')                                         
xlabel('Salinity [psu]')                                                          
xlim([34.2 35.7])
set(gca,'Box','on')                                                             
grid on
printname = ['paperfigs/mitgcm_initial_profiles.eps']
print(1,'-depsc2',printname)
close

itrnames = [{'31680'} {'52560'} {'288000'} {'86400'}];
for j=1:length(expnames)
    fname = [root_folder char(expnames(j)) '/'];
    Tfinal = rdmds([fname 'T'],str2num(char(itrnames(j))));
    Tfinal = squeeze(nanmean(Tfinal,1));
    %figure(1)
    subplot(1,2,1)
    hold on
    if (j==4)
        plot(Tfinal,zref','-','color',[color(j,1) color(j,2) color(j,3)] ...
        ,'linewidth',2,'DisplayName',char(regionnames(j)));
    else
        plot(Tfinal,zref','color',[color(j,1) color(j,2) color(j,3)] ...
        ,'linewidth',2,'DisplayName',char(regionnames(j)));
    end
end
legend(gca,'show','Location','Southeast')
ylabel('Depth [m]')                                         
xlabel('Temperature [ \circC]')                                                          
xlim([-2 3])
set(gca,'Box','on')                                                             
grid on
for j=1:length(expnames)
    fname = [root_folder char(expnames(j)) '/'];
    Sfinal = rdmds([fname 'S'],str2num(char(itrnames(j))));
    Sfinal = squeeze(nanmean(Sfinal,1));
    %figure(2)
    subplot(1,2,2)
    hold on
    plot(Sfinal,zref','color',[color(j,1) color(j,2) color(j,3)] ...
        ,'linewidth',2,'DisplayName',char(regionnames(j)));
    %keyboard
end
legend(gca,'show','Location','Southeast')
ylabel('Depth [m]')                                         
xlabel('Salinity [psu]')                                                          
xlim([34.2 35.7])
set(gca,'Box','on')                                                             
grid on
printname = ['paperfigs/mitgcm_final_profiles.eps']
print(1,'-depsc2',printname)
close

