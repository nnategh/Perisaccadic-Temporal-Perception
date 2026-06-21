function perceived_time = find_temp_bias(corr_val, p)
%   Estimate perceived time for each real time-to-saccade 
%
%   For each time-to-saccade bin in a central window, computes the
%   perceived time as a weighted average of neighbouring bin times,
%   where weights are the correlations between the real and neighbour
%   correlation maps (significant cells only).
%
%   Inputs:
%     corr_val – 3-D numeric array (#delay x #delay x #t2sacc).
%     p        – 3-D numeric array, same size as corr_val.
%                p-value map corresponding to each element of corr_val.
%
%   Output:
%     perceived_time – 71 x 1 column vector (ms).
%                      Each entry is the perceived time 

T       = 30;              % half-window width (bins); 1 bin = 5 ms → ±150 ms
P_VAL   = 0.1;             % p-value threshold: cells above this are masked
T2SAC   = (-400:5:250)';   % time-to-saccade axis (ms)

% Index range of the central window 
IDX_START = T + 1;          
IDX_END   = 101;            

N_OUT = IDX_END - IDX_START + 1;   

if nargin < 2 || isempty(corr_val) || isempty(p)
    error('find_temp_bias:missingInput', ...
          'Both corr_val and p are required and must not be empty.');
end 

min_bins = IDX_END + T;
if size(corr_val, 3) < min_bins
    error('find_temp_bias:insufficientBins', ...
          'corr_val must have at least %d bins along dim 3 (has %d).', ...
          min_bins, size(corr_val, 3));
end

perceived_time = nan(N_OUT, 1);

for t2sacc = IDX_START:IDX_END

    corr_real        = squeeze(corr_val(:, :, t2sacc));
    p_real           = squeeze(p(:, :, t2sacc));
    corr_real        = normalize(corr_real);
    corr_real(p_real > P_VAL) = nan;

    % --- Neighbour correlations ---
    n_neighbors  = 2 * T + 1;
    R_neighbor   = nan(1, n_neighbors);   

    for k = -T:T
        corr_neighbor        = squeeze(corr_val(:, :, t2sacc + k));
        p_neighbor           = squeeze(p(:, :, t2sacc + k));
        corr_neighbor        = normalize(corr_neighbor);
        corr_neighbor(p_neighbor > P_VAL) = nan;

        [r_mat, ~] = corrcoef(corr_real(:), corr_neighbor(:), 'Rows', 'pairwise');
        R_neighbor(k + T + 1) = r_mat(1, 2);
    end

    % --- Weighted centre-of-mass estimate of perceived time ---
    t_neighbor = T2SAC(t2sacc - T : t2sacc + T);   % (2T+1) x 1 

    R_sum    = sum(R_neighbor,    'omitnan');
    time_sum = sum(R_neighbor' .* t_neighbor, 'omitnan');

    if R_sum ~= 0
        perceived_time(t2sacc - IDX_START + 1) = time_sum / R_sum;
    end 

end  
