function [corr] = sbj_MVPA(Y, n, label, e1, e2, nFolds)
% e1, e2 % which two events for training?
% v1, v2 % which two events for verification?

% standardize data to L2 norm when load_ev_series
[nT, v] = size(Y);

if (v < 10)
    corr = NaN;
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
for i = 1:length(n)
    temp = idx:(idx+n(i)-1);
    if i == e1 | i == e2
        temp = temp(randperm(length(temp)));
        pick = [pick temp(1:min_len)];
         indices = [indices crossvalind('Kfold', min_len, nFolds)'];       
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
        'KernelFunction', 'gaussian'); % basic
    classes = predict(svmStruct, data(test,:));
    classperf(cp,classes,test);
end

corr = cp.CorrectRate;

