clear all

project_name = [{'om3_core3_2'} {'om3_core3_2_BG_neg'} {'om3_core3_2_BG_pos'}]; 
project_name2 = [{'ctrl'} {'BG_neg'} {'BG_pos'}];

%project_name = [{'om3_core3_2'} {'om3_core3_2_BG_neg'} {'om3_core3_2_BG_pos'} {'om3_core3_2_GS_neg'} {'om3_core3_2_GS_pos'}];
%project_name2 = [{'ctrl'} {'BG_neg'} {'BG_pos'} {'GS_neg'} {'GS_pos'}];

time = 1980:2009;
indstr = 1980-1948+1;
ice_area_ann = containers.Map;
ice_area_sep = containers.Map;
ice_area_mar = containers.Map;

for i = 1:length(project_name)
    fname = ['matfiles/' project_name{i} '_ice_extend.mat'];
    load(fname);
    xice = xice(:,indstr:end);
    ice_area_ann(project_name2{i}) = nanmean(xice,1);
    ice_area_mar(project_name2{i}) = xice(3,:);
    ice_area_sep(project_name2{i}) = xice(9,:);
end

save('matfiles/ITU-MOM_area_time_series.mat','ice_area_ann','ice_area_mar','ice_area_sep','time');
% to plot the BG_POS vs BG_neg
figure(1)
plot(time,(ice_area_ann('BG_pos')-ice_area_ann('ctrl'))*1e-12,'b-','linewidth',2 ... 
     ,'DisplayName','BG-pos')
hold on
plot(time,(ice_area_ann('BG_neg')-ice_area_ann('ctrl'))*1e-12,'r-','linewidth',2 ...
     ,'DisplayName','BG-neg')
legend(gca,'show','Location','SouthEast')      
title('Annual mean Arctic sea ice area anomaly')
grid
ylim([-1 1])
xlabel('Years')
ylabel('Sea ice area anomaly (x 1000 km^3)')
printname = ['paperfigs/seaice_area_annual_anomaly.eps'];
print(1,'-depsc2','-r300',printname)

% March
figure
plot(time,(ice_area_mar('BG_pos')-ice_area_mar('ctrl'))*1e-12,'b-','linewidth',2 ... 
     ,'DisplayName','BG-pos')
hold on
plot(time,(ice_area_mar('BG_neg')-ice_area_mar('ctrl'))*1e-12,'r-','linewidth',2 ...
     ,'DisplayName','BG-neg')
legend(gca,'show','Location','SouthEast')      
title('March Arctic sea ice area anomaly')
grid
ylim([-1 1])
xlabel('Years')
ylabel('Sea ice area anomaly (x 1000 km^3)')
printname = ['paperfigs/seaice_area_march_anomaly.eps'];
print(1,'-depsc2','-r300',printname)

% September
figure
plot(time,(ice_area_sep('BG_pos')-ice_area_sep('ctrl'))*1e-12,'b-','linewidth',2 ... 
     ,'DisplayName','BG-pos')
hold on
plot(time,(ice_area_sep('BG_neg')-ice_area_sep('ctrl'))*1e-12,'r-','linewidth',2 ...
     ,'DisplayName','BG-neg')
legend(gca,'show','Location','SouthEast')      
title('September mean Arctic sea ice area anomaly')
grid
ylim([-1 1])
xlabel('Years')
ylabel('Sea ice area anomaly (x 1000 km^3)')
printname = ['paperfigs/seaice_area_september_anomaly.eps'];
print(1,'-depsc2','-r300',printname)

break

