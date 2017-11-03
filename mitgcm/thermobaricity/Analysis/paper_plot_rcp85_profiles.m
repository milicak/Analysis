clear all


%expnames = [{'CESM1-BGC'} {'CNRM-CM5'} {'HadGEM2-ES'} {'IPSL-CM5A-MR'} {'NorESM1-M'}];
%projectnames = [{'CESM1'} {'CNRM'} {'HadGEM2'} {'IPSL'} {'NorESM'}];

expnames = [{'CESM1-BGC'} {'CNRM-CM5'} {'HadGEM2-ES'} {'IPSL-CM5A-MR'} {'GFDL-ESM2G'} {'GFDL-ESM2M'} {'NorESM1-M'}];
projectnames = [{'CESM1'} {'CNRM'} {'HadGEM2'} {'IPSL'} {'GOLD'} {'MOM'} {'NorESM'}];

K2C = 273.15;

out0T = load('matfiles/mitgcm_Exp01.0ini_temp_profiles.mat');
out1T = load('matfiles/mitgcm_Exp01.1ini_temp_profiles.mat');
out2T = load('matfiles/mitgcm_Exp01.2ini_temp_profiles.mat');
out3T = load('matfiles/mitgcm_Exp01.3ini_temp_profiles.mat');
out0S = load('matfiles/mitgcm_Exp01.0ini_salt_profiles.mat');
out1S = load('matfiles/mitgcm_Exp01.1ini_salt_profiles.mat');
out2S = load('matfiles/mitgcm_Exp01.2ini_salt_profiles.mat');
out3S = load('matfiles/mitgcm_Exp01.3ini_salt_profiles.mat');
for j=1:length(expnames)
    %fname = ['matfiles/' char(expnames(j)) '_Arctic_rcp85.mat'];
    fname = ['matfiles/' char(expnames(j)) '_Arctic_rcp85_Lence.mat'];
    out = load(fname);
    out.T1ctr = out.T1ctr - K2C;
    out.T1rcp85 = out.T1rcp85 - K2C;
    if j==1
        out.S1ctr = out.S1ctr*1000;
        out.S1rcp85 = out.S1rcp85*1000;
    end
    %figure
    subplot(1,2,1)
    hold on
    plot(out1T.Tini-out0T.Tini,out0T.zref,'b','linewidth',2,'DisplayName','Warm1')
    plot(out2T.Tini-out0T.Tini,out0T.zref,'c','linewidth',2,'DisplayName','Warm2')
    plot(out3T.Tini-out0T.Tini,out0T.zref,'r--','linewidth',2,'DisplayName','Warm3')
    dnmctrl = squeeze(nanmean(out.T1ctr));
    dnmrcp = squeeze(nanmean(out.T1rcp85));
    plot(out.T1rcp85-out.T1ctr,-out.zr,'color',[.7 .7 .7])
    %plot(dnmctrl,-out.zr,'g','linewidth',2)
    %plot(dnmrcp,-out.zr,'r','linewidth',2)
    ylim([-4e3 0])
    ylabel('Depth [m]')                                         
    xlabel('Temperature [ \circC]')                                                          
    xlim([-2 6])
    set(gca,'Box','on')                                                             
    grid on
    subplot(1,2,2)
    hold on
    plot(out1S.Sini-out0S.Sini,out0T.zref,'b','linewidth',2,'DisplayName','Warm1')
    plot(out2S.Sini-out0S.Sini,out0T.zref,'c','linewidth',2,'DisplayName','Warm2')
    plot(out3S.Sini-out0S.Sini,out0T.zref,'r-','linewidth',2,'DisplayName','Warm3')
    legend(gca,'show','Location','Southeast')
    dnmctrl = squeeze(nanmean(out.S1ctr));
    dnmrcp = squeeze(nanmean(out.S1rcp85));
    if j~=4
        plot(out.S1rcp85-out.S1ctr,-out.zr,'color',[.7 .7 .7])
    else
        plot(-(out.S1rcp85-out.S1ctr),-out.zr,'color',[.7 .7 .7])
    end
    plot(out1S.Sini-out0S.Sini,out0T.zref,'b','linewidth',2,'DisplayName','Warm1')
    plot(out2S.Sini-out0S.Sini,out0T.zref,'c','linewidth',2,'DisplayName','Warm2')
    plot(out3S.Sini-out0S.Sini,out0T.zref,'r','linewidth',2,'DisplayName','Warm3')
    %plot(dnmctrl,-out.zr,'g','linewidth',2)
    %plot(dnmrcp,-out.zr,'r','linewidth',2)
    ylim([-4e3 0])
    ylabel('Depth [m]')                                         
    xlabel('Salinity [psu]')                                                          
    xlim([-2 2])
    set(gca,'Box','on')                                                             
    grid on
    %keyboard
end
printname = ['paperfigs/temp_salt_rcp85_mitgcm_profiles.eps']
print(1,'-depsc2',printname)
close



break
legend(gca,'show','Location','Southeast')
for j=1:length(expnames)
    %fname = ['matfiles/' char(expnames(j)) '_Arctic_rcp85.mat'];
    fname = ['matfiles/' char(expnames(j)) '_Arctic_rcp85_Lence.mat'];
    out = load(fname);
    out.T1ctr = out.T1ctr - K2C;
    out.T1rcp85 = out.T1rcp85 - K2C;
    if j==1
        out.S1ctr = out.S1ctr*1000;
        out.S1rcp85 = out.S1rcp85*1000;
    end
    figure
    subplot(1,2,1)
    hold on
    dnmctrl = squeeze(nanmean(out.T1ctr));
    dnmrcp = squeeze(nanmean(out.T1rcp85));
    plot(out.T1ctr,-out.zr,'color',[.4 .4 .4])
    plot(out.T1rcp85,-out.zr,'color',[.7 .7 .7])
    plot(dnmctrl,-out.zr,'g','linewidth',2)
    plot(dnmrcp,-out.zr,'r','linewidth',2)
    ylim([-4e3 0])
    ylabel('Depth [m]')                                         
    xlabel('Temperature [ \circC]')                                                          
    if j==1
        xlim([-2 5])
    elseif j==3
        xlim([-2 7])
    else
        xlim([-2 4])
    end
    set(gca,'Box','on')                                                             
    grid on
    subplot(1,2,2)
    hold on
    dnmctrl = squeeze(nanmean(out.S1ctr));
    dnmrcp = squeeze(nanmean(out.S1rcp85));
    plot(out.S1ctr,-out.zr,'color',[.4 .4 .4])
    plot(out.S1rcp85,-out.zr,'color',[.7 .7 .7])
    plot(dnmctrl,-out.zr,'g','linewidth',2)
    plot(dnmrcp,-out.zr,'r','linewidth',2)
    ylim([-4e3 0])
    ylabel('Depth [m]')                                         
    xlabel('Salinity [psu]')                                                          
    if j==1
        xlim([32 35.5])
    elseif j==5
        xlim([33 35.5])
    else
        xlim([32 35.5])
    end
    set(gca,'Box','on')                                                             
    grid on
    %keyboard
end
break
legend(gca,'show','Location','Southeast')

