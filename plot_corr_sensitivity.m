%% Visualization of correlation sensitivity maps and sigmoid fit example

addpath(genpath('functions'));

load('Data\corr_sensitivity.mat'); 
t2sac = (-200:5:50)';

%% Figure 2a: Correlation maps across a range of time-to-saccade bins
t2sac_indices = 1:10:51;     % bins to display as tiles
delay_axis    = 1:2:200;     % delay axis (ms) for both image dimensions
axis_limit    = 170;         % display range for x/y axes (ms)

color_limits = [min(corr_sens(:)) max(corr_sens(:))];

figure;
tile = tiledlayout(2, 3, 'TileSpacing', 'Compact');

for t = t2sac_indices
    nexttile;
    imagesc(delay_axis, delay_axis, squeeze(corr_sens(:,:,t)), color_limits);
    set(gca, 'YDir', 'normal');
    colormap hot;
    title(['Time to saccade = ', num2str(t2sac(t)), ' ms']);
    xlim([0 axis_limit]);
    ylim([0 axis_limit]);
    axis square;
end

cb = colorbar;
cb.Layout.Tile = 'east';
ylabel(cb, 'Correlation coefficient (a.u.)');
xlabel(tile, 'Delay (ms)');
ylabel(tile, 'Delay (ms)');
sgtitle('Figure 2a')

%% Figure 2b: Sigmoid fit example for a single (delay, t2sac) pair

t2sac_idx   = 1;     % example time-to-saccade bin
delay_idx   = 10;    % example delay bin
delay_band  = 45;    % upper bound of the delay range used for this slice

fit_options = fitoptions('Method', 'NonlinearLeastSquares', 'Normalize', 'on', ...
    'StartPoint', [25 25 -0.5], 'Lower', [-inf -inf -inf], 'Upper', [inf inf inf]);
fit_type = fittype('((-c+1)/(1+exp(a*x+b)))+c', 'options', fit_options);

raw_slice  = squeeze(corr_sens(delay_idx, delay_idx:delay_band, t2sac_idx));
norm_slice = normalize(raw_slice, 'range');

x_sparse = (delay_idx*2 - 0.5) : 2   : 89.5;   % original delay axis (ms)
x_dense  = (delay_idx*2 - 0.5) : 0.5 : 89.5;   % upsampled delay axis (ms)
interp_slice = interp1(x_sparse, norm_slice, x_dense);

[fitted_model, ~] = fit(x_dense', interp_slice', fit_type);
y_fitted = feval(fitted_model, x_dense);

[~, half_idx] = min(abs(y_fitted - 0.5));
crossing_found = any(y_fitted < 0.5);

figure;
if crossing_found
    plot(x_sparse, norm_slice, 'k.', 'LineWidth', 2);
    hold on;
    plot(x_dense, y_fitted, 'r', 'LineWidth', 2);
    plot(1:200, 0.5*ones(200,1), 'k--');

    y_to_half  = min(norm_slice):0.1:0.5;
    y_full     = min(norm_slice):0.1:1;
    plot(x_dense(half_idx) * ones(size(y_to_half)), y_to_half, 'k--');
    plot(delay_idx*2 * ones(size(y_full)), y_full, 'k--');

    legend('Normalized correlation', 'Sigmoidal fit');
    xlabel('Delay (ms)');
    ylabel('Normalized correlation (a.u.)');

    time_diff_estimate = x_dense(half_idx) - delay_idx*2;
    rectangle('Position', [delay_idx*2, min(norm_slice), time_diff_estimate, 0.02], ...
              'FaceColor', [0.5 0.5 0.5], 'EdgeColor', [0.5 0.5 0.5], 'LineWidth', 3);
end

axis tight;
xlim([1 85]);
title('Figure 2b');
