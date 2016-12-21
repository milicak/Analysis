clear all
tic
%lf_path = '/Volumes/sim/data/LF_newTP_dataset/data_mat/';
lf_path ='/bcmhsm/milicak/RUNS/obs/LF_newTP_dataset/data_mat/'

% extended land mask
% load land6km.mat

bin_centers = 5:10:95;

listing = dir([lf_path '*.mat']);
LF_all = [];
for i = 121:length(listing)
    fn_lf = [lf_path listing(i).name];
    load(fn_lf);
    if strcmp(listing(i).name(14:15), '03') == 0 % use only March data
        continue
    end
    fn_lf
    LF_filt = reshape(LF_corr,1,size(LF_corr,1)*size(LF_corr,2));
    % select only valid lead fraction values, not a NaN, > 0 and <= 100%:
    LF_filt(isnan(LF_filt) == 1 | LF_filt <= 0 | LF_filt > 100) = [];
    
    LF_all = [LF_all LF_filt];
end
        
%histogram:
LF_freq = hist(LF_all,bin_centers);

figure('color','white')
bar(bin_centers,100.*LF_freq./length(LF_all),'BarWidth',0.8,'EdgeColor','none','FaceColor',[0 0.447058826684952 0.74117648601532])
axis square
xlabel('LF, %')
ylabel('Rel. Freq., %')

toc
