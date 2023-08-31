function [PSD_final,f_final]  = PSD_CG(eegsignal)

% this function performs Power Spectral Density analysis (using welch method) on an input EEG time series

%% Enter analysis parameters and compute PSD
srate = 500;        % Sampling Rate
winsize = 2*srate; % 2-second window
hannw = .5 - cos(2*pi*linspace(0,1,winsize))./2; % Hanning window
noverlap = round(srate/2); % number of overlapped samples
nfft = srate*10; %  number of DFT points


[PSD,f] = pwelch(eegsignal,hannw,noverlap,nfft,srate);

MIN = 0.1;
MAX = 40;
PSD_signal = PSD(f>=MIN & f<=MAX);
f_final = f(f>=MIN & f<=MAX);
PSD_log = 10*log10(PSD_signal);
PSD_final = PSD_log;

%% end