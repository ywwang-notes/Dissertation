spm('defaults','fmri');
spm_jobman('initcfg');

upperdir = '/Users/yi-wenwang/Documents/Work/Analysis/'; % revise here

% set up for jobs
clear matlabbatch;
matlabbatch{1}.cfg_basicio.run_ops.runjobs.jobs = {[upperdir 'wbeta.m']}; % revise here

sidlst = [2526];

for sbj=1:length(sidlst) % revise here
    sid = num2str(sidlst(sbj), '%04i');
    
matlabbatch{1}.cfg_basicio.run_ops.runjobs.inputs{sbj}{1}.innifti = {[upperdir sid '/GLM/t2.nii,1']};
matlabbatch{1}.cfg_basicio.run_ops.runjobs.inputs{sbj}{2}.innifti = {[upperdir sid '/GLM/mean.nii,1']};
%%
matlabbatch{1}.cfg_basicio.run_ops.runjobs.inputs{sbj}{3}.innifti = {
                                                                   [upperdir sid '/GLM/beta_0001.nii,1']
                                                                   [upperdir sid '/GLM/beta_0002.nii,1']
                                                                   [upperdir sid '/GLM/beta_0003.nii,1']
                                                                   [upperdir sid '/GLM/beta_0004.nii,1']
                                                                   [upperdir sid '/GLM/beta_0005.nii,1']
                                                                   [upperdir sid '/GLM/beta_0006.nii,1']
                                                                   [upperdir sid '/GLM/beta_0007.nii,1']
                                                                   [upperdir sid '/GLM/beta_0008.nii,1']
                                                                   [upperdir sid '/GLM/beta_0009.nii,1']
                                                                   [upperdir sid '/GLM/beta_0010.nii,1']
                                                                   [upperdir sid '/GLM/beta_0011.nii,1']
                                                                   [upperdir sid '/GLM/beta_0012.nii,1']
                                                                   [upperdir sid '/GLM/beta_0013.nii,1']
                                                                   [upperdir sid '/GLM/beta_0014.nii,1']
                                                                   [upperdir sid '/GLM/beta_0015.nii,1']
                                                                   [upperdir sid '/GLM/beta_0016.nii,1']
                                                                   [upperdir sid '/GLM/beta_0017.nii,1']
                                                                   [upperdir sid '/GLM/beta_0018.nii,1']
                                                                   [upperdir sid '/GLM/beta_0019.nii,1']
                                                                   [upperdir sid '/GLM/beta_0020.nii,1']
                                                                   [upperdir sid '/GLM/beta_0021.nii,1']
                                                                   [upperdir sid '/GLM/beta_0022.nii,1']
                                                                   [upperdir sid '/GLM/beta_0023.nii,1']
                                                                   [upperdir sid '/GLM/beta_0024.nii,1']
                                                                   [upperdir sid '/GLM/beta_0025.nii,1']
                                                                   [upperdir sid '/GLM/beta_0026.nii,1']
                                                                   [upperdir sid '/GLM/beta_0027.nii,1']
                                                                   [upperdir sid '/GLM/beta_0028.nii,1']
                                                                   [upperdir sid '/GLM/beta_0029.nii,1']
                                                                   [upperdir sid '/GLM/beta_0030.nii,1']
                                                                   [upperdir sid '/GLM/beta_0031.nii,1']
                                                                   [upperdir sid '/GLM/beta_0032.nii,1']
                                                                   [upperdir sid '/GLM/beta_0033.nii,1']
                                                                   [upperdir sid '/GLM/beta_0034.nii,1']
                                                                   [upperdir sid '/GLM/beta_0035.nii,1']
                                                                   [upperdir sid '/GLM/beta_0036.nii,1']
                                                                   [upperdir sid '/GLM/beta_0037.nii,1']
                                                                   [upperdir sid '/GLM/beta_0038.nii,1']
                                                                   [upperdir sid '/GLM/beta_0039.nii,1']
                                                                   [upperdir sid '/GLM/beta_0040.nii,1']
                                                                   [upperdir sid '/GLM/beta_0041.nii,1']
                                                                   [upperdir sid '/GLM/beta_0042.nii,1']
                                                                   [upperdir sid '/GLM/beta_0043.nii,1']
                                                                   [upperdir sid '/GLM/beta_0044.nii,1']
                                                                   [upperdir sid '/GLM/beta_0045.nii,1']
                                                                   [upperdir sid '/GLM/beta_0046.nii,1']
                                                                   [upperdir sid '/GLM/beta_0047.nii,1']
                                                                   [upperdir sid '/GLM/beta_0048.nii,1']
                                                                   [upperdir sid '/GLM/beta_0049.nii,1']
                                                                   [upperdir sid '/GLM/beta_0050.nii,1']
                                                                   [upperdir sid '/GLM/beta_0051.nii,1']
                                                                   [upperdir sid '/GLM/beta_0052.nii,1']
                                                                   [upperdir sid '/GLM/beta_0053.nii,1']
                                                                   [upperdir sid '/GLM/beta_0054.nii,1']
                                                                   [upperdir sid '/GLM/beta_0055.nii,1']
                                                                   [upperdir sid '/GLM/beta_0056.nii,1']
                                                                   [upperdir sid '/GLM/beta_0057.nii,1']
                                                                   [upperdir sid '/GLM/beta_0058.nii,1']
                                                                   [upperdir sid '/GLM/beta_0059.nii,1']                                                            
                                                                   };
%%
matlabbatch{1}.cfg_basicio.run_ops.runjobs.inputs{sbj}{4}.inany = {[upperdir sid '/GLM/y_rt1.nii']};

end

matlabbatch{1}.cfg_basicio.run_ops.runjobs.save.savejobs.outstub = 'wbeta';
matlabbatch{1}.cfg_basicio.run_ops.runjobs.save.savejobs.outdir = {upperdir};
matlabbatch{1}.cfg_basicio.run_ops.runjobs.missing = 'skip';

spm_jobman('run',matlabbatch);