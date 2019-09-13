function [newdata, fit] = detrend(data, degree)

t = 1:length(data);
t = t';
b = polyfit(t, data, degree);
fit = polyval(b, t);
newdata = data - fit;

end