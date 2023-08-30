
% This script is used to generate EEG time series from REM states. 
% Input file is the structure array "EEG" (when the time series is imported using EEGLab GUI the array appears in the workspace)
% The output file is the structure array "REM_single" 

%% Load EEG data using EEGLAB GUI

% Once EEG data file is opened using EEGLAB toolbox, press green button "RUN" to generate the output which contain 
% REM time series from channel T7 and T8 (REM_single)

%% Extract indices of relevant states from Scores table 
scores = EEG.event;
% remove some fieds from the array (init_index,init_time, urevent, duration)
fields = {'init_index','init_time','urevent','duration'};
scores = rmfield(scores,fields);

% Find indices of empty fields in "scores" structure array 
emptyIndex = find(arrayfun(@(scores) isempty(scores.position),scores));

% Remove rows of "boundaries" from the scores structure array
scores(emptyIndex) = [];

% Remove two fields from the structre array (position and latency)
fields = {'position','latency'};
scores2 = rmfield(scores,fields); %Remove the field "Position" from the scores array
scores_cell = struct2cell(scores2); % convert structure array "scores" to cell array
scores_cell = squeeze (scores_cell); % remove dimensions of length 1

% Find index of REM, NREM, WAKE epochs in the Table Scores 
indexNREM=find(strcmpi(scores_cell,'NREM'));
NREM = indexNREM;

indexREM=find(strcmpi(scores_cell,'REM'));
REM = indexREM;

indexAwake=find(strcmpi(scores_cell,'Awake'));
Awake = indexAwake;

indexTrans = find(strcmpi(scores_cell,'Trans'));
Trans = indexTrans;

% Remove two fields from the structre array (position and type)
fields = {'position','type'};
scores3 = rmfield(scores,fields); %Remove the field "Position" from the scores array
latencies = (struct2array(scores3))'; % convert structure array "scores3" to "latencies" array

%% Find consecutive series in REM array

v=REM';
z= REM;

id=[length(z) diff(v) length(z)]==1;
ii1=strfind(id,[0 1]); % ii1 vector contains first index of the consecutive REM epochs
ii2=strfind(id,[ 1 0]);% ii2 vector contains last index of the consecutive serie

REM_epochs = {};

%% Generate REM epochs
for i = 1:length(ii1)-1
        if REM(ii2(end)) == length(scores_cell)
         REM_epochs{i,1} = latencies(REM(ii1(i)) : REM(ii2(i))+1);
             REM_epochs{length(ii1),1} = latencies(REM(ii1(length(ii1))) : REM(ii2(length(ii1))));
           
        else
         REM_epochs{i,1} = latencies(REM(ii1(i)) : REM(ii2(i))+1);
             REM_epochs{length(ii1),1} = latencies(REM(ii1(length(ii1))) : REM(ii2(length(ii1)))+1); 
     
        end
end

%% extract time series from channel T7
chan = 'T7'; % channel to analyse
eeg_T7 = EEG.data (find (strcmpi({EEG.chanlocs.labels},chan)==true),:);
eeg_T7 = double(eeg_T7); % convert single data to double precision data

%% extract time series from channel T8
chan = 'T8'; % channel to analyse
eeg_T8 = EEG.data (find (strcmpi({EEG.chanlocs.labels},chan)==true),:);
eeg_T8 = double(eeg_T8); % convert single data to double precision data


%% Some EEG recordings do not have T7 and T8 channels but have T3 and T4 channels (the same), in that case use the codes commented below

% extract time series from channel T3
% chan = 'T3'; % channel to analyse
% eeg_T3 = EEG.data (find (strcmpi({EEG.chanlocs.labels},chan)==true),:);
% eeg_T3 = double(eeg_T3);
% 
% extract time series from channel T4
% chan = 'T4'; % channel to analyse
% eeg_T4 = EEG.data (find (strcmpi({EEG.chanlocs.labels},chan)==true),:);
% eeg_T4 = double(eeg_T4);

%% Extract time series from REM epochs 
REM_T7 = {};

for i = 1:length(REM_epochs)-1
    if strcmpi(scores_cell{end}, 'REM')
    REM_T7 {i,1} = eeg_T7(REM_epochs{i,1}(1) : REM_epochs{i,1}(end));
    REM_T7 {length(REM_epochs),1} = eeg_T7(REM_epochs{length(REM_epochs),1}(1) : end);
    else
    REM_T7 {i,1} = eeg_T7(REM_epochs{i,1}(1) : REM_epochs{i,1}(end));
    REM_T7 {length(REM_epochs),1} = eeg_T7(REM_epochs{length(REM_epochs),1}(1) : latencies (REM(end) +1));  
    end
end

REM_T8 = {};

for i = 1:length(REM_epochs)-1
    if strcmpi(scores_cell{end}, 'REM')
    REM_T8 {i,1} = eeg_T8(REM_epochs{i,1}(1) : REM_epochs{i,1}(end));
    REM_T8 {length(REM_epochs),1} = eeg_T8(REM_epochs{length(REM_epochs),1}(1) : end);
    else
    REM_T8 {i,1} = eeg_T8(REM_epochs{i,1}(1) : REM_epochs{i,1}(end));
    REM_T8 {length(REM_epochs),1} = eeg_T8(REM_epochs{length(REM_epochs),1}(1) : latencies (REM(end) +1));  
    end
end

%% Output
output.REM_T7 = REM_T7;
output.REM_T8 = REM_T8;
REM_single = output; 

clearvars -except REM_single 

% REM_single array contains time series from REM states for T7 (T3) and T8
% (T4) channels. The array has two fields: one field for T7 and the other
% field is for T8 REM time series. Each field contains a cell array with
% one column and "n" number of rows where the number of rows indicate the
% number of time REM state was detected in the recording. For example if,
% in the recording, two REM states were detected then the cell arrays in
% each field of the REM_single structure array will have one column and two
% rwos. Each row is a double array that contains time series from the REM state. 

% save REM_single structure array for the next step (script "REM_series")
save('C:\Users\cigde\MATLAB Drive\baby EEG\Baby Files\scripts for manuscript\GITHUB\REM_single.mat');

%% end
