clear all
rearth=6370;
int_method='conserve';
i_sec=3; %Fram Strait at 79.5N

% Nemo-CNRM Fram Strait
map_file='/bcmhsm/milicak/RUNS/noresm/CORE2/Arctic/DATA/maps/map_nemo_cnrm_to_section.nc';
filename_u='/work/milicak/RUNS/noresm/CORE2/Arctic/DATA/nemo-cnrm/CNRM_TSUV_decade.nc';
filename_v='/work/milicak/RUNS/noresm/CORE2/Arctic/DATA/nemo-cnrm/CNRM_TSUV_decade.nc';
filename_t='/work/milicak/RUNS/noresm/CORE2/Arctic/DATA/nemo-cnrm/CNRM_TSUV_decade.nc';

temp=ncgetvar(filename_t,'T_decade_Cy1');
temp(:,:,:,7:12)=ncgetvar(filename_t,'T_decade_Cy2');
temp(:,:,:,13:18)=ncgetvar(filename_t,'T_decade_Cy3');
temp(:,:,:,19:24)=ncgetvar(filename_t,'T_decade_Cy4');
temp(:,:,:,25:30)=ncgetvar(filename_t,'T_decade_Cy5');

uvel=ncgetvar(filename_u,'U_decade_Cy1');
uvel(:,:,:,7:12)=ncgetvar(filename_u,'U_decade_Cy2');
uvel(:,:,:,13:18)=ncgetvar(filename_u,'U_decade_Cy3');
uvel(:,:,:,19:24)=ncgetvar(filename_u,'U_decade_Cy4');
uvel(:,:,:,25:30)=ncgetvar(filename_u,'U_decade_Cy5');

vvel=ncgetvar(filename_v,'V_decade_Cy1');
vvel(:,:,:,7:12)=ncgetvar(filename_v,'V_decade_Cy2');
vvel(:,:,:,13:18)=ncgetvar(filename_v,'V_decade_Cy3');
vvel(:,:,:,19:24)=ncgetvar(filename_v,'V_decade_Cy4');
vvel(:,:,:,25:30)=ncgetvar(filename_v,'V_decade_Cy5');

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
section=map_vector2section(tmpu,tmpv,map_file,int_method);
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

save('matfiles/nemo_cnrm_fram_strait_heat_volume_transport','time','total_heat_northward_transport','total_volume_northward_transport','total_heat_southward_transport','total_volume_southward_transport')

