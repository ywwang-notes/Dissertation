% Work in folder 'Analysis'
% folder structure: Analysis/xxxx/GLM (xxxx = subject ID)

events = {'c', 'c11', 'c12', 'c21', 'c22', 's11', 's12', 's21', 's22', 'x', 'o'}; % v1

% events = {'c', 'c1', 'c2', 's1', 's2', 'x', 'o'}; % v2

s_folder = dir;
% s_folder = {'0001'};

for s = 7:length(s_folder)
    sid = s_folder(s).name; % v1
    % sid = s_folder{s}; % v2
    target = [ sid '//GLM1s10//']; % revise here

    if ~exist([target 'SPM.mat'], 'file')
       continue;
    end

    disp(target);
    
    current = pwd;
    cd(target);
    fid = fopen([sid '_log.txt'],'a');
    load('SPM.mat');
    beta_id = 1;
    for b = 1:5
        for e = 1:length(events)
            target = sprintf('spm_spm:beta (%04d) - Sn(%01d) %s*bf(1)', beta_id, b, events{e});

            if strcmp(target, SPM.Vbeta(beta_id).descrip)
                oldname = sprintf('wrbeta_%04d.nii', beta_id);
                newname = sprintf('s%sb%d%s.nii', sid, b, events{e});
                fprintf(fid, [oldname ' => ' newname '\n']);
                movefile(oldname, newname);
                beta_id = beta_id + 1;
             % else
             %    disp([target ' not found']); % when there is no 'x'
            end % if event found
        end % for each event
    end % for each block

    fclose(fid);
    cd(current);
end
