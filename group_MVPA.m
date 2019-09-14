% revised from new_MVPA.m

v_name = 'STN_uf_';
Nfolds = 10;
fid = fopen([v_name 's11s21_rev.txt'], 'w');
fprintf(fid, 'sid sess Nfolds corr sens spec set1 set2 overlap\n');

% sidlst = [0001 0002 0003 0004 0567 0679 0739 0844 0893 1000 1061 1091 1205 1676 1697 ...
%     1710 1886 1993 2010 2054 2055 2099 2167 2187 2372 2526 2764 2809 3008 ...
%     3034 3080 3149 3431 3461 3552 3883 3973 4087 4298 4320 4599 4765 4958];
sidlst = [0003];

for s = 1:length(sidlst)
    
    t_path = sprintf('/Users/yi-wenwang/Documents/Work/Analysis/%04i/G1STN/', sidlst(s));
    
    if ~exist(t_path)
        disp(sprintf('%s does not exist', t_path));
        continue;
    end
    
    for b=1:5
        [series, label, n, overlap] = load_ev_series({'s11', 's12', 's21', 's22'}, t_path, v_name, b);
        if sum(n) < 1
            disp(sprintf('no VOI data for %04i', sidlst(s)));
            break;
        end
        
        % pick data
        i1 = 1; i2 = n(1)+1; i3=sum(n(1:2))+1; i4=sum(n(1:3))+1;
        pick = [(i1:i2-1) (i3:i4-1)];
        CorrectLabels = label(pick);
        data = series(pick, :);
        indices = crossvalind('Kfold', size(data,1), Nfolds);
        cp = classperf(CorrectLabels); 
        
        for i = 1:Nfolds
            test = (indices == i); train = ~test;
            svmStruct = fitcsvm(data(train,:), CorrectLabels(train), 'Standardize', true); % basic            
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