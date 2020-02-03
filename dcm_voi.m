function dcm_voi(sbj)

normVOI = [{'Motor', [-36 -20 66]}
    {'MFG', [-48 12 36]}
    {'Ins', [-34 20 2]}
    {'OpIFG', [-54 16 8]}
    {'MTG', [-54 -46 -2]}
    {'Vis', [-16 -94 -6]}
    ];

[r c] = size(normVOI);

% % for debug
% for i = 1:r
%     sbjVOI(i,:) = {normVOI{i, 1}, sbjmni(sbj, normVOI{i, 2})'};
% end
spm('defaults','fmri');
spm_jobman('initcfg');

for i = 1:r
    clear matlabbatch;
    for sess = 1:5
        matlabbatch{sess}.spm.util.voi.spmmat = {['/mnt/Work/SystemSwitch/Analysis/' sbj '/GLM4/SPM.mat']};
        matlabbatch{sess}.spm.util.voi.adjust = 0;
        matlabbatch{sess}.spm.util.voi.session = sess;
        matlabbatch{sess}.spm.util.voi.name = normVOI{i,1};
        matlabbatch{sess}.spm.util.voi.roi{1}.sphere.centre = sbjmni(sbj, normVOI{i, 2})';
        matlabbatch{sess}.spm.util.voi.roi{1}.sphere.radius = 5;
        matlabbatch{sess}.spm.util.voi.roi{1}.sphere.move.fixed = 1;
        matlabbatch{sess}.spm.util.voi.expression = 'i1';
    end
    spm_jobman('run',matlabbatch);
end % for each VOI

end %function