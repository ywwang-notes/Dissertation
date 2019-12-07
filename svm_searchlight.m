% under development
clear
data_path = '/Users/yi-wenwang/Documents/Work/MotionCorrected/';
sid = '0003';
radius = 5;
k_func = 'linear';
mask = '/GLM1s10/mask.nii';
events = {'s11', 's12', 's21', 's22'};
e1 = 1; e2 = 4; % which two events for training?
v1 = 3; v2 = 2; % which two events for verification?
TrainSize = 60;

load([sid '/GLM1s10/SPM.mat']);

% === pick TRs ===
for sess=1:5
    tic
    start_TR = sum(SPM.nscan(1:(sess-1))) + 1;
    end_TR = sum(SPM.nscan(1:sess));
    
    [r, c] = size(events);
    
    series = {};
    peak = [];
    
    for i=1:c
        beta_i = query_beta(events{i}, SPM);
        series{i} = SPM.xX.X(start_TR:end_TR, beta_i(sess)); % predicted BOLD
        peak = [peak max(series{i})];
    end
    
    th = min(peak) * 0.6;
    TRs = {};
    
    for i=1:c
        TRs{i} = find(series{i} > th);
    end
    
    % remove overlaps; pair-wise comparisons
    pairs = [1 2; 1 3; 1 4; 2 3; 2 4; 3 4];
    [r, c] = size(pairs);
    overlap = 0;
    
    for i=1:r
        p1 = pairs(i, 1);
        p2 = pairs(i, 2);
        to_remove = intersect(TRs{p1}, TRs{p2});
        n_remove = length(to_remove);
        if n_remove > 0
            TRs{p1}(ismember(TRs{p1}, to_remove)) = [];
            TRs{p2}(ismember(TRs{p2}, to_remove)) = [];
            overlap = overlap + n_remove;
        end
    end
    
    % move the following segment into function
    [r, c] = size(TRs);
    n = [];
    label = [];
    for i=1:c % i for each beta
        n = [n length(TRs{i})];
        label = [label i*ones(1, n(i))];
    end
    
    % pick data: keep data for each level of equal length
    idx = 1;
    min_len = min(n([e1 e2]));
    
    % be sure that each label have equal amount asigned to runs
    if min_len < TrainSize
        disp(sprintf('block %i of subject %s skipped: length = %i', sess, sid, min_len));
        continue; % not enough data; skip this block
    else
        disp(sprintf('block %i of subject %s MVPA', sess, sid));
    end
    
    % === searchlight ===
    % [r, c] = size(SPM.xY.P);
    Scans.xY.VY = '';
    Scans.VM = [sid mask];
    
    i = 1;
    
    for iTRs = 1:length(TRs)
        for t = 1:length(TRs{iTRs}) % revise path
            tr = TRs{iTRs}(t) + start_TR - 1;
            %        pt = strfind(SPM.xY.P(tr, :), sid);
            Scans.xY.VY(i,:) = SPM.xY.P(tr, :);
            i = i + 1;
        end
    end
    
    % SPM.xY.VY = SPM.xY.VY(start_TR:end_TR,1);
    test_func = @(Y,XYZ, n, label, e1, e2, v1, v2, k_func) sbj_xMVPA(Y, n, label, e1, e2, v1, v2, k_func);
    searchopt = struct('def','sphere','spec',radius);
    spm_searchlight(Scans,searchopt, test_func, n, label, e1, e2, v1, v2, k_func);
    toc
    
    movefile('searchlight_0001.nii', ...
        sprintf('corr_%s_b%i_%s%sx%s%s_%imm_%s.nii', ...
        sid, sess, events{e1}, events{e2}, events{v1}, events{v2}, radius, k_func));
    movefile('searchlight_0002.nii', ...
        sprintf('sens_%s_b%i_%s%sx%s%s_%imm_%s.nii', ...
        sid, sess, events{e1}, events{e2}, events{v1}, events{v2}, radius, k_func));
    movefile('searchlight_0003.nii', ...
        sprintf('spec_%s_b%i_%s%sx%s%s_%imm_%s.nii', ...
        sid, sess, events{e1}, events{e2}, events{v1}, events{v2}, radius, k_func));

end