clear all
addpath '/Users/yi-wenwang/Documents/Matlab/spm12';

% v_name = 'STN_uf_';
% subfolder = '/G1STN/';
% mask_file = [subfolder 'mask.nii']; % in G1STN folder
% SPM_file = [subfolder 'SPM.mat'];

v_name = 'V1_suf_';
mask_dir = '/ROI/';
spm_dir = '/GLM3/';
mask_file = [mask_dir 'mask_V1.nii']; % in G1STN folder
SPM_file = [spm_dir 'SPM.mat'];

sidlst = spm_select(Inf,'dir','Select subject directories',[],pwd);;
[r, c] = size(sidlst);
tic
for sbj=1:r
    s_path = sidlst(sbj,:);
    s_path = s_path(~isspace(s_path));
    mask = [s_path mask_file];
    s_spm = [s_path SPM_file];

    if ~exist(mask) | ~exist(s_spm)
        disp('at least one of the following files not found:');
        disp(mask);
        disp(s_spm);
        continue;
    end
        
    load(s_spm);
    
    start = zeros(1, length(SPM.nscan));
    last = zeros(1, length(SPM.nscan)+ 1);
    
    for b=1:length(SPM.nscan)
        start(b) = last(b) + 1;
        last(b+1) = last(b) + SPM.nscan(b);
    end
    last = last(2:length(last));
    
    for b=1:length(SPM.nscan)
        data = SPM.xY.P(start(b):last(b), :);
        [Ym R info] = extract_voxel_values(mask, data, []);         
    end
    clear SPM;
end
toc