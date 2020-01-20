spm('defaults','fmri');
spm_jobman('initcfg');
clear matlabbatch;

folder = '/mnt/Work/SystemSwitch/Analysis/';
% folder = '/mnt/Work/SystemSwitch/backup/corr_p/';

w_folder = 'SVM/normalise/';
% w_folder = '';


% out_folder = 'wrcorr_0';
out_folder = w_folder;

contents = dir([folder w_folder 'wrcorr_7*_rndc_n.nii']);
n_batch = 0;

for i=1:length(contents)
    w_file = contents(i).name;
    newfile = [w_file(1:end-4) '0.nii'];
        
    n_batch = n_batch + 1;
    matlabbatch{n_batch}.spm.util.imcalc.input = {[folder w_folder w_file ',1']};
    matlabbatch{n_batch}.spm.util.imcalc.output = newfile;
    matlabbatch{n_batch}.spm.util.imcalc.outdir = {[folder out_folder]};
    matlabbatch{n_batch}.spm.util.imcalc.expression = ['i1 - 0.5'];
    matlabbatch{n_batch}.spm.util.imcalc.var = struct('name', {}, 'value', {});
    matlabbatch{n_batch}.spm.util.imcalc.options.dmtx = 0;
    matlabbatch{n_batch}.spm.util.imcalc.options.mask = 0;
    matlabbatch{n_batch}.spm.util.imcalc.options.interp = 1;
    matlabbatch{n_batch}.spm.util.imcalc.options.dtype = 16;
    
end % end of loop thru subject folders

if n_batch > 0
    spm_jobman('run',matlabbatch);
end
