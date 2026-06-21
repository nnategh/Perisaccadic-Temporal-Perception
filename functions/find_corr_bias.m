function corr_val = find_corr_bias(kernel,RFarea)
% find correlation for the bias analysis

% kernel is a (N x 9 x 9 x 1081 x 200) matrix, so there is 1081 ms of time to
% saccade and 200 ms of delay. We have binned time to saccade with the bin
% size of 5 ms and delay with bin size of 2 ms.

corr_val = nan(100,100,217); % resultant correlation values over delay of 1:2:200 and time to saccade of 1:5:1081 
bin_size = 2;
N = size(kernel,1); % number of neurons in this ensemble

Rq = nan(N,9,1081,200);
for i= 1:9
    Rq(:,i,:,:) = squeeze(kernel(:, RFarea(i,1), RFarea(i,2),:,:));
end

t = 0;
for t2sacc = 1:5:1081 
    t = t + 1;
    for d1 = 1:100
        start_index = (d1 - 1) * bin_size + 1;
        end_index = d1 * bin_size;

        krn_fix = nan(N,9);
        krn_fix = squeeze(nanmean(nanmean(Rq(:, :, 541-500:541-300, start_index:end_index),3),4));    % fixation kerenels 

        for d2 = 1:100
            start_ind = (d2 - 1) * bin_size + 1;
            end_ind = d2 * bin_size;

            krn2 = nan(N,9);
            krn2 = squeeze(nanmean(nanmean(Rq(:, :, t2sacc-5:t2sacc+5, start_ind:end_ind),3),4));

            corr_val(d1,d2,t) = corr2(krn2, krn_fix);
        end
    end
end


