function v = noLeapDateVec(day)
% Cumsum of the number of days, no leap years:  
cum = [0, 31, 59, 90, 120, 151, 181, 212, 243, 273, 304, 334, 365];
% Get year:
day = reshape(day, 1, []);  % Row-shape
y   = floor(day / 365);
t   = day - y * 365;
% Adjust year for the last day of the year:
idx    = (t <= 0);
y(idx) = y(idx) - 1;
t(idx) = day(idx) - y(idx) * 365;
% Get month roughly and refine using accumulated number of days:
m      = ceil(t / 29) - 1;  % 30 or 31 would work also!
idx    = t > cum(m + 1);
m(idx) = m(idx) + 1;
% Get day:
d      = t - cum(m);
% Join the date:
v = [y(:), m(:), d(:)];

