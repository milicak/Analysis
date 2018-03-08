

%monthly averaged
%md = [31 29 31 30 31 30 31 31 30 31 30 31];
%bi weekly averaged
md = [15 16 15 14 15 16 15 15 15 16 15 15 15 16 15 16 15 15 15 16 15 15 15 16];  
mdw = md./sum(md);

fname = 'data/marmara-t-dayz.xyz';
tmp1 = textread(fname);
temp = tmp1(:,4);
Nz = 92;
dz = tmp1(1:Nz,3);
temp = reshape(temp,[Nz 366]);

ind = 0;
for i=1:length(md)
    ind+1:ind+md(i);
    tmp = temp(:,ind+1:ind+md(i));
    T(i,:) = mean(tmp,2);
    dnm = cumsum(md(1:i));
    ind = dnm(end); 
end


fname = 'data/marmara-s-dayz.xyz';
tmp1 = textread(fname);
salt = tmp1(:,4);
Nz = 92;
dz = tmp1(1:Nz,3);
salt = reshape(salt,[Nz 366]);

ind = 0;
for i=1:length(md)
    ind+1:ind+md(i);
    tmp = salt(:,ind+1:ind+md(i));
    S(i,:) = mean(tmp,2);
    dnm = cumsum(md(1:i));
    ind = dnm(end); 
end
