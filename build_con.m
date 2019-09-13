% build contrasts by log in SPM.mat
% Work in folder 'Analysis'
% folder structure: Analysis/xxxx/GLMv{1|2} (xxxx = subject ID)

% events = {'c', 'c11', 'c12', 'c21', 'c22', 's11', 's12', 's21', 's22', 'x', 'o'}; % v1
% events = {'c', 'c1', 'c2', 's1', 's2', 'x', 'o'}; % v2
events = {'c', 'c1', 'c2', 'rA', 'rB', 'rC', 'rD', 'rN', 'x', 'o'}; %v3

dirname = 'GLM3';

spm('defaults','fmri');
spm_jobman('initcfg');

% set up for jobs
clear matlabbatch;

sid = [0001 0002 0004 0567 0679 0739 0844 0893 ...
   1061 1091 1205 1676 1710 1886 1993 2010 2054 ...
   2055 2099 2167 2187 2372 2526 2764 2809 3008 3034 3080 ...
   3149 3431 3461 3552 3883 3973 4087 4289 4320 4599 4765 4958];
% issue: 1697

batch_id = 1;

for s = 1:length(sid)
    target = sprintf('%04i/%s/', sid(s), dirname);
    
    if ~exist([target 'SPM.mat'], 'file')
       disp(['no SPM.mat in ' target]);
       continue;
    end
    
    current = pwd;
    cd(target);
    load('SPM.mat');
    beta_id = 1;
    spmfile = sprintf('/Users/yi-wenwang/Documents/Work/Analysis/%04i/%s/SPM.mat', sid(s), dirname); % revise here
    matlabbatch{batch_id}.spm.stats.con.spmmat = {spmfile};

    for b = 1:5
        for e = 1:length(events)
            target = sprintf('spm_spm:beta (%04d) - Sn(%01d) %s*bf(1)', beta_id, b, events{e});

            if strcmp(target, SPM.Vbeta(beta_id).descrip)
                conname = sprintf('b%d%s', b, events{e});
                conweights = zeros(1, beta_id);
                conweights(beta_id) = 1;
                matlabbatch{batch_id}.spm.stats.con.consess{beta_id}.tcon.name = conname;
                matlabbatch{batch_id}.spm.stats.con.consess{beta_id}.tcon.weights = conweights;
                matlabbatch{batch_id}.spm.stats.con.consess{beta_id}.tcon.sessrep = 'none';

                beta_id = beta_id + 1;
            end % if event found
        end % for each event
    end % for each block

    matlabbatch{batch_id}.spm.stats.con.delete = 0;
    batch_id = batch_id + 1;
    cd(current);
end

spm_jobman('run',matlabbatch);
