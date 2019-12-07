function [cp_out] = sbj_xMVPA(Y, n, label, e1, e2, v1, v2, k_func)
% e1, e2 % which two events for training?
% v1, v2 % which two events for verification?

% standardize data to L2 norm when load_ev_series
[nT, v] = size(Y);

if (v < 10)
    cp_out = [NaN NaN NaN];
    return;
end

for i=1:nT
        % xY.y: row for each TR, col for each voxel
        Y(i,:) = Y(i,:) - mean(Y(i,:)); % centered to zero
        Y(i,:) = Y(i,:) / norm(Y(i,:)); % normalized to unit L2 norm
end % standardize to L2 norm for each observation (ROI-wise)

% [series, label, n, overlap] = load_ev_series(events, t_path, v_name, b, stdiz);
% pick data: keep data for each level of equal length
idx = 1;
min_len = min(n([e1 e2]));
train_len = min_len;
pick = [];
for i = 1:length(n)
    temp = idx:(idx+n(i)-1);
    if i == e1 | i == e2
        temp = temp(randperm(length(temp)));
        pick = [pick temp(1:min_len)];
    end
    idx = idx + n(i);% for start of next label
end
    
CorrectLabels = label(pick);
data = Y(pick, :);
    
svmStruct = fitcsvm(data, CorrectLabels, ...
        'Standardize', false, ...
        'KernelFunction', k_func); % 'polynomial'); % basic
    
% pick test data from next block: keep data for each level of equal length
idx = 1;
min_len = min(n([v1 v2]));
test_len = min_len; % log this for logistic regression
pick = [];
for i = 1:length(n)
    temp = idx:(idx+n(i)-1);
    if i == v1 | i == v2
        temp = temp(randperm(length(temp)));
        pick = [pick temp(1:min_len)];
    end
   idx = idx + n(i);% for start of next label
end
    
TestLabels = label(pick);
TestLabels(find(TestLabels == v1)) = e1;
TestLabels(find(TestLabels == v2)) = e2;
    
TestData = Y(pick, :);
    
cp = classperf(TestLabels);
classes = predict(svmStruct, TestData);
classperf(cp, classes);

corr = cp.CorrectRate;
sens = cp.Sensitivity;
spec = cp.Specificity;

cp_out = [corr sens spec];
