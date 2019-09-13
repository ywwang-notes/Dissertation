% build contrasts by log in SPM.mat
% Work in folder 'Analysis'
% folder structure: Analysis/xxxx/GLMv{1|2} (xxxx = subject ID)

% events = {'c', 'c11', 'c12', 'c21', 'c22', 's11', 's12', 's21', 's22', 'x', 'o'}; % v1
% events = {'c', 'c1', 'c2', 's1', 's2', 'x', 'o'}; % v2
% events = {'c', 'c1', 'c2', 'rA', 'rB', 'rC', 'rD', 'rN', 'x', 'o'}; %v3
events = {'rA', 'rB', 'rC', 'rD'};
constants = [-1 1 -1 1];
con_name = 'rB+rD-rA-rC';

dirname = 'GLM3';

spm('defaults','fmri');
spm_jobman('initcfg');

% set up for jobs
clear matlabbatch;

% sid = [0001 0002 0004 0567 0679 0739 0844 0893 ...
%    1061 1091 1205 1676 1710 1886 1993 2010 2054 ...
%    2055 2099 2167 2187 2372 2526 2764 2809 3008 3034 3080 ...
%    3149 3431 3461 3552 3883 3973 4087 4289 4320 4599 4765 4958];
% issue: 1697
sid = [0003];

batch_id = 1;

for s = 1:length(sid)
    target = sprintf('%04i/%s/', sid(s), dirname);
    
    if ~exist([target 'SPM.mat'], 'file')
        disp(['no SPM.mat in ' target]);
        continue;
    end
    
    spmfile = sprintf('/Users/yi-wenwang/Documents/Work/Analysis/%04i/%s/SPM.mat', sid(s), dirname); % revise here
    matlabbatch{batch_id}.spm.stats.con.spmmat = {spmfile};
    
    load(spmfile);
    [row, col] = size(SPM.xCon);
    if row > 0
        % remove old contrasts with exactly the same name
        oldcon = find(strcmp(con_name, {SPM.xCon(1:col).name}));
        if length(oldcon) > 0
            SPM.xCon(oldcon) = [];
            save(spmfile, 'SPM');
        end
    end
    
    conweights = zeros(1, length(SPM.Vbeta));
    
    for i = 1:length(events)
        ev = query_beta(events{i}, SPM);
        conweights(ev) = constants(i);
    end
    % setup matlabbatch
    matlabbatch{batch_id}.spm.stats.con.consess{1}.tcon.name = con_name;
    matlabbatch{batch_id}.spm.stats.con.consess{1}.tcon.weights = conweights;
    matlabbatch{batch_id}.spm.stats.con.consess{1}.tcon.sessrep = 'none';
    
    matlabbatch{batch_id}.spm.stats.con.delete = 0;
    batch_id = batch_id + 1;
end

spm_jobman('run',matlabbatch);
