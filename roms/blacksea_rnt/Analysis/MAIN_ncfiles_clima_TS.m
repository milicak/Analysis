
if ~exist('nameit','var')
  nameit='blacksea';
  grd=rnt_gridload(nameit);
  outdir='./';
  clmfile=[outdir,nameit,'-clim.nc'];
end

% select which option you want
DoLevClima=1 ;  % for Levitus


%==========================================================
%	% Levitus Climatology for TS
%==========================================================

if DoLevClima==1
disp (' ----------STAGE 3 ----------');
disp(' Doing Levitus Clima ...');
if exist(levfile) ==0 
   updateClima =0;
   levitus = rnc_LevitusClima(grd,clmfile,updateClima); % LevitusClima.m
   save (levfile,'levitus')
else
   load (levfile,'levitus')
end   
   updateClima =1;
   rnc_UpdateLevitusClima(grd,clmfile,levitus); % LevitusClima.m
disp(' DONE.');
end




% /d6/edl/ROMS-pak/matlib/rnc/rnc_LevitusClima.m
