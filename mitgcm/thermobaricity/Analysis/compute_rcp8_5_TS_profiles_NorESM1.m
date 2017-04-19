clear all

lon_region1 = [28.4183 50.1650 61.7595 59.7147 41.6135 24.3184 28.4183];
lat_region1 = [83.6591 84.0485 83.8828 82.8630 82.7320 82.2573 83.6591];

root_folder = '/work/milicak/mnt/SKDData/'

varname1 = 'thetao';
varname2 = 'so';

project_name = 'NorESM1-M'

rname = 'r1i1p1';

% historical
expid1 = 'historical'
% rcp8.5
expid2 = 'rcp85'

years = '198201-198512.nc';
filename = [root_folder expid1 '/' varname1 '/mon/' project_name '/' rname '/']; 
filename = [filename varname1 '_Omon_' project_name '_' expid1 '_' rname '_' years];
temp = ncread(filename,varname1);
lon = ncread(filename,'lon');
lat = ncread(filename,'lat');
zr = ncread(filename,'lev');

filename = [root_folder expid1 '/' varname2 '/mon/' project_name '/' rname '/']; 
filename = [filename varname2 '_Omon_' project_name '_' expid1 '_' rname '_' years];
salt = ncread(filename,varname2);

years = '198601-198912.nc';
filename = [root_folder expid1 '/' varname1 '/mon/' project_name '/' rname '/']; 
filename = [filename varname1 '_Omon_' project_name '_' expid1 '_' rname '_' years];
temp=cat(4,temp,ncread(filename,varname1));
filename = [root_folder expid1 '/' varname2 '/mon/' project_name '/' rname '/']; 
filename = [filename varname2 '_Omon_' project_name '_' expid1 '_' rname '_' years];
salt=cat(4,salt,ncread(filename,varname2));
years = '199001-199312.nc';
filename = [root_folder expid1 '/' varname1 '/mon/' project_name '/' rname '/']; 
filename = [filename varname1 '_Omon_' project_name '_' expid1 '_' rname '_' years];
temp=cat(4,temp,ncread(filename,varname1));
filename = [root_folder expid1 '/' varname2 '/mon/' project_name '/' rname '/']; 
filename = [filename varname2 '_Omon_' project_name '_' expid1 '_' rname '_' years];
salt=cat(4,salt,ncread(filename,varname2));
years = '199401-199712.nc';
filename = [root_folder expid1 '/' varname1 '/mon/' project_name '/' rname '/']; 
filename = [filename varname1 '_Omon_' project_name '_' expid1 '_' rname '_' years];
temp=cat(4,temp,ncread(filename,varname1));
filename = [root_folder expid1 '/' varname2 '/mon/' project_name '/' rname '/']; 
filename = [filename varname2 '_Omon_' project_name '_' expid1 '_' rname '_' years];
salt=cat(4,salt,ncread(filename,varname2));
years = '199801-200112.nc';
filename = [root_folder expid1 '/' varname1 '/mon/' project_name '/' rname '/']; 
filename = [filename varname1 '_Omon_' project_name '_' expid1 '_' rname '_' years];
temp=cat(4,temp,ncread(filename,varname1));
filename = [root_folder expid1 '/' varname2 '/mon/' project_name '/' rname '/']; 
filename = [filename varname2 '_Omon_' project_name '_' expid1 '_' rname '_' years];
salt=cat(4,salt,ncread(filename,varname2));

% time average
temp = squeeze(nanmean(temp,4));
salt = squeeze(nanmean(salt,4));

in = insphpoly(lon,lat,lon_region1,lat_region1,0,90);  
in = double(in);
in = repmat(in,[1 1 size(temp,3)]);

tempctr = temp.*in;
saltctr = salt.*in;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

years = '207801-208112.nc';
filename = [root_folder expid2 '/' varname1 '/mon/' project_name '/' rname '/']; 
filename = [filename varname1 '_Omon_' project_name '_' expid2 '_' rname '_' years];
temp = ncread(filename,varname1);

filename = [root_folder expid2 '/' varname2 '/mon/' project_name '/' rname '/']; 
filename = [filename varname2 '_Omon_' project_name '_' expid2 '_' rname '_' years];
salt = ncread(filename,varname2);

years = '208201-208512.nc';
filename = [root_folder expid2 '/' varname1 '/mon/' project_name '/' rname '/']; 
filename = [filename varname1 '_Omon_' project_name '_' expid2 '_' rname '_' years];
temp=cat(4,temp,ncread(filename,varname1));
filename = [root_folder expid2 '/' varname2 '/mon/' project_name '/' rname '/']; 
filename = [filename varname2 '_Omon_' project_name '_' expid2 '_' rname '_' years];
salt=cat(4,salt,ncread(filename,varname2));
years = '208601-208912.nc';
filename = [root_folder expid2 '/' varname1 '/mon/' project_name '/' rname '/']; 
filename = [filename varname1 '_Omon_' project_name '_' expid2 '_' rname '_' years];
temp=cat(4,temp,ncread(filename,varname1));
filename = [root_folder expid2 '/' varname2 '/mon/' project_name '/' rname '/']; 
filename = [filename varname2 '_Omon_' project_name '_' expid2 '_' rname '_' years];
salt=cat(4,salt,ncread(filename,varname2));
years = '209001-209312.nc';
filename = [root_folder expid2 '/' varname1 '/mon/' project_name '/' rname '/']; 
filename = [filename varname1 '_Omon_' project_name '_' expid2 '_' rname '_' years];
temp=cat(4,temp,ncread(filename,varname1));
filename = [root_folder expid2 '/' varname2 '/mon/' project_name '/' rname '/']; 
filename = [filename varname2 '_Omon_' project_name '_' expid2 '_' rname '_' years];
salt=cat(4,salt,ncread(filename,varname2));
years = '209401-209712.nc';
filename = [root_folder expid2 '/' varname1 '/mon/' project_name '/' rname '/']; 
filename = [filename varname1 '_Omon_' project_name '_' expid2 '_' rname '_' years];
temp=cat(4,temp,ncread(filename,varname1));
filename = [root_folder expid2 '/' varname2 '/mon/' project_name '/' rname '/']; 
filename = [filename varname2 '_Omon_' project_name '_' expid2 '_' rname '_' years];
salt=cat(4,salt,ncread(filename,varname2));
years = '209801-210012.nc';
filename = [root_folder expid2 '/' varname1 '/mon/' project_name '/' rname '/']; 
filename = [filename varname1 '_Omon_' project_name '_' expid2 '_' rname '_' years];
temp=cat(4,temp,ncread(filename,varname1));
filename = [root_folder expid2 '/' varname2 '/mon/' project_name '/' rname '/']; 
filename = [filename varname2 '_Omon_' project_name '_' expid2 '_' rname '_' years];
salt=cat(4,salt,ncread(filename,varname2));

% time average
temp = squeeze(nanmean(temp,4));
salt = squeeze(nanmean(salt,4));

temprcp85 = temp.*in;
saltrcp85 = salt.*in;

tempctr= reshape(tempctr,[size(tempctr,1)*size(tempctr,2) size(tempctr,3)]);
temprcp85 = reshape(temprcp85,[size(temprcp85,1)*size(temprcp85,2) size(temprcp85,3)]);
saltctr= reshape(saltctr,[size(saltctr,1)*size(saltctr,2) size(saltctr,3)]);
saltrcp85 = reshape(saltrcp85,[size(saltrcp85,1)*size(saltrcp85,2) size(saltrcp85,3)]);

tempctr(isnan(tempctr))=0;
saltctr(isnan(saltctr))=0;
temprcp85(isnan(temprcp85))=0;
saltrcp85(isnan(saltrcp85))=0;

k=1;
for i=1:size(tempctr,1)
if(tempctr(i,1)~=0)
   T1ctr(k,:)=tempctr(i,:);
   k=k+1;
end;end
k=1;
for i=1:size(saltctr,1)
if(saltctr(i,1)~=0)
   S1ctr(k,:)=saltctr(i,:);
   k=k+1;
end;end
k=1;
for i=1:size(temprcp85,1)
if(temprcp85(i,1)~=0)
   T1rcp85(k,:)=temprcp85(i,:);
   k=k+1;
end;end
k=1;
for i=1:size(saltrcp85,1)
if(saltrcp85(i,1)~=0)
   S1rcp85(k,:)=saltrcp85(i,:);
   k=k+1;
end;end

T1rcp85(T1rcp85==0)=NaN;
T1ctr(T1ctr==0)=NaN;
S1ctr(S1ctr==0)=NaN;
S1rcp85(S1rcp85==0)=NaN;

save(['matfiles/' project_name '_Arctic_rcp85.mat'],'S1ctr','S1rcp85','T1ctr','T1rcp85','zr')

