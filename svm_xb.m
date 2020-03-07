function svm_xb(sid, glm_folder, TrainSize, th_ratio, radius, events, e1, e2, rndc)
% under development
data_path = '/Users/gregashby/Documents/MATLAB/Experiments/Yiwen/SystemSwitch/';
target = glm_folder;
k_func = 'linear';

v = 1:4;
v = setdiff(v, [e1 e2]);
v1 = v(1); v2 = v(2); 

mask = sprintf('/%s/mask.nii', target);

if rndc
    postfix = '_rndc';
else
    postfix = '';
end
% === subject path ===
dlist = dir;

load([sid '/' target '/SPM.mat']);

% === pick TRs ===
for sess=1:4
    tic
    
     % pick TRs from this session
    % what's needed here: SPM, sess, events
    % output for searchlight: TRs, n, label
    
    [TRs] = GetTRs(SPM, sess, events, th_ratio / 10);
    
    % pick data: keep data for each level of equal length
    idx = 1;
    min_len = min(length(TRs{e1}), length(TRs{e2}));
    
    % be sure that each label have equal amount asigned to runs
    if min_len < TrainSize
        disp(sprintf('block %i of subject %s skipped: training set = %i', sess, sid, min_len));
        continue; % not enough data; skip this block
    end
    
    disp(sprintf('block %i of subject %s MVPA', sess, sid));
    
    [TRs2] = GetTRs(SPM, sess+1, events, th_ratio / 10);
    
    % === chunck-wise permutation for TRs2
    % step 1: find chuncks
    % step 2: permutate
    % step 3: re-asign labels
    if rndc
        cTRs = [0 0 0 0];
        for iTRs = [e1 e2]
            previous = -1; % ensure that the first TR will be a new chunck
            for t = 1:length(TRs2{iTRs})
                tr = TRs2{iTRs}(t);
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
            for t = 1:length(TRs2{iTRs})
                tr = TRs2{iTRs}(t);
                if tr - previous > 1
                    i_pick = i_pick + 1;
                    p = pick{iTRs}(i_pick);
                    disp(num2str(p));
                end
                previous = tr;
                rndTRs{p} = [rndTRs{p} tr];
            end
        end
        
        TRs2{e1} = rndTRs{1};
        TRs2{e2} = rndTRs{2};
    end
    
    % prepare test sets
    TRs{v1} = TRs2{e1};
    TRs{v2} = TRs2{e2};
    
    [r, c] = size(TRs);
    n = [];
    label = [];
    for i=1:c % i for each beta
        n = [n length(TRs{i})];
        label = [label i*ones(1, n(i))];
    end
       
    % === searchlight ===
    % [r, c] = size(SPM.xY.P);
    Scans.xY.VY = '';
    Scans.VM = [sid mask];
    
    i = 1;
    
    blist = [sess sess sess sess];
    blist([v1 v2]) = sess+1;
    for iTRs = 1:length(TRs)
        
        start_TR = sum(SPM.nscan(1:(blist(iTRs)-1))) + 1;
        
        for t = 1:length(TRs{iTRs}) % revise path
            tr = TRs{iTRs}(t) + start_TR - 1;
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
        sprintf('corr_%i_%s_b%i_%s%sxb_%imm_%s%s.nii', ...
        th_ratio, sid, sess, events{e1}, events{e2}, radius, k_func, postfix));
    movefile('searchlight_0002.nii', ...
        sprintf('sens_%i_%s_b%i_%s%sxb_%imm_%s%s.nii', ...
        th_ratio, sid, sess, events{e1}, events{e2}, radius, k_func, postfix));
    movefile('searchlight_0003.nii', ...
        sprintf('spec_%i_%s_b%i_%s%sxb_%imm_%s%s.nii', ...
        th_ratio, sid, sess, events{e1}, events{e2}, radius, k_func, postfix));

end