clear all
nx = 144;
ny = 96;

fyear = 1;
lyear = 250;

grid_file='/bcmhsm/milicak/RUNS/noresm/CORE2/Arctic/DATA/ncar-pop/areacello_fx_CCSM4_piControl_r0i0p0.nc';
area=ncgetvar(grid_file,'areacello');

%project_name = 'B1850CN_f19_tn11_kdsens';
%project_name = 'B1850CN_f19_tn11_kdsens01';
%project_name = 'B1850CN_f19_tn11_kdsens02';
%project_name = 'B1850CN_f19_tn11_kdsens03';
%project_name = 'B1850CN_f19_tn11_kdsens04';
%project_name = 'B1850CN_f19_tn11_kdsens05'
project_name = 'B1850CN_f19_tn11_kdsens06'

filename=['matfiles/' project_name '_airslp_mean_' num2str(fyear) '_' num2str(lyear) '.mat'];
load(filename)

south1 = 20; %20 North
north1 = 80; %20 North
west1 = -90+360; %90 West
east1 = 40; %40 East

jind1=max(find(lat<=south1));
jind2=max(find(lat<=north1));
iind1=max(find(lon<=west1));
iind2=max(find(lon<=east1));

% North Atlantic mask
mask=zeros(lyear-fyear+1,nx,ny);
mask(:,iind1:end,jind1:jind2)=1;
mask(:,1:iind2,jind1:jind2)=1;

data=AIRslpmeanwinter.*mask;
%data=AIRslpmean.*mask;

% data (nlat x nlon x ntime)
data=permute(data,[3 2 1]);
data=sq(data);
data_mean=squeeze(nanmean(data,3));
data_mean=repmat(data_mean,[1 1 lyear-fyear+1]);
% remove mean
data=data-data_mean;
[pattern,pc,expl_var]=calc_eof_nan(data,lat,3);

patternrot=pattern;
patternrot(:,73:end,:)=pattern(:,1:72,:);
patternrot(:,1:72,:)=pattern(:,73:end,:);

save(['matfiles/' project_name '_slp_eof_' num2str(fyear) '_' num2str(lyear) '.mat'],'patternrot','pc','expl_var','lon','lat')
break

% how to plot
figure
m_proj('lambert','long',[-90 40],'lat',[20 90]);
m_pcolor(lon-180,lat,squeeze(patternrot(:,:,2)));shfn
m_coast('patch',[.7 .7 .7])


fill2c(1:250,pc(:,1),'r','b')
hold on
fill2c(1:250,pc(:,1)+6,'r','b',6)
