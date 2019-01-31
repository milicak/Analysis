clear all
close all

root_folder = '/shared/projects/uniklima/globclim/milicak/JRA55/';
root_folder = '/okyanus/users/milicak/dataset/JRA55/';

% fyear = 1958;
% lyear = 2015;
% fyear = 2016;
% lyear = 2016;
fyear = 2017;
lyear = 2017;


foutnames = {'JRA55_runoff'};
vars = {'runoff_all'};
varnames = {'friver'};

for i = 1:length(vars)
    for year=fyear:lyear
        year
        % fname = [root_folder vars{i} '.' num2str(year) '.15Dec2016.nc'];
        % fname = [root_folder vars{i} '.' num2str(year) '.30Jun2017.nc'];
        fname = [root_folder vars{i} '.' num2str(year) '.18Mar2018.nc'];
        tmp = ncread(fname,varnames{i});
        fout = [root_folder foutnames{i} '_' num2str(year)];
        writebin(fout,tmp,1,'real*4')
        clear tmp
    end % year
end

