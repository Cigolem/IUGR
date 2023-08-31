function [out]  = spectral_single(eeg)

% this function is used to perform spectral analysis on an input EEG time series, which is multiple REM series (each lasting 30 sec)

% Enter parameters for FFT
srate = 500;
trials = size(eeg,1);
pnts = size (eeg,2);
hz = linspace(0,srate/2,floor(pnts/2)+1);

% Compute FFT
        
EEGpowr = (2*abs(fft(eeg, [],2)/pnts)).^2; 

% Crop the power spectra to the range of interest for each epoch

MIN_RANGE = 0.2;
MAX_RANGE = 30;
spectra1 = EEGpowr;
FreqAxis = hz;


for i= 1:size(EEGpowr,1)
    spectra1_crop(i,:) = spectra1 (i,FreqAxis>=MIN_RANGE & FreqAxis<=MAX_RANGE);
end

FreqAxis_crop = FreqAxis (:,FreqAxis>=MIN_RANGE & FreqAxis<=MAX_RANGE);

% Calculate total power across the whole cropped spectra for each epoch

for i=1:size(EEGpowr,1)
     totalPower(i) = sum(spectra1_crop(i,:));
end


%% Calculate DELTA 

% Extract spectra for DELTA frequency band
DELTA_LOW = 0.2;
DELTA_HIGH = 4;
for i= 1:size(EEGpowr,1)
    delta_spectra(i,:) = spectra1 (i,FreqAxis>=DELTA_LOW & FreqAxis<= DELTA_HIGH); % power in delta 
end
delta_freq_axis = FreqAxis (:,(FreqAxis>=DELTA_LOW & FreqAxis<= DELTA_HIGH));% frequency axis for delta range
for i=1:size(EEGpowr,1)
     delta_sum(i) = sum(delta_spectra(i,:)); % Calculate total power for delta band 
end
delta_abs = mean(delta_sum); 


%% CALCULATE THETA

% Extract spectra for THETA frequency band

THETA_LOW = 4;
THETA_HIGH = 8;

for i= 1:size(EEGpowr,1)
   theta_spectra(i,:) = spectra1 (i,FreqAxis>=THETA_LOW & FreqAxis<= THETA_HIGH); 
end

theta_freq_axis = FreqAxis (:,(FreqAxis>=THETA_LOW & FreqAxis<= THETA_HIGH));

for i=1:size(EEGpowr,1)
     theta_sum(i) = sum(theta_spectra(i,:)); % Calculate total power for theta band 
end

theta_abs = mean(theta_sum); 

%% ALPHA and BETA
% Extract spectra for ALPHA frequency band
ALPHA_BETA_LOW = 8;
ALPHA_BETA_HIGH = 20;

for i= 1:size(EEGpowr,1)
   alpha_beta_spectra(i,:) = spectra1 (i,FreqAxis>=ALPHA_BETA_LOW & FreqAxis<= ALPHA_BETA_HIGH); 
end

alpha_beta_freq_axis = FreqAxis (:,(FreqAxis>=ALPHA_BETA_LOW & FreqAxis<= ALPHA_BETA_HIGH));

% Calculate total power for alpha_beta band 
for i=1:size(EEGpowr,1)
     alpha_beta_sum(i) = sum(alpha_beta_spectra(i,:));
end

alpha_beta_abs = mean(alpha_beta_sum); 


%% Output
out = [delta_abs, theta_abs, alpha_beta_abs];

clearvars -except out
%% clean up
