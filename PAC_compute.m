function [phaseamp] = PAC_compute(eeg)
% This function is used to determine the strength of the Phase Amplitude Coupling between two frequency oscillations 
% (modified from MX Cohen's lecture on "Multivariate cross-frequency coupling", COURSE: Advanced neuroscience techniques

%% Set parameters
srate = 500;
npnts = length(eeg);

%% Calculate CFC across frequency range (generate "phaseamp" matrix) 
% define frequencies for phase and for amplitude
phas_freqs =  0.1:1:5;
ampl_freqs =  4:1:10;

% number of iterations used for permutation testing
n_iter = 200; 

% initialize output phase-amplitude matrix
phaseamp = zeros(length(phas_freqs),length(ampl_freqs));

% loop over frequencies for phase
for lower_fi=1:length(phas_freqs)
    
    % get phase values
    phasefilt = filterFGx(eeg,srate,phas_freqs(lower_fi),phas_freqs(lower_fi)*.4);
    phase = angle(hilbert(phasefilt));
    
    for upper_fi=1:length(ampl_freqs)
        
        % get power values 
        ampfilt = filterFGx(eeg,srate,ampl_freqs(upper_fi),ampl_freqs(upper_fi)*.78);
        amplit = abs(hilbert(ampfilt)).^2;
        
        % calculate observed modulation index
        modidx = abs(mean(amplit.*exp(1i*phase)));

        % use permutation testing to get Z-value
        bm = zeros(1,length(n_iter));
        for bi=1:n_iter
            cutpoint = randsample(round(npnts/10):round(npnts*.9),1);
            bm(bi) = abs(mean(amplit([ cutpoint:end 1:cutpoint-1 ]).*exp(1i*phase)));
        end

        phaseamp(lower_fi,upper_fi) = (modidx-mean(bm))/std(bm);
    end 
end 


%% end
