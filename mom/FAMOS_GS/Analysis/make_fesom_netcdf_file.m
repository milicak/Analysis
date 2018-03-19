clear all

netcdfname = ['FESOM_GS_exps.nc'];

dnames = [{'data1'}, {'data2'}, {'data3'}, {'data4'}, {'data5'}];

expnames = [{'control'}, {'GSplus'}, {'GSminus'}];
exprnmes = [{'ctl'}, {'gsp'}, {'gsn'}];
varrnmes = [{'vol'}, {'heat'}, {'salt'}];


varn1 = [{'transp_BS'}, {'transp_BS_in'}, {'transp_BS_out'}, ...
         {'transp_BSO'}, {'transp_BSO_in'}, {'transp_BSO_out'}, ...
         {'transp_DS'}, {'transp_FS_in'}, {'transp_FS_out'}, ...
         {'transp_FS'}, {'transp_DS_in'}, {'transp_DS_out'}];

varn2 = [{'iext'}, {'iext_BK'}];
varn3 = [{'ivol'}, {'ivol_BK'}];


for ind = 1:3 %first 3 datanames
    for ind2 = 1:3 % control, gsp gsn
    fname=[char(dnames(ind)) '_' char(expnames(ind2))];
    load(fname);
    for var = 1:length(varn1)
        varname = [char(exprnmes(ind2)) char(varrnmes(ind)) char(varn1(var))]
        oldname = [char(varn1(var))];
        % create the netcdf variable
        nccreate(netcdfname,varname,'Dimensions',{'time',360})
        % write the netcdf variable
        ncwrite(netcdfname,varname,eval(oldname))
    end
    end
end
% for ice ext
for ind = 4:4 %first 3 datanames
    for ind2 = 1:3 % control, gsp gsn
    fname=[char(dnames(ind)) '_' char(expnames(ind2))];
    load(fname);
    for var = 1:length(varn2)
        varname = [char(exprnmes(ind2)) char(varn2(var))]
        oldname = [char(varn2(var))];
        % create the netcdf variable
        nccreate(netcdfname,varname,'Dimensions',{'time',360})
        % write the netcdf variable
        ncwrite(netcdfname,varname,eval(oldname))
    end
    end
end
% for ice vol
for ind = 5:5 %first 3 datanames
    for ind2 = 1:3 % control, gsp gsn
    fname=[char(dnames(ind)) '_' char(expnames(ind2))];
    load(fname);
    for var = 1:length(varn3)
        varname = [char(exprnmes(ind2)) char(varn3(var))]
        oldname = [char(varn3(var))];
        % create the netcdf variable
        nccreate(netcdfname,varname,'Dimensions',{'time',360})
        % write the netcdf variable
        ncwrite(netcdfname,varname,eval(oldname))
    end
    end
end
