function r=p_alpha(p,p0,th,s)

rho_18_const

b1i=1./(b11+b12*th+b13*s);
a1=(a11+th.*(a12+a14*th+a15*s)+s.*(a13+a16*s)).*b1i;
a2=(a21+th.*(a22+a24*th+a25*s)+s.*(a23+a26*s)).*b1i;
b2=(b21+b22*th+b23*s).*b1i;

r=b2.*(p-p0)+(a2-a1.*b2).*log((a1+p)./(a1+p0));
