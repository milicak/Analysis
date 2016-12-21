function strmf=micom_strmf(uflx,vflx,i0,j0,nreg);
%uflx should be 2D and nansum(uflx,3) in z
%vflx should be 2D and nansum(vflx,3) in z
%i0=25 of 360 j0=290 of 385 A point in North America

[nx ny]=size(uflx);
if i0<1|i0>nx
  error('i0 is outside valid range')
end
if j0<1|j0>ny
  error('j0 is outside valid range')
end
uflx(find(isnan(uflx)))=0;
vflx(find(isnan(vflx)))=0;

if     nreg==1

  qi=1:nx*ny;
  qis=[(nx+1):2*nx 1:nx*(ny-1)];
  qin=[(nx+1):nx*ny (nx*(ny-2)+1):nx*(ny-1)];
  qie=reshape(circshift(reshape(qi,nx,ny),1),1,[]);
  qiw=reshape(circshift(reshape(qi,nx,ny),-1),1,[]);

  wi=(nx+1):nx*ny;
  uis=[1:nx*(ny-1)];
  vie=reshape(circshift(reshape(wi,nx,ny-1),1),1,[]);

elseif nreg==2

  qi=1:nx*ny;
  qis=[(nx+1):2*nx 1:nx*(ny-1)];
  qin=[(nx+1):(nx*(ny-1)+nx/2+1) (nx*(ny-1)+nx/2):-1:(nx*(ny-1)+2) ...
       (nx*(ny-1)+1) nx*(ny-1):-1:(nx*(ny-2)+nx/2+2) (nx*(ny-1)+nx/2+1) ...
       (nx*(ny-2)+nx/2):-1:(nx*(ny-2)+2)];
  qie=reshape(circshift(reshape(qi,nx,ny),1),1,[]);
  qiw=reshape(circshift(reshape(qi,nx,ny),-1),1,[]);

  wi=(nx+1):nx*ny;
  uis=[1:nx*(ny-1)];
  vie=reshape(circshift(reshape(wi,nx,ny-1),1),1,[]);

elseif nreg==4

  qi=1:nx*ny;
  qis=reshape(circshift(reshape(qi,nx,ny),[0 1]),1,[]);
  qin=reshape(circshift(reshape(qi,nx,ny),[0 -1]),1,[]);
  qie=qi-1;qie(1:nx:end)=qie(1:nx:end)+2;
  qiw=qi+1;qiw(nx:nx:end)=qiw(nx:nx:end)-2;

  wi=zeros(1,nx*ny);wi(1:nx:end)=nan;wi=find(~isnan(wi));
  uis=reshape(circshift(reshape(wi,nx-1,ny),[0 1]),1,[]);
  vie=wi-1;

else
  error(sprintf('unsupported grid type, nreg = %d',nreg))
end

row=[qi qi qi qi qi];
col=[qi qis qie qiw qin];
s=reshape(ones(nx*ny,1)*[4 -1 -1 -1 -1],1,[]);
A=sparse(row,col,s,nx*ny,nx*ny);

omega=zeros(nx*ny,1);
omega(wi)=-uflx(uis)+uflx(wi)+vflx(vie)-vflx(wi);

strmf=reshape(A\omega,nx,ny);
keyboard
strmf=strmf-strmf(i0,j0);

