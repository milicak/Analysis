clear all
fid=fopen('tide_gauge_bodrum_orig.txt','r');
for i = 1:15195
    line_ex = fgetl(fid);
    time(i) = datenum(line_ex(1:20));
    ssh(i) = str2num(line_ex(21:end));
end
save('bodrum_tide','time','ssh');


