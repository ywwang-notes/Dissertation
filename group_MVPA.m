% revised from new_MVPA.m
events = {'s11', 's12', 's21', 's22'};
e1 = 1; e2 = 4; % which two events?
v_name = 'STN_uf_';
Nfolds = 10;
fid = fopen([v_name events{e1} events{e2} 'n.txt'], 'w'); % n means normalized (standardized)
fprintf(fid, 'sid sess Nfolds corr sens spec set1 set2 overlap\n');

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
        
        % pick data
        idx = [1];
        for i = 1:length(n)
            idx = [idx sum(n(1:i))+1]; % add start TR of the (i+1)th event
        end
        
        pick = [(idx(e1):idx(e1+1)-1) (idx(e2):idx(e2+1)-1)];
        
        CorrectLabels = label(pick);
        data = series(pick, :);
        indices = crossvalind('Kfold', size(data,1), Nfolds);
        cp = classperf(CorrectLabels); 
        
        for i = 1:Nfolds
            test = (indices == i); train = ~test;
            svmStruct = fitcsvm(data(train,:), CorrectLabels(train), 'Standardize', ~stdiz); % basic            
            classes = predict(svmStruct, data(test,:));
            classperf(cp,classes,test);
        end
        cp
        
        % sid sess Nfolds corr sens spec set1 set2 overlap
        fprintf(fid, "%04i %i %i %.4f %.4f %.4f %i %i %i\n", ...
            sidlst(s), b, Nfolds, ... 
            cp.CorrectRate, cp.Sensitivity, cp.Specificity, ...
            n(1), n(3), overlap);
        clear data label CorrectLabels indices cp svmStruct classes
    end % for sessions
    
end

fclose(fid);