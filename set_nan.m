function a2 = set_nan(a1, th)
    a2 = a1;
    a2(a2 <= th) = NaN;
end