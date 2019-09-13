spm('defaults','fmri');
spm_jobman('initcfg');

upperdir = '/Users/yi-wenwang/Documents/Work/Analysis/'; % revise here

% set up for jobs
clear matlabbatch;
matlabbatch{1}.cfg_basicio.run_ops.runjobs.jobs = {[upperdir 'inv_normalise.m']}; % revise here

sidlst = [0001 0002 0003 0004 0567 0679 0739 0844 0893 1000 1061 1091 1205 1676 1697 ...
    1710 1886 1993 2010 2054 2055 2099 2167 2187 2372 2526 2764 2809 3008 ...
    3034 3080 3149 3431 3461 3552 3883 3973 4087 4298 4320 4599 4765 4958];
prefix = 'GPi';

for sbj=1:length(sidlst) % revise here
    sid = num2str(sidlst(sbj), '%04i');
    matlabbatch{1}.cfg_basicio.run_ops.runjobs.inputs{sbj}{1}.inany = {[upperdir sid '/Strc2MNI/iy_rt1_' sid '.nii']};
    matlabbatch{1}.cfg_basicio.run_ops.runjobs.inputs{sbj}{2}.inany = {[upperdir sid '/Strc2MNI/wrt1_' sid '.nii']};
    matlabbatch{1}.cfg_basicio.run_ops.runjobs.inputs{sbj}{3}.innifti = {
                                                                       '/Users/yi-wenwang/Documents/Work/Analysis/atlas/L_GPi.nii'
                                                                       '/Users/yi-wenwang/Documents/Work/Analysis/atlas/R_GPi.nii'
                                                                       };
    matlabbatch{1}.cfg_basicio.run_ops.runjobs.inputs{sbj}{4}.inany = {[upperdir  sid '/ROI/']};
    matlabbatch{1}.cfg_basicio.run_ops.runjobs.inputs{sbj}{5}.inany = {[upperdir sid '/Strc2MNI/rt1_' sid '.nii']};
	matlabbatch{1}.cfg_basicio.run_ops.runjobs.inputs{sbj}{6}.innifti = {[upperdir  sid '/ROI/mean_' sid '.nii,1']};
	matlabbatch{1}.cfg_basicio.run_ops.runjobs.inputs{sbj}{7}.innifti = {[upperdir  sid '/ROI/t2_' sid '.nii,1']};
end


matlabbatch{1}.cfg_basicio.run_ops.runjobs.save.savejobs.outstub = prefix;
matlabbatch{1}.cfg_basicio.run_ops.runjobs.save.savejobs.outdir = {upperdir}; % revise here
matlabbatch{1}.cfg_basicio.run_ops.runjobs.missing = 'skip';

spm_jobman('run',matlabbatch);
