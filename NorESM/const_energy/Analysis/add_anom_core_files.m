clear all

index=1;

nx=192;
ny=94;

filenamet=['ncep.t_10.T62.'];
filenamelw=['giss.lwdn.T62.'];

root_folder_ctrl='/fimm/work/milicak/mnt/viljework/archive/iaf/';

endname1='.nc';
endname2='.20120414.nc';
endname3='.20120412.nc';

if index==1
  root_folder='/fimm/work/milicak/mnt/viljework/archive/iaf_high_temp/';
elseif index==2
  root_folder='/fimm/work/milicak/mnt/viljework/archive/iaf_low_temp/';
elseif index==3
  root_folder='/fimm/work/milicak/mnt/viljework/archive/iaf_rcp8_5_temp/';
end


itime=1;
for year=1948:2009
%for year=2005:2009
  if year==2005
    endname=endname2;
    endnamelw=endname1;
  elseif year==2008
    endname=endname3;
    endnamelw=endname3;
  elseif year==2009
    endname=endname3;
    endnamelw=endname3;
  else
    endname=endname1;
    endnamelw=endname1;
  end
  fname=[root_folder_ctrl filenamet num2str(year) endname];
  fname2=[root_folder_ctrl filenamelw num2str(year) endnamelw];
  var=ncgetvar(fname,'t_10'); 
  var2=ncgetvar(fname2,'lwdn'); 
  if(itime==1)
    lon=ncgetvar(fname,'lon'); 
    lat=ncgetvar(fname,'lat'); 
    ind1=min(find(abs(lat)<=30.0));
    ind2=max(find(abs(lat)<=30.0));
    t_10_anom = zeros(nx,ny);
    if(index==1)
      t_10_anom(:,ind1:ind2)=10;
    elseif index==2
      t_10_anom(:,ind1:ind2)=-10;
    elseif index==3
      out1=load('matfiles/N20TRAERCN_f19_g16_01_airtemp_mean_1980_2000.mat');
      out2=load('matfiles/NRCP85AERCN_f19_g16_01_airtemp_mean_2080_2100.mat');
      dnm1=squeeze(nanmean(out1.AIRTEMPTrefmean,1));
      dnm2=squeeze(nanmean(out2.AIRTEMPTrefmean,1));
      dnm1=nanmean(dnm1,1);
      dnm2=nanmean(dnm2,1);
      dnm=dnm2-dnm1;
      t_10_anom(:,:)=repmat(dnm(2:end-1),[nx 1]);
    end
    itime=0;
  end
  var=var+repmat(t_10_anom,[1 1 size(var,3)]);
  for days=1:size(var2,3)
    var2(:,ind1:ind2,days)=4*var2(:,ind1:ind2,days);
  end
  fname=[root_folder filenamet num2str(year) endname]
  ncwrite(fname,'t_10',var);
  fname2=[root_folder filenamelw num2str(year) endnamelw]
  ncwrite(fname2,'lwdn',var2);
end

