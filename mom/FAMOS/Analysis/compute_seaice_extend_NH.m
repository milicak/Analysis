clear all

%we will use already computed values
load matfiles/om3_core3_2_ice_extend.mat
xice_NH = containers.Map;
xice = xice(:);
xice = xice(397:end);
xice_NH('ctrl') = xice(:);
load matfiles/om3_core3_2_BG_pos_ice_extend.mat
xice = xice(:);
xice = xice(397:end);
xice_NH('BG_pos') = xice(:);
load matfiles/om3_core3_2_BG_neg_ice_extend.mat
xice = xice(:);
xice = xice(397:end);
xice_NH('BG_neg') = xice(:);

save('matfiles/xice_NH_time.mat','xice_NH');

