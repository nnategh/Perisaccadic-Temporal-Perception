%% Visualization of perceived time to saccade (full vs reduced models) 

addpath(genpath('functions'));

load('Data\perceived_time.mat');   
t2sac = (-250:5:135)';

per_full       = perc_time(:,:,1);   % full model
per_bias_red   = perc_time(:,:,2);   % bias-reduced model
per_noise_red  = perc_time(:,:,3);   % noise-reduced model 

%% Full vs bias-reduced model
figure;
niceplot3(t2sac, per_full', 5, 0, 0, 1);
hold on;
niceplot3(t2sac, per_bias_red', 7, 1, 0, 0);
plot(t2sac, t2sac, 'k--');
xlabel('Real t2sac (ms)');
ylabel('Perceived t2sac (ms)');
axis tight square;

%% Full vs noise-reduced model
figure;
niceplot3(t2sac, per_full', 5, 0, 0, 1);
hold on;
niceplot3(t2sac, per_noise_red', 7, 1, 0, 0);
plot(t2sac, t2sac, 'k--');
xlabel('Real t2sac (ms)');
ylabel('Perceived t2sac (ms)');
axis tight square; 

%% Histogram overlay, full vs bias-reduced model
mean_full = mean(per_full, 2, 'omitnan');
mean_bias_red = mean(per_bias_red, 2, 'omitnan');
figure;
h = histogram(mean_full, 9, 'Normalization', 'percentage');
edges = h.BinEdges;
hold on;
histogram(mean_bias_red, edges, 'Normalization', 'percentage');
ylabel('Percentage (%)');
xlim([-230 150])

%% Histogram overlay, full vs noise-reduced model 
mean_noise_red = mean(per_noise_red, 2, 'omitnan');
figure;
h = histogram(mean_full, 9, 'Normalization', 'percentage');
edges = h.BinEdges;
hold on;
histogram(mean_noise_red, edges, 'Normalization', 'percentage');
ylabel('Percentage (%)');
xlim([-230 150])
