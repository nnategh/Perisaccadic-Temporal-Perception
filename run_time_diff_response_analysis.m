%% Produces Figure 3b,d of the paper
clear;
set(0, 'DefaultFigureWindowStyle', 'docked');

addpath(genpath('functions')); 

DATA_FILE = fullfile('Data', 'corr_sensitivity_response.mat');   
DATA_VAR  = 'corr_sens_resp';

BIN_SIZE    = 10;             % (ms) delay bin size 
TIME_START  = -252;           % (ms) first time bin
TIME_STEP   =    7;           % (ms) step between time bins
TIME_END    =   49;           % (ms) last time bin

DELAY_BAND  = (40/BIN_SIZE +1):60/BIN_SIZE;     % delay-bin range averaged 

loaded = load(DATA_FILE, DATA_VAR);

corr_sens_resp = loaded.(DATA_VAR);

% Compute time differences
fprintf('Computing time differences...\n');
time_diff = find_time_diff_response(corr_sens_resp);
fprintf('Done.\n');

times = (TIME_START : TIME_STEP : TIME_END)';

% Mean time difference 
figure;
subplot(212)
plot(times, mean(time_diff(:, DELAY_BAND), 2, 'omitnan'), 'LineWidth', 1.5);
xlabel('stimulus time to saccade (ms)');
ylabel('time difference (ms)');
axis tight;
title('Mean time difference over delays 40-60 ms, Figure 3d');

% Time difference across time and delay
delay_axis = 1:BIN_SIZE:200;

subplot(211)
surf(times, delay_axis, time_diff');
xlabel('stimulus time to saccade (ms)');
ylabel('delay (ms)');
axis tight;
set(gca, 'YDir', 'normal');
c = colorbar;
ylabel(c, 'Time difference (ms)');
colormap('jet');
shading interp;
view([0 90]);
title('Time difference across time and delay, Figure 3b');
