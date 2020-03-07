% nFold partition by chunck
clear all

data_path = '/Users/yi-wenwang/Documents/Work/MotionCorrected/';
sid = '0002';
target = 'GLM3';
nFolds = 5;
radius = 5; % 5mm
k_func = 'linear';
events = {'rA', 'rB', 'rC', 'rD'};
% events = {'s11', 's12', 's21', 's22'};
e1 = 1; e2 = 2; % which two events for training?
TrainSize = 60;
th_ratio = 0.6;

mask = sprintf('/%s/mask.nii', target);
load(sprintf('%s/%s/SPM.mat', sid, target));

for sess = 1:5
    disp(['session ' num2str(sess)]);
    % === pick TRs ===
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
    
    th = min(peak) * th_ratio;
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

     % === chunck-wise permutation
     % step 1: find chuncks
     % step 2: permutate 
     % step 3: re-asign labels
     
    cTRs = [0 0 0 0];
     for iTRs = [e1 e2]
        previous = -1; % ensure that the first TR will be a new chunck
        for t = 1:length(TRs{iTRs})
            tr = TRs{iTRs}(t);
            if tr - previous > 1
                cTRs(iTRs) = cTRs(iTRs) + 1; % add one chunk
            end
            previous = tr;
        end
     end
   
    pick = {[] [] [] []};
    for iTRs = [e1 e2]
        tmp = ones(1, cTRs(iTRs));
        tmp(ceil(end/2)) = randi(2); % if ceil > floor, this chunk is randomly assigned 1 or 2 
        tmp(1:floor(end/2)) = 2; % if floor == ceil, it will be replaced with 2
        tmp = tmp(randperm(end));
        tmp = tmp(randperm(end)); % perm twice
        pick{iTRs} = tmp;
    end
    
    rndTRs = {[] []};
    for iTRs = [e1 e2]
        previous = -1; % ensure that the first TR will be assigned a newly picked label
        i_pick = 0;
        disp(sprintf('event %i: ', iTRs));
        for t = 1:length(TRs{iTRs})
            tr = TRs{iTRs}(t);
            if tr - previous > 1
                i_pick = i_pick + 1;
                p = pick{iTRs}(i_pick);
                disp(num2str(p));
            end
            previous = tr;
            rndTRs{p} = [rndTRs{p} tr];
        end
    end

    TRs{e1} = rndTRs{1};
    TRs{e2} = rndTRs{2};    
    
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
            % for local data
%            Scans.xY.VY(i,:) = SPM.xY.P(tr, :);
            % for data from mini
            pt = strfind(SPM.xY.P(tr, :), sid);
            Scans.xY.VY(i,:) = [data_path SPM.xY.P(tr, pt:end-2)];
            i = i + 1;
        end
    end
    
    % SPM.xY.VY = SPM.xY.VY(start_TR:end_TR,1);
    test_func = @(Y,XYZ, n, label, e1, e2, nFolds, k_func) sbj_MVPA(Y, n, label, e1, e2, nFolds, k_func);
    searchopt = struct('def','sphere','spec', radius);
    spm_searchlight(Scans,searchopt, test_func, n, label, e1, e2, nFolds, k_func);
    toc
    
    movefile('searchlight_0001.nii', ...
        sprintf('corr_p_%s_b%i_%s%s_%imm_%s_rndc.nii', ...
        sid, sess, events{e1}, events{e2}, radius, k_func));
    movefile('searchlight_0002.nii', ...
        sprintf('sens_p_%s_b%i_%s%s_%imm_%s_rndc.nii', ...
        sid, sess, events{e1}, events{e2}, radius, k_func));
    movefile('searchlight_0003.nii', ...
        sprintf('spec_p_%s_b%i_%s%s_%imm_%s_rndc.nii', ...
        sid, sess, events{e1}, events{e2}, radius, k_func));

end % sess