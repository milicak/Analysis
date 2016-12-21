
nameit=input('Name of grid = ');
grd=rnt_gridload(nameit);

datadir='.';
outdir='./';

% the following file will be made if it does not exist.
levfile=         [outdir,'Levitus.mat'];

clmfile=[outdir,nameit,'-clim.nc'];
bryfile=[outdir,nameit,'-bry.nc'];
initfile=[outdir,nameit,'-init.nc'];
forcfile=[outdir,nameit,'-forc.nc'];

disp('Current Settings:');
setng.nameit=nameit;
setng.outputdir=outdir;
setng
input('Return to continue ... (CTRL-C to stop) ');

%==========================================================
%	% create files
%==========================================================

disp (' ----------STAGE 1: Creating NC files ----------');
if exist(bryfile) == 0
      disp(' Creating bry ..');
      rnc_CreateBryFile(grd,bryfile) 
end
if exist(clmfile) == 0   
      disp(' Creating clim ..');
      rnc_CreateClimFile(grd,clmfile)
	 
end
if exist(forcfile) == 0
      disp(' Creating forc ..');
	rnc_CreateForcFile(grd,forcfile)	
end
if exist(initfile) == 0
      disp(' Creating init ..');
	rnc_CreateIniFile(grd,initfile);
end


input('Continue with climatology interpolation ... (CTRL-C to stop) ');

%==========================================================
%	do the CLIMATOLOGY
%==========================================================

rnc_SetClimaConst(grd,clmfile);
MAIN_ncfiles_clima_TS   %MAIN_ncfiles_clima_TS.m

% now that you extracted levitus verify that the resolution
% of the extracted data is adeguate for the grid you are 
% preparing.
%     load Levitus
%     rnt_plc(grd.h*nan,grd,0,5,0,0); 
%     pcolor(levitus.lon,levitus.lat,levitus.mask(:,:,1,1))
%     shading interp;



MAIN_ncfiles_clima_UV   %MAIN_ncfiles_clima_UV.m



% The following run by hand interactively first use.

%==========================================================
%	do the FORCING   (MAIN_ncfiles_forc.m)
%==========================================================
rnc_SetForcZero(grd,forcfile);
MAIN_ncfiles_clima_forc

% need to add SST  and SSS to forcing
rnc_AddSSTfromClima(clmfile,forcfile);  % touch AddSSTfromClima.m
rnc_AddSSSfromClima(clmfile,forcfile);  % AddSSSfromClima.m


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

vars = { 'sms_time' 'shf_time' 'swf_time' 'sst_time' 'sss_time' 'srf_time'};
nc=netcdf(forcfile,'w');
climatime=15:30:360;
for i=1:length(vars)
  nc{vars{i}}(:) = climatime;
end
close(nc);




%==========================================================
%	do the INITIAL CONDITION  and BOUNDARY FILE
%==========================================================

timeindex=1;  % put timelevel 5 as initial condition
rnc_SetInitFromClim(grd,clmfile,initfile,timeindex);
rnc_SetBryFromClim(grd,clmfile,bryfile);





% plotting stuff ...

disp('Plotting NC Files using function PlotNCfiles(nameit, outdir)');
rnc_PlotNCfiles(nameit, outdir)

ctli=rnt_timectl({initfile},'ocean_time');
ctlc=rnt_timectl({clmfile},'tclm_time');
ctlf=rnt_timectl({forcfile},'sms_time');

save CTLs.mat ctli ctlc ctlf grd
clear
load CTLs
whos
% now add dQdSST



