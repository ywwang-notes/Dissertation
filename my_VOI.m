sbj = 0003;
sess = 1;
t_path = [num2str(sbj, '%04i') '/GLM3s10/'];

% load([t_path 'L_PrG_raw_' num2str(sess) '.mat']);
[Ym R info] = extract_voxel_values([],[],[]);

save([t_path 'STN_uf_' num2str(sess) '.mat'], 'Ym', 'R', 'info');
