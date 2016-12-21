load mitgcm_sose_EKE

EKE_SO=squeeze(EKE(:,120,:));

nw=2;  % time-bandwidth product (window width) for the discrete prolate
nfft=2048; % the length of the FFT
fs=1;     % 1 value per daily since i have daily   fs would be 1/4 if i have 6 hours data to have 1 value per day (to get daily frequency)
p=0.95  % significant level used to calculate confidence estimates
method='adapt'; % Thomsons adaptive nonlinear combination
% % % (adaptively-weighted estimates)
range='onesided'; % Compute the one-sided PSD over the frequency range [0,fs]


for i=1:2096
[Pxx_index,Pxxc_index,f_index] = pmtm(EKE_SO(i,:),nw,nfft,fs,p,method,range);
ens1=Pxx_index(1:end-1,:)/std(Pxx_index(1:end-1,:));
f=1./f_index(2:end,1);
semilogx(f,ens1);
hold on
end




%% FFT APPROACH
Y = fft(EKE_SO(i,:),nfft)/length(EKE_SO(i,:));
f = fs/2*linspace(0,1,nfft/2+1);
t2=2*abs(Y(1:nfft/2+1));
f2=1./f;


% deseasonalize
for i=1:2160
%  a=find(EKE_SO(i,:)==0);
  for j=1:3; %temporal
    c=EKE_SO(i,j*365-364:j*365);
    amoc(i,j:12:a(1)-1-12+j)=c - mean(c);
  end
  clear j c
 

