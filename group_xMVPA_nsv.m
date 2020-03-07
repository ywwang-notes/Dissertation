% revised from new_MVPA.m
events = {'rA', 'rB', 'rC', 'rD'};
e1 = 1; e2 = 3; % which two events for training?
v1 = 2; v2 = 4; % which two events for verification?
v_name = 'aIPS_suf_';
TrainSize = 70;
fid = fopen([v_name events{e1} events{e2} '_nsv.txt'], 'w'); 
fprintf(fid, 'sid sess nsv nob bias\n');

sidlst = [0001 0002 0003 0004 0567 0679 0739 0844 0893 1000 1061 1091 1205 1676 1697 ...
    1710 1886 1993 2010 2054 2055 2099 2167 2187 2372 2526 2764 2809 3008 ...
    3034 3080 3149 3431 3461 3552 3883 3973 4087 4298 4320 4599 4765 4958];

stdiz = true; 
% standardize data to L2 norm when load_ev_series
% if true, svm 'Standardize' = false

for s = 1:length(sidlst)
    
    t_path = sprintf('/Users/yi-wenwang/Documents/Work/Analysis/%04i/GLM3/', sidlst(s));
    
    if ~exist(t_path)
        disp(sprintf('%s does not exist', t_path));
        continue;
    end
    
    for b=1:5
        [series, label, n, overlap] = load_ev_series(events, t_path, v_name, b, stdiz);
        if sum(n) < 1
            disp(sprintf('no VOI data for %04i', sidlst(s)));
            break;
        end
        
        % pick data: keep data for each level of equal length
        idx = 1;
        min_len = min(n([e1 e2]));

        % be sure that each label have equal amount asigned to runs
        if min_len < TrainSize
            disp(sprintf('block %i of subject %04i skipped: length = %i', b, sidlst(s), min_len));
            continue; % not enough data; skip this block
        else
            disp(sprintf('block %i of subject %04i MVPA', b, sidlst(s)));
        end

        train_len = min_len;
        pick = [];
        for i = 1:length(n)
            temp = idx:(idx+n(i)-1); 
            if i == e1 | i == e2
                temp = temp(randperm(length(temp)));
                pick = [pick temp(1:min_len)];
            end
            idx = idx + n(i);% for start of next label
        end

        CorrectLabels = label(pick);
        data = series(pick, :);
        
        svmStruct = fitcsvm(data, CorrectLabels, ...
                            'Standardize', ~stdiz, ...
                            'KernelFunction', 'polynomial'); % basic            

        
        % sid sess Nfolds corr sens spec set1 set2 overlap
        fprintf(fid, "%04i %i %i %i %.04f\n", ...
            sidlst(s), b, sum(svmStruct.IsSupportVector), ...
            svmStruct.NumObservations, svmStruct.Bias);
%        clear data label CorrectLabels indices cp svmStruct classes
    end % for sessions
end

fclose(fid);