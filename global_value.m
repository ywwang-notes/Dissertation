close all
clear all

fname = spm_select();
[r, c] = size(fname);
Old = [];
mean_list = [];
for i=1:r
    V=spm_vol(fname(i,:));
    Y=spm_read_vols(V);
    dim = size(Y);
    Y2 = reshape(Y, [1 dim(1)*dim(2)*dim(3)]);
    % hist(Y2)
    % min(Y2)
    disp(fname(i,:));
    mean_list = [nanmean(Y2) mean_list];
    Y2 = Y2(~isnan(Y2));
%    Y2 = Y2(Y2>0);
    cdfplot(Y2);
    hold on
    
%     if length(Old) > 0
%         [h,p] = kstest2(Old, Y2) % too sensitive -- almost always reject null hypothesis
%     end
%     Old = Y2;
end
mean(mean_list)