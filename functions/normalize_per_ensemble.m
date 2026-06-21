function normalized = normalize_per_ensemble(diff_data, n_ensembles, n_delay)
%
%   Inputs:
%     diff_data   – #ensembles x #t2sac x #delay array
%     n_ensembles – number of ensembles 
%     n_delay     – number of delay bins 
%
%   Output:
%     normalized – #t2sac x n_delay x n_ensembles array of normalized values

    n_t2sac    = size(diff_data, 2);
    normalized = nan(n_t2sac, n_delay, n_ensembles);

    for ensemble = 1:n_ensembles
        ensemble_slice = squeeze(diff_data(ensemble, :, 1:n_delay));
        ensemble_mean  = squeeze(mean(diff_data(ensemble, :, 1:n_delay), 1, 'omitnan'));
        ref_min        = min(ensemble_mean(:));
        ref_max        = max(ensemble_mean(:));
        normalized(:, :, ensemble) = (ensemble_slice - ref_min) / (ref_max - ref_min);
    end
end
