function time_diff = find_time_diff_response(corr_resp)
%   Input:
%     corr_resp – 3-D numeric array (#delay x #delay x #time).
%
%   Output:
%     time_diff – (#time x #delay-bins) matrix, where #delay-bins =
%                 200/binsize. 

if nargin < 1 || ndims(corr_resp) ~= 3
    error('find_time_diff_response:missingInput', ...
          'find_time_diff_response:invalidDimensions');
end 

BIN_SIZE  = 10;             % (ms) delay bin size 
N_TIME    = size(corr_resp, 3);
N_DELAY   = 200 / BIN_SIZE;

fit_options = fitoptions( ...
    'Method',     'NonlinearLeastSquares', ...
    'Normalize',  'on', ...
    'StartPoint', [25  25  0.1], ...
    'Lower',      [-inf   -inf   -inf], ...
    'Upper',      [inf inf inf]);

fit_type = fittype( ...
    '((1-c) / (1 + exp(a*x + b))) + c', ...
    'options', fit_options);

time_diff = nan(N_TIME, N_DELAY);

for time = 1:N_TIME

    time_slice = squeeze(corr_resp(:, :, time));

    for delay = 1:N_DELAY

        try
            x_sparse = delay*BIN_SIZE : BIN_SIZE : 200;
            x_dense  = delay*BIN_SIZE : 200;
            raw_col  = time_slice(delay:end, delay);

            interp_col = interp1(x_sparse, raw_col, x_dense, 'spline');

            % Min–max normalisation to [0, 1]
            val_min = min(interp_col);
            val_max = max(interp_col);
            norm_col = (interp_col - val_min) / (val_max - val_min);

            x_idx = 1:length(norm_col);

            % Fit the sigmoid model
            [fitted_model, ~] = fit(x_idx', norm_col', fit_type);
            y_fitted = feval(fitted_model, x_idx);

            [~, half_idx] = min(abs(y_fitted - 0.5));
            crossing_found = any(y_fitted < 0.5);

            if crossing_found
                time_diff(time, delay) = half_idx;
            end

        catch fit_err
            % warning('find_time_diff_response:fitFailed', ...
            %         'Fit failed at time=%d, delay=%d — %s', ...
            %         time, delay, fit_err.message);
        end

    end  
end  
