function time_diff = find_time_diff(corr_val)
%   Find time difference for each ensemble via sigmoidal fit
%
%   Fits a sigmoidal function to normalised correlation slices and returns
%   the difference between actual delay and the delay at which each fitted curve crosses 0.5.
%   This is computed for every combination of time-to-saccade and delay bin.
%
%   Input:
%     corr_val  – 3-D numeric array of size (#delay x #delay x #t2sacc).
%                 Each element represents a correlation value for a given
%                 delay bin and time-to-saccade index.
%
%   Output:
%     time_diff – 2-D matrix of size (#t2sacc x #delay).
%                 Each entry is the difference between actual delay and 
%                 the delay at which the sigmoid crosses 0.5. 
%                 Entries remain NaN when the fit fails or
%                 when the correlation slice is flat (zero range).

if ~isnumeric(corr_val) || ndims(corr_val) ~= 3
    error('find_time_diff:badInput', ...
          'corr_val must be a 3-D numeric array.');
end 

n_t2sacc = size(corr_val, 3);
n_delay  = size(corr_val, 2);

fit_options = fitoptions( ...
    'Method',     'NonlinearLeastSquares', ...
    'Normalize',  'on', ...
    'StartPoint', [25  25  0], ...
    'Lower',      [0  -inf -inf], ...
    'Upper',      [inf inf  inf]);

fit_type = fittype( ...
    '((-c+1) / (1 + exp(a*x + b))) + c', ...
    'options', fit_options);

time_diff = nan(n_t2sacc, n_delay);

for t2sacc = 1:n_t2sacc
    for delay = 1:n_delay

        raw_slice = squeeze(corr_val(delay, delay:end, t2sacc));

        % Min–max normalisation to [0, 1]
        val_min = min(raw_slice);
        val_max = max(raw_slice);

        if val_max == val_min
            % skip: normalization would divide by zero 
            continue
        end

        norm_slice = (raw_slice - val_min) / (val_max - val_min);

        % Upsample from 2 ms steps to 0.5 ms steps via linear interpolation
        x_sparse = 0 : 2   : (length(norm_slice) * 2 - 2);  % original 
        x_dense  = 0 : 0.5 : (length(norm_slice) * 2 - 2);  % upsampled 
        interp_slice = interp1(x_sparse, norm_slice, x_dense);

        try
            % Fit the sigmoid model to the upsampled data
            [fitted_model, ~] = fit(x_dense', interp_slice', fit_type);

            % Evaluate the fitted curve and find the 0.5 crossing
            y_fitted         = feval(fitted_model, x_dense);
            [~, half_idx]    = min(abs(y_fitted - 0.5));
            time_diff(t2sacc, delay) = x_dense(half_idx);

        catch fit_err
            % warning('find_time_diff:fitFailed', ...
            %         'Sigmoid fit failed at t2sacc=%d, delay=%d — %s', ...
            %         t2sacc, delay, fit_err.message); 
        end

    end  
end  
