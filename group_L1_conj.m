spm('defaults','fmri');
spm_jobman('initcfg');

% set up for jobs
clear matlabbatch;

% sid = [0002 0003 0004 0567 0679 0739 0844 0893 ...
%        1061 1091 1205 1676 1697 1710 1886 1993 2010 2054 ...
%        2055 2099 2167 2187 2372 2526 2764 2809 3008 3034 3080 ...
%        3149 3431 3461 3552 3883 3973 4087 4289 4320 4599 4765 4958];
sid = [0003];

min_beta = 1;

% events = {'c', 'c11', 'c12', 'c21', 'c22', 's11', 's12', 's21', 's22', 'o', 'x'}; % v1
events = {'c', 'c1', 'c2', 's1', 's2', 'x', 'o'}; % v2

run_n = 1;

for sbj=1:length(sid)    
    for ev=1:length(events)
        i = 1;
        exp = [];
        for b=1:5
            fname = sprintf('%04i/GLM2/s%04ib%i%s.nii', ...
                            sid(sbj), sid(sbj), b, events{ev});
            if isfile(fname)
                matlabbatch{run_n}.spm.util.imcalc.input(i,1) = {[fname ',1']};
                exp = [exp sprintf('&(i%d > %.02f)', i, min_beta)];
                i = i + 1;
            else
                [fname ' does not exist']
            end
         
        end % loop thru blocks
        matlabbatch{run_n}.spm.util.imcalc.output = ...
            sprintf('%04i/GLM2/s%04i%s_cj.nii', sid(sbj), sid(sbj), events{ev}); % for all blocks
        matlabbatch{run_n}.spm.util.imcalc.outdir = {sprintf('04i/', sid(sbj))};
        matlabbatch{run_n}.spm.util.imcalc.expression = exp(2:end); % remove the first '&'
        matlabbatch{run_n}.spm.util.imcalc.var = struct('name', {}, 'value', {});
        matlabbatch{run_n}.spm.util.imcalc.options.dmtx = 0;
        matlabbatch{run_n}.spm.util.imcalc.options.mask = 0;
        matlabbatch{run_n}.spm.util.imcalc.options.interp = 1;
        matlabbatch{run_n}.spm.util.imcalc.options.dtype = 16;
        run_n = run_n + 1;
    end % loop thru events

end % end of loop thru subject folders

spm_jobman('run',matlabbatch);
