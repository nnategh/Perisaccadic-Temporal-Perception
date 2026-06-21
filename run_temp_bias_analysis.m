%% Produces Figure 4d of the paper
% Loads correlation and p-value data, computes perceived time via
% find_temp_bias, and plots perceived vs real time-to-saccade onset.

addpath(genpath('functions')); 

DATA_FILE   = 'Data\corr_bias.mat';   
CORR_VAR    = 'corr_bias';       
PVAL_VAR    = 'pval_bias';       

T2SAC_START = -250;   % (ms) first bin of the output axis
T2SAC_STEP  =    5;   % (ms) step between bins
T2SAC_END   =  100;   % (ms) last bin of the output axis

if ~isfile(DATA_FILE)
    error('run_temp_bias_analysis:fileNotFound', ...
          'Data file not found: %s\nCheck DATA_FILE in the PARAMETERS section.', ...
          DATA_FILE);
end

loaded = load(DATA_FILE, CORR_VAR, PVAL_VAR);

corr_bias = loaded.(CORR_VAR);
pval_bias = loaded.(PVAL_VAR);

% Compute perceived time
fprintf('Computing temporal bias...\n');
perceived_time = find_temp_bias(corr_bias, pval_bias);
fprintf('Done.\n');

t2sac_axis = (T2SAC_START : T2SAC_STEP : T2SAC_END)';

% Figure
figure('Name', 'Temporal Bias Analysis', 'NumberTitle', 'off');
plot(t2sac_axis, perceived_time, 'LineWidth', 1.5, ...
     'DisplayName', 'Perceived t2sac');
hold on;
plot(t2sac_axis, t2sac_axis, 'k--', 'LineWidth', 1, ...
     'DisplayName', 'Veridical'); 
hold off;

xlabel('Real time to saccade (ms)');
ylabel('Perceived time to saccade (ms)');
title('Temporal bias: Figure 4d');
legend('Location', 'northwest');
axis tight square;
