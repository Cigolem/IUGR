%% This script is used to  plot PSDs from early CGA and late CGA groups (all subjects included, i.e control + experimental)

% Input files are:
            % PSD esimates as averaged for T7 and T8 channels from all babies with 30-33 (approximately) CGA weeks (PSD_early_av); 
            % PSD esimates as averaged for T7 and T8 channels from all babies with 33-40 (approximately) CGA weeks (PSD_late_av);
            % frequency spectrum to use for PSD plotting (freq_PSD)
% Output is the plot showing PSD estimate in both groups

% Load all T7/T8 PSD estimates from all early and late CGA subjects

load('C:\Users\cigde\MATLAB Drive\baby EEG\Baby Files\scripts for manuscript\GITHUB\PSD_early_av')
load('C:\Users\cigde\MATLAB Drive\baby EEG\Baby Files\scripts for manuscript\GITHUB\PSD_late_av')
load('C:\Users\cigde\MATLAB Drive\baby EEG\Baby Files\scripts for manuscript\GITHUB\freq_PSD')


% Put average T7/T8 PSD estimates from all control and experimental subjects into one matrix

    Early_PSD = vertcat (PSD_early_av {1,:});
    Late_PSD = vertcat (PSD_late_av {1,:});

% Determine mean, sem, low and high bounds

 Early_PSD_mean = mean (Early_PSD,1);
 Early_PSD_sem = std(Early_PSD, [], 1)./sqrt(size(Early_PSD, 1));
 Early_PSD_lo = Early_PSD_mean - Early_PSD_sem;
 Early_PSD_hi = Early_PSD_mean + Early_PSD_sem;

Late_PSD_mean = mean (Late_PSD,1);
Late_PSD_sem = std(Late_PSD, [], 1)./sqrt(size(Late_PSD, 1));
Late_PSD_lo = Late_PSD_mean - Late_PSD_sem;
Late_PSD_hi = Late_PSD_mean + Late_PSD_sem;

%% Plot
t = freq_PSD';
figure(1)
hold on
patch([t fliplr(t)], [Early_PSD_lo fliplr(Early_PSD_hi)], 'r', 'EdgeColor', 'none', 'FaceAlpha','0.6')
plot(t, Early_PSD_mean, 'k', 'linewidth', 1)
patch([t fliplr(t)], [Late_PSD_lo fliplr(Late_PSD_hi)], 'b', 'EdgeColor', 'none', 'FaceAlpha','0.6')
plot(t, Late_PSD_mean, 'k', 'linewidth', 1)
hold off
xlabel('Frequency log scale (Hz)')
set(gca, 'XScale', 'log')
xlim ([0.2 40])
set(gca, 'xtick', [0.2 0.5 1 2 3 4 5 6 8 10 20 30 40])
ylabel('PSD (uV^2/Hz)')
title('All Babies PSD Estimate')
set(gca, 'FontSize', 34, 'TickDir', 'out', 'box', 'off')  
legend({'30.57-32.86 weeks CGA';'';'33.00-39.42  weeks CGA'})


%% end