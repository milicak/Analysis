function [rho,al0,lambda,p0] = wright_eos2(T,S,P)
% EQN_STATE_WRIGHT(T,S,P)
%
% Returns the in situ density in kg/m^3.
%
% T - potential temperature relative to the surface in C.
% S - salinity in PSU.
% P - pressure in Pa.
%
% Coded for Matlab by W. Anderson 9/07

%a0 = 7.057924e-4; a1 = 3.480336e-7; a2 = -1.112733e-7;
%b0 = 5.790749e8;  b1 = 3.516535e6;  b2 = -4.002714e4;
%b3 = 2.084372e2;  b4 = 5.944068e5;  b5 = -9.643486e3;
%c0 = 1.704853e5;  c1 = 7.904722e2;  c2 = -7.984422;
%c3 = 5.140652e-2; c4 = -2.302158e2; c5 = -3.079464;

a0 = 7.133718e-4; a1 = 2.724670e-7; a2 = -1.646582e-7;
b0 = 5.613770e8;  b1 = 3.600337e6;  b2 = -3.727194e4;
b3 = 1.660557e2;  b4 = 6.844158e5;  b5 = -8.389457e3;
c0 = 1.609893e5;  c1 = 8.427815e2;  c2 = -6.931554;
c3 = 3.869318e-2; c4 = -1.664201e2; c5 = -2.765195;

al0 = a0 + (a1*T +a2*S);
p0 = (b0 + b4*S) + T .* (b1 + T.*(b2 + b3*T) + b5*S);
lambda = (c0 +c4*S) + T .* (c1 + T.*(c2 + c3*T) + c5*S);
rho = (P + p0) ./ (lambda + al0.*(P + p0));
