
% G = neutral density. the 
% are the RhoLevels I chose. I have attached it
% Then to get  <v><h> and <v’h’> you do:

load('/okyanus/users/milicak/dataset/SOSE/Rhlvls.mat')  %let these be centers of layer 
NG = length(RhoLevels);
mncurref (2:NG) = (RhoLevels(1:NG-1) + RhoLevels(2:end))/2;
mncurref (1) = 23;
mncurref(NG+1) = 29;

grdname = '/okyanus/users/milicak/dataset/SOSE/1_over_3_degree/grid.nc';
hFacC = ncread(grdname,'hFacC');
hFacS = ncread(grdname,'hFacS');
XC = ncread(grdname,'XC');
YC = ncread(grdname,'YC');
RC = ncread(grdname,'RC');
DXG = ncread(grdname,'DXG');
DXC = ncread(grdname,'DXC');
DRF = ncread(grdname,'DRF');


maskC = hFacC;maskC(maskC>0)=1;
[NX,NY,NZ]=size(hFacS);
maskS = hFacS; maskS(maskS>0)=1;
dnmS = maskC(:,:,:) + maskC(:,[1 1:NY-1],:);dnmS(dnmS==0)=inf; dnmS=1./dnmS;
lon = XC(:,1);lat = YC(1,:);r = squeeze(RC(:));
Hinz = hFacS*0;
for k = 1:NZ
  Hinz(:,:,k) = hFacS(:,:,k)*DRF(k);
end
DXinG = zeros(NX,NY,NG,'single');
for k = 1:NG
  DXinG(:,:,k) = DXG;
end
clear hFacC XC YC RC hFacS DXG DRF

NT = 609;
for t=1:NT   
   G = ncread('/okyanus/users/milicak/dataset/SOSE/1_over_3_degree/bsose_i105_2008to2012_3day_GAMMA.nc','GAMMA',[1 1 1 t],[Inf Inf Inf 1]);
   V = ncread('/okyanus/users/milicak/dataset/SOSE/1_over_3_degree/bsose_i105_2008to2012_3day_Vvel.nc','VVEL',[1 1 1 t],[Inf Inf Inf 1]);
   %MAP G,N TO S POINTS
   G = (G + G(:,[1 1:NY-1],:)).*dnmS;
   VH = zeros(NX,NY,NG,'single');
   H = VH;
   for kcur=1:NG
     tmp1=V.*Hinz;
     tmp2=Hinz;
     tmp1( (G< mncurref(kcur)) | (G>=mncurref(kcur+1)) )=0;
     tmp2(tmp1==0)=0;
     VH(:,:,kcur) = (sum(tmp1,3));%total transport in layer  (vh)
     H(:,:,kcur)  = (sum(tmp2,3));%layer thickness
   end   
   recipH = H; recipH(recipH==0)=inf; recipH = 1./recipH;
   V =  VH.*recipH;
   %write VH H V here if need full fields
   %AND SAVE ZONAL INTEGRALS.
   H(H==0)=nan;% VH(VH==0)=nan;  NVH(NVH==0)=nan;
   VH = VH.*DXinG; 
   V = V.*DXinG; 
   VH_x(:,:,t)  = squeeze(sum(  VH,1));
   V_x(:,:,t)   = squeeze(sum(  V,1));
   H_x(:,:,t)   = squeeze(nanmean(  H,1));
   t
end


