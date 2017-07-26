clear all

project_name = [{'om3_core3_2'} {'om3_core3_2_BG_neg'} {'om3_core3_2_BG_pos'}]; 
project_name2 = [{'ctrl'} {'BG_neg'} {'BG_pos'}];

%project_name = [{'om3_core3_2'} {'om3_core3_2_BG_neg'} {'om3_core3_2_BG_pos'} {'om3_core3_2_GS_neg'} {'om3_core3_2_GS_pos'}];
%project_name2 = [{'ctrl'} {'BG_neg'} {'BG_pos'} {'GS_neg'} {'GS_pos'}];

time = 1980:2009;
indstr = 1980-1948+1;
ice_volume_ann = containers.Map;
ice_volume_sep = containers.Map;
ice_volume_mar = containers.Map;

for i = 1:length(project_name)
    fname = ['matfiles/' project_name{i} '_ice_volume.mat'];
    load(fname);
    vice = vice(:,indstr:end);
    ice_volume_ann(project_name2{i}) = nanmean(vice,1);
    ice_volume_mar(project_name2{i}) = vice(3,:);
    ice_volume_sep(project_name2{i}) = vice(9,:);
end
save('matfiles/ITU-MOM_volume_time_series.mat','ice_volume_ann','ice_volume_mar','ice_volume_sep','time');

% to plot the BG_POS vs BG_neg
figure(1)
plot(time,(ice_volume_ann('BG_pos')-ice_volume_ann('ctrl'))*1e-12,'b-','linewidth',2 ... 
     ,'DisplayName','BG-pos')
hold on
plot(time,(ice_volume_ann('BG_neg')-ice_volume_ann('ctrl'))*1e-12,'r-','linewidth',2 ...
     ,'DisplayName','BG-neg')
legend(gca,'show','Location','SouthEast')      
title('Annual mean Arctic sea ice volume anomaly')
grid
ylim([-1 1])
xlabel('Years')
ylabel('Sea ice volume anomaly (x 1000 km^3)')
printname = ['paperfigs/seaice_volume_annual_anomaly.eps'];
print(1,'-depsc2','-r300',printname)

% March
figure
plot(time,(ice_volume_mar('BG_pos')-ice_volume_mar('ctrl'))*1e-12,'b-','linewidth',2 ... 
     ,'DisplayName','BG-pos')
hold on
plot(time,(ice_volume_mar('BG_neg')-ice_volume_mar('ctrl'))*1e-12,'r-','linewidth',2 ...
     ,'DisplayName','BG-neg')
legend(gca,'show','Location','SouthEast')      
title('March Arctic sea ice volume anomaly')
grid
ylim([-1 1])
xlabel('Years')
ylabel('Sea ice volume anomaly (x 1000 km^3)')
printname = ['paperfigs/seaice_volume_march_anomaly.eps'];
print(1,'-depsc2','-r300',printname)

% September
figure
plot(time,(ice_volume_sep('BG_pos')-ice_volume_sep('ctrl'))*1e-12,'b-','linewidth',2 ... 
     ,'DisplayName','BG-pos')
hold on
plot(time,(ice_volume_sep('BG_neg')-ice_volume_sep('ctrl'))*1e-12,'r-','linewidth',2 ...
     ,'DisplayName','BG-neg')
legend(gca,'show','Location','SouthEast')      
title('September mean Arctic sea ice volume anomaly')
grid
ylim([-1 1])
xlabel('Years')
ylabel('Sea ice volume anomaly (x 1000 km^3)')
printname = ['paperfigs/seaice_volume_september_anomaly.eps'];
print(1,'-depsc2','-r300',printname)

break

