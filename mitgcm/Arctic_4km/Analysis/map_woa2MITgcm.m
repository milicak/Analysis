% Function to map PHC3 data fields to MITgcm grid.
% itimu Jan 10

% "P" indicates "woa13" variable, "M" indicates MITgcm.
function Mfield = map_woa2MITgcm(Pfld,lonMIT,latMIT,PlonsGlob,PlatsGlob,Mlevs,Plevs,nanrepval) 

% Build PHC lons lats and levs: check phc_info.txt
%PlonsGlob  =   0.5:1:359.5;
% if longitude gt 180 then make -ve
%neg = find(PlonsGlob > 180);
%PlonsGlob(neg) = -(360-PlonsGlob(neg)); 

Plandval = -99 ;

%find PHC indices containing MITgcm region
ind_w = floor(interp1(PlonsGlob,1:length(PlonsGlob),min(lonMIT(:))-1)) ; 
ind_e =  ceil(interp1(PlonsGlob,1:length(PlonsGlob),max(lonMIT(:))+1)) ;
ind_s = floor(interp1(PlatsGlob,1:length(PlatsGlob),min(latMIT(:))-1)) ;
ind_n =  ceil(interp1(PlatsGlob,1:length(PlatsGlob),max(latMIT(:))+1)) ;
ind_w = 1;
ind_e = length(PlonsGlob);
ind_n = length(PlatsGlob);

Plons = PlonsGlob(ind_w:ind_e);
Plats = PlatsGlob(ind_s:ind_n);
Pf = Pfld(ind_w:ind_e,ind_s:ind_n,:);
%Pf = Pfld;

[lonPHC,latPHC] = meshgrid(Plons,Plats) ;
lonPHC = lonPHC';
latPHC = latPHC';

dnm = Pf;
% use Objective Analysis (OA) to remove NaNs from woa fields
for k=1:size(Pf,3)
    Pf(:,:,k)=get_missing_val(double(lonPHC),double(latPHC),squeeze(Pf(:,:,k)),NaN,0,nanrepval);
end

% Build MITgcm grid
%[lonMIT,latMIT] = meshgrid(Mlons,Mlats) ;

% Extend PHC field at the bottom so no extrapolation is needed.
maxdep = max(Mlevs) + 100 ;  % Add 100m to deepest depth in MITgcm model
%Plevs = [Plevs maxdep];
%Pf = cat(3,Pf,Pf(:,:,end)) ; % Add level at bottom to the PHC field itself
%Pf = permute(Pf,[2 1 3]);

% Stage 1.
% Loop through each PHC grid point and interpolate vertically to MITgcm
% taking into account only the PHC's sea values
Pf_new = Plandval*ones(size(lonPHC,1),size(lonPHC,2),length(Mlevs)) ;
fprintf(1,' Interpolate PHC levs to MITgcm depths...') ;
for jj = 1:length(Plats)
   fprintf(1,'.') ; 
   for ii = 1:length(Plons)      
      tmpPf = squeeze(Pf(ii,jj,:)) ;    
      sea = find(tmpPf ~= Plandval) ;
      if(~isempty(sea)) %interpolate only if there are sea points, use land value for extrapolation value
          Pf_new(ii,jj,:) = interp1(Plevs(sea),tmpPf(sea),Mlevs,'linear',Plandval) ;
      end    
      clear tmpPf sea
   end % ii
end % jj
fprintf(1,'done.\n') ;

% Stage 2.
% Loop over depth and interpolate horizontally to MITgcm grid
% taking into account only the PHC's sea values
fprintf(1,' Loop over depths interpolating to MITgcm grid...(slow!)') ;
Mfield = zeros(size(lonMIT,1),size(lonMIT,2),length(Mlevs)) ;
for kk = 1:length(Mlevs)   % Loop over MITgcm levels.
    fprintf(1,'.') ;
    tmpPf = squeeze(Pf_new(:,:,kk)) ;
    lndmask = find(tmpPf == Plandval) ;
    seamask = find(tmpPf ~= Plandval) ;
   %assign values to land pts based on closest sea points
    if(~isempty(lndmask) & ~isempty(seamask))
        tmpPf(lndmask) = griddata(lonPHC(seamask),latPHC(seamask),tmpPf(seamask),lonPHC(lndmask),latPHC(lndmask),'nearest');
    end
   %now interpolate without any worries 
    %Mfield(:,:,kk) = interp2(lonPHC,latPHC,tmpPf,lonMIT,latMIT,'cubic') ;
    Mfield(:,:,kk) = griddata(double(lonPHC),double(latPHC),tmpPf,lonMIT,latMIT,'cubic') ;
    clear tmpPf seamask
end % kk

fprintf(1,'done.\n') ;

return
