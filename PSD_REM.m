
% This script is used to generate Power spectral density estimates of multiple REM epochs from temporal channels 

% The input is the workspace where individual REM_multiple time series from all subjects are stored
       % PSDs from 30-33 weeks CGA subjects (Control and Treatment groups) - named early
       % PSDs from 33-40 weeks CGA subjects (Control and Treatment groups) - named late
% The output is:
           % freq_PSD array (frequency array for plotting power spectral density estimates)
           % PSD_early (cell array that contains PSD estimates for all epochs from T7/T8 channels separately for each subject) 
           % PSD_early_av (cell array that contains PSD estimates for all epochs average of T7/T8 channels for each subject) 
% For generating PSD estimates for the late group, simply change the name from early to late throughout the script

%% Load the workspace where all individual multiple REM time series are stored and store all series in a cell array

REM_early = (struct2cell(load('C:\Users\Cigdem\MATLAB Drive\baby EEG\Baby Files\scripts for manuscript\GITHUB\REM_early.mat')))';

for i = 1:length(REM_early)
    REM_early{1,i} = struct2cell(REM_early{1,i});
end


%% Perform PSD using the script "PSD_CG" for each channel separately
for i = 1: length(REM_early)
    for j = 1:length(REM_early{1,i})
        for k = 1:size(REM_early{1,i}{j,1}, 1)
    PSD_early {1,i}{j,1}(k,:) = PSD_CG (REM_early{1,i}{j,1}(k,:));
        end
    end
end

clearvars i j k

% Save PSD_early (or PSD_late) - this contains PSDs from T7 and T8 separate

save('C:\Users\Cigdem\MATLAB Drive\baby EEG\Baby Files\scripts for manuscript\GITHUB\PSD_early', 'PSD_early');

% Generate frequency array to use for plotting and save 
[~ , freq_PSD] = PSD_CG(REM_early{1,1}{1,1}(1,:));
save('C:\Users\Cigdem\MATLAB Drive\baby EEG\Baby Files\scripts for manuscript\GITHUB\freq_PSD', 'freq_PSD');

% Average PSDs from T7 and T8
for i = 1:length(PSD_early)
    PSD_early_av {1,i} = ((PSD_early{1,i}{1,1}) + (PSD_early{1,i}{2,1}))/2;
end

save('C:\Users\Cigdem\MATLAB Drive\baby EEG\Baby Files\scripts for manuscript\GITHUB\PSD_early_av', 'PSD_early_av');

% the arrays "freq_PD"; "PSD_early_av"; "PSD_late_av"will be used for the script "PSD_plotting" 

%% end
