clear
tic
data_path = '/mnt/Work/SystemSwitch/MotionCorrected/';
sid = '3080';
sess = 3;
nFolds = 5;
events = {'s11', 's12', 's21', 's22'};
e1 = 2; e2 = 4; % which two events for training?
TrainSize = 70;

spm_file{1} = '/GLM/SPM.mat';
spm_file{2} = '/GLM1s10/SPM.mat';
Debug.VY = '';
Debug.TRs = {};

for run = 1:2
load([sid spm_file{run}]);
disp(['session ' num2str(sess)]);

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

% === searchlight ===
% [r, c] = size(SPM.xY.P);


i = 1;
Debug(run).TRs = TRs;

for iTRs = 1:length(TRs)
    for t = 1:length(TRs{iTRs}) % revise path
        tr = TRs{iTRs}(t) + start_TR - 1;
        pt = strfind(SPM.xY.P(tr, :), sid);
        Debug(run).VY(i,:) = [data_path SPM.xY.P(tr, pt:end-2)];
        i = i + 1;
    end
end


end