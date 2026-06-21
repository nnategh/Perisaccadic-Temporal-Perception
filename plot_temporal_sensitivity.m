%% Visualization of temporal sensitivity (full vs reduced models)

addpath(genpath('functions'));

clear; clc;
set(0, 'DefaultFigureWindowStyle', 'docked');

load('Data\temporal_sensitivity.mat');   

diff_full      = D(:,:,:,1);   % full model
diff_bias_red  = D(:,:,:,2);   % bias-reduced model
diff_noise_red = D(:,:,:,3);   % noise-reduced model

t2sac    = (-250:5:50)';
binsize  = 2;
n_delay     = 85;     % number of delay bins shown in the surface plots
n_ensembles = 15;     % number of neural ensembles

%% Per-ensemble min-max normalization (full model)
norm_full = normalize_per_ensemble(diff_full, n_ensembles, n_delay);

%% Surf plot: full model  
plot_temporal_surface(t2sac, binsize, norm_full, []);
title('Full model: Figure 2d');

%% Per-ensemble min-max normalization (bias-reduced model)
norm_bias_red = normalize_per_ensemble(diff_bias_red, n_ensembles, n_delay);

%% Surface plot: bias-reduced model (normalized, averaged across ensembles)
plot_temporal_surface(t2sac, binsize, norm_bias_red, [0.085 0.63]);
title('Bias-reduced model: Figure 6e');

%% Per-ensemble min-max normalization (noise-reduced model)
norm_noise_red = normalize_per_ensemble(diff_noise_red, n_ensembles, n_delay);

%% Surface plot: noise-reduced model (normalized, averaged across ensembles)
plot_temporal_surface(t2sac, binsize, norm_noise_red, []);
title('Noise-reduced model: Figure 7e');

%% Baseline-subtracted time course: full model
delay_band_low  = 40/binsize + 1;
delay_band_high = 60/binsize;

baseline_full = squeeze(mean(mean(diff_full(:,11:31,delay_band_low:delay_band_high), 3, 'omitnan'), 2, 'omitnan'));
timecourse_full = squeeze(mean(diff_full(:,:,delay_band_low:delay_band_high), 3, 'omitnan')) - baseline_full;

%% Baseline-subtracted time course: full vs bias-reduced model 
baseline_bias_red = squeeze(mean(mean(diff_bias_red(:,11:21,delay_band_low:delay_band_high), 3, 'omitnan'), 2, 'omitnan'));
timecourse_bias_red = squeeze(mean(diff_bias_red(:,:,delay_band_low:delay_band_high), 3, 'omitnan')) - baseline_bias_red;

figure;
plot(-250:50, zeros(301,1), 'k--', 'LineWidth', 1.5);
hold on;
niceplot3(t2sac, timecourse_full, 10, 0, 0, 1);
niceplot3(t2sac, timecourse_bias_red, 10, 1, 0, 0);
xlabel('Time to saccade onset (ms)');
ylabel('Time difference (ms)');
axis tight;
% xlim([-250 150]);
title('Full vs bias-reduced model: Figure 6f');

%% Baseline-subtracted time course: full vs noise-reduced model
figure;
baseline_noise_red = squeeze(mean(mean(diff_noise_red(:,11:21,delay_band_low:delay_band_high), 3, 'omitnan'), 2, 'omitnan'));
timecourse_noise_red = squeeze(mean(diff_noise_red(:,:,delay_band_low:delay_band_high), 3, 'omitnan')) - baseline_noise_red;

plot(-250:50, zeros(301,1), 'k--', 'LineWidth', 1.5);
hold on;
niceplot3(t2sac, timecourse_full, 10, 0, 0, 1);
niceplot3(t2sac, timecourse_noise_red, 10, 1, 0, 0);
xlabel('Time to saccade onset (ms)');
ylabel('Time difference (ms)');
axis tight;
% xlim([-250 150]);
title('full vs noise-reduced model: Figure 7f'); 
