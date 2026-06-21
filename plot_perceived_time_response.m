%% Visualization of perceived time 

addpath(genpath('functions'));

clear;
set(0, 'DefaultFigureWindowStyle', 'docked');

%% Load data
load(fullfile('Data', 'perceived_time_response.mat'));           

per_full      = perc_time_resp;
per_bias_red  = perc_time_resp_red(:,:,1);   % synthetic response for bias-reduced model
per_noise_red = perc_time_resp_red(:,:,2);   % synthetic response for noise-reduced model

times_full = (-364:7:105)';   % time axis for the neural response 
times_red  = (-365:5:105)';   % time axis for the synthetic reponse of reduced models

XLIM_RANGE = [-250 100];
YLIM_RANGE = [-250 150];
HIST_BIN_WIDTH = 50;

mean_full = mean(per_full, 2, 'omitnan');

%% Neural response vs bias-reduced synthetic response
figure;
niceplot3(times_full, per_full', 5, 0, 0, 1);
hold on;
niceplot3(times_red, per_bias_red', 5, 1, 0, 0);
plot(times_red, times_red, 'k--');

xlim(XLIM_RANGE);
ylim(YLIM_RANGE);
axis square;
xlabel('Real time of stimulus to saccade onset (ms)');
ylabel('Perceived time of stimulus to saccade onset (ms)');
title('Full vs bias-reduced model: Figure 6g');

%% Neural response vs noise-reduced synthetic response
figure;
niceplot3(times_full, per_full', 5, 0, 0, 1);
hold on;
niceplot3(times_red, per_noise_red', 5, 1, 0, 0);
plot(times_red, times_red, 'k--');

xlim(XLIM_RANGE);
ylim(YLIM_RANGE);
axis square;
xlabel('Real time of stimulus to saccade onset (ms)');
ylabel('Perceived time of stimulus to saccade onset (ms)');
title('Full vs noise-reduced model: Figure 7g');

%% reduced models
mean_bias_red  = mean(per_bias_red, 2, 'omitnan');
mean_noise_red = mean(per_noise_red, 2, 'omitnan');

%% Histogram, Neural response vs bias-reduced synthetic response
figure;
histogram(mean_full, 'Normalization', 'percentage', 'BinWidth', HIST_BIN_WIDTH);
hold on;
histogram(mean_bias_red, 'Normalization', 'percentage', 'BinWidth', HIST_BIN_WIDTH);
xlim([-250 150]);
xlabel('Mean perceived time (ms)');
ylabel('Percentage (%)');
legend('Full', 'Bias-reduced');
title('Full vs bias-reduced model');

%% Histogram, Neural response vs noise-reduced synthetic response 
figure;
histogram(mean_full, 'Normalization', 'percentage', 'BinWidth', HIST_BIN_WIDTH);
hold on;
histogram(mean_noise_red, 'Normalization', 'percentage', 'BinWidth', HIST_BIN_WIDTH);
xlim([-250 150]);
xlabel('Mean perceived time (ms)');
ylabel('Percentage (%)');
legend('Full', 'Noise-reduced');
title('Full vs noise-reduced model');
