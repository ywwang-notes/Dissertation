% under development
clear all
data_path = '/Users/yi-wenwang/Documents/Work/MotionCorrected/';
sid = '2526';
target = 'GLM3';
radius = 5;
k_func = 'linear';
events = {'rA', 'rB', 'rC', 'rD'}; % must be consistent with e1 e2

% do not change the following 3 lines!!
e1 = 1; e2 = 2; 
v1 = 3; v2 = 4; 
TrainSize = 60;

mask = sprintf('/%s/mask.nii', target);

load([sid '/' target '/SPM.mat']);

% === pick TRs ===
for sess=1:5
    tic
    
     % pick TRs from this session
    % what's needed here: SPM, sess, events
    % output for searchlight: TRs, n, label
    
    [TRs] = GetTRs(SPM, sess, events);
    
    % pick data: keep data for each level of equal length
    idx = 1;
    min_len = min(length(TRs{e1}), length(TRs{e2}));
    
    % be sure that each label have equal amount asigned to runs
    if min_len < TrainSize
        disp(sprintf('block %i of subject %s skipped: training set = %i', sess, sid, min_len));
        continue; % not enough data; skip this block
    end
    
    disp(sprintf('block %i of subject %s MVPA', sess, sid));
    
    % test classifier with training data!
    TRs{v1} = TRs{e1};
    TRs{v2} = TRs{e2};
    
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
    for iTRs = 1:length(TRs)
        
        start_TR = sum(SPM.nscan(1:(blist(iTRs)-1))) + 1;
        
        for t = 1:length(TRs{iTRs}) % revise path
            tr = TRs{iTRs}(t) + start_TR - 1;
            Scans.xY.VY(i,:) = SPM.xY.P(tr, :);
            % pt = strfind(SPM.xY.P(tr, :), sid);
            % Scans.xY.VY(i,:) = [data_path SPM.xY.P(tr, pt:end-2)];
            i = i + 1;
        end
    end
    
    % SPM.xY.VY = SPM.xY.VY(start_TR:end_TR,1);
    test_func = @(Y,XYZ, n, label, e1, e2, v1, v2, k_func) sbj_xMVPA(Y, n, label, e1, e2, v1, v2, k_func);
    searchopt = struct('def','sphere','spec',radius);
    spm_searchlight(Scans,searchopt, test_func, n, label, e1, e2, v1, v2, k_func);
    
    toc
    
    movefile('searchlight_0001.nii', ...
        sprintf('corr_pb_%s_b%i_%s%s_%imm_%s.nii', ...
        sid, sess, events{e1}, events{e2}, radius, k_func));
    movefile('searchlight_0002.nii', ...
        sprintf('sens_pb_%s_b%i_%s%s_%imm_%s.nii', ...
        sid, sess, events{e1}, events{e2}, radius, k_func));
    movefile('searchlight_0003.nii', ...
        sprintf('spec_pb_%s_b%i_%s%s_%imm_%s.nii', ...
        sid, sess, events{e1}, events{e2}, radius, k_func));

end