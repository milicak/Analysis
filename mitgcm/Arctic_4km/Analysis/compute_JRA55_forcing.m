clear all
close all

root_folder = '/okyanus/users/milicak/dataset/JRA55/';

% fyear = 1958;
% lyear = 2016;
fyear = 2017;
lyear = 2017;


% var q_10

foutnames = {'JRA55_rain','JRA55_tmp10m_degC','JRA55_spfh10m' ...
             'JRA55_dsw','JRA55_dlw','JRA55_u10m','JRA55_v10m'};
vars = {'rain','t_10','q_10','rsds','rlds','u_10','v_10'};
varnames = {'prrn','tas_10m','huss_10m','rsds','rlds','uas_10m','vas_10m'};

% foutnames = {'JRA55_rain','JRA55_tmp10m_degC','JRA55_spfh10m' ...
             % 'JRA55_dsw','JRA55_dlw','JRA55_u10m','JRA55_v10m'};
% vars = {'rain','t_10','q_10','rsds','rlds','u_10','v_10'};
% varnames = {'prrn','tas_10m','huss_10m','rsds','rlds','uas_10m','vas_10m'};

% foutnames = {'JRA55_rain'}
% vars = {'rain'}
% varnames = {'prrn'}

for i = 1:length(vars)
    for year=fyear:lyear
        year
        % fname = [root_folder vars{i} '.' num2str(year) '.18Oct2017.nc'];
        fname = [root_folder vars{i} '.' num2str(year) '.14Jan2018.nc'];
        tmp = ncread(fname,varnames{i});
        fout = [root_folder foutnames{i} '_' num2str(year)];
        writebin(fout,tmp,1,'real*4')
        clear tmp
    end % year
end

