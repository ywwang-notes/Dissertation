function [cp_out] = sbj_cMVPA(Y, n, label, e1, e2, nFolds, k_func)
% e1, e2 % which two events for training?
% v1, v2 % which two events for verification?

% standardize data to L2 norm when load_ev_series
[nT, v] = size(Y);

if (v < 5)
    cp_out = [NaN NaN NaN];
    return;
end

for i=1:nT
    % xY.y: row for each TR, col for each voxel
    Y(i,:) = Y(i,:) - mean(Y(i,:)); % centered to zero
    Y(i,:) = Y(i,:) / norm(Y(i,:)); % normalized to unit L2 norm
end % standardize to L2 norm for each observation (ROI-wise)

% pick data: keep data for each level of equal length
idx = 1;
min_len = min(n([e1 e2]));
train_len = min_len;
pick = [];
indices = [];

subindices = kron(1:nFolds, ones(1, floor(min_len/nFolds)));
if length(subindices) < min_len
    subindices(end+1:min_len) = nFolds;
end

for i = 1:length(n)
    temp = idx:(idx+n(i)-1);
    if i == e1 | i == e2
        temp = temp(randperm(length(temp)));
        temp = temp(1:min_len);
        temp = sort(temp); % keep order
        pick = [pick temp];
        indices = [indices subindices]; % keep order
    end
    idx = idx + n(i);% for start of next label
end

CorrectLabels = label(pick);
data = Y(pick, :);

cp = classperf(CorrectLabels);

for i = 1:nFolds
    test = (indices == i); train = ~test;
    svmStruct = fitcsvm(data(train,:), CorrectLabels(train), ...
        'Standardize', false, ...
        'KernelFunction', k_func); % basic
    classes = predict(svmStruct, data(test,:));
    classperf(cp,classes,test);
end

corr = cp.CorrectRate;
sens = cp.Sensitivity;
spec = cp.Specificity;

cp_out = [corr sens spec];
