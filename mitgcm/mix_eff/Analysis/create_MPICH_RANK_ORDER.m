clear all
num_cores = 32; %24;  %for gaea cm1
grid_x = 5120; %3456; %  1152;
grid_y = 320;  % 216; %72;
num_procs = 1600; %864; %576; % it should be divided by 24

grank2(num_cores,[grid_x grid_y],num_procs)

% get something from the fourth column (Points/core)
% it should be even 
% For instance 12x12 in this case
% 576     (24,1)          (4,6)           (12,12)


%grank([24 1],[4 9],[1 1]) 

%grank([24 1],[4 9],[1 1]) 
grank([32 1],[5 10],[1 1])
