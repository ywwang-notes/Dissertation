clear
tic
events = {'s12', 's21'};
sess = 1;
load('/Users/yi-wenwang/Documents/Work/MotionCorrected/17jun2015_2526e/GLM/SPM.mat');
start_TR = sum(SPM.nscan(1:(sess-1))) + 1;
end_TR = sum(SPM.nscan(1:sess));
[r, c] = size(events);
for i=1:c
    beta_i = query_beta(events{i}, SPM);
    series{i} = SPM.xX.X(start_TR:end_TR, beta_i(sess)); % predicted BOLD
end

SPM.xY.VY = spm_select(Inf,'image','scans');
SPM.VM = []; % or specify a mask image here
% SPM.xY.VY = SPM.xY.VY(start_TR:end_TR,1);
size(SPM.xY.VY)
searchopt = struct('def','sphere','spec',0);
do_nothing = @(Y,XYZ,B) mscohere(Y,B);
spm_searchlight(SPM,searchopt,do_nothing,series{1});
toc
