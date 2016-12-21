function [P,rho] = int_for_p(T,S,dz,gravity)

P=0*T+cumsum(dz,3)*gravity*1025; % Initial guess fo pressure
rho=wright_eos2(T,S,P);
%Pio=[];
for it=1:5;
  dp=gravity*rho.*dz;
%  Pi=[0 cumsum(dp,3)];
  Pi=zeros(size(T,1),size(T,2),size(T,3)+1);
  Pi(:,:,2:end)=cumsum(dp,3);

%  if isempty(Pio)
%    Pio=Pi;
%  else
%    stats(Pi-Pio)
%    Pio=Pi;
%  end
  rho=wright_eos2(T,S, (Pi(:,:,1:end-1)+Pi(:,:,2:end))/2 );
end
%Pi=[0 cumsum(dp)];
Pi=zeros(size(T,1),size(T,2),size(T,3)+1);
Pi(:,:,2:end)=cumsum(dp,3);
P=(Pi(:,:,1:end-1)+Pi(:,:,2:end))/2;
