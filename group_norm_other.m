% normalise images other than originals

spm('defaults','fmri');
spm_jobman('initcfg');

upperdir = '/mnt/Work/SystemSwitch/Analysis/'; % revise here

% set up for jobs
clear matlabbatch;
matlabbatch{1}.cfg_basicio.run_ops.runjobs.jobs = {[upperdir 'wbeta.m']}; % revise here

sidlst = [0004 0567 0679 0739 0844 1061 1091 1205 1676 1697 1710 1886 1993 ...
    2010 2054 2055 2099 2187 2372 2809 3008 3431 3552 3883 3973 4320];
prefix = 'norm';
sidlst = [0003];
contents = dir('SVM');
n = length(contents);

for sbj=1:length(sidlst) % revise here
    sid = num2str(sidlst(sbj), '%04i');

    count = 1;
    filelist = {};
    for i = 1:n
        if ~isempty(strfind(contents(i).name, sid))
            filelist{end+1,1} = ['SVM/' contents(i).name ',1'];
        end
    end

matlabbatch{1}.cfg_basicio.run_ops.runjobs.inputs{sbj}{1}.innifti = {[upperdir sid '/GLM/t2.nii,1']};
matlabbatch{1}.cfg_basicio.run_ops.runjobs.inputs{sbj}{2}.innifti = {[upperdir sid '/GLM/mean.nii,1']};
matlabbatch{1}.cfg_basicio.run_ops.runjobs.inputs{sbj}{3}.innifti = filelist;
matlabbatch{1}.cfg_basicio.run_ops.runjobs.inputs{sbj}{4}.inany = {[upperdir sid '/GLM/y_rt1.nii']};

end

matlabbatch{1}.cfg_basicio.run_ops.runjobs.save.savejobs.outstub = prefix;
matlabbatch{1}.cfg_basicio.run_ops.runjobs.save.savejobs.outdir = {upperdir};
matlabbatch{1}.cfg_basicio.run_ops.runjobs.missing = 'skip';

spm_jobman('run',matlabbatch);