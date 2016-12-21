% E. Di Lorenzo ---------------------------Creating forcing files.
% Mon Mar 14 15:04:53 EST 2005


% The logic is:
% 1) Create the empty recipient forcing files for your grid
%    You can create also a forcing file for each variable separately.
% 2) Set the times in the forcing file for each time variable
% 3) Extract forcing fields
% 4) Interpolate to grid and save in ncfiles

forc_timevars= ...
    {'shf_time' 'srf_time' 'swf_time'  'sms_time'  'sst_time' 'sss_time'};

forc_vars= ...
    {'shflux'   'swrad'    'swflux' 'sustr' 'svstr' 'SST'  'SSS' 'dQdSST'};


disp('Doing FORCING ....... ');

nameit=input('Name of grid = ');
grd=rnt_gridload(nameit);
DO_CLIMATOLOGY=1;

%==========================================================
%	CLIMATOLOGY - example
%==========================================================
if DO_CLIMATOLOGY == 1
% STEP 1-2: define times and create forcing file
   forcfile=[nameit,'-forc.nc'];
   opt.sms_time=12;   opt.sms_time_cycle=360; opt.sms_timeVal=[15:30:360];
   opt.shf_time=12;   opt.shf_time_cycle=360; opt.shf_timeVal=[15:30:360];
   opt.swf_time=12;   opt.swf_time_cycle=360; opt.swf_timeVal=[15:30:360];
   opt.srf_time=12;   opt.srf_time_cycle=360; opt.srf_timeVal=[15:30:360];
   opt.sst_time=12;   opt.sst_time_cycle=360; opt.sst_timeVal=[15:30:360];
   opt.sss_time=12;   opt.sss_time_cycle=360; opt.sss_timeVal=[15:30:360];
   rnc_CreateForcFile(grd, forcfile, opt);
   
% STEP 3: Extract forcing from product of choice (NCEP in this case)
   ctlf=rnt_ctl(forcfile,'sms_time');
   vars=    {'shflux'   'swrad'    'swflux' 'sustr' 'svstr'};
   forcd = rnc_Extract_SurfFluxes_NCEP(grd.lonr,grd.latr, ctlf.datenum, 'clima',vars);
   % now get SST/SSS from Levitus
   forcd2 = rnc_Extract_LevitusTS_Clima(grd.lonr,grd.latr, ctlf.datenum,'surface');
   % get flux correction    (rnc_Extract_dQdSST_Clima.m)
   forcd3 = rnc_Extract_dQdSST_Clima(grd.lonr,grd.latr, ctlf.datenum);

   
   
   
% STEP 4:    Interpolate to grid and save in ncfiles
   rnc_Interp2grid_NCEP(ctlf,forcd,grd);
   rnc_Interp2grid_NCEP(ctlf,forcd2,grd);
   rnc_Interp2grid_NCEP(ctlf,forcd3,grd);
end








%==========================================================
%	TIME DEPENDENT MONTHLY FOCRING
%==========================================================
% we are going to make a separate file for each forcing variable
if DO_TIMEDEP == 1
year=1997:2004

% daily winds
   forcfile=[nameit,'-forc-winds_1997_2004.nc'];
   disp(forcfile);
   daysnum=rnc_returndays(year,1:12);   
   idnval=daysnum; idn=length(idnval);
   opt.sms_time=idn;   opt.sms_time_cycle=0; opt.sms_timeVal=idnval;
   rnc_CreateForcFile(grd, forcfile, opt);
   mydate = opt.sms_timeVal;
   
   % You can extract any of the following.
   
   % NCEP Reanalysis 1950-2005 (climatology, monthly and daily)
   [forcd] = rnc_Extract_SurfFluxes_NCEP(grd.lonr,grd.latr, mydate, ...
                             'daily',{'sustr' 'svstr'} );
				     
   % Reconstructed NCEP using QSCATT EOFs
   % Step 1: correct monthly data using QSCATT EOFs
   [ncepR, ncep, basis] = rnc_reconstructNCEP_with_QSCATT( ...
              grd.lonr,grd.latr,mydate,'monthly');
   % Step 2: add daily winds from NCEP	  
   [forcd] = rnc_reconstructNCEP_add_daily(grd.lonr,grd.latr,mydate,ncepR);
   
   % QSCATT gridded 25 km winds available 2000-2004 monthly only.				     
   [forcd]=qsc_Extract_QSCATT(grd.lonr,grd.latr, mydate, 'monthly') 
   
   % QSCATT/NCEP blend from Milliff et al. DSS 2000-2004
   [forcd] = rnc_ExtractNCEP_QSCATT(grd.lonr,grd.latr, mydate, 'daily');
   
   ctlf=rnt_ctl(forcfile,'sms_time');
   rnc_Interp2grid_NCEP(ctlf,forcd,grd);
   

   n=0; clear idnval
   for iy=year, for imon=1:12
   n=n+1; idnval(n)=datenum(iy,imon,15);
   end, end;
           
   idn=length(idnval); clear opt
   opt.shf_time=idn;   opt.shf_time_cycle=0; opt.shf_timeVal=idnval;
   opt.swf_time=idn;   opt.swf_time_cycle=0; opt.swf_timeVal=idnval;
   opt.srf_time=idn;   opt.srf_time_cycle=0; opt.srf_timeVal=idnval;
   opt.sst_time=idn;   opt.sst_time_cycle=0; opt.sst_timeVal=idnval;
   opt.sss_time=idn;   opt.sss_time_cycle=0; opt.sss_timeVal=idnval;
   forcfile=[nameit,'-forc-other_1997_2004.nc'];
   rnc_CreateForcFile(grd, forcfile, opt);


% STEP 3-4: for monthly forcing   
   ctlf=rnt_ctl(forcfile,'srf_time');
   vars=    {'shflux'   'swrad'    'swflux' };
   forcd = rnc_Extract_SurfFluxes_NCEP(grd.lonr,grd.latr, ctlf.datenum, 'monthly',vars);
   rnc_Interp2grid_NCEP(ctlf,forcd,grd);
   
   % now get SST/SSS from Levitus but use clima at each month
   forcd = rnc_Extract_LevitusTS_Clima(grd.lonr,grd.latr, ctlf.datenum,'surface');
   forcd=rmfield(forcd,'SST');
   rnc_Interp2grid_NCEP(ctlf,forcd,grd);
   
   ctlf=rnt_ctl(forcfile,'sst_time');
   forcd=rnc_Extract_NOAA_SST(grd.lonr,grd.latr, ctlf.datenum);
   rnc_Interp2grid_NCEP(ctlf,forcd,grd);
   
   % get flux correction    (rnc_Extract_dQdSST_Clima.m)
   forcd = rnc_Extract_dQdSST_Clima(grd.lonr,grd.latr, ctlf.datenum);
   rnc_Interp2grid_NCEP(ctlf,forcd,grd);







return
%==========================================================
%	END - below is Manu's junk
%==========================================================



