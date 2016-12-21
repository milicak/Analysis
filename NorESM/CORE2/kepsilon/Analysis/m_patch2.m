function h=m_patch2(long,lat,c)
% M_PATCH2 Create patches on a map
%    M_PATCH2(LONG,LAT,C) is a drop-in replacement for PATCH that uses 
%    longitude/latitude coordinates to draw a patch on the current map. 
%    See PATCH for more details about the way in which patch colours and 
%    properties should be specified.
%
%    See also M_LINE, M_LL2XY

% Mats Bentsen (mats@nersc.no) 2005/11/23

% Check number of input/output arguments
error(nargchk(3,3,nargin))
error(nargoutchk(0,1,nargout))

% Check dimensions and type of input arguments
if ndims(long)~=2|ndims(lat)~=2
  error('Data may not have more than 2 dimensions.')
end
if ndims(c)>3|(ndims(c)==3&size(c,3)~=3)
  error('C must be [MxN] or [MxNx3].')
end
if size(long,1)==1
  long=long';
end
if size(lat,1)==1
  lat=lat';
end
if size(long)~=size(lat)
  error('Vectors must be the same lengths.')
end
[m n]=size(long);
if isstr(c)
  if length(c)~=1|~any(strcmp(c,{'r' 'g' 'b' 'c' 'm' 'y' 'w' 'k'}))
    error('Error in color/linetype argument.')
  end
  onecolor=1;
elseif length(c)==1
  onecolor=1;
elseif ndims(c)==2&size(c,1)==1&size(c,2)==3
  if ~isempty(find(isnan(c)|c<0|c>1))
    error(['Color value contains NaN, or element out of range ' ...
           '0.0 <= value <= 1.0.'])
  end
  onecolor=1;
else
  if ndims(c)==2&size(c,1)==1&n==1
    c=c';
  end
  if (size(c,1)~=1&size(c,1)~=m)&size(c,2)~=n
    error('Size of C must match sizes of LONG LAT.')
  end
  onecolor=0;
end

global MAP_PROJECTION MAP_VAR_LIST

if isempty(MAP_PROJECTION)
  error('No Map Projection initialized - call M_PROJ first!');
end

% Only consider patches where all colors are not NaN
if ~onecolor
  iptch=find(~isnan(mean(mean(c,3),1)))';
  long=long(:,iptch);
  lat=lat(:,iptch);
  c=c(:,iptch,:);
end

% Make sure the longitudes fit within the range defined by the map
longoffset=0.5*(MAP_VAR_LIST.longs(1)+MAP_VAR_LIST.longs(2))-180;
long=mod(long-longoffset,360)+longoffset;

% Only consider the patches that lies inside or partly inside the map
[x,y]=m_ll2xy(long,lat,'clip','point');
nanvrtx=sum(isnan(x));
iptch=find(nanvrtx>0&nanvrtx<m);
[x(:,iptch),y(:,iptch)]=m_ll2xy(long(:,iptch),lat(:,iptch),'clip','off');
iptch=find(nanvrtx<m);
x=x(:,iptch);
y=y(:,iptch);
if ~onecolor
  c=c(:,iptch,:);
end
long=long(:,iptch);
lat=lat(:,iptch);


% Handle patches that crosses two borders. This is done by comparing the
% orientation (clockwise/counterclockwise) of the patch on the map and
% the patch stereographically projected onto the plane with the first
% vertex in origo.
rad=pi/180;
z=tan((90-lat)*rad/2).*exp(i*long*rad);
w=ones(m,1)*(tan((90-lat(1,:))*rad/2).*exp(i*long(1,:)*rad));
z=(z-w)./(conj(w).*z+1);
za=sum(real(z([2:m 1],:)+z(:,:)).*imag(z([2:m 1],:)-z(:,:)));
xya=sum((x([2:m 1],:)+x(:,:)).*(y([2:m 1],:)-y(:,:)));
iptch=find(sign(za)~=sign(xya));
longoffset=ones(m,1)*min(long(:,iptch))-180;
longt=mod(long(:,iptch)-longoffset,360)+longoffset;
[x(:,iptch),y(:,iptch)]=m_ll2xy(longt,lat(:,iptch),'clip','off');
longoffset=ones(m,1)*max(long(:,iptch))-180;
longt=mod(long(:,iptch)-longoffset,360)+longoffset;
jptch=(n+1):(n+length(iptch));
[x(:,jptch),y(:,jptch)]=m_ll2xy(longt,lat(:,iptch),'clip','off');
if ~onecolor
  c(:,jptch,:)=c(:,iptch,:);
end

% Draw the patches
h=patch(x,y,c);
axis([MAP_VAR_LIST.xlims MAP_VAR_LIST.ylims])

if nargout==0,
 clear h
end
