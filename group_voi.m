% addpath '/Users/yi-wenwang/Documents/Matlab/spm12';
v_name = 'STN_uf_';
subfolder = '/G1STN/';
mask_file = [subfolder 'mask.nii']; % in G1STN folder
SPM_file = [subfolder 'SPM.mat'];

sidlst = spm_select(Inf,'dir','Select subject directories',[],pwd);;
[r, c] = size(sidlst);

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
    
    start = 0;
    last = 0;
    
    for b=1:length(SPM.nscan)
        start = last + 1;
        last = last + SPM.nscan(b);
        data = SPM.xY.P(start:last, :);
        [Ym R info] = extract_voxel_values(mask, data, []); 
        
        filename = [s_path subfolder v_name num2str(b) '.mat'];
        save(filename);
        disp(sprintf('%s contains %i voxels.', filename, length(R.I(1).xyz)));
        clear Ym R info;
    end
    clear SPM;
end