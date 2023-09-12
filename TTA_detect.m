% This script is used to determine TTA events in eeg time series extracted
% from REM states

% Input files are single REM time series (not epoched) from all control and  FGR groups from T7 channels
% Output files are structure arrays (TTA_final) that contain information on different features of TTA events 
% (amplitude, density, time series, durations etc..)

%% Load the eeg time series 
load('C:\Users\Cigdem\MATLAB Drive\baby EEG\Baby Files\scripts for manuscript\GITHUB\REM_single.mat')
eeg = horzcat (REM_single.REM_T7{:}); % concatanate single REM series in one array

%% Step 1: Band-pass filter the time series between 4-7.5 Hz 

TTA=struct();
TTA.filtsig = [];

% create TTA filters
TTA_low = 4;
TTA_high = 7.5;
fs = 500;
order = 3; % order of filter
[b,a]=butter(order,[TTA_low,TTA_high]/(fs/2),'bandpass');

% generate filtered signal
TTA.filtsig=filter(b,a,eeg);     

pnts = length (TTA.filtsig);
time  = (0:pnts-1)/fs;

clearvars a b TTA_low TTA_high order 

[up,lo] = envelope(TTA.filtsig);


%% Step 2: Take Hilbert transform of the filtered signal

    TTA.amplitude = abs(hilbert(TTA.filtsig)); % amplitude of the filtered signal 

    TTA.amp_average = mean(TTA.amplitude); % average amplitude
    TTA.amplitude_threshold = 5 * TTA.amp_average; % amplitude threshold for detecting TTA events
    TTA.start_end = 1.5 * TTA.amp_average; % amplitude threshold for detecting the start and end of TTA events

   %% Step 3: Determine TTA events that have amplitudes higher than threshold

   TTA.envelope = up;
   TTA.amplitude_selected = find(TTA.envelope>=TTA.amplitude_threshold);

%% Step 4: Calculate the duration of TTA events that are higher than amplitude threshold

% Find indices of consecutive TTA events 

id=[length(TTA.amplitude_selected') diff(TTA.amplitude_selected) length(TTA.amplitude_selected')]==1;
ii1=strfind(id,[0 1]); % ii1 vector contains first index of the consecutive numbers in the array
ii2=strfind(id,[ 1 0]);% ii2 vector contains last index of the consecutive numbers in the array 

TTA.indices = {}; % shows the indices of TTA amplitudes that meet start and end threshold criteria
for i= 1:length(ii1)
 TTA.indices{i} = TTA.amplitude_selected ((ii1(i)):ii2(i));                      
end

clearvars i

% Determine the duration of consecutive series
for i=1:length(ii1)
    TTA.durations(i) = ((ii2(i)-ii1(i)) +1)*2;  % this shows the durations of TTA events that are higher than amplitude 
                                                % threshold (in msec)
end

clearvars i 

%% Step 5: Determine TTA events that meet both amplitude and duration criteria (i.e. min 0.3 sec max 1.6 sec)

c = 0;
TTA.selected_TTA = 0; % this shows the indices of durations in "TTA durations" array that meet the duration criteria
for i=1:length(TTA.durations)
    if TTA.durations(i) >=300 && TTA.durations(i) <=1600
        c=c+1;
        TTA.selected_TTA (c) = i;
    end
end

clearvars c i

%% Step 6: Put the durations of selected TTA events in the "TTA.selected_durations" array (meet both amplitude and duration threshold)

TTA.selected_durations = 0; % this shows the durations of selected TTA events (meet both amplitude and duration threshold) 
for i= 1:length(TTA.selected_TTA)
 TTA.selected_durations(i) = TTA.durations (TTA.selected_TTA(i));                      
end

clearvars i

%% Step 7: Determine time indices for selected TTA events (meet both amplitude and duration threshold)

TTA.selected_time = {}; % shows the indices for selected TTA events (meet both amplitude and duration threshold)

for i= 1:length(TTA.selected_TTA)
 TTA.selected_time{i} = TTA.amplitude_selected ((ii1(TTA.selected_TTA(i)):ii2(TTA.selected_TTA(i))));                      
end

clearvars i id ii1 ii2

%% Get EEG time series from TTA events that meet amplitude and duration threshold (5* amp_threshold and 0.3 - 1.6 sec duration)

for i= 1:length(TTA.selected_durations)
 TTA.eegsignal_1{i} = eeg(TTA.selected_time{1,i});
end

% TTA_eegsignal_1 contains time series of TTA events that meet "amplitude threshold" + duration threshold 
% (i.e the highest part, without start and end part of the selected TTA events)

clearvars i

%% Determine time indices for segments that are within start and end indices

% Determine TTA envelopes that last longer than "TTA.start_end" threshold

TTA.amplitude_start_end = find(TTA.envelope>=TTA.start_end);

% Find indices of consecutive TTA start_end segments

idd=[length(TTA.amplitude_start_end') diff(TTA.amplitude_start_end) length(TTA.amplitude_start_end')]==1;
iii1=strfind(idd,[0 1]); 
iii2=strfind(idd,[ 1 0]);

% Determine the time series of consecutive series

TTA.start_end_time = {}; % shows the indices of TTA amplitudes that meet start and end threshold criteria
for i= 1:length(iii1)
 TTA.start_end_time{i} = TTA.amplitude_start_end ((iii1(i)):iii2(i));                      
end

clearvars i idd iii1 iii2
%% Get indices that are the same between "selected time" and "start_end_time" series

TTA.similarity_scores = {};


for i=1:length(TTA.start_end_time)
    for j = 1:length(TTA.selected_time)
    TTA.similarity_scores{i,j} =intersect(TTA.start_end_time{1,i},TTA.selected_time{1,j});
    end
end


for i=1:size( TTA.similarity_scores,1)
    for j = 1:size( TTA.similarity_scores,2)
    TTA.similarity_empty(i,j) = isempty(TTA.similarity_scores{i,j});
    end
end

clearvars i j 
%% if one TTA.start_end_time intersects with more than one TTA.selected_time:

% determine rows (a) and columns (b) in TTA.similairty_scores matrix where the matrix element is zero
% (i.e. there is similarity between TTA.start_end_time and TTA.selected_time)

[a,b] = find(~cellfun(@isempty,TTA.similarity_scores)); 

% put these rows and columns in a matrix "m"
m = [a b];

% Determine the values in the array a that are repeated (TTA.start_end_time in TTA.similarity_scores matrix that 
% intresect with more than one TTA.selected_time)
[ii,jj,kk]=unique(a);
out=ii(histc(kk,1:numel(ii))>1); % the array "out" holds the repeated elements

clearvars ii jj kk

% Determine the indices of values in the array a that are repeated (i.e. the "TTA.selected_time"s in TTA.similarity_scores
% matrix that intresect with more than one TTA.start_end_time)
 
[v, w] = unique( a, 'stable' );
duplicate_indices = setdiff( 1:numel(a), w );

clearvars v w

% split these values into cell array according to the row number

grp = cumsum([true, diff(duplicate_indices)~=1]);
C   = splitapply(@(x) {x}, duplicate_indices, grp);

% Convert repeated values in the TTA.similarity_empty matrix from 0 to 1
% so there is no repetition and more than one intersection

    for i = 1:size(C,2)
        for k = 1:size (C{1,i},2) 
           TTA.similarity_empty(out(i), C{1,i}(k)) = 1;
       end        
    end

clearvars i k 

%% Show indices on TTA.similarity_scores array with amplitudes higher than "TTA_amplitude" and "TTA.start_end" threshold 
c = 0;
TTA.selected_start_end = 0; % this shows indices (rows) on TTA.similarity_scores logical array with amplitudes also higher than "TTA.start_end" threshold 
for i=1:size(TTA.similarity_scores,1)
    for j = 1:size(TTA.similarity_scores,2)
    if TTA.similarity_empty (i,j)==0
        c=c+1;
        TTA.selected_start_end (c) = i;
    end
    end
end

for i=1:length(TTA.selected_start_end)  
    TTA.final_durations(i) = (length(TTA.start_end_time{1,TTA.selected_start_end(i)}))*2; % this is in msec as srate=500
end

%% Get time series from selected TTA events that meet amplitude and duration threshold (1.5* amp_threshold and duration threshold above)

clearvars c i
for i= 1:length(TTA.selected_start_end)
 TTA.eegsignal_2{i} = eeg(TTA.start_end_time{1,TTA.selected_start_end(i)});
end

% TTA_eegsignal_2 contains time series of TTA events that meet "start_end" threshold + "amplitude threshold" + duration 
% threshold (i.e entire part of the selected TTA events)

%% Determine density and durations of selected TTA events

TTA.eeg = eeg;
TTA.total_time= length (TTA.eeg)/30000; % in minutes
TTA.total_TTAs = length(TTA.final_durations);
TTA.density = TTA.total_TTAs/TTA.total_time; % number / minutes


%% Determine durations between consecutive TTA events

TTA.final_indices = {}; % this array has the time indices of the selected TTA events (time indices of TTA.eeg_2 time series)
for i=1:length(TTA.selected_start_end)  
    TTA.final_indices{1,i} = TTA.start_end_time{1,TTA.selected_start_end(i)}; % this is in msec as srate=500
end

TTA.inter_burst_interval = 0;

for i = 1:length(TTA.final_indices)-1
    TTA.inter_burst_interval (i) = ((TTA.final_indices{1,i+1}(1) - TTA.final_indices{1,i}(end))*2) / 1000; % in sec
end

%% Filter eegsignals for 4-7.5 Hz range and calculate amplitude of filtered signal using Hilbert

% create TTA filters
TTA_low = 4;
TTA_high = 7.5;
fs = 500;
order = 3; % order of filter
[b,a]=butter(order,[TTA_low,TTA_high]/(fs/2),'bandpass');

% Generate filtered signal - eeg_1
for i = 1:length(TTA.eegsignal_1)
    filtsig_1{1,i} = filter(b,a,TTA.eegsignal_1{1,i}); 
end

% Take Hilbert transform of the filtered signal
for i = 1:length(TTA.eegsignal_1)
    amp_1{1,i} = abs(hilbert(filtsig_1{1,i})); 
end

% Final amplitude for a given burst is determined by dividing total amplitude for the burst to is length

for i = 1:length(TTA.eegsignal_1)
    TTA.amplitude_1(i) = sum(amp_1{1,i})/ length(amp_1{1,i}); 
end
 
TTA.amplitude_1 = round(TTA.amplitude_1,2);  % round the final amplitude to two decimal points
TTA.mean_amp1 = mean (TTA.amplitude_1);
TTA.median_amp1 = median (TTA.amplitude_1);
TTA.inter_burst_interval = round(TTA.inter_burst_interval,2);

%% Add one sec to each side of the TTA events for PAC analysis

for i= 1:length(TTA.selected_time)
      TTA.indices_PAC{1,i} = (TTA.selected_time{1,i}(1)-500) : (TTA.selected_time{1,i}(end)+500);
end


for i= 1:length(TTA.indices_PAC)
      TTA.eeg1_PAC{1,i} = TTA.eeg(TTA.indices_PAC{1,i});
end


clearvars -except TTA
%% TTA_final structure array

TTA_final = struct();

TTA_final.eeg = TTA.eeg; % conccataned time series from REM states
TTA_final.total_time = TTA.total_time; % in minutes
TTA_final.total_TTA = TTA.total_TTAs; % total number of TTA events in the whole REM time series
TTA_final.density = TTA.density; % number of TTA events / minute of REM EEG
TTA_final.eegsignal_1 = TTA.eegsignal_1;% time series of the TTA event which only contains the peak
                                        % (i.e those that meet amplitude + duration threshold)
TTA_final.eegsignal_2 = TTA.eegsignal_2;% time series of the TTA event which contains the start + the end + the peak 
                                        % (i.e those that meet start_and_end + amplitude + duration threshold)
TTA_final.indices_1 = TTA.selected_time; % indices of TTA_final.eegsignal_1 time series
TTA_final.indices_2 = TTA.final_indices; % indices of TTA_final.eegsignal_2 time series
TTA_final.durations_1 =TTA.selected_durations; % durations of selected TTA events (that meet amplitude and duration threshold) 
TTA_final.durations_2 =TTA.final_durations; % durations of selected TTA events that begin / end with amplitude higher
                                            % than start-end threshold) + that meet amplitude and duration theshold
TTA_final.IBI = TTA.inter_burst_interval; % time (in sec) between two consecutive TTA burst
TTA_final.amp = TTA.amplitude_1; % amplitude for each of the detected TTA event (sum amplitude / length of TTA event)
TTA_final.mean_amp = TTA.mean_amp1; % mean amplitude for all TTA events 
TTA_final.median_amp = TTA.median_amp1;% median amplitude for all TTA events 
TTA_final.indices_PAC = TTA.indices_PAC; % indices of TTA events that contain one sec from each side for PAC analysis
TTA_final.eeg1_PAC = TTA.eeg1_PAC; % time series of TTA events that contain one sec from each side for PAC analysis

clearvars -except TTA_final

%% save structure array TTA_final to use for the script "PAC_arrays"

save('C:\Users\Cigdem\MATLAB Drive\baby EEG\Baby Files\scripts for manuscript\GITHUB\TTA_final.mat')

%% end

