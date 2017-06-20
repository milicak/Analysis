clear all


%expnames = [{'CESM1-BGC'} {'CNRM-CM5'} {'HadGEM2-ES'} {'IPSL-CM5A-MR'} {'NorESM1-M'}];
%projectnames = [{'CESM1'} {'CNRM'} {'HadGEM2'} {'IPSL'} {'NorESM'}];

expnames = [{'CESM1-BGC'} {'CNRM-CM5'} {'HadGEM2-ES'} {'IPSL-CM5A-MR'} {'GFDL-ESM2G'} {'GFDL-ESM2M'} {'NorESM1-M'}];
projectnames = [{'CESM1'} {'CNRM'} {'HadGEM2'} {'IPSL'} {'GOLD'} {'MOM'} {'NorESM'}];

K2C = 273.15;
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
    dnmctrl = squeeze(nanmean(out.T1ctr));
    dnmrcp = squeeze(nanmean(out.T1rcp85));
    plot(out.T1rcp85-out.T1ctr,-out.zr,'color',[.4 .4 .4])
    %plot(dnmctrl,-out.zr,'g','linewidth',2)
    %plot(dnmrcp,-out.zr,'r','linewidth',2)
    ylim([-4e3 0])
    ylabel('Depth [m]')                                         
    xlabel('Temperature [ \circC]')                                                          
    if j==1
    %    xlim([-2 5])
    elseif j==3
    %    xlim([-2 7])
    else
    %    xlim([-2 4])
    end
    set(gca,'Box','on')                                                             
    grid on
    subplot(1,2,2)
    hold on
    dnmctrl = squeeze(nanmean(out.S1ctr));
    dnmrcp = squeeze(nanmean(out.S1rcp85));
    plot(out.S1rcp85-out.S1ctr,-out.zr,'color',[.4 .4 .4])
    %plot(dnmctrl,-out.zr,'g','linewidth',2)
    %plot(dnmrcp,-out.zr,'r','linewidth',2)
    ylim([-4e3 0])
    ylabel('Depth [m]')                                         
    xlabel('Salinity [psu]')                                                          
    if j==1
    %    xlim([32 35.5])
    elseif j==5
    %    xlim([33 35.5])
    else
    %    xlim([32 35.5])
    end
    set(gca,'Box','on')                                                             
    grid on
    %keyboard
end



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

