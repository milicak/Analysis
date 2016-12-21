% function [correlations]=my_corr(vector,matrix,option);
%
%  A method to do a fast calculation of the correlation
%  coeffisients at zero time lag. We can have two input, where both
%  may be vectors, both matrices or the first vector and the last a
%  matrix. The corrlations will be calculated along the columns of the
%  matrix. The length of the vector must equal the numbers of
%  rows in the matrix.
%
%  Use option='l' or option='m' to remove linear trend or mean value.
%  (default is none)
%
%  Just another excellent ad hoc program by Tore Furevik
%
%  Modified so that it accepts nan-entries in the input.
%
%  22/11/06 Tor Eldevik
%
%  corrected for nonhom. when you remove NaNs
%
%  12/6/07 Tor Eldevik
%

function [out]=my_corr(in1,in2,opt);
if nargin<2
 disp('You must provide two input arguments');
 return;
end;

if nargin<3 opt='n'; end;

if size(in2,1) == 1 
  in1 = in1';
  in2 = in2';
end

II=find(~isnan(in1)&~isnan(in2));
in1=in1(II);in2=in2(II);

[I1,J1]=size(in1); [I2,J2]=size(in2);
if I1~=I2 in1=in1'; end;
[I1,J1]=size(in1);
if I1~=I2
 disp('Error lengths');
 out=0;
 return;
elseif size(II,1)==0
 out=NaN;
 return;
end;

% use option;
%if opt=='l'; in1=detrend(in1); in2=detrend(in2); end; % requires homog. in1 and in2
if opt=='l';
  P1=polyfit(II,in1,1);
  P2=polyfit(II,in2,1);
  in1=in1-(P1(1)*II+P1(2));
  in2=in2-(P2(1)*II+P2(2));
end
if opt=='m'; in1=detrend(in1,'constant'); in2=detrend(in2,'constant'); end;

if J1==1; in1=meshgrid(in1,1:J2)'; end;

out=sum(in1.*in2,1)./sqrt(sum(in1.*in1,1).*sum(in2.*in2,1));
