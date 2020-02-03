function vox=sbjmni(sbj, mni)
folder = ['/mnt/Work/SystemSwitch/Analysis/' sbj '/Strc2MNI/'];
tmp = load([folder 'rt1_' sbj '_seg8.mat']);
M1 = tmp.Affine;
yfile = [folder 'y_rt1_' sbj '.nii'];
P = [[yfile ', 1,1'];[yfile ', 1,2'];[yfile ', 1,3']];
V = spm_vol(P);
vox = M1\[mni'; 1];
vox = vox(1:3);
end
