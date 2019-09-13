function[beta_list] = query_beta(ev, SPM)
% Usage: query_con(ev, SPM) 
% please load SPM.mat before query
% ev: (string) name of the event (listed below)
% v1: 'c', 'c11', 'c12', 'c21', 'c22', 's11', 's12', 's21', 's22', 'x', 'o'
% v2: 'c', 'c1', 'c2', 's1', 's2', 'x', 'o'
% v3: 'c', 'c1', 'c2', 'rA', 'rB', 'rC', 'rD', 'rN', 'x', 'o'

[row, col] = size(SPM.Vbeta);
beta_list = [];
target = sprintf('%s*bf(1)', ev);
disp(target);
beta_list = find(contains({SPM.Vbeta(1:col).descrip}, target));

end % function
