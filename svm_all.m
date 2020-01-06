function svm_all(sid, glm_folder, th_ratio, radius, events, e1, e2, rndc)
% rndc currently not in use

tic

data_path = '/mnt/Work/SystemSwitch/MotionCorrected/';
target = glm_folder;
k_func = 'linear';

v = 1:4;
v = setdiff(v, [e1 e2]);

mask = sprintf('/%s/mask.nii', target);
load(sprintf('%s/%s/SPM.mat', sid, target));

AllData = {[] [] [] []};

% === pick TRs ===
for sess=1:5
    
    % odd sessions for training, even sessions for testing
    train = (mod(sess, 2) == 1);
    
    disp(sprintf('block %i of subject %s TRs', sess, sid));
    [TRs] = GetTRs(SPM, sess, events, th_ratio / 10) % display this
    
    [r, c] = size(TRs);
    for i=[e1 e2]
        TRs{i} = TRs{i} + sum(SPM.nscan(1:(sess-1))); % shift to the actual index
    end
    
    if train
        p = [e1 e2];
    else
        p = [v(1) v(2)];
    end
    
    AllData{p(1)} = [AllData{p(1)} TRs{e1}'];
    AllData{p(2)} = [AllData{p(2)} TRs{e2}'];
    
end % end of preparing TR index

TRs = AllData; % for re-using the old code
[r, c] = size(TRs);
n = [];
label = [];
for i=1:c % i for each beta
    n = [n length(TRs{i})];
    label = [label i*ones(1, n(i))];
end

Scans.xY.VY = '';
Scans.VM = [sid mask];

for iTRs = 1:length(TRs)
    for t = 1:length(TRs{iTRs}) % revise path
        tr = TRs{iTRs}(t);
        pt = strfind(SPM.xY.P(tr, :), sid);
        Scans.xY.VY(end+1,:) = [data_path SPM.xY.P(tr, pt:end-2)];
    end
end

test_func = @(Y,XYZ, n, label, e1, e2, v1, v2, k_func) sbj_xMVPA(Y, n, label, e1, e2, v1, v2, k_func);
searchopt = struct('def','sphere','spec',radius);
spm_searchlight(Scans,searchopt, test_func, n, label, e1, e2, v(1), v(2), k_func);
toc

movefile('searchlight_0001.nii', ...
    sprintf('corr_%i_%s_all_%s%s_%imm_%s.nii', ...
    th_ratio, sid,  events{e1}, events{e2}, radius, k_func));
movefile('searchlight_0002.nii', ...
    sprintf('sens_%i_%s_all_%s%s_%imm_%s.nii', ...
    th_ratio, sid,  events{e1}, events{e2}, radius, k_func));
movefile('searchlight_0003.nii', ...
    sprintf('spec_%i_%s_all_%s%s_%imm_%s.nii', ...
    th_ratio, sid,  events{e1}, events{e2}, radius, k_func));

end
