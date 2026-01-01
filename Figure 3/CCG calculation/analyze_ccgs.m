function ccg_output = analyze_ccgs(data, flag)
% INPUT:
%   data: 
%   flag:
% convert spike train to 'has at least 1 spike in bin'
data.spiketrain = logical(data.spiketrain); 

% get times of interest
data_subset = data.spiketrain(:, flag.start_time_index:flag.end_time_index, :);
Ncell=size(data_subset,3);
ccg_output = struct;

% jitter spiketrains
for j = 1:Ncell
    data_subset_jitter{j} = jitter(data_subset(:,:,j), flag.jit_window);
    data_subset_real{j} = data_subset(:,:,j);
end
clearvars data_subset
% change to for if do not want to use multiple cpus
ccgs=cell(1,Ncell);
maxlag=flag.max_lag;
minlag=flag.min_lag;
parfor j = 1:Ncell
    disp("processing neuron: " + j);
    ccgs{j}=struct();
    cnt = 0;
    for k = j+1:Ncell
        % pre & post comps
        % first neuron is pre
        cnt = cnt + 1;       
        c_jk_norm = zeros(1,maxlag-minlag+1,'single');
        c_jk_unnorm= zeros(1,maxlag-minlag+1,'single');
        c_jk_norm_jt = zeros(1,maxlag-minlag+1,'single');
        c_jk_unnorm_jt= zeros(1,maxlag-minlag+1,'single');
        for lag=-maxlag:1:-minlag
            if lag<=0
                prev = data_subset_real{j}(:,1:end+lag);
                postv = data_subset_real{k}(:,1-lag:end);
                prev_jt = data_subset_jitter{j}(:,1:end+lag);
                postv_jt = data_subset_jitter{k}(:,1-lag:end);                
            else
                prev = data_subset_real{j}(:,1+lag:end);
                postv = data_subset_real{k}(:,1:end-lag);
                prev_jt = data_subset_jitter{j}(:,1+lag:end);
                postv_jt = data_subset_jitter{k}(:,1:end-lag);                
            end
            c_jk_unnorm(lag+maxlag+1) = sum(prev .* postv, 'all');
            c_jk_norm(lag+maxlag+1) = c_jk_unnorm(lag+maxlag+1)/sqrt(sum(prev, 'all')*sum(postv, 'all'));
            c_jk_unnorm_jt(lag+maxlag+1) = sum(prev_jt .* postv_jt, 'all');
            c_jk_norm_jt(lag+maxlag+1) = c_jk_unnorm_jt(lag+maxlag+1)/sqrt(sum(prev_jt, 'all')*sum(postv_jt, 'all'));            
        end
        ccgs{j}.ccg_norm(cnt,:)=c_jk_norm;
        ccgs{j}.ccg_unnorm(cnt,:)=c_jk_unnorm;
        ccgs{j}.ccg_norm_jitter(cnt,:)=c_jk_norm_jt;
        ccgs{j}.ccg_unnorm_jitter(cnt,:)=c_jk_unnorm_jt;
        ccgs{j}.neuron_id_pairs(cnt,:) = [j,k];
    end
end
% aggregate ccgs into ccg output struct
fields = fieldnames(ccgs{1});
for j = 1:length(fields)
    ccg_output.(fields{j}) = ccgs{1}.(fields{j});
end

for i = 2:Ncell-1
    for j = 1:length(fields)
        ccg_output.(fields{j}) = [ccg_output.(fields{j}); ccgs{i}.(fields{j})];
    end
end

% ccg control is base - jitter
ccg_output.ccg_control = ccg_output.ccg_norm-ccg_output.ccg_norm_jitter;
ccg_output.ccg_control_unnorm = ccg_output.ccg_unnorm-ccg_output.ccg_unnorm_jitter;

% store input in ccg_output struct
ccg_output.flag = flag;
ccg_output.data = data;
end