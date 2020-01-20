function p=get_cdf_p(data, v)
    [f, x] = ecdf(data);
    if max(x) < v
        p = 1;
    elseif min(x) > v
        p = 0;
    else
        p =min(f(x>v & x<(v+1/1000)));
    end
end