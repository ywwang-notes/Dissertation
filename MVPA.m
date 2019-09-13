targetpath = '/Users/yi-wenwang/Documents/Work/Analysis/0003/GLM3/';
sess = 1;

load([targetpath 'VOI_L_PrG_all_' num2str(sess) '.mat']);
% VOI structure
%       xY.xyz          - centre of VOI {mm}
%       xY.name         - name of VOI
%       xY.Ic           - contrast used to adjust data (0 - no adjustment)
%       xY.Sess         - session index
%       xY.def          - VOI definition
%       xY.spec         - VOI definition parameters
%       xY.str          - VOI description as a string
%       xY.XYZmm        - Co-ordinates of VOI voxels {mm}
%       xY.y            - [whitened and filtered] voxel-wise data
%       xY.u            - first eigenvariate {scaled - c.f. mean response}
%       xY.v            - first eigenimage
%       xY.s            - eigenvalues
%       xY.X0           - [whitened] confounds (including drift terms)

[nT nV] = size(xY.y);

load([targetpath 'SPM.mat']);

start_TR = sum(SPM.nscan(1:(sess-1))) + 1;
end_TR = sum(SPM.nscan(1:sess));

if(nT ~= SPM.nscan(sess))
    disp('error: TR numbers do not match.');
    return;
end

b_rA = query_beta('rA', SPM);
b_rB = query_beta('rB', SPM);
b_rC = query_beta('rC', SPM);
b_rD = query_beta('rD', SPM);

% b_rA = query_beta('c11', SPM);
% b_rB = query_beta('c22', SPM);
% b_rC = query_beta('c', SPM);
% b_rD = query_beta('c', SPM);

rA = SPM.xX.X(start_TR:end_TR, b_rA(sess)); % predicted BOLD for rA
rB = SPM.xX.X(start_TR:end_TR, b_rB(sess));
rC = SPM.xX.X(start_TR:end_TR, b_rC(sess));
rD = SPM.xX.X(start_TR:end_TR, b_rD(sess));


th = max([rA' rB' rC' rD']) * 0.6;

% extract best TRs for training


% ~ 70%
% set1 = find((rA+rC-rB-rD) > th); 
% set2 = find((rB+rD-rA-rC) > th); 

% > 60%
% set1 = find((rB+rD) > th); 
% set2 = find((rB+rD) < th); 

set1 = find((rA-rB) > th);
set2 = find((rB-rA) > th);

% ~ 50%
% set1 = find(rA > th);
% set2 = find(rB > th);
% set3 = find(rC > th);
% set4 = find(rD > th);


data = xY.y([set1' set2'],:);

[r, l] = size(data);
for i=1:r
    data(i,:) = (data(i,:) - mean(data(i,:))) / norm(data(i,:));
end % normalize data

label1 = ones(1, length(set1));
label2 = 2 * ones(1, length(set2));
% label3 = 3 * ones(1, length(set3));
% label4 = 4 * ones(1, length(set4));

CorrectLabels = [label1 label2];

% Do MVPA
% adapted from http://www.umich.edu/~nii/doc/Polk-MVPA.pdf

Nfolds = 2; % How many folds (divisions of data) for cross-validation
indices = crossvalind('Kfold', size(data,1), Nfolds);
% Randomly divide data into folds. indices is a vector where each entry
% is an integer between 1 and Nfolds, indicating which fold each datapoint
% belongs to
cp = classperf(CorrectLabels); % Initialize a classifer performance object
for i = 1:Nfolds
    test = (indices == i); train = ~test;
    % test indicates data to be tested in this fold. train indicates data
    % used in training for this fold.
    % svmStruct = svmtrain(data(train,:),CorrectLabels(train));
    svmStruct = fitcsvm(data(train,:), CorrectLabels(train));
    
    % Train a support vector machine on this fold's training data
    % classes = svmclassify(svmStruct,data(test,:));
    classes = predict(svmStruct, data(test,:));
    
    % Use the trained SVM to classify this fold's test data
    classperf(cp,classes,test);
    % Update the CP object with the classification results from this fold
end
cp.CorrectRate % Output the average correct classification rate