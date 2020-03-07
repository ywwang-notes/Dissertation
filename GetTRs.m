function [TRs] = GetTRs(SPM, sess, events, th_ratio)
    start_TR = sum(SPM.nscan(1:(sess-1))) + 1;
    end_TR = sum(SPM.nscan(1:sess));
    
    [r, c] = size(events);
    
    series = {};
    peak = [];
    
    for i=1:c
        beta_i = query_beta(events{i}, SPM);
        series{i} = SPM.xX.X(start_TR:end_TR, beta_i(sess)); % predicted BOLD
        peak = [peak max(series{i})];
    end
    
    th = min(peak) * th_ratio;
    TRs = {};
    
    for i=1:c
        TRs{i} = find(series{i} > th);
    end
    
    % remove overlaps; pair-wise comparisons
    pairs = [1 2; 1 3; 1 4; 2 3; 2 4; 3 4];
    [r, c] = size(pairs);
    overlap = 0;
    
    for i=1:r
        p1 = pairs(i, 1);
        p2 = pairs(i, 2);
        to_remove = intersect(TRs{p1}, TRs{p2});
        n_remove = length(to_remove);
        if n_remove > 0
            TRs{p1}(ismember(TRs{p1}, to_remove)) = [];
            TRs{p2}(ismember(TRs{p2}, to_remove)) = [];
            overlap = overlap + n_remove;
        end
    end
    

end