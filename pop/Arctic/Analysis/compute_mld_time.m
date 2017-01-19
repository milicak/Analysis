clear all
grid_file='/bcmhsm/milicak/RUNS/noresm/CORE2/Arctic/DATA/ncar-pop/areacello_fx_CCSM4_piControl_r0i0p0.nc';
lon=ncgetvar(grid_file,'lon');
lat=ncgetvar(grid_file,'lat');

%project_name = 'B1850CN_f19_tn11_kdsens';
%project_name = 'B1850CN_f19_tn11_kdsens01';
%project_name = 'B1850CN_f19_tn11_kdsens02';
%project_name = 'B1850CN_f19_tn11_kdsens03';
%project_name = 'B1850CN_f19_tn11_kdsens04';
%project_name = 'B1850CN_f19_tn11_kdsens05';
%project_name = 'B1850CN_f19_tn11_kdsens06';
project_name = 'B1850CN_f19_tn11_kdsens07';

fyear = 1;
lyear = 250;

filename = ['matfiles/' project_name '_mld_mean_' num2str(fyear) '_' num2str(lyear) '.mat']
load(filename)

south1 = 45; %0 North
north1 = 65; %60 North
west1 = -60+360; %60 West
east1 = -40+360; %00 East

[nx ny]=size(lon);
% Labrador Sea mask
mask=zeros(nx,ny);
for ii=1:nx; for jj=1:ny
   if(lat(ii,jj) >= south1 & lat(ii,jj) <= north1)
   if(lon(ii,jj) >= west1 & lon(ii,jj) <= east1)
       mask(ii,jj) = 1;
   end;end
end;end

mask=repmat(mask,[1 1 lyear-fyear+1]);
mask=permute(mask,[3 1 2]);

dnm=sq(MLDMarch.*mask);
dnm=reshape(dnm,[250 nx*ny]);
dnm=nanmean(dnm,2)*1e-2;

MLD_Lab = dnm;

save(['matfiles/' project_name '_mld_time_' num2str(fyear) '_' num2str(lyear) '.mat'],'MLD_Lab')


break


x=lon;                
x(x>320)=x(x>320)-360;

%for i=1:320;for j=1:384
%  if(x(i,j) > 180)
% 
%  end
%end;end
%xx=x(161:end,:)-360;     
%xx(161:320,:)=x(1:160,:);

figure
%m_projpolar
m_proj('stereographic','lat',80,'long',0,'radius',35);
%m_proj('stereographic','lat',90,'long',0,'radius',45);
%m_proj('Equidistant Cylindrical','lon',[-180 180],'lat',[-90 90]);
%m_proj('Equidistant Cylindrical','lon',[0 360],'lat',[-90 90]);
m_pcolor(lon,lat,dnm);shfn
caxis([0 1500])
m_coast('patch',[.7 .7 .7])
m_grid
shading faceted
keyboard

printname=[project_name 'mldMarch_' num2str(av1) '_' num2str(av2) '_years']
print('-dpng',printname)



