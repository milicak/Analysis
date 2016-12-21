clear all

y=[-1000:5:1000];

ystorm = 50; %km

tau0=2.0;

tau = sqrt(-1).*tau0.*exp(-((y/ystorm).^2));

dTstorm=12; %12 h forcing (I also use it as index for hourly data)



figure

plot(y,abs(tau),'k-s',y,real(tau),'go',y,imag(tau),'r.')

legend('|\tau|','\tau_x','\tau_y');

xlabel('y [km]'); ylabel('\tau [Pa]');

title('DAsaro 95 Part II Forcing');

% Conclusion DAsaro's tau: y-component ONLY!!





% Slab model solution

%fi=sw_f(47.5); % at y = 0
fi=sw_f(84); % at y = 0



% what is beta

beta=(sw_f(48.5)-sw_f(46.5))./222240;

% get the local f

f0=fi; yf0=0;

ykm=y;

for I=1:length(ykm)

    dy=ykm(I)-yf0;

    flocal(I)=(f0 + beta*(dy*1000));

end





% Slab model mixed layer velocity solution using local f

damp_day=30; % damping time scale

r = 1/(damp_day*24*3600); % damping coeff

rhow=1025;

H=30;  %mixed layer depth

thr=[0:20*24]; % 20 days time series

% wind forcing time window

forcing_time=ones(size(thr)).*0;

forcing_time(1:dTstorm)=1; % wind forcing for dTstorm hours



t=thr*3600;

for J=1:length(ykm)

    

    tauI= tau(J)*forcing_time; % time series of tau at this y location

    

    T=tauI./rhow;

    omega= complex(r,flocal(J));

    Z(1,J)=complex(.001,0);

    % DAsaro 85 appendix formulation

    for I=2:length(t)

        dt=t(I)-t(I-1);

        Tt=(T(I)-T(I-1))/dt;

        p1 = Z(I-1,J).*exp(-omega.*dt);

        p2 = Tt./(H.*(omega.*omega));

        p3=(1 - exp(-omega.*dt));

        Z(I,J)=p1-(p2.*p3);

        clear p1 p2 p3

    end

    clear T

end

clear dt Tt omega

%------------





t0=0;

% back rotate

% note below flocal is converted to rad/h to match with time in hr

% Part 1 claims he uses fi at 47.5N for backrotating (not local)

for I=1:size(Z,2) % y dim

    UR(:,I)=Z(:,I).*(exp(i.*((fi*3600).*(thr(:)-t0))));

end





figure

ax(1)=subplot(211);

pcolor(ykm,thr,imag(Z)); shading flat; colorbar

xlabel('y [km]'); ylabel('Time [h]');

title(['Slab model solution, v_{slab}; H=',num2str(H),' m; r =',num2str(damp_day),' day']);



ax(2)=subplot(212)

pcolor(ykm,thr,imag(UR)); shading flat; colorbar

title('Backrotated v_{slab}')

xlabel('y [km]'); ylabel('Time [h]');



figure

plot(thr,imag(Z(:,ceil(length(y)/2)-1))); hold on

plot(thr,imag(UR(:,ceil(length(y)/2-1))),'r');

xlabel('Time [hr]');

%yl(-1e-3,1e-3)

legend('v_{slab}','Backrotated')

title('Example, at y =-12.5 km')





% do plane wave fits to complex data

% work with data from y=-XX to XXkm where 0 km is at storm and -ve

% southward

Y=ykm; % referenced y to storm center already

pick=find(Y>=-200 & Y<=200); % he fits to +/- 200 km of origin

Y=Y(pick);

data=UR(:,pick);

f0hr=(fi)*3600; % use f at y = 700 km, storm center



winlen=37; % 37h windows (ca 2x inertial period)

shift_t=3;

N=floor((length(thr)-winlen)/shift_t)



opts = optimoptions(@lsqnonlin,...
    'Algorithm','levenberg-marquardt','TolFun',1e-6,...
    'TolX',1e-6,'Display','off');



for J=1:N

    

    Jstart=((J-1)*shift_t)+1;

    Jend=Jstart+winlen;

    

    u=data(Jstart:Jend,:);

    t=thr(Jstart:Jend);

    [T,YY]=ndgrid(t-t0,Y); % T in hour, Y in km

    

    i=sqrt(-1);

    %objfcn = @(p)(p(1) .* exp(i.*(p(2).*YY(:)-f0hr.*T(:)))) - u(:);
    % Because time variability is removed, fit to Y only
    objfcn = @(p)(p(1) .* exp(i.*(p(2).*YY(:)))) - u(:); 

    % wavefcn = @(p) p(1) .* exp(i.*(p(2)).*YY-f0hr.*T) ;

    

    params_init=(1+1i)*[1e-3; 1e-5]; % m/s 1/km

    [estimates] = lsqnonlin(objfcn,params_init,[],[],opts);

    

    Efit(J)=.5.*(abs(estimates(1)).^2); %This is J/kg = m2/s2

    Pha(J)=angle(estimates(1));

    ky(J)=real(estimates(2));

    tav(J)=mean(t);

    clear estimates params* u t T YY

end





figure

ax(1)=subplot(211)

plot(tav./24,Efit,'+');

grid on

ylabel('Inertial Energy [J/kg]');

% subplot(122)

% plot(tav./24,unwrap(mysmooth(Pha,37)).*(180/pi));

% xlabel('Time [day]')

% ylabel('Plane wave fit, phase');

title('Plane wave fit to backrotated mixed layer slab current')

ax(2)=subplot(212)

plot(tav./24,ky,'+')

xlabel('Time [day]'); ylabel('k_y [rad/km]');

hold on

bslope=-beta.*(24*3600.*1000);

xs=0; ys=0;

xe=20; dx=xe-xs; dy=bslope*dx;

ye=ys+dy;

plot([xs xe],[ys ye],'r','linew',1.5)

text(6,-0.011,'-\beta t','color','r');

set(gca,'ylim',[-.03 0.01])

grid on

set(ax,'xlim',[0 20])








