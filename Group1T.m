spm('defaults','fmri');
spm_jobman('initcfg');

% set up for jobs
clear matlabbatch;
folder = 'C:/Users/ywwang/Documents/dissertation/MVPA/wrcorr_0/';
event = 'rCrD';

% cond = 'cond1';
% sidlst = [2764 2526 3552 0739 2167 0893 3034 2809 1697 1091 2054 0679 ...
%           2010 1993 3431 2099 0001 0003 3149 0002];

cond = 'cond2';
sidlst = [0567 4087 1676 4765 2187 1710 4958 3973 2055 4599 2372 ...
    0844 3008 1061 3080 1886 4320 0004 4298 1205 3883];

filelist = {};

for sbj=1:length(sidlst)
    
        scan = sprintf('%swrcorr0_%04i_%s_5L.nii', folder, sidlst(sbj), event);
        if ~exist(scan)
            disp(sprintf('%04i skipped', sidlst(sbj)));
            continue;
        end
        filelist{end+1, 1} = [scan ',1'];
end

matlabbatch{1}.spm.stats.factorial_design.dir = {[folder event '/' cond]};
matlabbatch{1}.spm.stats.factorial_design.des.t1.scans = filelist;
matlabbatch{1}.spm.stats.factorial_design.cov = struct('c', {}, 'cname', {}, 'iCFI', {}, 'iCC', {});
matlabbatch{1}.spm.stats.factorial_design.multi_cov = struct('files', {}, 'iCFI', {}, 'iCC', {});
matlabbatch{1}.spm.stats.factorial_design.masking.tm.tm_none = 1;
matlabbatch{1}.spm.stats.factorial_design.masking.im = 1;
matlabbatch{1}.spm.stats.factorial_design.masking.em = {''};
matlabbatch{1}.spm.stats.factorial_design.globalc.g_omit = 1;
matlabbatch{1}.spm.stats.factorial_design.globalm.gmsca.gmsca_no = 1;
matlabbatch{1}.spm.stats.factorial_design.globalm.glonorm = 1;
matlabbatch{2}.spm.stats.fmri_est.spmmat(1) = cfg_dep('Factorial design specification: SPM.mat File', substruct('.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','spmmat'));
matlabbatch{2}.spm.stats.fmri_est.write_residuals = 0;
matlabbatch{2}.spm.stats.fmri_est.method.Classical = 1;
matlabbatch{3}.spm.stats.con.spmmat(1) = cfg_dep('Model estimation: SPM.mat File', substruct('.','val', '{}',{2}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','spmmat'));
matlabbatch{3}.spm.stats.con.consess{1}.tcon.name = 'above_chance';
matlabbatch{3}.spm.stats.con.consess{1}.tcon.weights = 1;
matlabbatch{3}.spm.stats.con.consess{1}.tcon.sessrep = 'none';
matlabbatch{3}.spm.stats.con.delete = 0;

spm_jobman('run',matlabbatch);
