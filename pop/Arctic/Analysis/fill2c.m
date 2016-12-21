%FILL2C		fill 2D areas below/above a threshold with different colors
%
%		FILL2C fills the areas defined by a 2D data sequence X/Y
%		and a threshold value (TH) with two user definable sets
%		of colors
%			set 1	for	Y  <=  TH (NEG)
%			set 2	for	Y  >=  TH (POS)
%		X/Y NaNs/Infs (NI) are removed in accordance with PLOT.
%		a sequence of data that contains NIs is split into
%		blocks of NEG/POS areas, which my be colored individually
%		depending on the size of the color set(s).
%		X values at TH crossings are computed during runtime and
%		optionally returned for later use.
%
%		See also: fill, area, patch, plot, line
%
%SYNTAX
%-------------------------------------------------------------------------------
%		[PH,PAR] = FILL2C(X,Y,CN,CP);
%		[PH,PAR] = FILL2C(X,Y,CN,CP,TH);
%
%INPUT
%-------------------------------------------------------------------------------
% X	:	X data vector
% Y	:	Y data vector
% CN	:	color(s) of NEG data areas
% CP	:	color(s) of POS data areas
%		arrays are either color symbols ['r','g',etc.]
%		or normalized rgb triplets.
%		if a color is empty, the respective NEG/POS areas
%		are not painted.
%		if an array of colors is selected, the colors are
%		(re)cycled for each area block.
% TH	:	Y value threshold between NEG/POS areas               [def: 0]
%
%OUTPUT
%-------------------------------------------------------------------------------
% PH	:	array of handles to all (individual)
%		NEG and POS area patches
% PAR	:	structure with fields
%		.th	TH
%		.nx	indices of NIs into X and Y
%		.xc	value(s) of zero crossing(s)
%		.dn	X/Y values of NEG areas
%		.dp	X/Y values of POS areas
%		.pn	handles to NEG area patches only
%		.pp	handles to POS area patches only
%
%NOTE
%-------------------------------------------------------------------------------
%		- X data vectors must be sorted in ascending order.
%		- filled areas are stacked from the bottom of other
%		  graphic objects of the current axis.
%		- latest patches are stacked on top of older ones.
%		- if Cx is empty, .xc/.dn/.dp are still computed.
%
%NOTE
%-------------------------------------------------------------------------------
%		- X data vectors must be sorted in ascending order
%		- filled areas are stacked from the bottom of other
%		  graphic objects of the current axis
%		- latest patches are stacked on top of older ones
%		- if Cx is empty, .xc/.dn/.dp are still computed
%
%EXAMPLE
%-------------------------------------------------------------------------------
%		x=[-5,2,3,4,9,10,12,nan,nan,13:20];
%		y=rand(size(x))-.5;
%		y(end-3:end-2)=inf;
%		plot(x,y,'-ok','markerfacecolor',[0,0,0]);
%		fill2c(x,y,[0,.75,.75],'y');

% test stuff
%	xx=@(a) line([min(a(:)),max(a(:))],[0,0],[-1,-1],'color',.85*[1,1,1]);
%	x=[NaN   -10    -1     2     3   NaN     9    10   NaN    12];
%	y=[  0   NaN     1     2     3     5     9    10    11    12];
%

% created:
%	us	22-Mar-2008 us@neurol.unizh.ch
% modified:
%	us	04-Apr-2008 13:12:58

%-------------------------------------------------------------------------------
function	[p,par]=fill2c(x,y,cn,cp,yoff)

% common parameters
		magic='FILL2C';
		pver='04-Apr-2008 13:12:58';
% macros
% - find zero crossings
		fz=@(x,y) unique(x(:,1)-diff(x,[],2).*y(:,1)./diff(y,[],2));

	if	nargout
		p=[];
	end
		par.magic=magic;
		par.([magic,'ver'])=pver;
		par.MLver=version;
		par.th=0;
		par.nx=[];
		par.xc=[];
		par.dn=[];
		par.dp=[];
		par.pn=[];
		par.pp=[];

	if	nargin < 4
		help(mfilename);
		return;
	end
	if	nargin > 4
		par.th=yoff;
	end

% simple sanity check
	if	check_data(false,par,x,y)
		return;
	end

		x=x(:);
		y=y(:)-par.th;

% check/handle NaNs/Infs
		par.nx=find_naninf(x,y);
		[x,y,xd,yd]=replace_naninf(par.nx,x,y);
	if	check_data(true,par,x,y)
		return;
	end

% compute zero crossings
		e=find(sign(y(1:end-1))~=sign(y(2:end)));
	if	~isempty(e)
		zx=[x(e),x(e+1)];
		zy=[y(e),y(e+1)];
		par.xc=fz(zx,zy);
	end

% create NEG/POS patches
		oh=ishold;
		hold on;

		in=sign(y)>0;
		[par.pn,par.dn]=set_patch(par,x,y,par.xc,xd,yd, in,cn);
		[par.pp,par.dp]=set_patch(par,x,y,par.xc,xd,yd,~in,cp);
		p=[par.pn;par.pp];
		set(p,...
			'tag',par.magic);

% - put patches at bottom of all graphic handles of the current axis
		pho=findall(gca,'tag',par.magic);
		uistack(pho,'bottom');

	if	~oh
		hold off;
	end
	if	~nargout
		clear p par;
	end
end
%-------------------------------------------------------------------------------
function	tf=check_data(mode,par,x,y)

		tf=false;
	if	numel(x) < 1				||...
		numel(y) < 1				||...
		numel(x) ~= numel(y)
		disp(sprintf('%s> ERROR: vector(s) are either empty or not of equal size',par.magic));
		tf=true;
		return;
	end
	if	~mode
		return;
	end
	if	~issorted(x)
		disp(sprintf('%s> ERROR: X-data are not sorted',par.magic));
		tf=true;
		return;
	end
end
%-------------------------------------------------------------------------------
function	nx=find_naninf(x,y)

		nx=find(...
			isnan(x)|...
			isnan(y)|...
			isinf(x)|...
			isinf(y)...
		);
end
%-------------------------------------------------------------------------------
function	[x,y,xd,yd]=replace_naninf(nx,x,y)

		xd=[];
		yd=[];

% clear NaNs/Infs
% - must handle X/Y size of 1

	if	nx

% - X/Y may be of size 1!
		ix=[1,numel(x)];
	if	numel(x) < 2
		ix=1;
	end

% - remove NaNs/Infs at start/end of data vectors
	while	nx
		nx=find(...
			isnan(x(ix))|...
			isnan(y(ix))|...
			isinf(x(ix))|...
			isinf(y(ix))...
		);
		x(ix(nx))=[];
		y(ix(nx))=[];
	if	isempty(x)
		return;
	end
		ix=[1,numel(x)];
	if	numel(x) < 2
		ix=1;
	end
	end

% - replace embedded NaNs/Infs
		nx=find_naninf(x,y);
		in=nx;
		in(in==1|in==numel(x))=[];
		xd=[x(in-1);x(in+1)];
		yd=[inf(size(x(in-1)));-inf(size(x(in+1)))];
		x(nx)=[];
		y(nx)=[];
		nx=find_naninf(xd,xd);
		xd(nx)=[];
		yd(nx)=[];
	end
end
%-------------------------------------------------------------------------------
function	[p,xy]=set_patch(par,x,y,ze,xd,yd,in,c)

% patches must be created individually for each epoch because of
% possible singular NaNs/Infs, which require the EDGECOLOR to be
% painted!

		xe=x.';
		ye=y.';
		ze=ze.';
		xe(in)=[];
		ye(in)=[];
		xt=[x(1),ze,x(end),xd.'];
		yt=[-inf,zeros(size(ze)),inf,yd.'];
		xy=sortrows([[xe.';xt.'],[ye.';yt.']]);

% - determine Nan/Inf delimited blocks
		ip=~isinf(xy(:,2)).';
		ib=strfind(ip,[0,1]);
		ie=strfind(ip,[1,0])+1;
		in=ie-ib+1;

		xy(isinf(xy))=0;
		xy(:,2)=xy(:,2)+par.th;

	if	isempty(c)
		p=[];
		return;
	end

		nb=numel(ib);
% - the colors
	if	ischar(c)
		c=c(:);
	end
		c=repmat(c,nb,1);
		c=c(1:nb,:);

% - the patches
		p=nan(nb,1);
		nc=0;
	for	i=1:nb
		pp=xy(ib(i):ie(i),:);
	if	in(i) > 3
		nc=nc+1;
		p(i)=patch(pp(:,1),pp(:,2),c(nc,:),...
			'edgecolor','none');
	elseif	pp(2,2) ~= 0
		nc=nc+1;
		p(i)=patch(pp(:,1),pp(:,2),c(nc,:),...
			'edgecolor',c(nc,:));
	end
	end
		p=p(ishandle(p));
end
%-------------------------------------------------------------------------------
