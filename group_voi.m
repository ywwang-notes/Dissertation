upperdir = '/Users/yi-wenwang/Documents/Work/Analysis/'; % revise here

% sidlst = [0001 0002 0003 0004 0567 0679 0739 0844 0893 1000 1061 1091 1205 1676 1697 ...
%     1710 1886 1993 2010 2054 2055 2099 2167 2187 2372 2526 2764 2809 3008 ...
%     3034 3080 3149 3431 3461 3552 3883 3973 4087 4298 4320 4599 4765 4958];
v_name = 'STN_uf_';
mask_name = 'mask_STN.nii';

sidlst = [0001];

for sbj=1:length(sidlst)
    s_path = [upperdir num2str(sidlst(sbj), '%04i') '/'];
    load([s_path 'SPM.mat']);
    mask = [s_path 'ROI/' mask_name];

    start = 0;
    last = 0;
    
    for b=1:length(SPM.nscan)
        start = last + 1;
        last = last + SPM.nscan(b);
        data = SPM.xY.P(start:last, :);
        [Ym R info] = extract_voxel_values(mask, SPM, []); 
        
        filename = [s_path v_name num2str(b) '.mat'];
        save(filename);
        disp(filename);
        clear Ym R info;
    end
    clear SPM;
end