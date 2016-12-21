% --- first line in float input file is the number of floats
% --- second line in float input file is the initial float time step
% --- this number is set to zero for the first model run segment

% ---   column 1 - initial sequential float number
% ---   column 2 - float type
% ---              1 = 3-d lagrangian (vertically advected by diagnosed w)
% ---              2 = isopycnic
% ---              3 = isobaric (surface drifter when released in sfc. layer)
% ---              4 = stationary (synthetic moored instrument)
% ---   column 3 - deployment time (days from model start, 0.0 = immediate)
% ---   column 4 - termination time (days from model start, 0.0 = forever)
% ---   column 5 - initial longitude (must be between minimum and maximum
% ---                                 longitudes defined in regional.grid.b)
% ---   column 6 - initial latitude  (must be between minimum and maximum
% ---                                 latitudes defined in regional.grid.b)
% ---   column 7 - initial depth (or reference sigma for isopycnic flo

clear all


flnmflti = 'floats.input'
flnmflto = 'floats_out'
flnmfltio= 'floats.input_out'

nflt = 5000; % number of floats
nstepfl = 0; % initial float time step

floattype = ones(nflt,1);
%floattype = int16(ones(nflt,1));
dplymnttime = zeros(nflt,1);
trmntime = zeros(nflt,1);

% GS area
%lonfloats = -70.0+2*rand(nflt,1);
%latfloats =  35.0+2*rand(nflt,1);
% GS area
lonfloats = -70.0+2*rand(nflt,1);
latfloats =  24.0+2*rand(nflt,1);
depthfloats =  30.0+10*rand(nflt,1);

fileID = fopen(flnmflti,'w');

fprintf(fileID,'%4.4d \n',nflt);
fprintf(fileID,'%1.1d \n',nstepfl);

%fprintf(fileID,'%6s %12s\n','x','exp(x)');
%fprintf(fileID,'%6.2f %12.8f\n',A);

for i =1:nflt
 fprintf(fileID,'%4.4d %1.1d %5.4e %5.4e %12.8f %12.8f %12.8f  \n', [i floattype(i) dplymnttime(i) trmntime(i) lonfloats(i) latfloats(i) depthfloats(i)]);    
 %fprintf(fileID,'%1.1d %6.3f %6.3f %6.3f  \n', [1 lonfloats(i) latfloats(i) depthfloats(i)]);    
end

fclose(fileID);

