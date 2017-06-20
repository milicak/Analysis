clear all

index=2;
str_time = (1980-1948+1)*4*365;

filenameu=['u_10.1948-2009.23OCT2012.nc'];
filenamev=['v_10.1948-2009.23OCT2012.nc'];
filenameslp=['slp.1948-2009.23OCT2012.nc'];

if index==1
  root_folder='../../../NorESM/FAMOS/Analysis/';
  slp_anom=ncgetvar([root_folder 'FAMOS_BG_pos.nc'],'slp_anom');
  u_10_anom=ncgetvar([root_folder 'FAMOS_BG_pos.nc'],'u_10_anom');
  v_10_anom=ncgetvar([root_folder 'FAMOS_BG_pos.nc'],'v_10_anom');
elseif index==2
  root_folder='../../../NorESM/FAMOS/Analysis/';
  slp_anom=ncgetvar([root_folder 'FAMOS_BG_neg.nc'],'slp_anom');
  u_10_anom=ncgetvar([root_folder 'FAMOS_BG_neg.nc'],'u_10_anom');
  v_10_anom=ncgetvar([root_folder 'FAMOS_BG_neg.nc'],'v_10_anom');
end

% remove NaNs
u_10_anom(isnan(u_10_anom))=0; 
v_10_anom(isnan(v_10_anom))=0; 
slp_anom(isnan(slp_anom))=0; 

root_folder_run = '/hexagon/work/milicak/RUNS/mom/om3_core3_v1/om3_core3/INPUT/';

% add slp anomalies
fname = [root_folder_run filenameslp];
if index==1
    oname = [root_folder_run 'slp.1948-2009.23OCT2012_anom_pos.nc']
else
    oname = [root_folder_run 'slp.1948-2009.23OCT2012_anom_neg.nc']
end
command = ['cp ' fname ' ' oname];
unix(command)
var = ncgetvar(oname,'SLP');
var_anom = zeros(size(var,1), size(var,2), size(var,3));
var_anom_tmp = repmat(slp_anom,[1 1 size(var,3)-str_time+1]);
var_anom(:,:,str_time:end) = var_anom_tmp;
var = var+var_anom;
ncwrite(oname,'SLP',var);

% add u_10 anomalies
fname = [root_folder_run filenameu];
if index==1
    oname = [root_folder_run 'u_10.1948-2009.23OCT2012_anom_pos.nc'];
else
    oname = [root_folder_run 'u_10.1948-2009.23OCT2012_anom_neg.nc'];
end
command = ['cp ' fname ' ' oname];
unix(command)
var = ncgetvar(oname,'U_10_MOD');
var_anom = zeros(size(var,1), size(var,2), size(var,3));
var_anom_tmp = repmat(u_10_anom,[1 1 size(var,3)-str_time+1]);
var_anom(:,:,str_time:end) = var_anom_tmp;
var = var+var_anom;
ncwrite(oname,'U_10_MOD',var);

% add v_10 anomalies
fname = [root_folder_run filenamev];
if index==1
    oname = [root_folder_run 'v_10.1948-2009.23OCT2012_anom_pos.nc'];
else
    oname = [root_folder_run 'v_10.1948-2009.23OCT2012_anom_neg.nc'];
end
command = ['cp ' fname ' ' oname];
unix(command)
var = ncgetvar(oname,'V_10_MOD');
var_anom = zeros(size(var,1), size(var,2), size(var,3));
var_anom_tmp = repmat(v_10_anom,[1 1 size(var,3)-str_time+1]);
var_anom(:,:,str_time:end) = var_anom_tmp;
var = var+var_anom;
ncwrite(oname,'V_10_MOD',var);

