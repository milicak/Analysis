clear all
rearth=6370;
int_method='conserve';
i_sec=3; %Fram Strait at 79.5N

% Geomar-Orca Fram Strait
map_file='/bcmhsm/milicak/RUNS/noresm/CORE2/Arctic/DATA/maps/map_geomar_orca_to_section.nc';

filename_u='/work/milicak/RUNS/noresm/CORE2/Arctic/DATA/geomar/ORCA05_5yr_19480101_20071231_vozocrtx.nc';
filename_v='/work/milicak/RUNS/noresm/CORE2/Arctic/DATA/geomar/ORCA05_5yr_19480101_20071231_vomecrty.nc';
filename_t='/work/milicak/RUNS/noresm/CORE2/Arctic/DATA/geomar/ORCA05_5yr_19480101_20071231_votemper.nc';
filename_mask='/work/milicak/RUNS/noresm/CORE2/Arctic/DATA/geomar/mesh_mask.nc';
uvel=ncgetvar(filename_u,'vozocrtx');
vvel=ncgetvar(filename_v,'vomecrty');
temp=ncgetvar(filename_t,'votemper');
tmask=ncgetvar(filename_mask,'tmask');
umask=ncgetvar(filename_mask,'umask');
vmask=ncgetvar(filename_mask,'vmask');
%temp(temp==0)=NaN;

time=ncgetvar(filename_t,'year');
zt=ncgetvar(filename_t,'gdept'); %convert cm to meter
%zt2(2:length(zt)+1)=cumsum(zt);
zt2(1)=0;
for k=2:length(zt)+1
zt2(k)=2*zt(k-1)-zt2(k-1);
end
dz=zt2(2:end)-zt2(1:end-1);

temp=squeeze(temp(2:end-1,1:end-1,:,:));
uvel=squeeze(uvel(2:end-1,1:end-1,:,:));
vvel=squeeze(vvel(2:end-1,1:end-1,:,:));

for kk=1:size(vvel,4)
tmpu=squeeze(uvel(:,:,:,kk));  
tmpv=squeeze(vvel(:,:,:,kk));
tmpu(umask==0)=NaN; 
tmpv(vmask==0)=NaN; 
section=map_vector2section(tmpu,tmpv,map_file,int_method);
tmp=squeeze(temp(:,:,:,kk)); %last cycle 
tmp(tmask==0)=NaN; 
section2=map_scalar2section(tmp,map_file,int_method);
tmpvacross=section(i_sec).v_across;
tmpdata=section2(i_sec).data;
dist(2:size(tmpdata,1)+1)=section(i_sec).edge_dist*rearth*1e3; %convert to m
ds=dist(2:end)-dist(1:end-1);
dz2d=repmat(dz,[size(tmpdata,1) 1]);
ds2d=repmat(ds',[1 size(tmpdata,2)]);
%compute heat transport
heat_transport=tmpdata.*tmpvacross.*dz2d.*ds2d;
%compute volume transport
volume_transport=tmpvacross.*dz2d.*ds2d;
% northward transport
dnm=heat_transport(volume_transport>=0);
total_heat_northward_transport(kk)=nansum(dnm(:));
dnm=volume_transport(volume_transport>=0);
total_volume_northward_transport(kk)=nansum(dnm(:));
% southward transport
dnm=heat_transport(volume_transport<0);
total_heat_southward_transport(kk)=nansum(dnm(:));
dnm=volume_transport(volume_transport<0);
total_volume_southward_transport(kk)=nansum(dnm(:));
kk
end

save('matfiles/nemo_cnrm_fram_strait_heat_volume_transport','time','total_heat_northward_transport','total_volume_northward_transport','total_heat_southward_transport','total_volume_southward_transport')

