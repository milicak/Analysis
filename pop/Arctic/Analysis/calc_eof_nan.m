function [pattern,pc,expl_var]=calc_eof_nan(data,lat,n)

% data (nlat x nlon x ntime) 
[nlat, nlon, ntime]=size(data);

switch nargin
    case 3
        n=n;
    case 2
        n=3;
    case 1
        n=3;
        lat=ones(1,nlat);
    otherwise
        sprintf('Wrong number of input arguments')
end

% area weighting

for i=1:nlat
data_w(i,:,:)=data(i,:,:)*sqrt(cosd(lat(i)));
end

% reshape maps into vectors
vektordata=reshape(data_w,nlat*nlon,ntime);
[gridsize_orig,ntime_orig]=size(vektordata);
% deal with NaN
nan_index=find(isnan(vektordata(:,1))==1);
vektordata(nan_index,:)=[];
[gridsize,ntime]=size(vektordata);

% eof analysis
[mod,s,v]    = svd(vektordata);
    if ntime < gridsize
        s = s(1:ntime,1:ntime);
    elseif ntime > gridsize
        v = v(:,1:gridsize);
    end
    varx = diag(s).^2;
    varx = varx/sum(varx);
    amp = v*s;

% put back NaN

mod_neu=NaN(gridsize_orig,gridsize);
gibts=0;
for ii=1:gridsize_orig
    if isempty(find(nan_index==ii))==1
        gibts=gibts+1;
        mod_neu(ii,:)=mod(gibts,:);
    end
end


% selection of n first eofs
for i=1:n
    pattern_unw(:,:,i)=reshape(mod_neu(:,i),nlat,nlon)*std(amp(:,i)); 
    pc(:,i)=amp(:,i)/std(amp(:,i));
    expl_var(i)=varx(i);
end
    

% undo area weighting

for i=1:nlat
    pattern(i,:,:)=pattern_unw(i,:,:)/sqrt(cosd(lat(i)));
end

% standardize sign of pattern

[na,nb,nc]=size(pattern);

for i=1:nc
if pattern(1,1,i)<0
    pattern(:,:,i)=-pattern(:,:,i);
    pc(:,i)=-pc(:,i);
end
end




end
