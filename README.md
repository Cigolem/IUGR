# IUGR
MATLAB Codes 

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
This script is used to calculate power at delta, theta and alpha_beta frequency ranges from multiple epochs REM time series from all control and FGR subjects from T7/T8 channels separetly and the average power from both channels. 
Input files are multiple epoched REM time series from all control and  FGR groups from both channels
Output files are cell arrays that contain absolute powers at each of the three frequency ranges seprately from T7 / T8 channels (spectral_control) and their average power (spectral_control_av)
For generating delta/theta/alpha_beta spectral powers for the FGRgroup, simply change the name from control to FGR throughout the script

Script 6: TTA_detect: 
This script is used to determine TTA events in eeg time series extracted from REM states
Input files are single REM time series (not epoched) from all control and  FGR groups from T7 channels
Output files are structure arrays (TTA_final) that contain information on different features of TTA events  (amplitude, density, time series, durations etc..)

Script 7: PAC_arrays
This script is used to generate modulation index for assessing the strength of phase amplitude coupling between two frequency bands in REM sleep. 
The script uses the function "PAC_compute" to calculate z scores for MIs.
Input files: eeg_PAC_Control (or FGR) workspaces that contain eeg time series for each TTA event for each baby (time series of TTA events that have one second additional data from each side) 
Output files: 
            PAC_Control_final (or FGR) 3D arrays that contain MI for the given frequency range for each of the TTA event
            Plots showing MI (z-scored) for each group

Function 3: PAC_compute
This function is used to determine the strength of the Phase Amplitude Coupling between a range for lower (phase) and higher (amplitude) frequencies. 
It is modified from MX Cohen's lecture on "Multivariate cross-frequency coupling". 
Input file is the eeg signal; output file is the vector array that contains z-scored MIs

R Codes
Script 8: plot_trajectories
This script is used to generate plots for trajectories for different variables including body weight, head circumference and doppler paramaters. 
Input files are data farmes that contain HC, BW and Doppler data 
Output files are lineplots that represent deveopmental trajectories in control and FGR group


