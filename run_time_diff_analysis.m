%% Produces Figure 2c,e of the paper 
addpath(genpath('functions'));

DATA_FILE      = 'Data\corr_sensitivity.mat';   
DATA_VAR       = 'corr_sens';               

T2SACC_START   = -250;   % (ms) first time-to-saccade bin
T2SACC_STEP   =    5;    % (ms) step between bins
T2SACC_END    =   50;    % (ms) last time-to-saccade bin

BIN_SIZE      =    2;    % (ms) delay bin size
N_DELAY_BINS  =   85;    % number of delay bins to display in the colour map

BAND_LOW_MS   =   40;    % (ms) lower edge of delay band for mean plot
BAND_HIGH_MS  =   60;    % (ms) upper edge of delay band for mean plot

if ~isfile(DATA_FILE)
    error('run_time_diff_analysis:fileNotFound', ...
          'Data file not found: %s\nCheck DATA_FILE in the PARAMETERS section.', ...
          DATA_FILE);
end

loaded = load(DATA_FILE, DATA_VAR);

corr_sens = loaded.(DATA_VAR);

fprintf('Computing time differences...\n');
time_diff = find_time_diff(corr_sens);
fprintf('Done.\n');

t2sacc_axis = (T2SACC_START : T2SACC_STEP : T2SACC_END)';   % (#bins x 1)
delay_axis  = 1 : BIN_SIZE : (N_DELAY_BINS * BIN_SIZE);      % delay in ms

% Index range for the 40–60 ms delay band
band_low_idx  = BAND_LOW_MS  / BIN_SIZE + 1;
band_high_idx = BAND_HIGH_MS / BIN_SIZE;

fig = figure('Name', 'Time Difference Analysis', 'NumberTitle', 'off');
subplot(2, 1, 1);
imagesc(t2sacc_axis, delay_axis, squeeze(time_diff(:, 1:N_DELAY_BINS))');
xlabel('Time to saccade (ms)');
ylabel('Delay (ms)');
axis tight;
c = colorbar;
ylabel(c, 'Time difference (ms)');
set(gca, 'YDir', 'normal');
colormap(gca, jet);   
shading interp;
view([0 90]);
hold on;
z_level = max(time_diff(:), [], 'omitnan');    
plot3([T2SACC_START T2SACC_END], [BAND_LOW_MS  BAND_LOW_MS],  [z_level z_level], ...
      'k--', 'DisplayName', sprintf('%d ms', BAND_LOW_MS));
plot3([T2SACC_START T2SACC_END], [BAND_HIGH_MS BAND_HIGH_MS], [z_level z_level], ...
      'k--', 'DisplayName', sprintf('%d ms', BAND_HIGH_MS));
hold off;
title('Time difference: Figure 2c');

subplot(2, 1, 2);
band_mean = mean(time_diff(:, band_low_idx:band_high_idx), 2, 'omitnan');
plot(t2sacc_axis, band_mean, 'Color', 'b', 'LineWidth', 2);
xlabel('Time to saccade (ms)');
ylabel('Time difference (ms)');
axis tight;
title(sprintf('Mean time difference (over delay of %d–%d ms, Figure 2e)', ...
              BAND_LOW_MS, BAND_HIGH_MS));
