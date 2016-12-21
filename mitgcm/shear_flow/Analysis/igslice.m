function hout = iGslice(varargin)
%iGSLICE  Volumetric slice plot into an irregular volume by interpolation.
% 
% iGSLICE(X,Y,Z,V,Sx,Sy,Sz) draws slices along the x,y,z directions at
%   the points in the vectors Sx,Sy,Sz. The arrays X,Y,Z define the
%   coordinates for V. X,Y,Z and V must be 3D matrices, however, Z and V do
%   not need to be monotonic and may contain NaNs. It is assumed that NaNs
%   in Z and V occur in the same positions, such that Z(isfinite(V)) would
%   return finite values only.
%   It is also assumed that X,Y,Z,V have the same indexing as grids
%   produced by MESHGRID. 
%   Z at each point is determined by 2D interpolation into each 'layer' of
%   Z, where layer i would be Z(:,:,i).
%   The color at each point will be determined by 3-D interpolation into 
%   the volume V, using TriScatteredInterp.
%
%   To call iGSlice with slices in only 1 or 2 coordinate directions, enter
%   0 for the remainder.
%
% iGSLICE(X,Y,Z,V,Sx,Sy,Sz,F), uses F as the 3D interpolant, where
%   F=TriScatteredInterp(Xx,Yy,Zz,Vv) and Xx=X, Yy=Y, Zz=Z, Vv=V,
%   and Xx(~isfinite(Vv))=[]; Yy(~isfinite(Vv))=[]; Zz(~isfinite(Vv))=[];
%   Vv(~isfinite(Vv))=[];
%   Using iGSlice in this manner is HIGHLY reccomended as the interpolant
%   does not need to be calculated with each call to iGSlice, improving 
%   performance.
%
% iGSLICE(...,'method') specifies the interpolation method to use.
%   'method' can be 'linear', 'cubic', or 'nearest'.  'linear' is the
%   default (see griddata3).
%
%   iGSLICE(AX,...) plots into AX instead of GCA.
%
%   H = iGSLICE(...) returns a vector of handles to SURFACE objects.
%
%   The axes CLim property is set to span the finite values of V.
%   
%   SEE ALSO, quickSlice,TriScatteredInterp, griddata, ndgrid, slice 

% James Ramm $Date: 23/01/2011 16:25:18 $
% james.ramm@geo.au.dk


[cax,args,nargs] = axescheck(varargin{:});
error(nargchk(4,8,nargs,'struct'));

cax = newplot(cax);
hold_state = ishold(cax);

method = 'linear';

nin = nargs;
if ischar(args{nin}), % slice(...,'method')
    method = args{nin};
    nin = nin - 1;
end
if nin < 7
    error(id('WrongNumberOfInputs'),'Wrong number of input arguments.')
elseif nin == 7 || nin == 8, % slice(x,y,z,v,xi,yi,zi,<nx>)
    v = args{4};
    args{4} = [];
    if ndims(v)~=3, error(id('InvalidVDims'),'V must be a 3-D array.'); end
    [nx,ny,nz] = size(v);
    [x,y,z] = deal(args{1:3});
    [sx,sy,sz] = deal(args{5:7});
end

%If the interpolant, F is there, retrieve it, otherwise calculate.
if nin == 8;
    F=args{8};
    if size(F.X,2) ~= 3;
        error(id('InvalidXDims'),'The dimensions of the interpolant,F, are invalid');
    end
elseif nin==7
    %Remove Nans and inf from V data and corresponding values from coords.
    xx=x(isfinite(v));
    yy=y(isfinite(v));
    zz=z(isfinite(v));
    vv=v(isfinite(v));
    % Setup 3D interpolant for v interpolation.
    F=TriScatteredInterp(xx,yy,zz,vv);
end
h = [];
if sx,
    
    [xi,yi] = meshgrid(sx,y(:,1,1));
    zi=zeros(size(xi,1),size(xi,2),nz);
    for i = 1:nz
        zi(:,:,i)=griddata(x(:,:,1),y(:,:,1),z(:,:,i),xi,yi,method); %griddata
        %allows NaN, TriScatteredInterp does not. We need to preserve the
        %original matrix shape here to grid by layer.
    end
    xi=squeeze(repmat(xi,[1,1,26])); %xy coords need to be replicated to nz
    yi=squeeze(repmat(yi,[1,1,26])); % and extra D squeezed out
    zi=squeeze(zi);
    
    vi=F(xi,yi,zi);
    
    
    for i = 1:length(sx)
        h = [h; surface(reshape(xi(:,i,:),[nx,nz]),reshape(yi(:,i,:),[nx,nz]),...
            reshape(zi(:,i,:),[nx,nz]),reshape(vi(:,i,:),[nx,nz]), ...
            'parent',cax)];
    end
end
if sy,
    clear zi vi xi yi
    [xi,yi] = meshgrid(x(1,:,1),sy);
    for i = 1:nz
        zi(:,:,i)=griddata(x(:,:,1),y(:,:,1),z(:,:,i),xi,yi);
    end
    xi=squeeze(repmat(xi,[1,1,26])); %xy coords need to be replicated to nz
    yi=squeeze(repmat(yi,[1,1,26])); % and extra D squeezed out
    zi=squeeze(zi);
    
    vi=F(xi,yi,zi);
    
    for i = 1:length(sy)
        h = [h; surface(reshape(xi(i,:,:),[ny,nz]),reshape(yi(i,:,:),[ny,nz]),...
            reshape(zi(i,:,:),[ny,nz]),reshape(vi(i,:,:),[ny,nz]), ...
            'parent',cax)];
    end
end
if sz
    [xi,yi,zi] = meshgrid(x(1,:,1),y(:,1,1),sz);
    vi=F(xi,yi,zi);
    
    for i = 1:length(sz)
        h = [h; surface(reshape(xi(:,:,i),[nx,ny]),reshape(yi(:,:,i),[nx,ny]),...
            reshape(zi(:,:,i),[nx,ny]),reshape(vi(:,:,i),[nx,ny]), ...
            'parent',cax)];
    end
else
    %   vi = F(sx,sy,sz);
    %    h = surf(sx,sy,sz,vi,'parent',cax);  %SLICE code for slicing
    %    across a surface. This is untested so commented.
end

if nargout > 0
    hout = h;
end
if ~hold_state
    view(cax,3), grid(cax,'on')
end

% Use ISFINITE to make sure no NaNs or Infs get passed to CAXIS
u=v(isfinite(v)); u = u(:);
caxis(cax,[min(u) max(u)]);
% Signal to the world that we have created a new plot:
plotdoneevent(cax,h);

function str=id(str)
str = ['MATLAB:slice:' str];
