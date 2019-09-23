% revised from new_MVPA.m
events = {'s11', 's12', 's21', 's22'};
v1 = 1; v2 = 3; % which two events for training?
e1 = 2; e2 = 4; % which two events for verification?
v_name = 'STN_uf_';
TrainSize = 70;

sidlst = [0001];

stdiz = true; 
% standardize data when load_ev_series
% if true, svm 'Standardize' = false
% if false, filename = inxf

for s = 1:length(sidlst)
    
    t_path = sprintf('/Users/yi-wenwang/Documents/Work/Analysis/%04i/G1STN/', sidlst(s));
    
    if ~exist(t_path)
        disp(sprintf('%s does not exist', t_path));
        continue;
    end
    
    for b=1:1
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
            disp(sprintf('block %i of subject %04i skipped', b, sidlst(s)));
            continue; % not enough data; skip this block
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
                

        for i = 1:length(pick)
            v_std(i) = std(data(i,:));
            v_mean(i) = mean(data(i,:));
            v_norm(i) = norm(data(i,:));
        end
    end % for sessions
    
end
