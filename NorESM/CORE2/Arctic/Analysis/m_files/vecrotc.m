function [ur,vr]=vecrotc(lon,lat,u,v,arakawa_type),
% VECROTC rotate vector components
%      [UR,VR] = VECROT(LON,LAT,U,V) rotate the vector components U and
%      V defined at Arakawa C grid velocity points to zonal (UR) and
%      meridional (VR) components defined at scalar points. LON and LAT
%      defines the geographic location of the scalar points. Points near
%      the pole singularities are set to NaN.

% Centered latitude and longitude differences in one direction
dlat=[lat(2,:)-lat(1,:);
      (lat(3:end,:)-lat(1:end-2,:))*.5;
      lat(end,:)-lat(end-1,:)];
dlon=[lon(2,:)-lon(1,:);
      (lon(3:end,:)-lon(1:end-2,:))*.5;
      lon(end,:)-lon(end-1,:)];
ind=find(dlon>180); dlon(ind)=dlon(ind)-360;
ind=find(dlon<-180); dlon(ind)=dlon(ind)+360;
ind=find(dlon>90); dlon(ind)=dlon(ind)-180;
ind=find(dlon<-90); dlon(ind)=dlon(ind)+180;

% Compute rotation angle
rad=pi/180;
phi=atan2(dlat,(dlon.*cos(lat*rad)));

if(arakawa_type=='C')
% Get velocity components at scalar point
  us=[(u(1:end-1,:)+u(2:end,:))*.5;
      u(end,:)];
  vs=[(v(:,1:end-1)+v(:,2:end))*.5 v(:,end)];
elseif(arakawa_type=='B')
  us=u;vs=v;
end

% Rotate the vector components
ur=us.*cos(phi)-vs.*sin(phi);
vr=us.*sin(phi)+vs.*cos(phi);

% Set points near pole singularities to NaN
ind=find(lat>88|lat<-88);
ur(ind)=nan;
vr(ind)=nan;
