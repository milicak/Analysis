clear all

%we will use already computed values
load matfiles/om3_core3_2_ice_volume.mat
vice_NH = containers.Map;
vice = vice(:);
vice = vice(397:end);
vice_NH('ctrl') = vice(:);
load matfiles/om3_core3_2_BG_pos_ice_volume.mat
vice = vice(:);
vice = vice(397:end);
vice_NH('BG_pos') = vice(:);
load matfiles/om3_core3_2_BG_neg_ice_volume.mat
vice = vice(:);
vice = vice(397:end);
vice_NH('BG_neg') = vice(:);

save('matfiles/vice_NH_time.mat','vice_NH');
