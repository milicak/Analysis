function []=micom_flat(field,pclon,pclat)

% Check number of input/output arguments
%error(nargchk(1,2,nargin))
%error(nargoutchk(0,0,nargout))

%global pclon pclat MAP_PROJECTION

if isempty(pclon) & isempty(pclat)
  pclon=reshape(ncgetvar('../../climatology/Analysis/grid.nc','pclon'),[],4)';
  pclat=reshape(ncgetvar('../../climatology/Analysis/grid.nc','pclat'),[],4)';
end

%if isempty(MAP_PROJECTION)
  m_proj('Equidistant Cylindrical','lon',[-180 180],'lat',[-90 90]);
%end

if nargin==2
  ind=find(~isnan(field));
  h=m_patch2(pclon(:,ind),pclat(:,ind),reshape(field(ind),1,[]));
  set(h,'edgecolor','none')
  ind=find(isnan(field));
  h=m_patch2(pclon(:,ind),pclat(:,ind),nancol);
  set(h,'edgecolor','none')
else
  h=m_patch2(pclon,pclat,reshape(field,1,[]));
  set(h,'edgecolor','none')
end
