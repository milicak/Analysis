clear all                                                                       
close all                                                                       
                                                                                
root_folder = '/okyanus/users/milicak/dataset/CORE2/NIAF/';              
                                                                                
fyear = 1948;                                                                 
lyear = 2009;                                                                 
                                                                                
                                                                                
% var q_10                                                                      
                                                                                
% foutnames = {'JRA55_rain','JRA55_tmp10m_degC','JRA55_spfh10m' ...             
             % 'JRA55_dsw','JRA55_dlw','JRA55_u10m','JRA55_v10m'};              
% vars = {'rain','t_10','q_10','rsds','rlds','u_10','v_10'};                    
% varnames = {'prrn','tas_10m','huss_10m','rsds','rlds','uas_10m','vas_10m'};   
% foutnames = {'JRA55_tmp10m_degC','JRA55_spfh10m' ...                          
             % 'JRA55_dsw','JRA55_dlw','JRA55_u10m','JRA55_v10m'};              
% vars = {'t_10','q_10','rsds','rlds','u_10','v_10'};                           
% varnames = {'tas_10m','huss_10m','rsds','rlds','uas_10m','vas_10m'};          
                                                                                
foutnames = {'CORE_IAF_tmp10m_degK','CORE_IAF_u10m','CORE_IAF_v10m', ...
             'CORE_IAF_spfh10m','CORE_IAF_rain','CORE_IAF_dsw','CORE_IAF_dlw'}                                                      
vars = {'t_10','u_10','v_10','q_10','ncar_precip','ncar_rad','ncar_rad'}                                                                 
varnames = {'T_10_MOD','U_10_MOD','V_10_MOD','Q_10_MOD','RAIN','SWDN_MOD','LWDN_MOD'}                                                             
                                                                                
for i = 1:length(vars)                                                          
    for year=fyear:lyear                                                        
        year                                                                
        if(year<=2007)
            fname = [root_folder vars{i} '.' num2str(year) '.05APR2010.nc'];      
        elseif(year>=2008)
            fname = [root_folder vars{i} '.' num2str(year) '.23OCT2012.nc'];        
        end
        tmp = ncread(fname,varnames{i});                                        
        fout = [root_folder foutnames{i} '_' num2str(year)];                    
        writebin(fout,tmp,1,'real*4')                                           
        clear tmp                                                               
    end % year                                                                  
end                                                                             
                                                                                

