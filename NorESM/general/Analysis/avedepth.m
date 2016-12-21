function a=avedepth(field,dz,z1,z2)

[nx ny nz]=size(field);
if nx<nz
  field=permute(field,[2 3 1]);
  dz=permute(dz,[2 3 1]);
  [nx ny nz]=size(field);
end

z=zeros(nx,ny,nz+1);
dz(find(isnan(dz)))=0;
for k=2:nz+1,
  z(:,:,k)=z(:,:,k-1)+dz(:,:,k-1);
end
dz=diff(max(z1,min(z2,z)),1,3);
a=nansum(field.*dz,3);
sumdz=sum(dz,3);
sumdz(find(sumdz==0))=nan;
a=a./sumdz;
