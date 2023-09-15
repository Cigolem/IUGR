% This script is used to generate modulation index for assessing the strength of phase amplitude coupling between two 
% frequency bands in REM sleep. The script uses the function "PAC_compute"
% to calculate z scores for MIs.
% 
% Input files: eeg_PAC_Control (or FGR) workspaces that contain eeg time series for each TTA event for each baby
% (time series of TTA events that have one second additional data from each side 
% Output files: 
%             PAC_Control_final (or FGR) 3D arrays that contain MI for the given frequency range for each of the TTA event
%             Plots showing MI (z-scored) for each group

%% Compute MI on Control eeg time series:

% Load the workspace with eeg_PAC time series for TTA events ad put all series in one cell array
eeg_control = struct2cell(load('C:\Users\Cigdem\MATLAB Drive\baby EEG\Baby Files\scripts for manuscript\GITHUB\arrays\eeg_PAC_Control'));

eeg_control_all = vertcat (eeg_control{:});

clearvars -except eeg_control_all;
save('C:\Users\Cigdem\MATLAB Drive\baby EEG\Baby Files\scripts for manuscript\GITHUB\arrays\eeg_control_all');

%% Compute PAC on arrays - Control
eeg = eeg_control_all;

steps = length(eeg);

nbytes = fprintf('Working on step 1 of %d', steps);

for i = 1:steps
         PAC_Control{i} =PAC_compute(eeg{i});
         while nbytes > 0
            fprintf('\i')
            nbytes = nbytes - 1;
         end
        if i+1 <= steps
            nbytes = fprintf('Working on step %d of %d', i+1, steps);
        else
            fprintf('Finished %d steps\n', steps);
        end
end

% convert from cell to vector array and save 
for i= 1:length(PAC_Control)
    j = 1:size(PAC_Control{1,i},1);
    k = 1:size(PAC_Control{1,i},2);
   PAC_Control_final(j,k,i) = PAC_Control{1,i};
end

clearvars -except PAC_Control_final 

save('C:\Users\Cigdem\MATLAB Drive\baby EEG\Baby Files\scripts for manuscript\GITHUB\arrays\PAC_Control_final');


%% Compute MI on FGR eeg time series:

% Load the workspace with eeg_PAC time series for TTA events ad put all series in one cell array
eeg_FGR = struct2cell(load('C:\Users\Cigdem\MATLAB Drive\baby EEG\Baby Files\scripts for manuscript\GITHUB\arrays\eeg_PAC_FGR'));

eeg_FGR_all = vertcat (eeg_FGR{:});

clearvars -except eeg_FGR_all;
save('C:\Users\Cigdem\MATLAB Drive\baby EEG\Baby Files\scripts for manuscript\GITHUB\arrays\eeg_FGR_all');

%% Compute PAC on arrays - FGR
eeg = eeg_FGR_all;

steps = length(eeg);

nbytes = fprintf('Working on step 1 of %d', steps);

for i = 1:steps
         PAC_FGR{i} =PAC_compute(eeg{i});
         while nbytes > 0
            fprintf('\i')
            nbytes = nbytes - 1;
         end
        if i+1 <= steps
            nbytes = fprintf('Working on step %d of %d', i+1, steps);
        else
            fprintf('Finished %d steps\n', steps);
        end
end

% convert from cell to vector array and save 
for i= 1:length(PAC_FGR)
    j = 1:size(PAC_FGR{1,i},1);
    k = 1:size(PAC_FGR{1,i},2);
   PAC_FGR_final(j,k,i) = PAC_FGR{1,i};
end

clearvars -except PAC_FGR_final 

save('C:\Users\Cigdem\MATLAB Drive\baby EEG\Baby Files\scripts for manuscript\GITHUB\arrays\PAC_FGR_final');


%% Plot
load('C:\Users\Cigdem\MATLAB Drive\baby EEG\Baby Files\scripts for manuscript\GITHUB\arrays\PAC_Control_final');

phas_freqs =  0.1:1:5;
ampl_freqs =  4:1:10;

figure('units', 'normalized', 'outerposition', [0 0 0.60 0.25])

Control_mn = mean(PAC_Control_final, 3);
FGR_mn = mean(PAC_FGR_final, 3);

bottom = min(min(min(Control_mn)),min(min(FGR_mn)));
top  = max(max(max(Control_mn)),max(max(FGR_mn)));

subplot(1, 2, 1)
contourf(phas_freqs,ampl_freqs,Control_mn',500, 'linestyle','none')
xlim ([0.1 4])
xlabel('Frequency phase')
ylabel('Frequency amplitude ')
colormap('jet')
title('Control TTA T7 MI')
set(gca, 'FontSize', 20, 'TickDir', 'out', 'box', 'off') 
caxis manual
caxis([bottom top]);
subplot(1, 2, 2)
contourf(phas_freqs,ampl_freqs,FGR_mn',500, 'linestyle','none')
xlim ([0.1 4])
xlabel('Frequency phase')
ylabel('Frequency amplitude ')
caxis manual
caxis([bottom top]);
colormap('jet')
title('FGR TTA T7 MI')
set(gca, 'FontSize', 20, 'TickDir', 'out', 'box', 'off')
hcol = colorbar;
hcol.Position = [0.92 0.130 0.02 0.8];
ylabel(hcol, 'z-modulation')
set(hcol, 'ylim', [bottom top], 'FontName', 'Times New Roman', 'FontSize', 24)

%%  end