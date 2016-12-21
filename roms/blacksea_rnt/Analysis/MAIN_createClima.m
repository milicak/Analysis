
nameit='blacksea'; 
grd=rnt_gridload(nameit);

datadir='.';
outdir='./';

% the following file will be made if it does not exist.
levfile=         [outdir,'Levitus.mat'];

clmfile=[outdir,nameit,'-clim.nc'];

disp('Current Settings:');
setng.nameit=nameit;
setng.outputdir=outdir;
setng
input('Return to continue ... (CTRL-C to stop) ');

disp(' Creating clim ..');
opt.npzd=1;
rnc_CreateClimFile(grd,clmfile,opt)

rnc_SetClimaConst(grd,clmfile);
MAIN_ncfiles_clima_TS   %MAIN_ncfiles_clima_TS.m
MAIN_ncfiles_clima_UV   %MAIN_ncfiles_clima_UV.m

%==========================================================
%	% Add time indices in climatology
%==========================================================
nc=netcdf(clmfile,'w');
vars = { 'tclm_time' 'sclm_time' 'ssh_time' 'uclm_time' 'vclm_time'};
climatime=15:30:360;
for i=1:length(vars)
  nc{vars{i}}(:) = climatime;
end
close(nc);

