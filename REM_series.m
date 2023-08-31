% This script is used to generate multiple "epochs" each lasting 30 sec. from single REM time series
% The input file is the "REM_single.mat" 
% The output file is the "REM_multiple.mat"

%% load cell array that contains time series from REM states (these cell arrays are called "REM_single")
load('C:\Users\Cigdem\MATLAB Drive\baby EEG\Baby Files\scripts for manuscript\GITHUB\REM_single.mat')

%% Organize single time series into epoched arrays each epoch lasting 30 sec (15000 samples)

% take REM series out of the cell array T7:

for i = 1:length(REM_single.REM_T7)
        REM_T7 (i) = REM_single.REM_T7(i,1);
end

% organize single arrays into a matrix with multiple epochs each lasting 30 sec. (i.e. 15000 samples)
srate = 500; % sample rate
window = 30; % analysis window (in sec)
epoch_length = srate * window; % analysis window (sample number)

for i = 1: length(REM_T7) 
      irange = 1:epoch_length:length(REM_T7{1,i})-epoch_length;
         for j=1:length(irange)
             m = irange(j);
        REM_T7m {1,i}(j,:)  = REM_T7{1,i}(m:(m+(epoch_length-1)));
         end
     
end
   
% Put all 30 sec REM series together

REM_T7m = vertcat(REM_T7m{:});

%%%%%%%%%%%%%%%%%%

% take REM series out of the cell array T8:

for i = 1:length(REM_single.REM_T8)
        REM_T8 (i) = REM_single.REM_T8(i,1);
end

% organize single arrays into a matrix with 30 sec multiple trials 

for i = 1: length(REM_T8) 
      irange = 1:epoch_length:length(REM_T8{1,i})-epoch_length;
         for j=1:length(irange)
             m = irange(j);
        REM_T8m {1,i}(j,:)  = REM_T8{1,i}(m:(m+(epoch_length-1)));
         end
     
end

% Put all 30 sec REM series together

REM_T8m = vertcat(REM_T8m{:});



%% Output
output.REM_T7 = REM_T7m;
output.REM_T8 = REM_T8m;
REM_multiple = output; 

clearvars -except REM_multiple

% save REM_multiple structure array for further analyses 
save('C:\Users\Cigdem\MATLAB Drive\baby EEG\Baby Files\scripts for manuscript\GITHUB\REM_multiple.mat');

%% end     
    