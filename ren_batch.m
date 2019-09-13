sidlst = [0001 0002 0003 0004 0567 0679 0739 0844 0893 1000 1061 1091 1205 1676 1697 ...
    1710 1886 1993 2010 2054 2055 2099 2167 2187 2372 2526 2764 2809 3008 ...
    3034 3080 3149 3431 3461 3552 3883 3973 4087 4298 4320 4599 4765 4958];
prefix = 'GPi';

for sbj=1:length(sidlst)
   fname = sprintf('%s_%03i.m', prefix, sbj);
   movefile(fname, sprintf('%04i/ROI/%s_%04i.m', sidlst(sbj), prefix, sidlst(sbj)));    
%     fname = sprintf('%04i/w_', sidlst(sbj));
%     movefile(fname, [fname sprintf('_%04i.m', sidlst(sbj))]);    
end