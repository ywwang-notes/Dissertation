% under development

clear
tic
data_path = '/mnt/Work/SystemSwitch/MotionCorrected/';
sid = '2526';
mask = '/GLM3/mask.nii';
sess = 2;
events = {'rA', 'rB', 'rC', 'rD'};
e1 = 1; e2 = 3; % which two events for training?
v1 = 2; v2 = 4; % which two events for verification?
TrainSize = 70;

load([sid '/GLM3/SPM.mat']);

% === pick TRs ===

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
    return; % not enough data; skip this block
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
        pt = strfind(SPM.xY.P(tr, :), sid);
        Scans.xY.VY(i,:) = [data_path SPM.xY.P(tr, pt:end-2)];
        i = i + 1;
    end
end

% SPM.xY.VY = SPM.xY.VY(start_TR:end_TR,1);
test_func = @(Y,XYZ, n, label, e1, e2, v1, v2) sbj_xMVPA(Y, n, label, e1, e2, v1, v2);
searchopt = struct('def','sphere','spec',10);
spm_searchlight(Scans,searchopt, test_func, n, label, e1, e2, v1, v2);
toc
