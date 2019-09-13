spm('defaults','fmri');
spm_jobman('initcfg');

upperdir = '/Users/yi-wenwang/Documents/Work/Analysis/'; % revise here

% set up for jobs
clear matlabbatch;
matlabbatch{1}.cfg_basicio.run_ops.runjobs.jobs = {[upperdir 'normalise2.m']}; % revise here

sidlst = [4087 4765 2526];

for sbj=1:length(sidlst) % revise here
    sid = num2str(sidlst(sbj), '%04i');
	matlabbatch{1}.cfg_basicio.run_ops.runjobs.inputs{sbj}{1}.innifti = {[upperdir  sid '/t2_' sid '.nii,1']};
	matlabbatch{1}.cfg_basicio.run_ops.runjobs.inputs{sbj}{2}.innifti = {[upperdir  sid '/t1_' sid '.nii,1']};
	matlabbatch{1}.cfg_basicio.run_ops.runjobs.inputs{sbj}{3}.innifti = {[upperdir  sid '/t2_' sid '.nii,1']};
	matlabbatch{1}.cfg_basicio.run_ops.runjobs.inputs{sbj}{4}.innifti = {[upperdir  sid '/mean_' sid '.nii,1']};
	matlabbatch{1}.cfg_basicio.run_ops.runjobs.inputs{sbj}{5}.innifti = {[upperdir  sid '/t2_' sid '.nii,1']};
end

matlabbatch{1}.cfg_basicio.run_ops.runjobs.save.savejobs.outstub = 'w';
matlabbatch{1}.cfg_basicio.run_ops.runjobs.save.savejobs.outdir = {upperdir}; % revise here
matlabbatch{1}.cfg_basicio.run_ops.runjobs.missing = 'skip';

spm_jobman('run',matlabbatch);
