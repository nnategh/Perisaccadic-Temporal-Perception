function corr_val = find_corr_sensitivity(kernel,RFarea) 
% find correlation for the sensitivity analysis 

% kernel is a (N x 9 x 9 x 1081 x 200) matrix, so there is 1081 ms of time to
% saccade and 200 ms of delay. We have binned time to saccade with the bin
% size of 5 ms and delay with bin size of 2 ms. 

corr_val = nan(100,100,217); % resultant correlation values over delay of 1:2:200 and time to saccade of 1:5:1081 
bin_size = 2;
N = size(kernel,1); % number of neurons 
t = 0;

for t2sacc = 1:5:1081 
    t = t + 1;
    for d1 = 1:100
        d1_start_ind = (d1 - 1) * bin_size + 1;
        d1_end_ind = d1 * bin_size;

        krn1 = nan(N,9);
        for i= 1:9
            krn1(:,i) = squeeze(nanmean(nanmean(kernel(:, RFarea(i,1), RFarea(i,2), t2sacc-5:t2sacc+5, d1_start_ind:d1_end_ind),4),5));
        end

        for d2 = 1:100
            d2_start_ind = (d2 - 1) * bin_size + 1;
            d2_end_ind = d2 * bin_size;

            krn2 = nan(N,9);
            for i= 1:9
                krn2(:,i) = squeeze(nanmean(nanmean(kernel(:, RFarea(i,1), RFarea(i,2), t2sacc-5:t2sacc+5, d2_start_ind:d2_end_ind),4),5));
            end

            corr_val(d1,d2,t) = corr2(krn2, krn1);
        end
    end
end


