clear all

index=1;

filenameu=['uwnd_10m.'];
filenamev=['vwnd_10m.'];
filenamew=['wwnd_10m.'];

% to the hexagon work folder
root_folder_ctrl='/work/shared/noresm/inputdata/atm/datm7/20CRv2adj/';

endname1='.nc';

if index==1
% to the hexagon work folder
  root_folder='/work/mmu072/20CRv2adj_BG_pos/';
  w_10_anom=ncgetvar('FAMOS_20CR_BG_pos.nc','w_10_anom');
  u_10_anom=ncgetvar('FAMOS_20CR_BG_pos.nc','u_10_anom');
  v_10_anom=ncgetvar('FAMOS_20CR_BG_pos.nc','v_10_anom');
elseif index==2
  root_folder='/work/mmu072/20CRv2adj_BG_neg/';
  w_10_anom=ncgetvar('FAMOS_20CR_BG_neg.nc','w_10_anom');
  u_10_anom=ncgetvar('FAMOS_20CR_BG_neg.nc','u_10_anom');
  v_10_anom=ncgetvar('FAMOS_20CR_BG_neg.nc','v_10_anom');
elseif index==3
  root_folder='/work/mmu072/20CRv2adj_GS_pos/';
  w_10_anom=ncgetvar('FAMOS_20CR_GS_pos.nc','w_10_anom');
  u_10_anom=ncgetvar('FAMOS_20CR_GS_pos.nc','u_10_anom');
  v_10_anom=ncgetvar('FAMOS_20CR_GS_pos.nc','v_10_anom');
elseif index==4
  root_folder='/work/mmu072/20CRv2adj_GS_neg/';
  w_10_anom=ncgetvar('FAMOS_20CR_GS_neg.nc','w_10_anom');
  u_10_anom=ncgetvar('FAMOS_20CR_GS_neg.nc','u_10_anom');
  v_10_anom=ncgetvar('FAMOS_20CR_GS_neg.nc','v_10_anom');
end

% remove NaNs
u_10_anom(isnan(u_10_anom))=0; 
v_10_anom(isnan(v_10_anom))=0; 
w_10_anom(isnan(w_10_anom))=0; 

break
%for year=1948:2009
for year=1980:2011
  endname=endname1;
  fname=[root_folder_ctrl filenameu num2str(year) endname];
  var=ncgetvar(fname,'uwnd'); 
  if(year==2011)
    dnm=zeros(size(var,1),size(var,2),size(var,3));
    dnm(:,:,1:end-8)=repmat(u_10_anom,[1 1 size(var,3)-8]);
    var=var+dnm;
  else
    var=var+repmat(u_10_anom,[1 1 size(var,3)]);
  end
  fname=[root_folder filenameu num2str(year) endname]
  ncwrite(fname,'uwnd',var);

  % v component
  fname=[root_folder_ctrl filenamev num2str(year) endname];
  var=ncgetvar(fname,'vwnd'); 
  if(year==2011)
    dnm=zeros(size(var,1),size(var,2),size(var,3));
    dnm(:,:,1:end-8)=repmat(v_10_anom,[1 1 size(var,3)-8]);
    var=var+dnm;
  else
    var=var+repmat(v_10_anom,[1 1 size(var,3)]);
  end
  fname=[root_folder filenamev num2str(year) endname]
  ncwrite(fname,'vwnd',var);

  % w component
  fname=[root_folder_ctrl filenamew num2str(year) endname];
  var=ncgetvar(fname,'wspd'); 
  if(year==2011)
    dnm=zeros(size(var,1),size(var,2),size(var,3));
    dnm(:,:,1:end-8)=repmat(w_10_anom,[1 1 size(var,3)-8]);
    var=var+dnm;
  else
    var=var+repmat(w_10_anom,[1 1 size(var,3)]);
  end
  fname=[root_folder filenamew num2str(year) endname]
  ncwrite(fname,'wspd',var);
end

