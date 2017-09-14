function [BPE,FBPE,HPE,bpe,rhos,zs,vol_sorted] = bpe_calc2(theta_model,salt_model,dz_model,area_model,h_model,h_topog,vol_topog,gravity)
% bpe = bpe_calc(theta,salt,dz,area,H,h_sorted,vol_sorted,gravity)
%
% Calculates the integral of z*rho for the lowest potential energy state
eos_type = 'linear';
%eos_type = 'nonlinear';

if sum(abs(size(theta_model)-size(dz_model))); error('theta and dz must be the same size'); end
if sum(abs(size(theta_model)-size(salt_model))); error('theta and salt must be the same size'); end
if sum(abs(size(squeeze(theta_model(:,:,1)))-size(area_model))); error('rho and area must have consistent sizes'); end
if sum(abs(size(h_model)-size(area_model))); error('H and area must have consistent sizes'); end
total_area=sum(area_model(:));
fprintf('bpe_calc: ocean area = %.14g m^2\n',total_area)

tic;
dxdydz=NaN*dz_model; % Allocate memory
for k=1:size(dz_model,3)
  dxdydz(:,:,k)=area_model.*squeeze(dz_model(:,:,k)); % Volumes of cells on model grid
end
fprintf('bpe_calc: ocean volume = %.14g m^3 (from model)\n',sum(dxdydz(:)))
theta_model=theta_model(:)'; salt_model=salt_model(:)'; dxdydz=dxdydz(:)';
j=isnan(theta_model(:));            % Remove NaN's from data ...
% above is faster! j=find(dxdydz==0);                  % Remove solid land from data ...
theta_model(j)=[]; salt_model(j)=[]; dxdydz(j)=[];   % ... which also makes the problem smaller! :-)
switch eos_type
    case ('linear')
        sigma_model=this_eos_linear(theta_model,salt_model);
    case ('nonlinear')
        sigma_model=this_eos_nonlinear(theta_model,salt_model,2000e4);
end
sigma_model=sigma_model-(max(sigma_model(:))+min(sigma_model(:)))/2; % Shift to reduce round-off errors
[rho_sorted,j]=sort(sigma_model(:)','descend'); % Sort by densest first
vol_sorted=dxdydz(j);                           % with associated volume
theta_sorted=theta_model(j);                    % and associated theta
salt_sorted=salt_model(j);                      % and associated salt
clear dxdydz
tim1=toc;

total_volume=sum(vol_sorted);
total_theta=sum(theta_sorted.*vol_sorted); mean_theta=total_theta/total_volume;
total_salt=sum(salt_sorted.*vol_sorted); mean_salt=total_salt/total_volume;
fprintf('bpe_calc: ocean volume = %.14g m^3\n',total_volume)
fprintf('bpe_calc: mean theta = %.14g ^oC\n',mean_theta)
fprintf('bpe_calc: mean salt = %.14g psu\n',mean_salt)

zs=NaN*zeros(1,numel(rho_sorted)+numel(h_topog)); % Allocate memory
vols=NaN*zeros(1,numel(rho_sorted)+numel(h_topog)); % Allocate memory
dzs=NaN*zeros(1,numel(rho_sorted)+numel(h_topog)); % Allocate memory
thetas=NaN*zeros(1,numel(rho_sorted)+numel(h_topog)); % Allocate memory
salts=NaN*zeros(1,numel(rho_sorted)+numel(h_topog)); % Allocate memory

k=numel(vol_topog); % First (deepest) water column
current_top=h_topog(end); % Top of model
remaining_vol_of_H=vol_topog(end); % Volumne of this depth class
remaining_dh=h_topog(end)-h_topog(end-1); % Thickness of this depth class
area=remaining_vol_of_H/remaining_dh; % Area of this depth class
jj=0; % Index of the sorted/split profile
I1err=0; I2err=0;
for j=length(vol_sorted):-1:1 % reverse to get lightest first
  remaining_vol_of_water=vol_sorted(j);
  while remaining_vol_of_water>0
    jj=jj+1; % New entry in list
    if remaining_vol_of_water<remaining_vol_of_H
      % This water mass does not fill this volume of depth class
      % so consume it all
      dz=remaining_vol_of_water/area; % thickness after spreading water over area
      z=current_top-dz/2; % center of spread out water
      zs(jj)=z; % For plotting
      vols(jj)=remaining_vol_of_water; % For plotting
      dzs(jj)=dz; % For plotting
      thetas(jj)=theta_sorted(j);
      salts(jj)=salt_sorted(j);
      remaining_vol_of_H=remaining_vol_of_H-remaining_vol_of_water;
      current_top=current_top-dz; % bottom of newly spread out water
      remaining_vol_of_water=0.; % all the water was used to fill this depth class
    else
      % There is more water than can fit in the volume in
      % this depth class so consume only part of it
      dz=remaining_vol_of_H/area; % thickness after spreading water over area
      z=current_top-dz/2; % center of spread out water
      zs(jj)=z; % For plotting
      vols(jj)=remaining_vol_of_H; % For plotting
      dzs(jj)=dz; % For plotting
      thetas(jj)=theta_sorted(j);
      salts(jj)=salt_sorted(j);

      % Only some of the water was used to fill this depth class
      remaining_vol_of_water=remaining_vol_of_water-remaining_vol_of_H;
      remaining_vol_of_H=0.; % All this depth class was filled
      current_top=current_top-dz; % bottom of newly spread out water

      % Move to next depth class
      k=k-1;
      if k<1 % Used to be >numel(h_topog) when working bottom up
       if remaining_vol_of_H>0
         dz=remaining_vol_of_H/area
         error('bpe_calc: ran out of water to fill with!')
       elseif remaining_vol_of_water>0
         dz=remaining_vol_of_water/area;
         fprintf('bpe_calc: ** basin full (excess water left over)! Adding %.5gm of water to bottom (%.5gm of sea-level)\n',dz,dz*area/total_area)
         remaining_vol_of_H=remaining_vol_of_water;
         remaining_dh=dz;
       end
      else
       if k<=length(vol_topog) && k>1
         current_top=h_topog(k+1); % Better to assign than accumulate errors, replaces (1)
         remaining_vol_of_H=vol_topog(k); % Volumne of this depth class
         remaining_dh=h_topog(k+1)-h_topog(k); % Thickness of this depth class
         area=remaining_vol_of_H/remaining_dh; % Area of this depth class
       end
      end
    end % if remaining_vol_of_water<remaining_vol_of_H
  end % while remaining_vol_of_water>0
end % for j

jj=isnan(thetas); 
zs(jj)=[]; vols(jj)=[]; dzs(jj)=[]; thetas(jj)=[]; salts(jj)=[];
switch eos_type
    case ('linear')
        rhos=this_eos_linear(thetas,salts); 
    case ('nonlinear')
        %check_stable(thetas,salts,dzs,gravity);
        ps=int_for_p(thetas,salts,dzs,gravity);
        %ps=2000e4+0*zs; % uncomment to use sigma2 for BPE calculation
        rhos=this_eos_nonlinear(thetas,salts,ps); 
end
%for accuracy
rhos=rhos-(max(rhos)+min(rhos))/2;


old_total_volume=total_volume; % Keep for estimating errors
total_volume=sum(vols); % Re-calculate for accuracy
total_mass=sum(rhos.*vols); mean_rho=total_mass/total_volume;
fprintf('bpe_calc: ocean volume = %.14g m^3 (sorted), non-dim. err=%.1e\n',total_volume,(old_total_volume-total_volume)/total_volume)
fprintf('bpe_calc: total mass = %.14g kg\n',total_mass)
fprintf('bpe_calc: mean density = %.14g kg/m^3\n',mean_rho)
z_cov=sum(zs.*vols)/total_volume; % Re-calcalulate for accuracy
bpe=gravity*zs.*rhos.*vols;
bpep=gravity*(zs-z_cov).*(rhos-mean_rho).*vols;
I1err=sum( -gravity*(rhos-mean_rho)*z_cov .*vols )/total_area;
I2err=sum( gravity*mean_rho*(zs-z_cov) .*vols )/total_area;

FBPE=sum(bpe)/total_area; % Return J/m^2 (full un-adjusted BPE)
BPE=sum(bpep)/total_area; % Return J/m^2 (frame invariant BPE)
HPE=gravity*z_cov*mean_rho*total_volume/total_area;  % Return J/m^2 (frame/mass adjustment)
BPE_err=(FBPE-HPE-BPE)/BPE;

%fprintf('bpe_calc: BPE = %.14e J/m^2, HPE = %.14e J/m^2, FBPE = %.14e J/m^2\n',BPE,HPE,FBPE)
fprintf('bpe_calc: BPE = %.14e J/m^2 (non-dim. errors=%.1e, %.1e, %.1e)\n',BPE,BPE_err,I1err/BPE,I2err/BPE)


% ==================================================================

function [rho,al0,lambda,p0] = this_eos_nonlinear(T,S,P)
% EQN_STATE_WRIGHT(T,S,P)
%
% Returns the in situ density in kg/m^3.
%
% T - potential temperature relative to the surface in C.
% S - salinity in PSU.
% P - pressure in Pa.
%
% Coded for Matlab by W. Anderson 9/07

%a0 = 7.057924e-4; a1 = 3.480336e-7; a2 = -1.112733e-7;
%b0 = 5.790749e8;  b1 = 3.516535e6;  b2 = -4.002714e4;
%b3 = 2.084372e2;  b4 = 5.944068e5;  b5 = -9.643486e3;
%c0 = 1.704853e5;  c1 = 7.904722e2;  c2 = -7.984422;
%c3 = 5.140652e-2; c4 = -2.302158e2; c5 = -3.079464;

a0 = 7.133718e-4; a1 = 2.724670e-7; a2 = -1.646582e-7;
b0 = 5.613770e8;  b1 = 3.600337e6;  b2 = -3.727194e4;
b3 = 1.660557e2;  b4 = 6.844158e5;  b5 = -8.389457e3;
c0 = 1.609893e5;  c1 = 8.427815e2;  c2 = -6.931554;
c3 = 3.869318e-2; c4 = -1.664201e2; c5 = -2.765195;

al0 = a0 + (a1*T +a2*S);
p0 = (b0 + b4*S) + T .* (b1 + T.*(b2 + b3*T) + b5*S);
lambda = (c0 +c4*S) + T .* (c1 + T.*(c2 + c3*T) + c5*S);
rho = (P + p0) ./ (lambda + al0.*(P + p0));

% ==================================================================

function [rho,al0,lambda,p0] = this_eos_linear(T,S,P)

% Linear EOS
rho = 26-0.21*(T-15.0)+0.75*(S-35.0);

% ==================================================================

function [P,rho] = int_for_p(T,S,dz,gravity)

P=0*T+cumsum(dz)*gravity*1025; % Initial guess fo pressure
rho=this_eos(T,S,P);
%Pio=[];
for it=1:5;
  dp=gravity*rho.*dz;
  Pi=[0 cumsum(dp)];
%  if isempty(Pio)
%    Pio=Pi;
%  else
%    stats(Pi-Pio)
%    Pio=Pi;
%  end
  rho=this_eos(T,S, (Pi(1:end-1)+Pi(2:end))/2 );
end
Pi=[0 cumsum(dp)];
P=(Pi(1:end-1)+Pi(2:end))/2;

% ==================================================================

function [rhos] = check_stable(T,S,dz,gravity)

ps=int_for_p(T,S,dz,gravity);
%ps=2000e4+0*ps;
pi=(ps(1:end-1)+ps(2:end))/2; % Interface pressures
rhou=this_eos_nonlinear(T(1:end-1),S(1:end-1),pi);
rhod=this_eos_nonlinear(T(2:end),S(2:end),pi);
ni=numel(rhod);
j=find(rhod<rhou);
fprintf('bpe_calc: %i/%i (%.3g%%) statically unstable interfaces\n',length(j),ni,100*length(j)/ni)
j=find(rhod==rhou);
fprintf('bpe_calc: %i/%i (%.3g%%) neutrally stable interfaces\n',length(j),ni,100*length(j)/ni)
j=find(rhod>rhou);
fprintf('bpe_calc: %i/%i (%.3g%%) stable interfaces\n',length(j),ni,100*length(j)/ni)
plot(cumsum(rhod-rhou))
