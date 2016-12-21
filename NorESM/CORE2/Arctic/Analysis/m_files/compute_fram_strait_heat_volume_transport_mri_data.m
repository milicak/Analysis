clear all
rearth=6370;
int_method='conserve';
i_sec=3; %Fram Strait at 79.5N

% MRI-FREE Fram Strait
map_file='/bcmhsm/milicak/RUNS/noresm/CORE2/Arctic/DATA/maps/map_mri_free_to_section.nc';
filename_u='/work/milicak/RUNS/noresm/CORE2/Arctic/DATA/mir-data/u_pentadal.nc';
filename_v='/work/milicak/RUNS/noresm/CORE2/Arctic/DATA/mir-data/v_pentadal.nc';
filename_t='/work/milicak/RUNS/noresm/CORE2/Arctic/DATA/mir-data/temperature_pentadal.nc';
filename_mask='/work/milicak/RUNS/noresm/CORE2/Arctic/DATA/mir-data/arctic_mask_u.nc';

%uvel=ncgetvar(filename_u,'u');
%vvel=ncgetvar(filename_v,'v');
masku=ncgetvar(filename_mask,'indx');
uvel=nc_varget(filename_u,'u')./1e2;
vvel=nc_varget(filename_v,'v')./1e2;
uvel=permute(uvel,[4 3 2 1]);
vvel=permute(vvel,[4 3 2 1]);

temp=ncgetvar(filename_t,'temp');
time=ncgetvar(filename_t,'time');
zt=ncgetvar(filename_t,'level'); 
zt2(1)=0;
for k=2:length(zt)+1
zt2(k)=2*zt(k-1)-zt2(k-1);
end
dz=zt2(2:end)-zt2(1:end-1);

uvel=squeeze(uvel(3:end-2,1:end-2,:,:));
vvel=squeeze(vvel(3:end-2,1:end-2,:,:));
temp=squeeze(temp(3:end-2,1:end-2,:,:));
temp(temp<-100)=NaN;
%uvel(isnan(temp))=NaN;
%vvel(isnan(temp))=NaN;

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

save('matfiles/mir_data_fram_strait_heat_volume_transport','time','total_heat_northward_transport','total_volume_northward_transport','total_heat_southward_transport','total_volume_southward_transport')

