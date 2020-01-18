function p=get_cdf_p(data, v)
    [f, x] = ecdf(data);
    p =min(f(x>v & x<(v+1/1000)));
    
end