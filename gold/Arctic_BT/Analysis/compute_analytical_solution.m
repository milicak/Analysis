% The Arctic and Subarctic Ocean Flux of Potential Vorticity and the Arctic Ocean Circulation
% Jiayan Yang
% this routine solves H2H3*Q1-H1H3*(Q1+Q3)+H1H2*Q3
clear all

H1=100;
Q1=-2:0.05:2;
Q3=-3:0.05:3;

if 0
 H2=2000;
 H3=1000;
 for i=1:length(Q1)
   for j=1:length(Q3)
    PV(i,j) = H2*H3*Q1(i)-H1*H3*(Q1(i)+Q3(j))+H1*H2*Q3(j);
   end
 end
end

H2=1500:50:2500;
H3=750:50:1250;
for ii=1:length(H2);for jj=1:length(H3)
for i=1:length(Q1)
  for j=1:length(Q3)
    PV(ii,jj,i,j) = H2(ii)*H3(jj)*Q1(i)-H1*H3(jj)*(Q1(i)+Q3(j))+H1*H2(ii)*Q3(j);
  end
end
end;end
