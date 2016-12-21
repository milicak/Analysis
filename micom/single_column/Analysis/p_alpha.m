function r=p_alpha(p,p0,th,s)
% Integration of alpha from p0 to p.

rho_18_const

a1=a11+(a12+a14*th+a15*s).*th+(a13+a16*s).*s;
a2=a21+(a22+a24*th+a25*s).*th+(a23+a26*s).*s;
b1=b11+b12*th+b13*s;
b2=b21+b22*th+b23*s;

b1i=1./b1;
a1b1i=a1.*b1i;

r=(b2.*(p-p0)+(a2-a1b1i.*b2).*log((a1b1i+p)./(a1b1i+p0))).*b1i;
