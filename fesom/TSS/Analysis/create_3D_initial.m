clear all

tmp = textread('nod3d.out');

% longitude
lon_fesom = tmp(:,2);
% latitude
lat_fesom = tmp(:,3); 
% latitude
depth_fesom = tmp(:,4); 

% salinity
salt_fesom = ncread('oper.2017.oce.mean.nc','salt');
temp_fesom = ncread('oper.2017.oce.mean.nc','temp');

clear tmp

depth1 = unique(depth_fesom);
depth1 = sort(depth1,'descend');

depth = [1.0 2.0 3.0 4.0 5.0 6.0 7.0 8.0 9.0 10.0 11.0 12.0 13.0 14.0 15.0 ...  
         16.0 17.0 18.0 19.0 20.0 21.0 22.0 23.0 24.0 25.0 26.0 27.0 28.0 29.0 ...
         30.0 31.0 32.0 33.0 34.0 35.0 36.0 37.0 38.0 39.0 40.0 41.0 42.0 ...    
         43.0 44.0 45.0 46.0 47.0 48.0 49.0 50.0 55.0 60.0 65.0 70.0 75.0 ...    
         80.0 85.0 90.0 95.0 100.0 120.0 140.0 160.0 180.0 200.0 250.0 ...       
         300.0 350.0 400.0 450.0 500.0 550.0 600.0 650.0 700.0 750.0 800.0 ...   
         850.0 900.0 950.0 1000.0 1100.0 1200.0 1300.0 1400.0 1500.0 1600.0 ...  
         1700.0 1800.0 1900.0 2000.0 2100.0 2200.0];


x = ncread('uTSS_lobc_chunk_0365.nos.nc','longitude');                          
y = ncread('uTSS_lobc_chunk_0365.nos.nc','latitude');

% salt_fesom = zeros(70270,109); %size(node2d,depth1)

for ind = 1:length(depth)
    ind_fesom = max(find(depth1>=-depth(ind)));
    lont = lon_fesom(depth_fesom==depth1(ind_fesom));
    latt = lat_fesom(depth_fesom==depth1(ind_fesom));
    tmps = salt_fesom(depth_fesom==depth1(ind_fesom));
    tmpt = temp_fesom(depth_fesom==depth1(ind_fesom));
    dnm = griddata(lont,latt,double(tmps),double(x),double(y),'nearest');
    salt_uTSS(:,ind) = dnm;
    dnm = griddata(lont,latt,double(tmpt),double(x),double(y),'nearest');
    temp_uTSS(:,ind) = dnm;
    ind
end