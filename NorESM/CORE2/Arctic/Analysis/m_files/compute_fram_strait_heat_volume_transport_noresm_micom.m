clear all
rearth=6370;
int_method='conserve';
i_sec=3; %Fram Strait at 79.5N

% NorESM Fram Strait
map_file='/bcmhsm/milicak/RUNS/noresm/CORE2/Arctic/DATA/maps/map_noresm_tnx1v1_to_section.nc';
filename_u='/work/milicak/RUNS/noresm/CORE2/Arctic/DATA/NorESM/NOIIA_T62_tn11_sr10m60d_01_u_velocity_pendatal_1-300.nc';
filename_v='/work/milicak/RUNS/noresm/CORE2/Arctic/DATA/NorESM/NOIIA_T62_tn11_sr10m60d_01_v_velocity_pendatal_1-300.nc';
filename_t='/work/milicak/RUNS/noresm/CORE2/Arctic/DATA/NorESM/NOIIA_T62_tn11_sr10m60d_01_temperature_pendatal_1-300.nc';
gridfile='/work/milicak/RUNS/noresm/CORE2/Arctic/DATA/NorESM/grid_NORESM.nc';
uvel=ncgetvar(filename_u,'uvel');
vvel=ncgetvar(filename_v,'vvel');
temp=ncgetvar(filename_t,'temp');
angle=ncgetvar(gridfile,'angle');
angle=angle(:,1:end-1);
%lon=ncgetvar(filename_t,'TLON');
%lat=ncgetvar(filename_t,'TLAT');
zt=ncgetvar(filename_t,'depth'); %convert cm to meter
zt2=ncgetvar(filename_t,'depth_bounds'); %convert cm to meter
dz=zt2(2,:)-zt2(1,:);

for kk=1:size(vvel,4)
tmpu=squeeze(uvel(:,:,:,kk));  
tmpv=squeeze(vvel(:,:,:,kk)); 
cosa=reshape(reshape(cos(angle),[],1)*ones(1,size(tmpu,3)),size(tmpu));
sina=reshape(reshape(sin(angle),[],1)*ones(1,size(tmpu,3)),size(tmpu));
u=cosa.*tmpu-sina.*tmpv;
v=sina.*tmpu+cosa.*tmpv;
section=map_vector2section(u,v,map_file,int_method);
tmp=squeeze(temp(:,:,:,kk)); %last cycle 
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

save('matfiles/noresm_micom_fram_strait_heat_volume_transport','total_heat_northward_transport','total_volume_northward_transport','total_heat_southward_transport','total_volume_southward_transport')

