function ccg_data = ccg_to_attributes_V1(ccg_output, flag)
ccg_types = ["ccg"];

for ccg_type = 1:length(ccg_types)
    ccg_data_t = struct;
    ccg_data_t.ccg_control = ccg_output.(strcat(ccg_types(ccg_type),'_control'));
    ccg_data_t.ccg_jitter = ccg_output.(strcat(ccg_types(ccg_type),'_norm_jitter'));
    ccg_data_t.ccg_norm = ccg_output.(strcat(ccg_types(ccg_type),'_norm'));
    ccg_data_t.ccg_unnorm = ccg_output.(strcat(ccg_types(ccg_type),'_unnorm'));

    ccgs = ccg_data_t.ccg_control(:,91:111);
    pair_ids = ccg_output.neuron_id_pairs;
    data_included = ccg_output.data;
        
    [peaks, lpeak_lag] = max(ccg_data_t.ccg_control,[],2);
    [troughs, ltrough_lag] = min(ccg_data_t.ccg_control,[],2);
    ccg_data_t.config.cont_vars = ["peaks", "troughs", "peak_lag","trough_lag", "area", "peak_trough_diff", "peak_trough_lag_diff","pair_distance","peak_width", "trough_width"];
    ccg_data_t.config.cat_vars = ["pre_id", "post_id", "pre_ct", "post_ct", "pre_cl", "post_cl", "pre_depth", "post_depth", "clust", "syn_peak", "syn_trough"];
    ccg_data_t.config.flag = flag;    
    ccg_data_t.peaks = peaks;
    ccg_data_t.troughs = troughs;
        
    ccg_data_t.peak_lag = 100-lpeak_lag+1;
    ccg_data_t.trough_lag = 100-ltrough_lag+1;
        
    ccg_data_t.peak_trough_diff =  ccg_data_t.peaks- ccg_data_t.troughs;
    ccg_data_t.peak_trough_lag_diff = ccg_data_t.peak_lag-ccg_data_t.trough_lag;   
    ccg_data_t.syn_peak = ccg_data_t.peak_lag == 0; 
    ccg_data_t.syn_trough = ccg_data_t.trough_lag == 0; 
    %% 
    ccg_data_t.pre_id = pair_ids(:,1);
    ccg_data_t.post_id = pair_ids(:,2);

    ccg_data_t.pre_layerID = data_included.cluster_layerID(ccg_data_t.pre_id);
    ccg_data_t.post_layerID = data_included.cluster_layerID(ccg_data_t.post_id);        
    %% ccg_exclusions
    noise_distribution2 = [ccg_data_t.ccg_control(:, 1:50), ccg_data_t.ccg_control(:, 151:201)];
    ccg_data_t.area = nansum(ccgs,2);
    ccg_data_t.noise_std2 = std(noise_distribution2,[],2, 'omitnan');
    ccg_data_t.noise_mean2 = nanmean(noise_distribution2,2);
    %% ccg peak and trough width    
    if flag.large_output
    else
        ccg_data_t.ccg_control = [];
    end
    ccg_data_t.ccgs = ccgs;
    
    % iterate over output struct and make everything verticle
    fields = fieldnames(ccg_data_t);
    for i = 1:length(fields)
        if ~strcmp(fields{i},'cluster') && ~strcmp(fields{i},'config')
            if size(ccg_data_t.(fields{i}), 1) == 1
                ccg_data_t.(fields{i}) = ccg_data_t.(fields{i})';
            end
        end
    end
    ccg_data.(strcat(ccg_types(ccg_type))) = ccg_data_t;
end

end