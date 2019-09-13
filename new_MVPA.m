t_path = '/Users/yi-wenwang/Documents/Work/Analysis/2526/G1STN/';
% v_name = 'VOI_L_PrG_all_s_';
% [data1 label1] = load_data(t_path, v_name, 1);
% [data2 label2] = load_data(t_path, v_name, 2);

v_name = 'STN_uf_';
% STN_uf works better for switch vs. stay
% STN_suf works better for cat1 vs. cat2

[data1 label1] = load_raw(t_path, v_name, 1);
% [data2 label2] = load_raw(t_path, v_name, 2);

% cross sessions
% normalize columns of data: doesn't seem to have any effect
% [r1 c1] = size(data1);
% [r2 c2] = size(data2);
% 
% data = [data1; data2];
% for i=1:c1
%     data(:,i) = (data(:,i) - mean(data(:,i))) / norm(data(:,i));
% end % normalize columns of data
% 
% data1 = data(1:r1,:);
% data2 = data((r1+1):(r1+r2), :);
% 
% train_data = data2;
% train_label = label2;
% test_data = data1;
% test_label = label1;
% 
% svmStruct = fitcsvm(train_data, train_label, 'Standardize', true);
% classes = predict(svmStruct, test_data);
% cp = classperf(test_label);
% classperf(cp, classes);
% cp


% within session
data = data1;
CorrectLabels = label1;
Nfolds = 10; % How many folds (divisions of data) for cross-validation
indices = crossvalind('Kfold', size(data,1), Nfolds);
cp = classperf(CorrectLabels); % Initialize a classifer performance object

for i = 1:Nfolds
    test = (indices == i); train = ~test;
    svmStruct = fitcsvm(data(train,:), CorrectLabels(train), 'Standardize', true); % basic
    % svmStruct = fitcsvm(data(train,:), CorrectLabels(train), 'Standardize', false, ...
    %     'KernelScale','auto', 'OutlierFraction',0.05); % example from mathworks; doesn't improve either.
    
    classes = predict(svmStruct, data(test,:));
    
    % Use the trained SVM to classify this fold's test data
    classperf(cp,classes,test);
    % Update the CP object with the classification results from this fold
end
cp
% correct rate is affected by numbers of observations; don't just look at
% this. Instead, look at sensitivity and specificity.
