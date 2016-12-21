function y=rm(x,n)
%RM Running mean
%    Y = RM(X,N) filters the data in the vector or matrix X with a
%    running mean with window size N.
%
%    When X is a matrix, RM operates on the columns of X.

if length(n)>1|n==0|mod(n,1)~=0,
  error('The window size must be specified by an integer greater than zero')
end
origsize=size(x);
xdm=origsize(1);
if xdm==1&ndims(x)==2,
  x=x';
  xdm=origsize(2);
end
fn2=floor(n/2);
if xdm<2*fn2+1,
  error('Window size too big compared to input matrix dimensions')
end

if mod(n,2)==0,
  b=[0.5;ones(n-1,1);0.5]/n;
else
  b=ones(n,1)/n;
end
y=filter(b,1,x);
y(fn2+1:xdm-fn2,:)=y(2*fn2+1:xdm,:);
y(1:fn2,:)=ones(size(y(1:fn2,:)))*nan;
y(xdm-fn2+1:xdm,:)=ones(size(y(xdm-fn2+1:xdm,:)))*nan;
y=reshape(y,origsize);
