function[mtx] = dcm_mtx(ev_list, b_list, SPM)
% Usage: query_con(ev, SPM)
% please load SPM.mat before query
% ev: (string) name of the event (listed below)
% v1: 'c', 'c11', 'c12', 'c21', 'c22', 's11', 's12', 's21', 's22', 'x', 'o'
% v2: 'c', 'c1', 'c2', 's1', 's2', 'x', 'o'
% v3: 'c', 'c1', 'c2', 'rA', 'rB', 'rC', 'rD', 'rN', 'x', 'o'
% v4: 'c', 'c1', 'c2', 's1', 's2', 'x', 'o', 's'

mtx = [];
for ev = ev_list
    row = [];
    for b = b_list
        row = [row ismember([SPM.Sess(b).U.name], ev)];
    end
    mtx = [mtx; row];
end

end % function
