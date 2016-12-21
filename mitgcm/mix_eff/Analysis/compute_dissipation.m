function [epsilon epsilon_rho]=compute_dissipation(rho,u,v,w,u_rho,v_rho,w_rho,visc,delta_x,delta_y,delta_z,Nx,Ny,Nz)

% x-component
dudx=(u(2:end,:,:)-u(1:end-1,:,:))./delta_x;
eps11=visc.*(dudx.^2).*delta_x.*delta_y.*delta_z;
clear dudx

dudy(:,2:Ny,:)=(u(2:end,2:end,:)-u(2:end,1:end-1,:))./(0.5*(delta_y(:,2:end,:)+delta_y(:,1:end-1,:)));
dudy(end+1,:,:)=dudy(1,:,:);                                                                            
dudy(:,end+1,:)=dudy(:,1,:);
dnm=visc.*dudy.^2;
clear dudy
eps12=0.25*(dnm(1:end-1,1:end-1,:)+dnm(2:end,2:end,:)+dnm(2:end,2:end,:)+dnm(1:end-1,1:end-1,:)).*delta_x.*delta_y.*delta_z;
clear dnm

epsilon= eps11 +eps12;
epsilon_rho=rho.*(eps11 +eps12);
clear eps11 eps12

dudz_w(:,:,2:Nz)=(u_rho(:,:,2:end)-u_rho(:,:,1:end-1))./(0.5*(delta_z(:,:,2:end)+delta_z(:,:,1:end-1)));
dudz_w(:,:,Nz+1)=0;
dudz=0.5*(dudz_w(:,:,1:end-1)+dudz_w(:,:,2:end));
clear dudz_w
eps13=visc.*(dudz.^2).*delta_x.*delta_y.*delta_z;
clear dudz

epsilon= epsilon +eps13;
epsilon_rho=epsilon + rho.*(eps13);
clear eps13

% y-component
dvdx(2:Nx,:,:)=(v(2:end,2:end,:)-v(1:end-1,2:end,:))./(0.5*(delta_x(2:end,:,:)+delta_x(1:end-1,:,:)));
dvdx(end+1,:,:)=dvdx(1,:,:);                                                                            
dvdx(:,end+1,:)=dvdx(:,1,:);
dnm=visc.*dvdx.^2;
clear dvdx
eps21=0.25*(dnm(1:end-1,1:end-1,:)+dnm(2:end,2:end,:)+dnm(2:end,2:end,:)+dnm(1:end-1,1:end-1,:)).*delta_x.*delta_y.*delta_z;
clear dnm

dvdy=(v(:,2:end,:)-v(:,1:end-1,:))./delta_y;
eps22=visc.*(dvdy.^2).*delta_x.*delta_y.*delta_z;
clear dvdy

epsilon=epsilon + eps21 + eps22;
epsilon_rho=epsilon_rho + rho.*(eps21 + eps22);
clear eps11 eps12 eps13 eps21 eps22

dvdz_w(:,:,2:Nz)=(v_rho(:,:,2:end)-v_rho(:,:,1:end-1))./(0.5*(delta_z(:,:,2:end)+delta_z(:,:,1:end-1)));
dvdz_w(:,:,Nz+1)=0;
dvdz=0.5*(dvdz_w(:,:,1:end-1)+dvdz_w(:,:,2:end));
clear dvdz_w
eps23=visc.*(dvdz.^2).*delta_x.*delta_y.*delta_z;
clear dvdz

epsilon=epsilon + eps23;
epsilon_rho=epsilon_rho + rho.*(eps23);
clear eps11 eps12 eps13 eps21 eps22 eps23

% z-component
dwdx_u(2:Nx,:,:)=(w_rho(2:end,:,:)-w_rho(1:end-1,:,:))./(0.5*(delta_x(2:end,:,:)+delta_x(1:end-1,:,:)));
dwdx_u(Nx+1,:,:)=0.0;
dwdx=0.5*(dwdx_u(1:end-1,:,:)+dwdx_u(2:end,:,:));
clear dwdx_u
eps31=visc.*(dwdx.^2).*delta_x.*delta_y.*delta_z;
clear dwdx

dwdy_v(:,2:Ny,:)=(w_rho(:,2:end,:)-w_rho(:,1:end-1,:))./(0.5*(delta_y(:,2:end,:)+delta_y(:,1:end-1,:)));
dwdy_v(:,Ny+1,:)=0.0;
dwdy=0.5*(dwdy_v(:,1:end-1,:)+dwdy_v(:,2:end,:));
clear dwdy_v
eps32=visc.*(dwdy.^2).*delta_x.*delta_y.*delta_z;
clear dwdy

dwdz=(w(:,:,2:end)-w(:,:,1:end-1))./delta_z;
eps33=visc.*(dwdz.^2).*delta_x.*delta_y.*delta_z;
clear dwdz

epsilon=epsilon + eps31 +eps32 +eps33;
epsilon_rho=epsilon_rho+rho.*(eps31 +eps32 +eps33);
