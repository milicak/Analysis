clear all
close all

% 4km resolution values
Nx = 1680;
Ny = 1536;
nt_new = 576; % time lenght for the original dataset
dzc = [10.00, 10.00, 10.00, 10.00, 10.00, 10.00, 10.00, 10.01, ... 
 10.03, 10.11, 10.32, 10.80, 11.76, 13.42, 16.04 , 19.82, 24.85, ...              
 31.10, 38.42, 46.50, 55.00, 63.50, 71.58, 78.90, 85.15, 90.18, ...
 93.96, 96.58, 98.25, 99.25,100.01,101.33,104.56,111.33,122.83, ...             
 139.09,158.94,180.83,203.55,226.50,249.50,272.50,295.50,318.50, ...             
 341.50,364.50,387.50,410.50,433.50,456.50];

Nzc = length(dzc);

depth=rdmds('Depth');

pin='/home/milicak/models/MITgcm/Projects/Arctic_4km/Exp0vanilla/';

tn = {'OBWt_arctic_const_1680x1536.stable'};
sn = {'OBWs_arctic_const_1680x1536.stable'};
fin=[pin tn{1}]; disp(fin)
if fin(3)=='N', nd=Nx; else nd=Ny; end
temp = readbin(fin,[nd Nzc nt_new]);
fin=[pin sn{1}]; disp(fin)
if fin(3)=='N', nd=Nx; else nd=Ny; end
salt = readbin(fin,[nd Nzc nt_new]);

depthW = depth(1,:);

