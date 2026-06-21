%% Produces Figure 5b of the paper
clear;
set(0, 'DefaultFigureWindowStyle', 'docked');

addpath(genpath('functions'));

DATA_FILE = fullfile('Data', 'corr_resp_bias.mat');
CORR_VAR  = 'corr_val_resp';
PVAL_VAR  = 'pval'; 

loaded = load(DATA_FILE, CORR_VAR, PVAL_VAR);

corr_val_resp = loaded.(CORR_VAR);
pval          = loaded.(PVAL_VAR);

fprintf('Computing temporal bias (neural response)...\n');
perc_time = find_temp_bias_response(corr_val_resp, pval);
fprintf('Done.\n');

times = -250:7:100;

figure;
plot(times, perc_time, 'LineWidth', 2);
grid on;
xlabel('Real stimulus time to saccade (ms)');
ylabel('Perceived stimulus time to saccade (ms)');
title('Temporal bias: neural response (figure 5b)');
hold on;
plot(times, times, 'k--'); 
axis tight square; 
