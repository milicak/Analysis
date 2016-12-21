function [TrN,TrW,TrU,TrE1,TrE2,TrAADW,TrITU,SUtime,SNtime,SStime,SDtime,SAtime]=compute_analytic_solution(filename)
%function [phi_Up]=compute_analytic_solution(filename)

load(filename)

for ind=1:24000*nthousand
    delta_rho = rho0*(beta_S*(SN-SU)-alpha_T*(TN-TU));
    delta_rho_SO = rho0*(beta_S*(SS-SU)-alpha_T*(TS-TU));
    delta_rho_SO2 = rho0*(beta_S*(SS-SD)-alpha_T*(TS-TD));
    delta_rho_AADW = rho0*(beta_S*(SA-SD)-alpha_T*(TA-TD));
    delta_rho_D = rho0*(beta_S*(SN-SD)-alpha_T*(TN-TD));

    kappa1 = kappa_cnst;  
    %kappa2 = kappa_cnst*1;  
    kappa2 = epsilon/(grav*delta_rho_AADW);

    % phi_Moc
    phi_N = (C1*grav*delta_rho*H_pyc*H_pyc/(rho0*fbeta*LyN));
    %if delta_rho_D<0
    if delta_rho<0
      display('MI'),iind
      phi_N = 0.0;
    %  break
    end
    % phi_Up    
    phi_Up = (LU*B*kappa1/H_pyc);

    % phi_Ek
    phi_Ek = (B*tau/(f0*rho0));

    % phi_GM
    %phi_GM1 = Cgm*(B*kappa_GM*(delta_rho_SO/rho0)*H_pyc/H); 
    %phi_GM2 = max(0,2*(B*kappa_GM*(delta_rho_SO2/rho0)*H_deep/H)); 
    phi_GM1 = 0.01*B*(grav*delta_rho_SO/rho0)*H_pyc*H_pyc/(f0*LS);
    phi_GM2 = 0.01*B*(grav*delta_rho_SO2/rho0)*H_deep*H_deep/(f0*LS);

    % phi_AADW (into the bottom layer AADW)
    phi_AADW = (phi_GM1+phi_GM2)-phi_Ek;
    % phi Internal Tides Upwelling
    %phi_ITU = (LU*B*kappa2/H_AADW);
    phi_ITU = (LU*B*kappa2/H_deep);
    %phi_ITU = max(0,(LU*B*kappa2/H_deep));
    if(isinf(phi_ITU)==1); phi_ITU = 0.0; end

    % new pycnocline depth
    H_pyc_new = H_pyc + (deltat/(B*LU))*(phi_Up+phi_Ek-phi_GM1-phi_N);

    % new AADW depth
    %H_AADW_new = H_AADW; %max(0,H_AADW + (deltat/(B*LU))*(phi_GM1+phi_GM2-phi_Ek-phi_AADW));
    H_AADW_new = H_AADW + (deltat/(B*LU))*(phi_AADW-phi_ITU);
    if(H_AADW_new < 0)
      display('Mehmet AADW depleted')
    %  H_AADW_new = 0.0;
    %  phi_ITU = 0.0;
    end

    % Volume*Salt terms
    VUSU=VU*SU;
    VNSN=VN*SN;
    VSSS=VS*SS;
    VDSD=VD*SD;
    VASA=VA*SA;
    if(tempevl)
      % Volume*Temp terms
      VUTU=VU*TU;
      VNTN=VN*TN;
      VSTS=VS*TS;
    %  VDTD=VD*TD;
      VATA=VA*TA;
    end
    % New volume salt terms
    VUSUnew = VUSU + deltat*(phi_Up*SD+phi_Ek*SS-SU*(phi_N+phi_GM1)+S0*(FN+FS));
    VNSNnew = VNSN + deltat*(phi_N*(SU-SN)-S0*(FN+FNFW));
    VSSSnew = VSSS + deltat*(phi_Ek*(-SS)+phi_GM1*(SU)+phi_GM2*(SD)-phi_AADW*SS-S0*FS);
    VDSDnew = VDSD + deltat*(phi_N*SN-phi_GM2*SD-SD*(phi_Up)+phi_ITU*SA);
    VASAnew = VASA + deltat*(phi_AADW*SS-phi_ITU*SA);
    %keyboard
    if(tempevl)
      % New volume temp terms      
      VUTUnew = VUTU + deltat*(phi_Up*TD+phi_Ek*TS-TU*(phi_N+phi_GM1)+gammau*VU*(TUrelax-TU));
      VNTNnew = VNTN + deltat*(phi_N*(TU-TN)+gamman*VN*(TNrelax-TN));
      VSTSnew = VSTS + deltat*(phi_Ek*(-TS)+phi_GM1*(TU)+phi_GM2*(TD)-phi_AADW*TS+gammas*VS*(TSrelax-TS));
    %  VDTDnew = VDTD + deltat*(phi_N*TN-phi_GM2*TD-TD*(phi_Up)+phi_ITU*TA);
      VATAnew = VATA + deltat*(phi_AADW*TS-phi_ITU*TA);
    end
    %keyboard
    %update values

    H_pyc = H_pyc_new;
    H_AADW = H_AADW_new;
    H_deep = bathy-H_pyc-H_AADW;
    VUSU = VUSUnew;
    VNSN = VNSNnew;    
    VSSS = VSSSnew;    
    VDSD = VDSDnew;
    VASA = VASAnew;
    if(tempevl)
       VUTU = VUTUnew;
       VNTN = VNTNnew;
       VSTS = VSTSnew;
    %   VDTD = VDTDnew;
       VATA = VATAnew;
    end
    VU = LU*B*H_pyc;
    VN = LN*B*bathy;
    VS = LS*B*bathy;
    VD = LU*B*H_deep;
    VA = LU*B*H_AADW;
    SU = VUSU/VU;
    SN = VNSN/VN;
    SS = VSSS/VS;
    SD = VDSD/VD;
    SA = VASA/VA;
    if(tempevl)
       TU = VUTU/VU;
       TN = VNTN/VN;
       TS = VSTS/VS;
    %   TD = VDTD/VD;
       TA = VATA/VA;
    end
    % time series
    time=time+deltat;        
    if(mod(time,yearinsec)==0)
      if FWforce==true
        if(mod(iind,100)==0)
          FNd=FNFW;
        end
        FNFW=FNd+(1*FNFW_cap)*mod(iind,100)/99;
        if iind>100 & iind < 200
          FNFW = 1.0*FNFW_cap;
        else
          FNFW = 0.0*FNFW_cap;
        end
      end  
      Fwater(iind)=FNFW;
      HUtime(iind) = H_pyc;
      HAADWtime(iind) = H_AADW;
      TrN(iind) = phi_N;
      TrW(iind) = phi_Ek;
      TrE1(iind) = phi_GM1;
      TrE2(iind) = phi_GM2;
      TrU(iind) = phi_Up;
      TrAADW(iind) = phi_AADW;
      TrITU(iind) = phi_ITU;
      SUtime(iind) = SU;
      SNtime(iind) = SN;
      SStime(iind) = SS;
      SDtime(iind) = SD;
      SAtime(iind) = SA;
      drho(iind) = delta_rho;
      drhoD(iind) = delta_rho_D;
      drhoSO(iind) = delta_rho_SO;
      drhoSO2(iind) = delta_rho_SO2;
      if(tempevl)
        TUtime(iind) = TU;
        TNtime(iind) = TN;
        TStime(iind) = TS;
        TDtime(iind) = TD;
        TAtime(iind) = TA;
      end
      iind = iind+1;
    end
end   

