
% This script is used to calculate power at delta, theta and alpha_beta frequency ranges from multiple epochs REM time series from all control
% and FGR subjects from T7/T8 channels separetly and the average power from both channels. 

% Input files are multiple epoched REM time series from all control and  FGR groups from both channels
% Output files are cell arrays that contain absolute powers at each of the three frequency ranges seprately from T7 / T8 channels 
% (spectral_control) and their average power (spectral_control_av)
% For generating delta/theta/alpha_beta spectral powers for the FGRgroup, simply change the name from control to FGR throughout the script

%% Load REM_multiple time series for the given (single) subject - both from T7 and T8.

REM_control = (struct2cell(load('C:\Users\cigde\MATLAB Drive\baby EEG\Baby Files\scripts for manuscript\GITHUB\REM_control.mat')))';

for i = 1:length(REM_control)
    REM_control{1,i} = struct2cell(REM_control{1,i});
end


%% Perform FFT using the script "spectral_single" for each channel separately
for i = 1: length(REM_control)
    for j = 1:length(REM_control{1,i})
        for k = 1:size(REM_control{1,i}{j,1}, 1)
    spectral_control {1,i}{j,1} = spectral_single (REM_control{1,i}{j,1});
        end
    end
end

clearvars i j k

% Save spectral_control (or spectral_FGR) - these contain absolute power for delta, theta, alpha_beta frequency ranges from T7 and T8 separate

save('C:\Users\cigde\MATLAB Drive\baby EEG\Baby Files\scripts for manuscript\GITHUB\spectral_control', 'spectral_control');


% Average frequency powers from T7 and T8

for i = 1:length(spectral_control)
   spectral_control_av {1,i} = ((spectral_control{1,i}{1,1}) + (spectral_control{1,i}{2,1}))/2;
end

save('C:\Users\cigde\MATLAB Drive\baby EEG\Baby Files\scripts for manuscript\GITHUB\spectral_control_av', 'spectral_control_av');

% Power values in the arrays "spectral_control_av" and "spectral_FGR_av" will be used for regression analyses
