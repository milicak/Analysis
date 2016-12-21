clear all

index=4;

filenameu=['ncep.u_10.T62.'];
filenamev=['ncep.v_10.T62.'];
filenameslp=['ncep.slp_.T62.'];

root_folder_ctrl='/fimm/work/milicak/mnt/viljework/archive/iaf/';

endname1='.nc';
endname2='.20120414.nc';
endname3='.20120412.nc';

if index==1
  root_folder='/fimm/work/milicak/mnt/viljework/archive/iaf_bg_pos/';
  slp_anom=ncgetvar('FAMOS_BG_pos.nc','slp_anom');
  u_10_anom=ncgetvar('FAMOS_BG_pos.nc','u_10_anom');
  v_10_anom=ncgetvar('FAMOS_BG_pos.nc','v_10_anom');
elseif index==2
  root_folder='/fimm/work/milicak/mnt/viljework/archive/iaf_bg_neg/';
  slp_anom=ncgetvar('FAMOS_BG_neg.nc','slp_anom');
  u_10_anom=ncgetvar('FAMOS_BG_neg.nc','u_10_anom');
  v_10_anom=ncgetvar('FAMOS_BG_neg.nc','v_10_anom');
elseif index==3
  root_folder='/fimm/work/milicak/mnt/viljework/archive/iaf_gs_pos/';
  slp_anom=ncgetvar('FAMOS_GS_pos.nc','slp_anom');
  u_10_anom=ncgetvar('FAMOS_GS_pos.nc','u_10_anom');
  v_10_anom=ncgetvar('FAMOS_GS_pos.nc','v_10_anom');
elseif index==4
  root_folder='/fimm/work/milicak/mnt/viljework/archive/iaf_gs_neg/';
  slp_anom=ncgetvar('FAMOS_GS_neg.nc','slp_anom');
  u_10_anom=ncgetvar('FAMOS_GS_neg.nc','u_10_anom');
  v_10_anom=ncgetvar('FAMOS_GS_neg.nc','v_10_anom');
end

% remove NaNs
u_10_anom(isnan(u_10_anom))=0; 
v_10_anom(isnan(v_10_anom))=0; 
slp_anom(isnan(slp_anom))=0; 


%for year=1948:2009
for year=1979:2009
  % u-10
  if year==2005
    endname=endname2;
  elseif year==2008
    endname=endname3;
  elseif year==2009
    endname=endname3;
  else
    endname=endname1;
  end
  fname=[root_folder_ctrl filenameu num2str(year) endname];
  var=ncgetvar(fname,'u_10'); 
  var=var+repmat(u_10_anom,[1 1 size(var,3)]);
  fname=[root_folder filenameu num2str(year) endname]
  ncwrite(fname,'u_10',var);
  % v-10
  fname=[root_folder_ctrl filenamev num2str(year) endname];
  var=ncgetvar(fname,'v_10'); 
  var=var+repmat(v_10_anom,[1 1 size(var,3)]);
  fname=[root_folder filenamev num2str(year) endname]
  ncwrite(fname,'v_10',var);
  % slp
  fname=[root_folder_ctrl filenameslp num2str(year) endname];
  var=ncgetvar(fname,'slp_'); 
  var=var+repmat(slp_anom,[1 1 size(var,3)]);
  fname=[root_folder filenameslp num2str(year) endname]
  ncwrite(fname,'slp_',var);
end

