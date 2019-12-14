% normalise beta.nii
% dependency: wbeta.m

spm('defaults','fmri');
spm_jobman('initcfg');

upperdir = ''; % revise here

% set up for jobs
clear matlabbatch;
matlabbatch{1}.cfg_basicio.run_ops.runjobs.jobs = {[upperdir 'wbeta.m']}; % revise here

sidlst = [0002 0003 0004 0567 0679 0739 0844 0893 ...
    1000 1061 1091 1205 1676 1697 1710 1886 1993 ...
    2010 2054 2055 2099 2167 2187 2372 2526 2764 2809 ...
    3008 3034 3080 3149 3431 3461 3552 3883 3973 ...
    4087 4289 4298 4320 4599 4765 4958];
% sidlst = [0001];
prefix = 'wbeta';
n_batch = 0;

w_sid = [];

for sbj=1:length(sidlst) % revise here
    sid = num2str(sidlst(sbj), '%04i');

    count = 1;
    filelist = {};
    target = [sid '/GLM1s10/'];
    if exist(target) == 7
        contents = dir([target 'beta*.nii']);
        for i = 1:length(contents)
            filelist{end+1,1} = [target contents(i).name ',1'];
        end
        filelist{end+1,1} = [target 'mask.nii,1'];

    end
    
    if isempty(filelist)
        continue;
    end
    n_batch = n_batch + 1;
    w_sid = [w_sid sidlst(sbj)];
    matlabbatch{1}.cfg_basicio.run_ops.runjobs.inputs{n_batch}{1}.innifti = {[upperdir sid '/GLM/t2.nii,1']};
    matlabbatch{1}.cfg_basicio.run_ops.runjobs.inputs{n_batch}{2}.innifti = {[upperdir sid '/GLM/mean.nii,1']};
    matlabbatch{1}.cfg_basicio.run_ops.runjobs.inputs{n_batch}{3}.innifti = filelist;
    matlabbatch{1}.cfg_basicio.run_ops.runjobs.inputs{n_batch}{4}.inany = {[upperdir sid '/GLM/y_rt1.nii']};

end

matlabbatch{1}.cfg_basicio.run_ops.runjobs.save.savejobs.outstub = prefix;
matlabbatch{1}.cfg_basicio.run_ops.runjobs.save.savejobs.outdir = {upperdir};
matlabbatch{1}.cfg_basicio.run_ops.runjobs.missing = 'skip';

spm_jobman('run',matlabbatch);

sidlst = w_sid;

for sbj=1:length(w_sid)
   fname = sprintf('%s_%03i.m', prefix, sbj);
   movefile(fname, sprintf('%04i/GLM1s10/%s_%04i.m', w_sid(sbj), prefix, w_sid(sbj)));    
end
