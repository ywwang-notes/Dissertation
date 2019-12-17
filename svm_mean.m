spm('defaults','fmri');
spm_jobman('initcfg');

% set up for jobs
clear matlabbatch;

sidlst = [0001 0002 0003 0004 0567 0679 0739 0844 0893 1000 1061 1091 1205 1676 1697 ...
    1710 1886 1993 2010 2054 2055 2099 2167 2187 2372 2526 2764 2809 3008 ...
    3034 3080 3149 3431 3461 3552 3883 3973 4087 4298 4320 4599 4765 4958];
events = 'rArB';

n_batch = 0;
folder = 'C:/Users/ywwang/Documents/dissertation/MVPA/wrcorr/';
logfile = [folder 'mean_' events '.txt'];
processed = {};
if exist(logfile, 'file')
    processed = importdata(logfile); % load old log
end
fid = fopen(logfile,'a'); % open log file for appending

for sbj=1:length(sidlst)
    sid = num2str(sidlst(sbj), '%04i');
    
    count = 1;
    filelist = {};
    to_update = false;
    for b=1:5
        filename = sprintf('wrcorr_p_%s_b%i_%s_5mm_linear.nii', sid, b, events);
        if exist([folder filename],'file')
            if ~any(strcmp(processed, filename))
                to_update = true;
                fprintf(fid, [filename '\n']);
            end
            filelist{end+1,1} = [folder filename ',1']; % processed files should also be included for calculating the mean
        end
    end
    
    if ~to_update
        continue;
    end
    
    target = sprintf('%swrcorr_p_%s_%s_5mm_linear.nii', folder, sid, events);
    
    if length(filelist) == 1
        tmp = char(filelist(1));
        tmp = tmp(1:end-2);
        copyfile(tmp, target);
        continue;
    end
    n_batch = n_batch + 1;
    
    matlabbatch{n_batch}.spm.util.imcalc.input = filelist;
    matlabbatch{n_batch}.spm.util.imcalc.output = target;
    matlabbatch{n_batch}.spm.util.imcalc.outdir = {folder};
    matlabbatch{n_batch}.spm.util.imcalc.expression = 'mean(X)';
    matlabbatch{n_batch}.spm.util.imcalc.var = struct('name', {}, 'value', {});
    matlabbatch{n_batch}.spm.util.imcalc.options.dmtx = 1;
    matlabbatch{n_batch}.spm.util.imcalc.options.mask = 0;
    matlabbatch{n_batch}.spm.util.imcalc.options.interp = 1;
    matlabbatch{n_batch}.spm.util.imcalc.options.dtype = 4;
    
end % end of loop thru subject folders

fclose(fid);

if exist('matlabbatch','var')
    spm_jobman('run',matlabbatch);
    % create the group mean image after mean per subject created
    clear matlabbatch;
    filelist = {};
    for sbj=1:length(sidlst)
        filename = sprintf('wrcorr_p_%04i_%s_5mm_linear.nii', sidlst(sbj), events);
        if exist([folder filename],'file')
            filelist{end+1,1} = [folder filename ',1'];
        end
    end % end of loop thru subject folders
    
    if length(filelist) > 1
        matlabbatch{1}.spm.util.imcalc.input = filelist;
        matlabbatch{1}.spm.util.imcalc.output = sprintf('%swrcorr_p_%s_5mm_linear.nii', folder, events);
        matlabbatch{1}.spm.util.imcalc.outdir = {folder};
        matlabbatch{1}.spm.util.imcalc.expression = 'mean(X)';
        matlabbatch{1}.spm.util.imcalc.var = struct('name', {}, 'value', {});
        matlabbatch{1}.spm.util.imcalc.options.dmtx = 1;
        matlabbatch{1}.spm.util.imcalc.options.mask = 0;
        matlabbatch{1}.spm.util.imcalc.options.interp = 1;
        matlabbatch{1}.spm.util.imcalc.options.dtype = 4;
        
        spm_jobman('run',matlabbatch);
    end
end