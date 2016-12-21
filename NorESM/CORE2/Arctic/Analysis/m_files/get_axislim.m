function [limX, DX,CI] = get_axislim(x,ntick,xmin,exclude_outliers);
% given an array x, gets the best axis limits and increment for plots
%[limX, DX,CI] = get_axislim(x,ntick,xmin,exclude_outliers);

if nargin<2 ntick=[];xmin=[];exclude_outliers=0;end
if nargin<3; xminflag=0;exclude_outliers=0;
else
xminflag=1;
end
if nargin<4; exclude_outliers=0;end
if isempty(x) | all(isnan(x));
    limX=[-1 1];
    DX=[0.5];
    CI=limX(1):DX:limX(2);
else
    %Mehmet
    x=denan(x(:));
    
    if exclude_outliers
   [in_spike,x]=despike1(x,5);
    end
        
    choices = [.1 .15 .2 .25 .3 .4 .5 .6 .75 .8];
    choices = cat(1,choices(:),choices(:).*10,choices(:).*100,100);
    
    if nargin<3 | isempty(xmin)
        xmin=min(min(x));
    end
    xmax=max(max(x));
    Xrange = xmax-xmin;
    
    if Xrange==0
        limX=[-1 1]; DX=1;
    else
        
        delta_step = 10.^(round(log10(Xrange)-1));
        
        if isempty(ntick)
            delta_typic=(xmax-xmin)/12;
            
            choices=choices.*delta_step;
            
            in=find(choices>=delta_typic);
            if ~isempty(in); DX=choices(in(1));
            else DX=1; end
            
            limX(1,1) = DX.*floor(xmin./DX);
            limX(1,2) = DX.*ceil(xmax./DX);
            
        else
            
            DX1=Xrange/(ntick);
            choices=choices.*delta_step;
            in=find(choices>=DX1);
            if ~isempty(in)
                for ii=1:length(in)
                    DXi=choices(in(ii));
                    
                    if xminflag
                        temp1=xmin;
                    else
                    temp1=roundto(xmin,DXi,'down');
                    end
                    temp2=temp1:DXi:temp1+(ntick-1)*DXi;
                    if temp2(end)>xmax; DX=DXi;
                        limX(1,1) = temp1;
                        limX(1,2) = temp2(end);
                        
                        break;
                    else
                        if ii==length(in)
                            disp('could not find it!!');
                            DX=1;
                            limX(1,1) = DX.*floor(xmin./DX);
                            limX(1,2) = DX.*ceil(xmax./DX);
                        end
                    end
                end
                
            else
                DX=1;
                limX(1,1) = DX.*floor(xmin./DX);
                limX(1,2) = DX.*ceil(xmax./DX);
            end
            
            
        end
        
    end
    CI=limX(1):DX:limX(2);
end
