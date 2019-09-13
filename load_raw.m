function [data, label] = load_data(targetpath, voi_name, sess)
% raw: R.I from extract_voxel_values

data = [];
label = [];

load([targetpath voi_name num2str(sess) '.mat']);

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

b_rA = query_beta('s11', SPM);
b_rB = query_beta('s12', SPM);
b_rC = query_beta('s21', SPM);
b_rD = query_beta('s22', SPM);

rA = SPM.xX.X(start_TR:end_TR, b_rA(sess)); % predicted BOLD for rA
rB = SPM.xX.X(start_TR:end_TR, b_rB(sess));
rC = SPM.xX.X(start_TR:end_TR, b_rC(sess));
rD = SPM.xX.X(start_TR:end_TR, b_rD(sess));


th = min(max([rA rB rC rD])) * 0.6

% extract best TRs for training

% set1 = find((rA > th) | (rD > th)); 
% set2 = find((rC > th) | (rB > th)); 

set1 = find(rA > th); 
set2 = find(rC > th); 

to_remove = intersect(set1, set2);
if length(to_remove) > 0
    set1(ismember(set1, to_remove)) = [];
    set2(ismember(set1, to_remove)) = [];
end

% set1 = find(rA > th); 
% set2 = find(rB+rC > th); 

% set1 = find((rA+rB) > th);
% set2 = find((rB-rA) > th);

% ~ 50%
% set1 = find(rA > th);
% set2 = find(rB > th);
% set3 = find(rC > th);
% set4 = find(rD > th);

sprintf('(session %i) set1: %i; set2: %i; %i TRs excluded', ...
    sess, length(set1), length(set2), length(to_remove))
data = xY.y([set1' set2'],:);

% normalize columns of data -- doesn't seem to affect anything
% [r, l] = size(data);
% for i=1:l
%     data(:,i) = (data(:,i) - mean(data(:,i))) / norm(data(:,i));
% end % normalize columns of data

label1 = ones(1, length(set1));
label2 = 2 * ones(1, length(set2));

label = [label1 label2];