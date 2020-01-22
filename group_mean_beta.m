clear all;
spm('defaults','fmri');
spm_jobman('initcfg');

% set up for jobs
clear matlabbatch;

redo = false;
sidlst = [2764 2526 0739 2167 0893 3034 1091 2054 0679 2010 ...
    0239 0001 0003 3149 0002 0567 4087 1676 4765 1710 4958 3973 ...
    4599 2372 3008 3080 4320 0004 4298 1205 3883];

folder = '/mnt/Work/SystemSwitch/Analysis/';
events = {'s11', 's12', 's21', 's22', 'c11', 'c12', 'c21', 'c22', 'x', 'o'};

for ev = events
    for sbj = sidlst
        filelist = {};
        
        for b=1:5
            
            filename = sprintf('%s%04i/GLM1s10/s%04ib%i%s.nii', folder, sbj, sbj, b, ev{1});
            
            if exist(filename,'file')
                filelist{end+1,1} = [filename ',1'];
            end
        end
        
        if length(filelist) > 1
            output = sprintf('%sGLM/s%04i%s.nii', folder, sbj , ev{1});
            if ~redo && exist(output,'file')
                disp([output ' exists.']);
                continue;
            end
            
            matlabbatch{1}.spm.util.imcalc.input = filelist;
            matlabbatch{1}.spm.util.imcalc.output = output;
            matlabbatch{1}.spm.util.imcalc.outdir = {};
            matlabbatch{1}.spm.util.imcalc.expression = 'mean(X)';
            matlabbatch{1}.spm.util.imcalc.var = struct('name', {}, 'value', {});
            matlabbatch{1}.spm.util.imcalc.options.dmtx = 1;
            matlabbatch{1}.spm.util.imcalc.options.mask = 0;
            matlabbatch{1}.spm.util.imcalc.options.interp = 1;
            matlabbatch{1}.spm.util.imcalc.options.dtype = 16;
            
            spm_jobman('run',matlabbatch);
        end
    end % end of loop thru subject folders
    
end
