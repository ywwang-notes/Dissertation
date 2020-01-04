spm('defaults','fmri');
spm_jobman('initcfg');
clear matlabbatch;

% folder = '/mnt/Work/SystemSwitch/Analysis/';
folder = '/mnt/Work/SystemSwitch/Analysis/corr_p/';

% w_folder = 'SVM/normalise/';
w_folder = '';

% org_folder = 'SVM/';
org_folder = '';

% out_folder = 'wrcorr_0';
out_folder = '';

events = 's21s12';

contents = dir([folder w_folder 'w*' events '_5mm_linear.nii']);
n_batch = 0;

for i=1:length(contents)
    w_file = contents(i).name;
    org_file = [folder org_folder w_file(3:end)];
    newfile = [w_file(1:end-4) '_n.nii'];
    
    if ~exist(org_file)
        disp(sprintf('%s does not exist.', w_file(3:end)));
        continue;
    end
    
    V=spm_vol(org_file);
    data=spm_read_vols(V);
    dim = size(data);
    th = min(reshape(data, [1 dim(1)*dim(2)*dim(3)]));
    
    n_batch = n_batch + 1;
    matlabbatch{n_batch}.spm.util.imcalc.input = {[folder w_folder w_file ',1']};
    matlabbatch{n_batch}.spm.util.imcalc.output = newfile;
    matlabbatch{n_batch}.spm.util.imcalc.outdir = {[folder org_folder out_folder]};
    matlabbatch{n_batch}.spm.util.imcalc.expression = ['set_nan(i1,' num2str(th) ')'];
    matlabbatch{n_batch}.spm.util.imcalc.var = struct('name', {}, 'value', {});
    matlabbatch{n_batch}.spm.util.imcalc.options.dmtx = 0;
    matlabbatch{n_batch}.spm.util.imcalc.options.mask = 0;
    matlabbatch{n_batch}.spm.util.imcalc.options.interp = 1;
    matlabbatch{n_batch}.spm.util.imcalc.options.dtype = 16;
    
end % end of loop thru subject folders

if n_batch > 0
    spm_jobman('run',matlabbatch);
end
