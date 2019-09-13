spm('defaults','fmri');
spm_jobman('initcfg');

% set up for jobs
clear matlabbatch;

sidlst = [0001 0002 0003 0004 0567 0679 0739 0844 0893 1000 1061 1091 1205 1676 1697 ...
    1710 1886 1993 2010 2054 2055 2099 2167 2187 2372 2526 2764 2809 3008 ...
    3034 3080 3149 3431 3461 3552 3883 3973 4087 4298 4320 4599 4765 4958];

for sbj=1:length(sidlst)
    to_path = sprintf('/Users/yi-wenwang/Documents/Work/Analysis/%04i/ROI/', sidlst(sbj));
    % copy and paste template batch code created by batch editor 
    % replace the index with run_n, eg. matlabbatch{run_n}
    % and change run_n based on your design

    matlabbatch{sbj}.spm.util.imcalc.input = {
                                        [to_path 'rwL_GPi.nii,1']
                                        [to_path 'rwR_GPi.nii,1']
                                        };
    matlabbatch{sbj}.spm.util.imcalc.output = 'mask_GPi';
    matlabbatch{sbj}.spm.util.imcalc.outdir = {to_path};
    matlabbatch{sbj}.spm.util.imcalc.expression = '(i1 > 0.5) | (i2 > 0.5)';
    matlabbatch{sbj}.spm.util.imcalc.var = struct('name', {}, 'value', {});
    matlabbatch{sbj}.spm.util.imcalc.options.dmtx = 0;
    matlabbatch{sbj}.spm.util.imcalc.options.mask = 0;
    matlabbatch{sbj}.spm.util.imcalc.options.interp = 1;
    matlabbatch{sbj}.spm.util.imcalc.options.dtype = 4;

end % end of loop thru subject folders

spm_jobman('run',matlabbatch);