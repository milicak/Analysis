function [h_sorted, vol_sorted] = sort_topog_eta(H,eta,area)
% [h_sorted, vol_sorted] = sort_topog_eta(H,eta,area)
%
% Sorts H into a deepest-first list with associated volumes of
% that depth
%
% H is the position of bottom (i.e. negative)
% eta is the position of surface
% area is cell area (looking down on the column)
%
% All arguments have the same shape/size.

if sum(abs(size(H)-size(eta))); size(H),size(eta), error('H and eta must be the same size'); end
if sum(abs(size(H)-size(area))); size(H),size(area), error('H and area must be the same size'); end

%area(eta-H==0)=0; % Zero out vanished ocean
area=area(:); H=H(:); eta=eta(:);
area(H==0)=[]; eta(H==0)=[]; H(H==0)=[]; % Remove land

msl=sum(eta(:).*area(:))/sum(area(:)); % Mean sea-level
err_msl=sum((eta(:)-msl).*area(:))/sum(area(:)); % Round-off error in mean sea-level
disp(sprintf('sort_topog_eta: MSL=%.14g m, Error in MSL=%.14g %%',msl,100*err_msl))
mbd=sum(H(:).*area(:))/sum(area(:)); % Mean bottom depth
disp(sprintf('sort_topog_eta: MBD=%.14g m',mbd))
vol=sum((eta(:)-H(:)).*area(:));
disp(sprintf('sort_topog_eta: Ocean area=%.14g m^2',sum(area)))
disp(sprintf('sort_topog_eta: Ocean volume=%.14g m^3',vol))

if max(H)>0 | min(H)==0; error('Expected H<0!'); end

[h_sorted,j]=sort(H(:)'); % Deepest first
a_sorted=area(j);         % with associated column area

vol_sorted=NaN*h_sorted; % Allocate memory
h_sorted(end+1)=msl;     % The mean sea-surface defines the top
cum_area=0;
for j=1:length(a_sorted)
  cum_area=cum_area+a_sorted(j);
  dh=h_sorted(j+1)-h_sorted(j);
  vol_sorted(j)=dh*cum_area;
end

j=find(vol_sorted==0); % These are the repeated depths
h_sorted(j)=[];
vol_sorted(j)=[];

disp(sprintf('sort_topog_eta: Ocean volume (sorted) =%.14g m^3',sum(vol_sorted)))
disp(sprintf('sort_topog_eta: Ocean volume error (sorted-orig) =%.14g %%',100*(sum(vol_sorted)-vol)/vol))
