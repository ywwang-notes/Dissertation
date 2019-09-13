function[con_list] = query_con(ev, SPM)
% Usage: query_con(ev, SPM) 
% please load SPM.mat before query
% ev: (string) name of the event (listed below)
% v1: 'c', 'c11', 'c12', 'c21', 'c22', 's11', 's12', 's21', 's22', 'x', 'o'
% v2: 'c', 'c1', 'c2', 's1', 's2', 'x', 'o'
% v3: 'c', 'c1', 'c2', 'rA', 'rB', 'rC', 'rD', 'rN', 'x', 'o'

[row, col] = size(SPM.xCon);
con_list = [];

if row < 1
    return;
end

for b = 1:5
    target = sprintf('b%i%s', b, ev);
    con_list = [con_list find(strcmp(target, {SPM.xCon(1:col).name}))];
end % blocks

end % function
