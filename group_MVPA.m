events = {'rA', 'rB', 'rC', 'rD'};
e1 = 2; e2 = 4; % which two events?
v_name = 'SMC_suf_';
Nfolds = 10;
TestSize = 7;
fid = fopen([v_name events{e1} events{e2} '.txt'], 'w'); 
fprintf(fid, 'sid sess Nfolds corr sens spec n overlap\n');

sidlst = [0001 0002 0003 0004 0567 0679 0739 0844 0893 1000 1061 1091 1205 1676 1697 ...
    1710 1886 1993 2010 2054 2055 2099 2167 2187 2372 2526 2764 2809 3008 ...
    3034 3080 3149 3431 3461 3552 3883 3973 4087 4298 4320 4599 4765 4958];
sidlst = [4765];

stdiz = true;

for s = 1:length(sidlst)
    
    t_path = sprintf('/mnt/Work/SystemSwitch/Analysis/%04i/GLM3/', sidlst(s));
    
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
        
        disp(sprintf('processing subject %04i block %i...', sidlst(s), b));
        % pick data: keep data for each level of equal length
        idx = 1;
        min_len = min(n([e1 e2]));

        % be sure that each label have equal amount asigned to runs
        if min_len < TestSize * Nfolds
            disp(sprintf('... not enough data (length = %i)', min_len));
            continue; % not enough data; skip this block
        end

        pick = [];
        indices = [];
        for i = 1:length(n)
            temp = idx:(idx+n(i)-1); 
            if i == e1 | i == e2
                temp = temp(randperm(length(temp)));
                pick = [pick temp(1:min_len)];
                indices = [indices crossvalind('Kfold', min_len, Nfolds)'];                
            end
            idx = idx + n(i);% for start of next label
        end

        CorrectLabels = label(pick);
        data = series(pick, :);
        
        cp = classperf(CorrectLabels); 
        
        for i = 1:Nfolds
            test = (indices == i); train = ~test;
            svmStruct = fitcsvm(data(train,:), CorrectLabels(train), ...
                                'Standardize', ~stdiz, ...
                                'KernelFunction', 'polynomial'); % basic            
            classes = predict(svmStruct, data(test,:));
            classperf(cp,classes,test);
        end
        cp
        
        % sid sess Nfolds corr sens spec set1 set2 overlap
        fprintf(fid, "%04i %i %i %.4f %.4f %.4f %i %i\n", ...
            sidlst(s), b, Nfolds, ... 
            cp.CorrectRate, cp.Sensitivity, cp.Specificity, ...
            min_len, overlap);
%        clear data label CorrectLabels indices cp svmStruct classes
    end % for sessions
    
end

fclose(fid);