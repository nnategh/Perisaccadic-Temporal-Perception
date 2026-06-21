function plot_temporal_surface(t2sac, binsize, normalized, clim_range)
%
%   Inputs:
%     t2sac      – time-to-saccade axis vector
%     binsize    – delay bin size (ms)
%     normalized – #t2sac x #delay x #ensembles normalized array
%     clim_range – [low high] 

    n_delay = size(normalized, 2);
    delay_axis = 1:binsize:(n_delay*binsize);

    figure;
    surf(t2sac, delay_axis, mean(normalized, 3, 'omitnan')');
    axis tight;
    c = colorbar;
    set(gca, 'YDir', 'normal');
    colormap jet;
    shading interp;
    view([0 90]);

    xlabel('Time to saccade onset (ms)');
    ylabel('Delay (ms)');
    ylabel(c, 'Time difference (a.u.)');

    hold on;
    plot3([t2sac(1) t2sac(end)], [40 40], [50 50], 'k--', 'LineWidth', 2);
    plot3([t2sac(1) t2sac(end)], [60 60], [50 50], 'k--', 'LineWidth', 2);

    if ~isempty(clim_range)
        clim(clim_range);
    end
end 
