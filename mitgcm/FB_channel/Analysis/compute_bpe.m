clear all
grav=9.8;
Kelvin2Celsius=273.15;
nz=64;

rootdir='/bcmhsm/milicak/RUNS/mitgcm/FB/'
%project_name='input_ref'
project_name='input_strength_5'
gridfile1=[rootdir project_name '/XC'];
gridfile2=[rootdir project_name '/YC'];
bathyfile=[rootdir project_name '/Depth'];

H=rdmds(bathyfile);
H(isnan(H))=0;

dx=rdmds([rootdir project_name '/DXC']);
dy=rdmds([rootdir project_name '/DYC']);
drf=rdmds([rootdir project_name '/DRF']);
area=dx.*dy;
lon=rdmds(gridfile1);
lat=rdmds(gridfile1);

tmask=rdmds([rootdir project_name '/maskInC']);
nx=size(tmask,1);ny=size(tmask,2);
tmask(tmask~=1)=0;
area=area.*tmask; H=H.*tmask;
tmask=repmat(tmask,[1 1 nz]);

hfacc=rdmds([rootdir project_name '/hFacC']);         % Level thicknesses
dz=(sq(drf));
[Nx Ny Nz]=size(hfacc);
delta_z=repmat(dz,[1 Nx Ny]);
delta_z=permute(delta_z,[2 3 1]);
delta_z=delta_z.*hfacc;
delta_z_ref=delta_z;


BPE=[];
FBPE=[];
HPE=[];

savename=['matfiles/' project_name '.mat'];

%years=23040:96:31680;
%years=115200:96:123840; %strength_0.1
%years=46080:96:54720; %strength_0.25
%years=230400:960:316800; %strength_2
years=230400:960:316800; %strength_5
real_ind=1;
for kind=1:length(years)
  T=rdmds([rootdir project_name '/T'],years(kind));
  S=rdmds([rootdir project_name '/S'],years(kind));

  T=T.*tmask;
  S=S.*tmask;

  eta=rdmds([rootdir project_name '/Eta'],years(kind));
  
  % This is due to zstar used in MITGCM; look at table 7.1 in mom4p1 manual
  corr=(1.0+eta./H);
  corr(isnan(corr))=0;
  corr=repmat(corr,[1 1 Nz]);
  dzts=delta_z_ref.*corr;
  dzts=dzts.*tmask;

  if real_ind==1
   [h_sorted, vol_sorted] = sort_topog_eta(-H,eta.*0.,area);
  else
    h_sorted(end)=sum(eta(:).*area(:))./sum(area(:));
  end
  clear corr eta
  %[BPE(end+1) FBPE(end+1) HPE(end+1)]=bpe_calc2(T,S,dzts,area,H,h_sorted,vol_sorted,grav);
  [BPE(end+1) FBPE(end+1) HPE(end+1)]=bpe_calc2(T,dzts,area,H,h_sorted,vol_sorted,grav);
  %fprintf('bpe_mom: timings, %f s, %f s, %f s. BPE=%g J/m^2\n',tim1,tim2,tim3,BPE(end))
  real_ind=real_ind+1
  save(savename,'BPE','FBPE','HPE');

end % kind




