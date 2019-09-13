function [data, label] = load_data(targetpath, voi_name, sess)

data = [];
label = [];
load([targetpath voi_name num2str(sess) '.mat']);
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

rA = SPM.xX.X(start_TR:end_TR, b_rA(sess)); % predicted BOLD for rA
rB = SPM.xX.X(start_TR:end_TR, b_rB(sess));
rC = SPM.xX.X(start_TR:end_TR, b_rC(sess));
rD = SPM.xX.X(start_TR:end_TR, b_rD(sess));


th = min(max([rA rB rC rD])) * 0.6

% extract best TRs for training

set1 = find((rA > th) | (rC > th)); 
set2 = find((rD > th) | (rB > th)); 


sprintf('intersect %i TRs, bias %02f', length(intersect(set1, set2)), ...
    length(set1) / length([set1' set2']))

% set1 = find(rA > th); 
% set2 = find(rB+rC > th); 

% set1 = find((rA+rB) > th);
% set2 = find((rB-rA) > th);

% ~ 50%
% set1 = find(rA > th);
% set2 = find(rB > th);
% set3 = find(rC > th);
% set4 = find(rD > th);

sprintf('(session %i) set1: %i; set2: %i', sess, length(set1), length(set2))
data = xY.y([set1' set2'],:);

% normalize columns of data -- doesn't seem to affect anything
[r, l] = size(data);
for i=1:l
    data(:,i) = (data(:,i) - mean(data(:,i))) / norm(data(:,i));
end % normalize columns of data

label1 = ones(1, length(set1));
label2 = 2 * ones(1, length(set2));

label = [label1 label2];