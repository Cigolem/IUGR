# IUGR
Codes for IUGR Manuscript - MATLAB

Script 1: extract_time_series
This script is used to generate EEG time series from REM states. The Input file is the structure array "EEG" (when the time series is imported using EEGLab GUI the array appears in the workspace). The output file is the structure array "REM_single".
The output file will be used for script number 2 "REM_series"

Script 2: REM_series
This script is used to generate multiple "epochs" each lasting 30 sec. from single REM time series. The input file is the "REM_single.mat". The output file is the "REM_multiple.mat"

Fuction 1: PSD_CG
This function is used to perform Power Spectral Density analysis (using welch method) on an input EEG time series.

Script 3: PSD_REM
This script is used to generate Power spectral density estimates of multiple REM epochs from temporal channels. The input is the workspace where all individual REM_multiple time series from all subjects are stored 
The output is:
           % freq_PSD array (frequency array for plotting power spectral density estimates)
           % PSD_Control (cell array that contains PSD estimates for all epochs from T7/T8 channels separately for each subject) 
           % PSD_Control_av (cell array that contains PSD estimates for all epochs average of T7/T8 channels for each subject) 

Script 4: PSD_plotting
This script is used to  plot PSDs from early CGA and late CGA groups (all subjects included, i.e control + experimental)
Input files are:
            % PSD esimates as averaged for T7 and T8 channels from all babies with 30-33 (approximately) CGA weeks (PSD_early_av); 
            % PSD esimates as averaged for T7 and T8 channels from all babies with 33-40 (approximately) CGA weeks (PSD_late_av);
            % frequency spectrum to use for PSD plotting (freq_PSD)
Output is the plot showing PSD estimate in both groups

Fuction 2: spectral_single
This function is used to perform spectral analysis on an input EEG time series, which is multiple REM series (each lasting 30 sec)

Script 5: spectral_analysis
% This script is used to calculate power at delta, theta and alpha_beta frequency ranges from multiple epochs REM time series from all control and FGR subjects from T7/T8 channels separetly and the average power from both channels. 
% Input files are multiple epoched REM time series from all control and  FGR groups from both channels
% Output files are cell arrays that contain absolute powers at each of the three frequency ranges seprately from T7 / T8 channels (spectral_control) and their average power (spectral_control_av)
% For generating delta/theta/alpha_beta spectral powers for the FGRgroup, simply change the name from control to FGR throughout the script
