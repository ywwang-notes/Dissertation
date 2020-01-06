spm('defaults','fmri');
spm_jobman('initcfg');

% set up for jobs
clear matlabbatch;


% events = 'ss';
% cond = 'cond1';
% sidlst = [2764 2526 3552 0739 2167 0893 3034 2809 1697 1091 2054 0679 ...
%           2010 1993 3431 2099 0001 0003 3149 0002];

% cond = 'cond2';
% sidlst = [0567 4087 1676 4765 2187 1710 4958 3973 2055 4599 2372 ...
%     0844 3008 1061 3080 1886 4320 0004 4298 1205 3883];

cond = '';
sidlst = [0001 0002 0003 0004 0567 0679 0739 0844 0893 1000 1061 1091 1205 1676 1697 ...
    1710 1993 2010 2054 2055 2099 2167 2187 2372 2526 2764 2809 3008 ...
    3034 3080 3149 3431 3461 3883 3973 4087 4298 4320 4599 4765 4958];
% sidlst = [1091 2526];

folder = '/mnt/Work/SystemSwitch/Analysis/SVM/normalise/';
filelist = {};

prefix = 'wrcorr_7';
postfix = '_rndc_n'; % _n, _rb_n, ... 
% events = 'rCrD';
% events = 's21s12';
events = 's11s22xb';

for sbj=1:length(sidlst)
    filename = sprintf('%s_%04i_%s_5mm_linear%s.nii', prefix, sidlst(sbj), events, postfix);
    if exist([folder filename],'file')
        filelist{end+1,1} = [folder filename ',1'];
    end    
end % end of loop thru subject folders

if length(filelist) > 1    
    matlabbatch{1}.spm.util.imcalc.input = filelist;
    matlabbatch{1}.spm.util.imcalc.output = sprintf('%s%s_%s_%i_%s_5mm_linear%s.nii', folder, prefix, cond, length(filelist), events, postfix);
    matlabbatch{1}.spm.util.imcalc.outdir = {folder};
    matlabbatch{1}.spm.util.imcalc.expression = 'mean(X)';
    matlabbatch{1}.spm.util.imcalc.var = struct('name', {}, 'value', {});
    matlabbatch{1}.spm.util.imcalc.options.dmtx = 1;
    matlabbatch{1}.spm.util.imcalc.options.mask = 0;
    matlabbatch{1}.spm.util.imcalc.options.interp = 1;
    matlabbatch{1}.spm.util.imcalc.options.dtype = 16;    
    
    spm_jobman('run',matlabbatch);
end
