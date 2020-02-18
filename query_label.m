function labels = query_label(tb)
[r, c] = size(tb);
labels = char();
for i = 1:r
    labels{end+1,1} = spm_atlas('query','neuromorphometrics', ...
        struct('def','sphere','spec',1,'xyz',[tb.x(i) tb.y(i) tb.zmm(i)]'));
end