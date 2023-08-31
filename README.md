# IUGR
Codes for IUGR Manuscript - MATLAB

Script 1: extract_time_series
This script is used to generate EEG time series from REM states. The Input file is the structure array "EEG" (when the time series is imported using EEGLab GUI the array appears in the workspace). The output file is the structure array "REM_single".
The output file will be used for script number 2 "REM_series"

Script 2: REM_series
This script is used to generate multiple "epochs" each lasting 30 sec. from single REM time series. The input file is the "REM_single.mat". The output file is the "REM_multiple.mat"

Script 3:
