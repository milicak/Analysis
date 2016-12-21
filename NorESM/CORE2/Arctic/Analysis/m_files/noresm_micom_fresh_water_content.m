clear all
fyear=241;
lyear=300;
Sref=34.8;  % reference salinity
Smin=0.0;
Smax=50;
grav=9.81;
rho0=1e3;

expid='NOIIA_T62_tn11_sr10m60d_01';
datesep='-';
%grid_file='/work/shared/noresm/inputdata/ocn/micom/tnx1v1/20120120/grid.nc';
grid_file='/fimm/home/bjerknes/milicak/Analysis/NorESM/climatology/Analysis/grid.nc';
lon=ncgetvar(grid_file,'plon');
lat=ncgetvar(grid_file,'plat');
%prefix=['/hexagon/work/milicak/archive/' expid '/ocn/hist/' expid '.micom.hm.'];
prefix=['/work-common/shared/bjerknes/milicak/mnt/norstore/NS2345K/noresm/cases/' expid '/ocn/hist/' expid '.micom.hm.'];
nx=size(lon,1);ny=size(lon,2);

% Retrieve mixed layer depths and write to netcdf variables
n=0;
for year=fyear:lyear
  for month=1:12
    n=n+1;
    sdate=sprintf('%4.4d%c%2.2d',year,datesep,month);
    disp(sdate)
    if (n==1)
       zt=ncgetvar([prefix sdate '.nc'],'depth');
       zw(2:length(zt))=0.5*(zt(2:end)+zt(1:end-1));
       zw(end+1)=zt(end)+(zt(end)-zw(end));
       dz=zw(2:end)-zw(1:end-1);
       dz3d=repmat(dz,[size(lon,1) 1 size(lon,2)]);
       dz3d=permute(dz3d,[1 3 2]);
    end

    %saln=ncgetvar([prefix sdate '.nc'],'saln');
    saln=ncgetvar([prefix sdate '.nc'],'salnlvl');
    saln(saln>Smax)=NaN;
    saln(saln<Smin)=NaN;
for i=1:nx;for j=1:ny
%kind=max(find(saln(i,j,:)<=Sref));
%if(isempty(kind)==0)
%saln(i,j,kind+1:end)=NaN;
%else
%saln(i,j,1:end)=NaN;
%end
k=1;
fwclogic=true;
for kk=1:size(saln,3)
if (fwclogic==true)
  if(saln(i,j,k)<=Sref)
    k=k+1;
  else
    fwclogic=false;
  end
end
end
saln(i,j,k:end)=NaN;
end;end
%    dp=ncgetvar([prefix sdate '.nc'],'dp');
%    tmp=(1.0-saln./Sref).*dp;
%    tmp=squeeze(nansum(tmp,3));
%    tmp=(tmp./grav)./rho0;
%    FWC(:,:,n)=tmp;

  tmp=(Sref-saln).*dz3d./Sref;
  tmp=nansum(tmp,3);
  FWC(:,:,n)=tmp;

  end
end

save('matfiles/noresm_micom_fresh_water_content.mat','FWC','lon','lat')
