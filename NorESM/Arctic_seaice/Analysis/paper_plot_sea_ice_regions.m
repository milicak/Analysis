clear all

load color_15
% swap black with cyan for the first one
color(1,:)=[0 0 0];
color(7,:)=[0 1 1];

out1 = load('matfiles/seaice_obs_Had_ISST_ice_extentions.mat');
out2 = load('matfiles/NorESM_ice_extentions.mat');
out3 = load('matfiles/ncar-pop_ice_extentions.mat');
out4 = load('matfiles/gfdl-gold_ice_extentions.mat');
out5 = load('matfiles/gfdl-mom_ice_extentions.mat');
out6 = load('matfiles/nemo-cerfacs_ice_extentions.mat');
out7 = load('matfiles/nemo-cnrm_ice_extentions.mat');

expnames = [ {'seaice_obs_Had_ISST'} {'NorESM'} {'ncar-pop'} {'gfdl-gold'} {'gfdl-mom'} ...
             {'nemo-cerfacs'} {'nemo-cnrm'}];

legendnames = [ {'HadISST'} {'Bergen'} {'NCAR'} {'GFDL-GOLD'} {'GFDL-MOM'} ...
             {'CERFACS'} {'CNRM'}];


regionnames = [{'KaraBarents'} {'Greenland'} {'Hudson'} {'CAA'} {'Canadian'} ...
{'Labrador'} {'Eurasian'} {'Bering'} {'Chukchi'} {'EastSiber'} {'Canadanew'} {'Arctic'}];

%regionnames = [{'KaraBarents'} {'Chukchi'} {'EastSiber'} {'Canadanew'} {'Arctic'}];
regionnames = [{'KaraBarents'} {'Chukchi'} {'EastSiber'} {'Canadanew'} {'Canadian'} {'Arctic'}];

time = 1979:1:2007;
scale = 1e-12; %10^6 km^2
ice_ext_regions_mean = containers.Map;

for j=1:length(expnames)
    figure(j)
    %title(char(regionnames(j)))
    out = load(['matfiles/' char(expnames(j)) '_ice_extentions.mat']);
    hold on
    for i=1:length(regionnames)
        tmp = out.ice_ext_regions(char(regionnames(i)));
        tmp(isnan(tmp)) = 0;
        tmp = reshape(tmp,[12 29]);
        tmp = nanmean(tmp,1);
        fname = [char(expnames(j)) '_' char(regionnames(i))];
        ice_ext_regions_mean(fname) = mean(tmp);
        aa(i) = (tmp(end)-mean(tmp));
        plot(time,(tmp-mean(tmp))*scale,'color',[color(i,1) color(i,2) color(i,3)] ...
            ,'linewidth',2,'DisplayName',char(regionnames(i)));
    end
    legend(gca,'show','Location','EastOutside')
    ylabel('Annual ice extent [10^6 km^2]')                                         
    xlabel('time [years]')                                                          
    xlim([1979 2007])
    set(gca,'Box','on')                                                             
    grid on
    break
    %set(gcf, 'units', 'centimeters', 'pos', [0 0 22.5 10])                          
    %set(gca, 'units', 'centimeters', 'pos', [2 1.2 15 8])                           
    %set(gcf, 'PaperPositionMode','auto') 
    out = load(['matfiles/' char(expnames(1)) '_ice_extentions.mat']);
    tmp = out.ice_ext_regions(char(regionnames(i)));
    tmp(isnan(tmp)) = 0;
    tmp = reshape(tmp,[12 29]);
    tmp = nanmean(tmp,1);
    plot(time,(tmp)*scale*0,'color','r' ...
        ,'linewidth',2,'DisplayName',char(legendnames(j)));
    printname = ['paperfigs/' char(expnames(j)) '_seaice_regions.eps']
    print(i,'-depsc2',printname)
    %close
    %keyboard
end

