function perc_time = find_temp_bias_response(corr_val, p)
%   For each time bin in a central window, computes the perceived time as 
%   a weighted average of neighbouring bin times, where weights are the 
%   correlations between the bin's correlation map and each neighbour's map.

times = (-665:7:308)';   % time axis (ms)
T     = 22;              % half-window width for 7ms bins 

IDX_START = 60;
IDX_END   = 110;      

if ~isequal(size(corr_val), size(p))
    error('find_temp_bias_response:sizeMismatch', ...
          'corr_val and p must have identical sizes.\n Got corr_val: [%s], p: [%s].', ...
          num2str(size(corr_val)), num2str(size(p)));
end

min_bins = IDX_END + T;
if size(corr_val, 3) < min_bins
    error('find_temp_bias_response:insufficientBins', ...
          'corr_val must have at least %d bins along dim 3 (has %d).', ...
          min_bins, size(corr_val, 3));
end

corr_min = min(corr_val(:));
corr_max = max(corr_val(:));
corr_val = (corr_val - corr_min) / (corr_max - corr_min);

ind_t = 0;

for t = IDX_START:IDX_END 
    ind_t = ind_t + 1;

    map_t = corr_val(:, :, t);
    p_t   = squeeze(p(:, :, t));    

    n_neighbors = 2 * T + 1;
    R_neighbor  = nan(1, n_neighbors);

    for k = -T:T
        map_neighbor = corr_val(:, :, t + k);
        p_neighbor   = squeeze(p(:, :, t + k));    

        [r_mat, ~] = corrcoef(map_t, map_neighbor, 'Rows', 'pairwise');
        R_neighbor(k + T + 1) = r_mat(1, 2);
    end

    t_neighbor = times(t - T : t + T);

    R_sum    = sum(R_neighbor, 'omitnan');
    time_sum = sum(R_neighbor' .* t_neighbor, 'omitnan');

    perc_time(ind_t) = time_sum / R_sum;

end   
