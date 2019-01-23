clear all

depth = [1.0 2.0 3.0 4.0 5.0 6.0 7.0 8.0 9.0 10.0 11.0 12.0 13.0 14.0 15.0 ...
        16.0 17.0 18.0 19.0 20.0 21.0 22.0 23.0 24.0 25.0 26.0 27.0 28.0 29.0 ...
        30.0 31.0 32.0 33.0 34.0 35.0 36.0 37.0 38.0 39.0 40.0 41.0 42.0 ...
        43.0 44.0 45.0 46.0 47.0 48.0 49.0 50.0 55.0 60.0 65.0 70.0 75.0 ... 
        80.0 85.0 90.0 95.0 100.0 120.0 140.0 160.0 180.0 200.0 250.0 ...
        300.0 350.0 400.0 450.0 500.0 550.0 600.0 650.0 700.0 750.0 800.0 ...
        850.0 900.0 950.0 1000.0 1100.0 1200.0 1300.0 1400.0 1500.0 1600.0 ...
        1700.0 1800.0 1900.0 2000.0 2100.0 2200.0];

depth = depth';
pres = sw_pres(depth,40.75);

dnm = textread('saltin_20160101.dat');
salt = dnm(:,3:end);
dnm = textread('tempin_20160101.dat');
temp = dnm(:,3:end);
clear dnm

x = ncread('uTSS_lobc_chunk_0365.nos.nc','longitude');
y = ncread('uTSS_lobc_chunk_0365.nos.nc','latitude');
elem = ncread('uTSS_lobc_chunk_0365.nos.nc','element_index');
salinity = ncread('uTSS_lobc_chunk_0365.nos.nc','salinity');

load('marmara_mask.mat')
in = insphpoly(x,y,xx,yy,0,90);
in = double(in);

trisurf(elem',x,y,salinity(1,:),'edgecolor','none','facecolor','interp');view(2);
offsetpsu = 2.5; % psu

pres2d = repmat(pres,[1 size(salt,1)]);
in2d = repmat(in,[1 size(salt,2)]);
dens = gsw_rho_t_exact(salt,temp,pres2d');
tmps = salt+offsetpsu.*in2d;
tmpt = gsw_t_from_rho_exact(dens,tmps,pres2d');
tmpt = temp+(tmpt-temp).*in2d;


fid = fopen('dnm.txt', 'w');
fprintf(fid, '0 2 957839 240993 93 1 1\n');
fprintf(fid, '20160101 0\n');
fclose(fid);
dlmwrite('dnm.txt',depth','delimiter',' ','-append','precision','%.1f') 
for ind=1:size(tmps,1)
    fid = fopen('dnm.txt', 'a');
    fprintf(fid, ' salinity [psu]\n');
    fprintf(fid, '93 -999.0 ');
    fclose(fid);
    dlmwrite('dnm.txt',tmps(ind,:),'delimiter',' ','-append','precision','%.10f')
end





