clear all;
spm('defaults','fmri');
spm_jobman('initcfg');

% set up for jobs
clear matlabbatch;

redo = true;
cond = 'cond1';
sidlst = [2764 2526 0739 2167 0893 3034 1091 2054 0679 2010 ...
    0239 0001 0003 3149 0002];

% cond = 'cond2';
% sidlst = [0567 4087 1676 4765 1710 4958 3973 4599 2372 3008 ...
%     3080 4320 0004 4298 1205 3883];
% to be checked: 0567 3883 2372 

% cond = '';
% sidlst = [0001 0002 0003 0004 0679 0739 0844 0893 1000 1061 1091 1205 1676 1697 ...
%     1710 1993 2010 2054 2055 2099 2167 2187 2526 2764 2809 ...
%     3034 3080 3149 3431 3973 4087 4298 4320 4599 4765 4958];


folder = '/mnt/Work/SystemSwitch/Analysis/SVM/normalise/';

prefix = 'wrcorr_7';
postfix = {'_n', '_rndc_n'}; % _n, _rb_n, ...
events = {'all_s11s22', 'all_s21s12', 'all_s11s21', 'all_s12s22', ...
    'all_rArB', 'all_rCrD', 'all_rArC', 'all_rBrD'};

for ev = events
    for pf = postfix
        
        filelist = {};
        
        for sbj=1:length(sidlst)
            
            filename = sprintf('%s_%04i_%s_5mm_linear%s.nii', prefix, sidlst(sbj), ev{1}, pf{1});
            
            if exist([folder filename],'file')
                filelist{end+1,1} = [folder filename ',1'];
            end
        end % end of loop thru subject folders
        
        
        if length(filelist) > 1
            output = sprintf('%sgroup/%s_%s_%i_%s_5mm_linear%s.nii', folder, prefix, cond, length(filelist), ev{1}, pf{1});
            if ~redo && exist(output,'file')
                disp([output ' exists.']);
                continue;
            end
            
            matlabbatch{1}.spm.util.imcalc.input = filelist;
            matlabbatch{1}.spm.util.imcalc.output = output;
            matlabbatch{1}.spm.util.imcalc.outdir = {[folder 'group/']};
            matlabbatch{1}.spm.util.imcalc.expression = 'mean(X)';
            matlabbatch{1}.spm.util.imcalc.var = struct('name', {}, 'value', {});
            matlabbatch{1}.spm.util.imcalc.options.dmtx = 1;
            matlabbatch{1}.spm.util.imcalc.options.mask = 0;
            matlabbatch{1}.spm.util.imcalc.options.interp = 1;
            matlabbatch{1}.spm.util.imcalc.options.dtype = 16;
            
            spm_jobman('run',matlabbatch);
        end
    end
end
