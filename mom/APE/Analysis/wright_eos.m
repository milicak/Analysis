function [rho drho_dT drho_dS] = wright_eos(T,S,p);

nx = size(T,3); ny = size(T,2); nz = size(T,1);

a0 = 7.057924e-4; a1 = 3.480336e-7; a2 = -1.112733e-7;
b0 = 5.790749e8;  b1 = 3.516535e6;  b2 = -4.002714e4;
b3 = 2.084372e2;  b4 = 5.944068e5;  b5 = -9.643486e3;
c0 = 1.704853e5;  c1 = 7.904722e2;  c2 = -7.984422;
c3 = 5.140652e-2; c4 = -2.302158e2; c5 = -3.079464;

rho = zeros(nz,ny,nx);
%drho_dT = zeros(nz,ny,nx);
%drho_dS = zeros(nz,ny,nx);

for k=1:nz
 for j=1:ny
  for i=1:nx
    al0 = a0 + a1*T(k,j,i) +a2*S(k,j,i);
    p0 = b0 + b4*S(k,j,i) + T(k,j,i) * (b1 + T(k,j,i)*(b2 + b3*T(k,j,i)) + b5*S(k,j,i));
    lambda = c0 +c4*S(k,j,i) + T(k,j,i) * (c1 + T(k,j,i)*(c2 + c3*T(k,j,i)) + c5*S(k,j,i));
    rho(k,j,i) = (p(k,j,i) + p0) / (lambda + al0*(p(k,j,i) + p0));
    %I_denom2 = 1.0 / (lambda + al0*(p(k,j,i)+p0));
    %I_denom2 = I_denom2 * I_denom2;
    %drho_dT(k,j,i)= I_denom2*(lambda*(b1+T(k,j,i)*(2*b2 + 3*b3*T(k,j,i))+b5*S(k,j,i)) - ...
%				      (p(k,j,i)+p0)*((p(k,j,i)+p0)*a1 + ...
%	                               (c1 + T(k,j,i)*(2*c2 + 3*c3*T(k,j,i)) + c5*S(k,j,i))));
%    drho_dS(k,j,i) = I_denom2*(lambda*(b4+b5*T(k,j,i)) - (p(k,j,i)+p0)*((p(k,j,i)+p0)*a2 + (c4 + c5*T(k,j,i))));
  end
 end
end

     
