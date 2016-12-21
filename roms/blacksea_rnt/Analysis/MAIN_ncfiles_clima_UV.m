
DoGeosFromClimaFile=1;
ZREF='bottom';
% you can ref the geos flow to 500 m by setting ZREF='500'
% or any other depth. If you are uncertain you can explore the 
% effects of varioous ZREF by
exploreZref=0;
if exploreZref==1
  ctlc = rnt_timectl( {clmfile},'tclm_time');
  T=rnt_loadvar(ctlc,1,'temp');
  S=rnt_loadvar(ctlc,1,'salt');
  [ssh,ugeo,vgeo]=rnt_calcSSH(T,S,grd,'bottom');
  figure(1);
  rnt_plcm(vgeo(:,:,end),grd);
  figure(2)
  Jsec = length(grd.lonr(1,:))/2;
  rnt_sectx(vgeo, Jsec, grd);
end





if DoGeosFromClimaFile ==1
%==========================================================
%	Add Geostrphy velocity refereced to bottom
%     from existing TS in climatology file.
%==========================================================

% this is NOT a rigourous calculation! It is just to get
% started with velocity in the model boundary and interior
% compute GEOS velocity relative to the bottom using the 
% model pressure gradient routine

ncout=netcdf(clmfile,'w');
     rho0=1025;
     
for it=1:12
    disp(['Geos vel. ',num2str(it)]);
    % compute density with model RHO equation
    temp=permute(ncout{'temp'}(it,:,:,:),[3 2 1]);
    salt=permute(ncout{'salt'}(it,:,:,:),[3 2 1]);
    zeta=zeros(size(temp(:,:,1)));

    [ssh,ugeo,vgeo]=rnt_calcSSH(temp,salt,grd,'bottom');
    
    AddEkman=0;  % this is not tested yet.
    if AddEkman ==1
    ctlf=rnt_timectl({forcfile},'sms_time');
    taoX=rnt_loadvar(ctlf,it,'sustr');
    taoY=rnt_loadvar(ctlf,it,'svstr');
    [Ue, Ve, dE, U10]=rnt_ekmanUV(taoX,taoY,grd);
    vgeo=vgeo+Ve;
    ugeo=ugeo+Ue;
    end

    % assign     
    ncout{'v'}(it,:,:,:)=permute(vgeo,[3 2 1]);
    ncout{'u'}(it,:,:,:)=permute(ugeo,[3 2 1]);  
    ncout{'zeta'}(it,:,:)=ssh';    

     % compute depth average barotropic flow
    [zr,zw,Hzout]=rnt_setdepth(zeta,grd);
    [ubar,vbar] = rnt_barotropic(ugeo,vgeo,Hzout,grd);    
    ncout{'vbar'}(it,:,:)=permute(vbar,[2 1]);
    ncout{'ubar'}(it,:,:)=permute(ubar,[2 1]);    
end    
  close(ncout) 
disp(' DONE.');

end












