close all
clear all

fname = spm_select();
[r, c] = size(fname);
Old = [];
mean_list = [];
max_p = 0;
for i=1:r
    V=spm_vol(fname(i,:));
    Y=spm_read_vols(V);
    dim = size(Y);
    Y2 = reshape(Y, [1 dim(1)*dim(2)*dim(3)]);
    Y2 = Y2(~isnan(Y2));
    mean_list = [mean_list mean(Y2)];
    max_p = max(max_p, max(Y2));
    if mean(Y2) < 0.48
        disp([fname(i,:) ': ' num2str(mean(Y2))]);
    end
   cdfplot(Y2);
   hold on
    
%     if length(Old) > 0
%         [h,p] = kstest2(Old, Y2) % too sensitive -- almost always reject null hypothesis
%     end
%     Old = Y2;
end

max_p
% mean(mean_list)
% sum(mean_list > 0.52)