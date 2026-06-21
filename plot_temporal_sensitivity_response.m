%% Produces Figure 3c,e, Figure 6h-i, Figure 7h-i of the paper 

addpath(genpath('functions'));

clear;
set(0, 'DefaultFigureWindowStyle', 'docked');

%% Load data
load(fullfile('Data', 'temporal_sensitivity_response.mat'));           

diff_bias_red  = time_diff_red_resp(:,:,:,1);   % bias-reduced model
diff_noise_red = time_diff_red_resp(:,:,:,2);   % noise-reduced model

BIN_SIZE    = 10;             % (ms) delay bin size
N_ENSEMBLES = 15;             % number of neural ensembles
T2SAC_SIZE  = 105;            % number of t2sac bins in the reduced-model surface plots

times_full = (-399:7:203)';   % time axis for the full model
times      = (-360:5:160)';   % time axis for the reduced models

delay_band_low  = 40/BIN_SIZE + 1;
delay_band_high = 60/BIN_SIZE;

base_idx_full = 1:18;       % baseline window index (neural data)
base_idx_red  = 1:33;       % baseline window index (synthetic response of reduced models)

baseline_full = squeeze(mean(mean(diff_resp(:, base_idx_full, delay_band_low:delay_band_high), 2, 'omitnan'), 3, 'omitnan'));
timecourse_full = mean(diff_resp(:,:,delay_band_low:delay_band_high), 3, 'omitnan') - baseline_full;

%% neural response vs synthetic noise-reduced response 
figure;
niceplot3(times_full, timecourse_full, 10, 0, 0, 1);
hold on;
plot(-250:50, zeros(301,1), 'k--', 'LineWidth', 1.5);

baseline_noise_red = squeeze(mean(mean(diff_noise_red(:, base_idx_red, delay_band_low:delay_band_high), 2, 'omitnan'), 3, 'omitnan'));
timecourse_noise_red = mean(diff_noise_red(:,:,delay_band_low:delay_band_high), 3, 'omitnan') - baseline_noise_red;

niceplot3(times, timecourse_noise_red, 10, 1, 0, 0);

xlabel('Time of stimulus from saccade onset (ms)');
ylabel('Time difference (ms)');
axis tight;
xlim([-250 50]);
title('Figure 7i');
legend('','neural response','','', 'synthetic response of noise-reduced model');

%% Per-ensemble normalized surf (noise-reduced model)
norm_noise_red = nan(N_ENSEMBLES, T2SAC_SIZE, N_ENSEMBLES);
for ensemble = 1:N_ENSEMBLES
    ensemble_mean = squeeze(mean(diff_noise_red(ensemble,:,:), 1, 'omitnan'));
    ref_min = min(ensemble_mean(:));
    ref_max = max(ensemble_mean(:));
    norm_noise_red(ensemble,:,:) = (ensemble_mean - ref_min) / (ref_max - ref_min);
end

%% Surface plot, noise-reduced model 
figure;
delay_axis = 1:BIN_SIZE:150;

surf(times, delay_axis, squeeze(mean(norm_noise_red, 1, 'omitnan'))');
xlabel('Time (ms)');
ylabel('Time difference (ms)');
axis tight;
set(gca, 'YDir', 'normal');
colorbar;
colormap('jet');
shading interp;
view([0 90]);

hold on;
plot3([times(1) times(end)], [40 40], [50 50], 'k--', 'LineWidth', 2);
plot3([times(1) times(end)], [60 60], [50 50], 'k--', 'LineWidth', 2);
xlim([-250 150]);
title('Figure 7h');

%% neural response vs synthetic response of bias-reduced model 
figure;
niceplot3(times_full, timecourse_full, 10, 0, 0, 1);
hold on;
plot(-250:50, zeros(301,1), 'k--', 'LineWidth', 1.5);

baseline_bias_red = squeeze(mean(mean(diff_bias_red(:, base_idx_red, delay_band_low:delay_band_high), 2, 'omitnan'), 3, 'omitnan'));
timecourse_bias_red = mean(diff_bias_red(:,:,delay_band_low:delay_band_high), 3, 'omitnan') - baseline_bias_red;

niceplot3(times, timecourse_bias_red, 10, 1, 0, 0);

xlabel('Time of stimulus from saccade onset (ms)');
ylabel('Time difference (ms)');
axis tight;
xlim([-250 50]);
title('Figure 6i');
legend('','neural response','','', 'synthetic response of bias-reduced model');

%% Per-ensemble normalized surface (bias-reduced model)
norm_bias_red = nan(N_ENSEMBLES, T2SAC_SIZE, N_ENSEMBLES);
for ensemble = 1:N_ENSEMBLES
    ensemble_mean = squeeze(mean(diff_bias_red(ensemble,:,:), 1, 'omitnan'));
    ref_min = min(ensemble_mean(:));
    ref_max = max(ensemble_mean(:));
    norm_bias_red(ensemble,:,:) = (ensemble_mean - ref_min) / (ref_max - ref_min);
end

%% Surface plot, bias-reduced model 
figure;
surf(times, delay_axis, squeeze(mean(norm_bias_red, 1, 'omitnan'))');
xlabel('Time (ms)');
ylabel('Time difference (ms)');
axis tight;
set(gca, 'YDir', 'normal');
colorbar;
colormap('jet');
shading interp;
view([0 90]);

hold on;
plot3([times(1) times(end)], [40 40], [50 50], 'k--', 'LineWidth', 2);
plot3([times(1) times(end)], [60 60], [50 50], 'k--', 'LineWidth', 2);
xlim([-250 50]);
title('Figure 6h');
