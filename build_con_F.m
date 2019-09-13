% build contrasts by log in SPM.mat
% Work in folder 'Analysis'
% folder structure: Analysis/xxxx/GLMv{1|2} (xxxx = subject ID)

events = {'c', 'c11', 'c12', 'c21', 'c22', 's11', 's12', 's21', 's22', 'x', 'o'}; % v1
% events = {'c', 'c1', 'c2', 's1', 's2', 'x', 'o'}; % v2
% events = {'c', 'c1', 'c2', 'rA', 'rB', 'rC', 'rD', 'rN', 'x', 'o'}; %v3
% events = {'rA', 'rB', 'rC', 'rD'}; %selected
fcon_name = 'all_F';

dirname = 'GLM1_STN';

spm('defaults','fmri');
spm_jobman('initcfg');

% set up for jobs
clear matlabbatch;

% sid = [0001 0002 0004 0567 0679 0739 0844 0893 ...
%    1061 1091 1205 1676 1710 1886 1993 2010 2054 ...
%    2055 2099 2167 2187 2372 2526 2764 2809 3008 3034 3080 ...
%    3149 3431 3461 3552 3883 3973 4087 4289 4320 4599 4765 4958];
% issue: 1697
sid = [0004];

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

    ev = [];
    for i = 1:length(events)
        ev = [ev query_beta(events{i}, SPM)];
    end

    if length(ev) > 0
        % build contrast matrix
%         conweights = zeros(length(ev), max(ev));
%         for j = 1:length(ev)
%             conweights(j, ev(j)) = 1;
%         end            
        conweights = eye(max(ev));
    end % if events found

    
    % setup matlabbatch
    matlabbatch{batch_id}.spm.stats.con.consess{1}.fcon.name = fcon_name;
    matlabbatch{batch_id}.spm.stats.con.consess{1}.fcon.weights = conweights;
    matlabbatch{batch_id}.spm.stats.con.consess{1}.fcon.sessrep = 'none';

    matlabbatch{batch_id}.spm.stats.con.delete = 0;
    batch_id = batch_id + 1;
end

spm_jobman('run',matlabbatch);
