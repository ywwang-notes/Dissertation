%-----------------------------------------------------------------------
% Job saved on 28-Aug-2019 02:07:06 by cfg_util (rev $Rev: 7345 $)
% spm SPM - SPM12 (7487)
% cfg_basicio BasicIO - Unknown
%-----------------------------------------------------------------------
matlabbatch{1}.spm.util.defs.comp{1}.inv.comp{1}.def = '<UNDEFINED>';
matlabbatch{1}.spm.util.defs.comp{1}.inv.space = '<UNDEFINED>';
matlabbatch{1}.spm.util.defs.out{1}.push.fnames = '<UNDEFINED>';
matlabbatch{1}.spm.util.defs.out{1}.push.weight = {''};
matlabbatch{1}.spm.util.defs.out{1}.push.savedir.saveusr = '<UNDEFINED>';
matlabbatch{1}.spm.util.defs.out{1}.push.fov.file = '<UNDEFINED>';
matlabbatch{1}.spm.util.defs.out{1}.push.preserve = 0;
matlabbatch{1}.spm.util.defs.out{1}.push.fwhm = [0 0 0];
matlabbatch{1}.spm.util.defs.out{1}.push.prefix = 'w';
matlabbatch{2}.spm.spatial.coreg.estwrite.ref = '<UNDEFINED>';
matlabbatch{2}.spm.spatial.coreg.estwrite.source = '<UNDEFINED>';
matlabbatch{2}.spm.spatial.coreg.estwrite.other(1) = cfg_dep('Deformations: Warped Images', substruct('.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','warped'));
matlabbatch{2}.spm.spatial.coreg.estwrite.eoptions.cost_fun = 'nmi';
matlabbatch{2}.spm.spatial.coreg.estwrite.eoptions.sep = [4 2];
matlabbatch{2}.spm.spatial.coreg.estwrite.eoptions.tol = [0.02 0.02 0.02 0.001 0.001 0.001 0.01 0.01 0.01 0.001 0.001 0.001];
matlabbatch{2}.spm.spatial.coreg.estwrite.eoptions.fwhm = [7 7];
matlabbatch{2}.spm.spatial.coreg.estwrite.roptions.interp = 1;
matlabbatch{2}.spm.spatial.coreg.estwrite.roptions.wrap = [0 0 0];
matlabbatch{2}.spm.spatial.coreg.estwrite.roptions.mask = 0;
matlabbatch{2}.spm.spatial.coreg.estwrite.roptions.prefix = 'r';
