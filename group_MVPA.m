% revised from new_MVPA.m
events = {'s11', 's12', 's21', 's22'};
e1 = 1; e2 = 4; % which two events?
v_name = 'STN_uf_';
Nfolds = 10;
fid = fopen([v_name events{e1} events{e2} 'n.txt'], 'w'); % n means normalized (standardized)
fprintf(fid, 'sid sess Nfolds corr sens spec n overlap\n');

sidlst = [0001 0002 0003 0004 0567 0679 0739 0844 0893 1000 1061 1091 1205 1676 1697 ...
    1710 1886 1993 2010 2054 2055 2099 2167 2187 2372 2526 2764 2809 3008 ...
    3034 3080 3149 3431 3461 3552 3883 3973 4087 4298 4320 4599 4765 4958];

stdiz = true;

for s = 1:length(sidlst)
    
    t_path = sprintf('/Users/yi-wenwang/Documents/Work/Analysis/%04i/G1STN/', sidlst(s));
    
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
        min_len = min(n);
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
        
        % be sure that each label have equal amount asigned to runs
        if min_len < 5 * Nfolds
            continue; % not enough data; skip this block
        end
        
        indices = [];
        for i=1:max(label)
            if i == e1 | i == e2
                indices = [indices crossvalind('Kfold', min_len, Nfolds)'];
            end
        end
        
        cp = classperf(CorrectLabels); 
        
        for i = 1:Nfolds
            test = (indices == i); train = ~test;
            svmStruct = fitcsvm(data(train,:), CorrectLabels(train), 'Standardize', ~stdiz); % basic            
            classes = predict(svmStruct, data(test,:));
            classperf(cp,classes,test);
        end
        cp
        
        % sid sess Nfolds corr sens spec set1 set2 overlap
        fprintf(fid, "%04i %i %i %.4f %.4f %.4f %i %i\n", ...
            sidlst(s), b, Nfolds, ... 
            cp.CorrectRate, cp.Sensitivity, cp.Specificity, ...
            min_len, overlap);
        clear data label CorrectLabels indices cp svmStruct classes
    end % for sessions
    
end

fclose(fid);