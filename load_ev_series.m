function [data, label, n, overlap] = load_raw(events, targetpath, voi_name, sess)
% raw: R.I from extract_voxel_values

data = [];
label = [];
n = [];
overlap = 0;

v_file = [targetpath voi_name num2str(sess) '.mat'];
if ~exist(v_file)
    return;
end

load(v_file);

% convert R.I.Ya to xY.y
nT = length(R.I);
xY.y = [];
for i=1:nT
    xY.y = [xY.y; R.I(i).Ya];
end

[nT nV] = size(xY.y);

% detrend (degree=2 works the best)
for i=1:nV
    [xY.y(:,i), ~] = detrend(xY.y(:,i), 2);
end

% normalize (it seems to harm the performance)
% for i=1:nV
%     xY.y(:,i) = (xY.y(:,i) - mean(xY.y(:,i))) / norm(xY.y(:,i));
% end % normalize columns of data

load([targetpath 'SPM.mat']);

start_TR = sum(SPM.nscan(1:(sess-1))) + 1;
end_TR = sum(SPM.nscan(1:sess));

if(nT ~= SPM.nscan(sess))
    disp('error: TR numbers do not match.');
    return;
end

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
data = [];
n = [];
for i=1:c % i for each beta
% xY.y: row for each TR, col for each voxel
    n = [n length(TRs{i})];
    data = [data; xY.y(TRs{i}, :)];
    label = [label i*ones(1, n(i))];
end
